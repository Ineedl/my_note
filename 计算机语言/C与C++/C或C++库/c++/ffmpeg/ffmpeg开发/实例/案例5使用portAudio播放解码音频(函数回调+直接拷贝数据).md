```c++
#include <stdio.h>
#include <iostream>
extern "C"
{
#include <portaudio.h>
#include <libavformat/avformat.h>
#include <libavcodec/avcodec.h>
#include <libavutil/avutil.h>
#include <libswresample/swresample.h>
}

#define FRAME_SIZE 1024

AVPacket* pkt = NULL;
AVFrame *frame = NULL;
AVFormatContext *format_ctx = NULL;
AVCodecContext *codec_ctx = NULL;
const AVCodec *codec = NULL;

int stream_index = -1;

static int audioCallback(const void *inputBuffer, void *outputBuffer,
                         unsigned long framesPerBuffer,
                         const PaStreamCallbackTimeInfo *timeInfo,
                         PaStreamCallbackFlags statusFlags,
                         void *userData)
{
        int ret = -1;
        float *out = static_cast<float *>(outputBuffer);
        if(av_read_frame(format_ctx, pkt) >= 0) {
            if (pkt->stream_index == stream_index) {
                ret = avcodec_send_packet(codec_ctx, pkt);
                if (ret < 0) {
                    fprintf(stderr, "Error sending packet to decoder\n");
                    return paComplete;
                }
                while (ret >= 0) {
                    ret = avcodec_receive_frame(codec_ctx, frame);
                    if (ret == AVERROR(EAGAIN) || ret == AVERROR_EOF) {
                        break;
                    }
                    if (ret < 0) {
                        fprintf(stderr, "Error receiving frame from decoder\n");
                        break;
                    }
                    int data_size = av_get_bytes_per_sample(codec_ctx->sample_fmt);
                    if (data_size < 0) {
                        printf("Failed to get bytes per sample for sample format: %s\n", av_get_sample_fmt_name(codec_ctx->sample_fmt));
                        break;
                    }
                    //获取一帧总长度
                    //int total_size = av_samples_get_buffer_size(NULL, codec_ctx->channels, frame->nb_samples, codec_ctx->sample_fmt, 1);
                    for (int i = 0; i < frame->nb_samples; i++) {
                        for (int j = 0; j < codec_ctx->channels; j++) {
                        		//按声道顺序存放每一帧数据
                            memcpy(out++, frame->data[j] + i * data_size, data_size);
                        }
                    }
                }
            }
            av_packet_unref(pkt);
        }else{
            return paComplete;
        }

        return paContinue;
}

int main(int argc, char *argv[]) {

    int ret;

    // Open the input file.
    if (avformat_open_input(&format_ctx, argv[1], NULL, NULL) < 0) {
        fprintf(stderr, "Could not open input file '%s'\n", argv[1]);
        return 1;
    }

    // Find the first audio stream.
    if (avformat_find_stream_info(format_ctx, NULL) < 0) {
        fprintf(stderr, "Could not find stream information\n");
        return 1;
    }
    stream_index = av_find_best_stream(format_ctx, AVMEDIA_TYPE_AUDIO, -1, -1, NULL, 0);
    if (stream_index < 0) {
        fprintf(stderr, "Could not find audio stream\n");
        return 1;
    }

    //查找解码器
    codec = avcodec_find_decoder(format_ctx->streams[stream_index]->codecpar->codec_id);
    if(!codec)
    {
        printf("find video decoder fail\n");
        return -1;
    }

    // Open the codec.
    codec_ctx = avcodec_alloc_context3(codec);
    avcodec_parameters_to_context(codec_ctx, format_ctx->streams[stream_index]->codecpar);
    if (avcodec_open2(codec_ctx, codec, NULL) < 0) {
        fprintf(stderr, "Could not open codec\n");
        return 1;
    }

    // Initialize the packet and frame.
    pkt = av_packet_alloc();
    frame = av_frame_alloc();
    if (!frame) {
        fprintf(stderr, "Could not allocate frame\n");
        return 1;
    }

    // Open PortAudio and start the stream.
    PaStream *stream = NULL;
    if (Pa_Initialize() != paNoError) {
        fprintf(stderr, "Could not initialize PortAudio\n");
        return 1;
    }

    std::cout<<codec_ctx->frame_size<<std::endl;
    std::cout<<codec_ctx->channels<<std::endl;

    if (Pa_OpenDefaultStream(&stream,
                             0,
                             codec_ctx->channels,
                             paFloat32,
                             codec_ctx->sample_rate,
                             codec_ctx->frame_size,		//portAudio中缓冲区大小，
                             //最好和每帧的采样数一致或者是他的倍数，不然容易造成音频卡顿或不连续
                             //一般aac为1024 mp3为1152
                             //此处的缓冲区大小为 float32长度 * frame_size * channels
                             //官方文档建议 framesPerBuffer 应该是 2 的幂，
                             //但实际上它并不一定必须是 2 的幂。
                             //framesPerBuffer 的值应该根据实际需求来确定，
                             //但需要注意的是，PortAudio 的内部缓冲区大小总是 2 的幂。
                             //因此，如果你选择的 framesPerBuffer 不是 2 的幂，
                             //PortAudio 内部会自动向上取整到最接近的 2 的幂。
                             //例如，如果你指定 framesPerBuffer 为 257，
                             //PortAudio 内部会将其自动调整为 512。
                             //这样做可能会增加一些额外的延迟，因为 PortAudio 
                             //实际上会处理比你指定的更多的帧，但它并不会对音频质量造成影响。
                             audioCallback,NULL
    ) != paNoError) {
        fprintf(stderr, "Could not open PortAudio stream\n");
        return 1;
    }

//    下列注释的效果等同于上述Pa_OpenDefaultStream的调用
//    PaStreamParameters outputParameters;
//
//    memset(&outputParameters, 0, sizeof(PaStreamParameters));
//    outputParameters.device = Pa_GetDefaultOutputDevice();
//    if (outputParameters.device == paNoDevice) {
//        printf("Failed to get default output device.\n");
//        return AVERROR(ENOMEM);
//    }
//
//    outputParameters.channelCount = codec_ctx->channels;
//    outputParameters.sampleFormat = paFloat32;
//    outputParameters.suggestedLatency = Pa_GetDeviceInfo(outputParameters.device)->defaultLowOutputLatency;
//    outputParameters.hostApiSpecificStreamInfo = nullptr;
//
//// Open the output stream
//
//    if(Pa_OpenStream(&stream,
//                        nullptr,
//                        &outputParameters,
//                        codec_ctx->sample_rate,
//                        codec_ctx->frame_size,	//portAudio中缓冲区大小，
                           //最好和每帧的采样数一致或者是他的倍数，不然容易造成音频卡顿或不连续
                           //一般aac为1024 mp3为1152
                           //此处的缓冲区大小为 float32长度 * frame_size * channels
                           //官方文档建议 framesPerBuffer 应该是 2 的幂，
                           //但实际上它并不一定必须是 2 的幂。
                           //framesPerBuffer 的值应该根据实际需求来确定，
                           //但需要注意的是，PortAudio 的内部缓冲区大小总是 2 的幂。
                           //因此，如果你选择的 framesPerBuffer 不是 2 的幂，
                           //PortAudio 内部会自动向上取整到最接近的 2 的幂。
                           //例如，如果你指定 framesPerBuffer 为 257，
                           //PortAudio 内部会将其自动调整为 512。
                           //这样做可能会增加一些额外的延迟，因为 PortAudio 
                           //实际上会处理比你指定的更多的帧，但它并不会对音频质量造成影响。
//  											//一般aac为1024 mp3为1152
//                        //此处的缓冲区大小为 float32长度 * frame_size * channels
//                        paNoFlag,
//                        audioCallback,
//                        nullptr)!= paNoError) {
//        fprintf(stderr, "Could not open PortAudio stream++\n");
//        return 1;
//    }

    if (Pa_StartStream(stream) != paNoError) {
        fprintf(stderr, "Could not start PortAudio stream\n");
        return 1;
    }

    // Run the audio loop
    while (Pa_IsStreamActive(stream)) {
        Pa_Sleep(100);
    }

// Stop and close the output stream
    ret = Pa_CloseStream(stream);
    if (ret != paNoError) {
        printf("Failed to close audio stream: %s\n", Pa_GetErrorText(ret));
        return ret;
    }

// Clean up PortAudio
    Pa_Terminate();

// Clean up resources.
    avformat_close_input(&format_ctx);
    avcodec_free_context(&codec_ctx);
    av_frame_free(&frame);
    Pa_StopStream(stream);
    Pa_CloseStream(stream);
    Pa_Terminate();

    return 0;
}
```
```c++
#include <stdio.h>
extern "C"
{
#include <portaudio.h>
#include <libavformat/avformat.h>
#include <libavcodec/avcodec.h>
#include <libavutil/avutil.h>
#include <libswresample/swresample.h>
}

#define SAMPLE_RATE 44100
#define FRAME_SIZE 1024
#define CHANNEL_LAYOUT AV_CH_LAYOUT_STEREO
#define SAMPLE_FORMAT AV_SAMPLE_FMT_FLT

int main(int argc, char *argv[]) {
    AVFormatContext *format_ctx = NULL;
    AVCodecContext *codec_ctx = NULL;
    const AVCodec *codec = NULL;
    AVPacket* pkt;
    AVFrame *frame = NULL;
    SwrContext *swr_ctx = NULL;
    float **converted_samples = NULL;
    int ret, stream_index, got_frame;


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

    // Initialize the resampler.
    swr_ctx = swr_alloc_set_opts(NULL,
                                 CHANNEL_LAYOUT,
                                 SAMPLE_FORMAT,
                                 SAMPLE_RATE,
                                 av_get_default_channel_layout(codec_ctx->channels),
                                 codec_ctx->sample_fmt,
                                 codec_ctx->sample_rate,
                                 0,
                                 NULL);
    if (!swr_ctx) {
        fprintf(stderr, "Could not allocate resampler context\n");
        return 1;
    }
    if (swr_init(swr_ctx) < 0) {
        fprintf(stderr, "Could not initialize resampler context\n");
        return 1;
    }

    // Open PortAudio and start the stream.
    PaStream *stream = NULL;
    if (Pa_Initialize() != paNoError) {
        fprintf(stderr, "Could not initialize PortAudio\n");
        return 1;
    }
    if (Pa_OpenDefaultStream(&stream,
                             0,
                             codec_ctx->channels,
                             paFloat32,
                             SAMPLE_RATE,
                             FRAME_SIZE,
                             //portAudio中缓冲区大小，
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
                             NULL,NULL
    ) != paNoError) {
        fprintf(stderr, "Could not open PortAudio stream\n");
        return 1;
    }
    if (Pa_StartStream(stream) != paNoError) {
        fprintf(stderr, "Could not start PortAudio stream\n");
        return 1;
    }

// Read and decode audio packets.
    while (av_read_frame(format_ctx, pkt) >= 0) {
        if (pkt->stream_index == stream_index) {
            ret = avcodec_send_packet(codec_ctx, pkt);
            if (ret < 0) {
                fprintf(stderr, "Error sending packet to decoder\n");
                break;
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

                // Allocate space for the converted samples.
                if (!converted_samples) {
                    if (av_samples_alloc_array_and_samples((uint8_t ***) &converted_samples,
                                                           NULL,
                                                           codec_ctx->channels,
                                                           frame->nb_samples,
                                                           SAMPLE_FORMAT,
                                                           0) < 0) {
                        fprintf(stderr, "Could not allocate converted sample buffers\n");
                        return 1;
                    }
                }

                // Convert the audio samples to PCM.
                int num_samples = swr_convert(swr_ctx,
                                              (uint8_t **) converted_samples,
                                              frame->nb_samples,
                                              (const uint8_t **) frame->data,
                                              frame->nb_samples);
                if (num_samples < 0) {
                    fprintf(stderr, "Error while converting audio\n");
                    break;
                }

                // Write the converted PCM samples to the PortAudio stream.
                if (Pa_WriteStream(stream, converted_samples[0], num_samples) != paNoError) {
                    fprintf(stderr, "Error writing to PortAudio stream\n");
                    break;
                }
            }
        }
        av_packet_unref(pkt);
    }

// Clean up resources.
    avformat_close_input(&format_ctx);
    avcodec_free_context(&codec_ctx);
    av_frame_free(&frame);
    swr_free(&swr_ctx);
    av_freep(&converted_samples[0]);
    Pa_StopStream(stream);
    Pa_CloseStream(stream);
    Pa_Terminate();

    return 0;
}
```
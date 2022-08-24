## 程序目的

根据输入的媒体文件自动判断视频编码格式并且输出该媒体的每一帧的yuv文件转码后的jpeg图片。


## ffmpeg版本

ffmpeg-5.0.1-mingw-64

## 源码

```c++
#include<iostream>
#include<string>
#include <unistd.h>

#ifndef INT64_C
#define INT64_C(c) (c ## LL)
#define UINT64_C(c) (c ## ULL)
#endif

#if defined __cplusplus
#define __STDC_CONSTANT_MACROS  //common.h中的错误
#define __STDC_FORMAT_MACROS    //timestamp.h中的错误
#endif

extern "C"
{
#include "libavutil/samplefmt.h"
#include "libavutil/timestamp.h"
#include "libavformat/avformat.h"
#include "libavcodec/avcodec.h"
#include "libswresample/swresample.h"
#include "libavutil/imgutils.h"
#include "libavutil/file.h"
#include <libswscale/swscale.h>
}

using namespace std;

AVFormatContext *fmt_ctx   = NULL;
AVCodecContext  *codec_ctx = NULL;
AVFrame *decoded_frame     = NULL;
AVPacket   *pPacket        = NULL;

AVCodecContext* outCodecCtx = NULL;
AVFormatContext *pFormatCtx = NULL;

AVPacket *mjpgPkt=NULL;          //编码后数据，如jpeg等

AVCodec *pEnCodec=NULL;

int EncodeYUVToJPEG(const AVFrame* inputFrame, const char* OutputFileName);


//视频所有帧转yuv420再转mjpeg图片
int main(int argc,char** argv)
{
    if(2>argc)
    {
        return -99;
    }
    string filename            = argv[1];

    //打开输入文件
    if (avformat_open_input(&fmt_ctx, filename.c_str(), NULL, NULL) < 0) {
        fprintf(stderr, "Could not open source file %s\n", filename.c_str());
        exit(1);
    }
    if(avformat_find_stream_info(fmt_ctx,NULL) < 0)
    {
        cout<<"get stream fail"<<endl;
        return -1;
    }
    //查找视频索引
    int video_index = -1;
    video_index = av_find_best_stream(fmt_ctx,AVMEDIA_TYPE_VIDEO,-1,-1,NULL,0);

    if(video_index < 0)
    {
        cout<<"not find video index"<<endl;
        return -1;
    }
    //打印输入文件相关信息
    av_dump_format(fmt_ctx, -1,filename.c_str(),0);

    //查找解码器
    const AVCodec *vCodec = NULL;
    vCodec = avcodec_find_decoder(fmt_ctx->streams[video_index]->codecpar->codec_id);
    if(!vCodec)
    {
        cout<<"find video decoder fail"<<endl;
        return -1;
    }

    //初始化解码器上下文
    codec_ctx = avcodec_alloc_context3(vCodec);
    if(!codec_ctx)
    {
        cout<<"init codec_ctx fail"<<endl;
        return -1;
    }
    std::cout<<"codec: "<<vCodec->long_name<<"-"<<std::endl;
    std::cout<<"codec bit rate: "<<codec_ctx->bit_rate<<"-"<<std::endl;
    std::cout<<"fmt_ctx bit rate: "<<fmt_ctx->bit_rate/1000<<"-"<<std::endl;

    int ret = avcodec_parameters_to_context(codec_ctx,fmt_ctx->streams[video_index]->codecpar);
    if(ret < 0)
    {
        cout<<"avcodec_parameters_to_contex fail"<<endl;
        return -1;
    }
    //打开解码器
    ret = avcodec_open2(codec_ctx,vCodec,NULL);
    if(ret != 0)
    {
        cout<<"avcodec_open2 fail"<<endl;
        return -1;
    }

    pPacket  = av_packet_alloc();

    decoded_frame = av_frame_alloc();
    if (!decoded_frame) {
        fprintf(stderr, "Could not allocate frame\n");
        ret = AVERROR(ENOMEM);
        return -1;
    }

    cout<<"width="<< codec_ctx->width<<" height="<< codec_ctx->height<<endl;


    //编码器相关初始化
    outCodecCtx = avcodec_alloc_context3(NULL);
    if(NULL==outCodecCtx)
    {
        std::cout<<"enCodecCtx init error"<<std::endl;
        return -1;
    }
    pFormatCtx = avformat_alloc_context();
    if(NULL==pFormatCtx)
    {
        std::cout<<"enCodec FormatCtx init error"<<std::endl;
        return -1;
    }
    mjpgPkt=av_packet_alloc();;          //编码后数据，如jpeg等
    if(NULL == mjpgPkt)
    {
        std::cout<<"encodec pkt init error"<<std::endl;
        return -1;
    }

    outCodecCtx->codec_id = AV_CODEC_ID_MJPEG;
    outCodecCtx->codec_type = AVMEDIA_TYPE_VIDEO;
    outCodecCtx->pix_fmt = AV_PIX_FMT_YUVJ420P;
    outCodecCtx->width = codec_ctx->width;
    outCodecCtx->height = codec_ctx->height;
    outCodecCtx->time_base.num = 1;
    outCodecCtx->time_base.den = 25;

    //为jpg pkt分配data空间
    if(0!=av_new_packet(mjpgPkt, codec_ctx->width*codec_ctx->height*3))
    {
        std::cout<<"new encode pkt error"<<std::endl;
        return -1;
    }

    pEnCodec = const_cast<AVCodec*>(avcodec_find_encoder(AV_CODEC_ID_MJPEG));
    if (!pEnCodec)
    {
        printf("enCodec not found.");
        return -1;
    }
    if (avcodec_open2(outCodecCtx, pEnCodec, NULL) < 0)
    {
        std::cout<<"enCodec init error."<<std::endl;
        return -1;
    }

    int i=0;

    while(1)
    {
        ret = av_read_frame(fmt_ctx, pPacket);
        if (ret != 0)
        {
            cout<<"ret="<<ret<<endl;
            av_packet_unref(pPacket);
            break;
        }

        if (ret >= 0 && pPacket->stream_index != video_index) {
            //清理AVPacket中的数据并且重新初始化
            av_packet_unref(pPacket);
            continue;
        }

        // 发送待解码包
        int len = avcodec_send_packet(codec_ctx, pPacket);
        if (len < 0)
        {
            av_log(NULL, AV_LOG_ERROR, "send packet fail\n");
            //清理AVPacket中的数据并且重新初始化
            av_packet_unref(pPacket);
            continue;
        }
        //接收解码数据
        while (len >= 0)
        {
            len = avcodec_receive_frame(codec_ctx, decoded_frame);
            if (len == AVERROR_EOF)
            {
                break;
            }
            else if (len == AVERROR(EAGAIN))
            {
                len = 0;
                break;
            }
            else if (len < 0)
            {
                av_log(NULL, AV_LOG_ERROR, "Error decoding frame\n");
                //清理AVFrame中的数据并且重新初始化
                av_frame_unref(decoded_frame);
                break;
            }
            i++;
            std::string intStr = to_string(i);
            std::string file_name = "./image/"+intStr+".jpg";	//图片名
            EncodeYUVToJPEG(decoded_frame,file_name.c_str());
        }
        av_packet_unref(pPacket);
        av_packet_unref(mjpgPkt);
    }
    //释放
    av_frame_free(&decoded_frame);
    avcodec_free_context(&codec_ctx);
    av_packet_free(&pPacket);
    avformat_close_input(&fmt_ctx);
    return 0;
}

int EncodeYUVToJPEG(const AVFrame* inputFrame, const char* OutputFileName)
{
    AVStream *video_st;
    avformat_alloc_output_context2(&pFormatCtx, NULL, NULL, OutputFileName);
    avcodec_send_frame(outCodecCtx, inputFrame);
    //Read encoded data from the encoder.
    avcodec_receive_packet(outCodecCtx, mjpgPkt);
    video_st = avformat_new_stream(pFormatCtx, 0);
    if (video_st == NULL)
    {
        return -1;
    }
    //Write Header
    avformat_write_header(pFormatCtx, NULL);
    //Write body
    av_write_frame(pFormatCtx, mjpgPkt);
    //Write Trailer
    av_write_trailer(pFormatCtx);
    printf("Encode Successful.\n");
    return 0;
}
```
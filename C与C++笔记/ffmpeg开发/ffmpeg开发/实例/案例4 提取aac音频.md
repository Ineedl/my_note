## 程序目的

提取视频中的aac音频

## ffmpeg版本

ffmpeg-5.0.1-mingw-64

## 源码
```c++
//
// Created by admin on 2022/8/24.
//

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
#include "libswscale/swscale.h"
#include "libavutil/opt.h"
}

#include <stdio.h>
#include <libavutil/log.h>
#include <libavformat/avformat.h>


#define ADTS_HEADER_LEN 7

char error[1024];

//采样率
const int sampling_frequencies[] = {
        96000,  // 0x0
        88200,  // 0x1
        64000,  // 0x2
        48000,  // 0x3
        44100,  // 0x4
        32000,  // 0x5
        24000,  // 0x6
        22050,  // 0x7
        16000,  // 0x8
        12000,  // 0x9
        11025,  // 0xa
        8000    // 0xb
        // 0xc d e f是保留的
};

//ADTS Frame由ADTS_Header和AAC ES组成。
//ADTS_Header包含采样率、声道数、帧长度的信息。
//ADTS头信息的长度是7个字节或9字节（有CRC的情况）。

//ADTS_Header的可以分为以下三部分：
//
//adts_fixed_header：每一帧的内容是不变的。
//adts_variable_header：每一帧的内容是存在变化的。
//crc：16bits，protection_absent字段为0时存在。

int adts_header(char* const p_adts_header, const int data_length,
                const int profile, const int sample_rate, const int channels) {
    int sampling_frequency_index = 3;  // 默认使用48000hz
    int adtsLen = data_length + 7;

    int frequencies_size =
            sizeof(sampling_frequencies) / sizeof(sampling_frequencies[0]);

    int i;
    for (i = 0; i < frequencies_size; i++) {
        if (sampling_frequencies[i] == sample_rate) {
            sampling_frequency_index = i;
            break;
        }
    }

    if (i >= frequencies_size) {
        std::cout<<"not found sample rate!"<<std::endl;
    }

    //大端顺序存放
    p_adts_header[0] = 0xff;       // syncword:0xfff                 高8bits
    p_adts_header[1] = 0xf0;       // syncword:0xfff                 低4bits
    p_adts_header[1] |= (0 << 3);  // MPEG Version : 0代表MPEG-4,1代表MPEG-2, 1bit
    p_adts_header[1] |= (0 << 1);  // layer字段 2位   所有位必须为0
    p_adts_header[1] |= 1;         // protection absent:1代表没有CRC，0代表有 1bit

    p_adts_header[2] = (profile) << 6;  // profile: 配置级别，可以使用编码器中的profile，详情见aac头       2bits
    p_adts_header[2] |= (sampling_frequency_index & 0x0f) << 2;  // sampling frequency index: 标识使用的采样频率 频率表同上述全局数组的定义  4bits
    p_adts_header[2] |= (0 << 1);  // private bit: 私有位，编码时设置为0，解码时忽略  1bit
    p_adts_header[2] |= (channels & 0x04) >> 2;  // channel configuration: 标识声道数  高1bit

    p_adts_header[3] = (channels & 0x03) << 6;       // channel configuration: 标识声道数  低2bits
    p_adts_header[3] |= (0 << 5);  // original：编码时设置为0，解码时忽略                     1bit
    p_adts_header[3] |= (0 << 4);  // home：编码时设置为0，解码时忽略                         1bit
    p_adts_header[3] |= (0 << 3);  // copyright id bit：编码时设置为0，解码时忽略             1bit
    p_adts_header[3] |= (0 << 2);  // copyright id start：编码时设置为0，解码时忽略           1bit
    p_adts_header[3] |= ((adtsLen & 0x1800) >> 11);  // 帧数长度,包括header和crc的长度  13bit  高2bits

    p_adts_header[4] = (uint8_t)((adtsLen & 0x7f8) >> 3);  // 帧数长度  中间8bits

    p_adts_header[5] = (uint8_t)((adtsLen & 0x7) << 5);  // 帧数长度    低3bits
    p_adts_header[5] |= 0x1f;             // 填充字节 0x7ff 高5bits

    p_adts_header[6] = 0xfc;              // 填充字节 0x7ff 低6bits

    // number_of_raw_data_blocks_in_frame：
    // 表示ADTS帧中有number_of_raw_data_blocks_in_frame + 1个AAC原始帧
    // 当前音频包里面包含的音频编码帧数， 置为 aac_nums - 1, 即只有一帧音频时置0

    //CRC效验位   16bit  如果没有保护,这位为0
    //CRC


    return 0;
}

int main(int argc,char** argv) {
    char* file_name = argv[1];
    char* dst_file_name = argv[2];

    FILE* fp = fopen(dst_file_name, "wb");
    if (!fp) {
        std::cout<<"Could not open file"<<std::endl;
    }

    AVFormatContext* fmt_ctx = NULL;
    int ret = avformat_open_input(&fmt_ctx, file_name, NULL, NULL);
    if (ret < 0) {
        av_strerror(ret, error, 1024);
        std::cout<<"avformat_open_input error"<<std::endl;
    }

    // 获取解码器信息
    ret = avformat_find_stream_info(fmt_ctx, NULL);
    if (ret < 0) {
        av_strerror(ret, error, 1024);
        std::cout<<"avformat_find_stream_info error"<<std::endl;
    }

    // dump媒体信息
    av_dump_format(fmt_ctx, 0, file_name, 0);

    // 查找audio对应的steam index
    int audio_index =av_find_best_stream(fmt_ctx, AVMEDIA_TYPE_AUDIO, -1, -1, NULL, 0);
    if (audio_index < 0) {
        std::cout<<"Could not find stream in input file"<<std::endl;
    }


    if (fmt_ctx->streams[audio_index]->codecpar->codec_id != AV_CODEC_ID_AAC) {
        std::cout<<"the media file no contain AAC stream"<<std::endl;
    }

    AVPacket pkt;

    // 初始化packet
    av_init_packet(&pkt);

    // 读取媒体文件，并把aac数据帧写入到本地文件。
    while (av_read_frame(fmt_ctx, &pkt) >= 0) {
        if (pkt.stream_index == audio_index) {
            char adts_header_buf[7] = {0};


            adts_header(adts_header_buf, pkt.size,
                        fmt_ctx->streams[audio_index]->codecpar->profile,
                        fmt_ctx->streams[audio_index]->codecpar->sample_rate,
                        fmt_ctx->streams[audio_index]->codecpar->channels);

            // 写adts header , ts流不适用，ts流分离出来的packet带了adts header。
            fwrite(adts_header_buf, 1, 7, fp);

            int len = fwrite(pkt.data, 1, pkt.size, fp);  // 写adts data
            if (len != pkt.size) {
                std::cout<<"warning, length of writed data isn't equal pkt.size"<<std::endl;
            }
        }
        av_packet_unref(&pkt);
    }

    avformat_close_input(&fmt_ctx);
    fclose(fp);

    std::cout<<"success"<<std::endl;

    return 0;
}
```
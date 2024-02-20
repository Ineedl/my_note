[toc]

## 介绍

Program Stream(节目流)，简称PS流，将一个或多个分组但有共同的时间基准的基本数据流(PES)合并成一个整体流,由PS包组成，而一个PS包又由若干个PES包组成（到这里，ES经过了两层的封装）。PS包的包头中包含了同步信息与时钟恢复信息。一个PS包最多可包含具有同一时钟基准的16个视频PES包和32个音频PES包。



## 结构

### 负载IDR NALU的PS包

```
| PS header| PS system header | PS system map | PES header | h264 IDR es data |
```

### 负载非关键帧的PS包

```
| PS header| PES header | h264 es data |
```

### 负载音频数据的PS包

```
| PES header | audio data |
```



## 结构介绍

### PSH

PSH主要包含了系统同步时间，并没有定义PSH与其后数据之间的必然关系。

PSH本身并不包含PS包负载数据的内容和长度信息，一个PS包内包含的PES包个数、类型和长度没有限制。

一个PS流文件只需要有头上一个PSH，后面的视频、音频和私有数据PES包可以交错排列。但PSH应当以一定的频率在流中出现，I帧前必须有PSH，P/B帧前要有PSH。

`结构`

| 字段                                | 长度   | 介绍                                                         |
| ----------------------------------- | ------ | ------------------------------------------------------------ |
| pack_start_code                     | 32bit  | 包起始码字段，固定为0x00 00 01 ba                            |
| \'01\'                              | 2bit   | 固定字段                                                     |
| system_clock_reference_base[32..30] | 3bit   | 系统时钟参考字段                                             |
| marker_bit                          | 1bit   | 标记位字段，其值为‘ 1’ 。                                    |
| system_clock_reference_base[29..15] | 15bit  | 系统时钟参考字段                                             |
| marker_bit                          | 1bit   | 标记位字段，其值为‘ 1’ 。                                    |
| system_clock_reference_base[14..0]  | 15bit  | 系统时钟参考字段                                             |
| marker_bit                          | 1bit   | 标记位字段，其值为‘ 1’ 。                                    |
| system_clock_reference_extension    | 9bit   | 系统时钟参考字段扩展部分                                     |
| marker_bit                          | 1bit   | 标记位字段，其值为‘ 1’ 。                                    |
| program_mux_rate                    | 22bit  | PS流传输速率。program_mux_rate 值以 50 字节/秒为度量单位。0 值禁用。 |
| marker_bit                          | 1bit   | 标记位字段，其值为‘ 1’ 。                                    |
| marker_bit                          | 1bit   | 标记位字段，其值为‘ 1’ 。                                    |
| reserved                            | 5bit   | 保留位                                                       |
| pack_stuffing_length                | 3bit   | 包填充长度字段,该字段后最大字节数，最大为7                   |
| stuffing_byte                       | 0-8bit | 8位字段，取值恒为'1111 1111'；由编码器插入，由解码器丢弃；在每个包标题中最多只允许有7个填充字节 |

#### system_clock_reference_base

该字段的作用是定义系统时钟参考（SCR）。SCR 是系统层的主时钟，用于同步所有的音频、视频和系统信息。所有的时间戳（如 PTS 和 DTS）都是相对于 SCR 的。

system_clock_reference_base 字段总共有 33 位，被分为 3 个部分：

- system_clock_reference_base[32..30]：最高的 3 位。
- system_clock_reference_base[29..15]：中间的 15 位。
- system_clock_reference_base[14..0]：最低的 15 位。

这三个部分组成了一个 33 位的二进制数，代表了 SCR 的值。注意，这个值是以 90 kHz 时钟为单位的。

在解析 PS System Header 时，需要先读取这三个字段的值，然后组合在一起，得到完整的 SCR 值。这样就可以知道这个 PS 包在整个流中的具体位置，从而实现音视频同步。



`system_clock_reference_extension 指示在节目目标解码器的输入端包含system_clock_reference_base 最后比特的字节到达的预期时间。`

`一般精度要求没有这么高，system_clock_reference_extension设置为0即可。`

#### SCR计算公式

```
常用：system_clock_frequency=27Mhz

SCR_base(i) = ((system_clock_frequency * t(i)) DIV 300) MOD 2^33

SCR_ext(i) = ((system_clock_frequency * t(i)) DIV 1) MOD 300
```

* PSH中存放的是等式的左边
* t(i)的单位不是以ms为单位，而是以90KHZ为单位



### PS system header

一般属于PSH头部后携带的扩展。

`结构`

| 字段                         | 长度  | 介绍                                                         |
| ---------------------------- | ----- | ------------------------------------------------------------ |
| system_header_start_code     | 32bit | 系统标题起始码字段，固定为 0x 00 00 01 BB                    |
| header_length                | 16bit | 指出该字段后PS system header剩余的字节长度                   |
| marker_bit                   | 1bit  | 标记位字段，其值为‘ 1’ 。                                    |
| rate_bound                   | 22bit | 表示整个程序流的最大比特率，包括音频、视频、填充和系统数据。单位是比特/秒，用来告诉解码器需要多大的缓冲区来存储数据，以防止数据溢出或下溢。这个值是由编码器在创建流时设置的。 |
| marker_bit                   | 1bit  | 标记位字段，其值为‘ 1’ 。                                    |
| audio_bound                  | 6bit  | audio_bound 为 0 到 32 闭区间内的一个整数，表示在任何给定的时刻，可能需要同时解码的音频流的数量。这个值是在创建流时由编码器设置。 |
| fixed_flag                   | 1bit  | 置于‘ 1’时指示固定的比特速率操作。置于‘ 0’时指示可变比特速率操作。 |
| CSPS_flag                    | 1bit  | CSPS标志字段，置为1时表示该PS流满足MPEG-2 标准文档中 2.7.9 节所定义的限制。 |
| system_audio_lock_flag       | 1bit  | 表示音频采样率和目标解码器的system_clock_frequency之间有一特定常数比例关系 |
| system_video_lock_flag       | 1bit  | 表示在系统目标解码器system_clock_frequency和视频帧速率之间存在一特定常数比例关系 |
| marker_bit                   | 1bit  | 标记位字段，其值为‘ 1’ 。                                    |
| vedio_bound                  | 5bit  | 在 0 到 16 的闭区间内取值，表示在任何给定的时刻，可能需要同时解码的视频流的数量。这个值是在创建流时由编码器设置。 |
| packet_rate_restriction_flag | 1bit  | CSPS 标志设置为‘ 1’ ，此字段表示哪种限制适用于分组速率，SPS 标志设置为‘ 0’ 此字段无意义。 |
| reserved_bits                | 7bit  | 预留字段                                                     |
| stream_id                    | 8bit  | 流标识字段                                                   |
| \'11\'                       | 2bit  | 固定字段                                                     |
| P-STD_buffer_bound_scale     | 1bit  | 表示用来解释后面P-STD_buffer_size_bound字段的比例因子；如果之前的stream_id表示音频流，则此值应为0，若之前的stream_id表示视频流，则此值应为1，对于其他stream类型，此值可以0或1 |
| P-STD_buffer_size_bound      | 13bit | P-STD(目标解码器)缓冲区大小界限字段，若 P-STD_buffer_bound_scale 有‘0’值，那么 P-STD_buffer_size_bound 以 128 字节为单位度量该缓冲器尺寸限制。 若 P-STD_buffer_bound_scale 有‘ 1’值，那么 P-STD_buffer_size_bound 以 1024 字节为单位度量该缓冲器尺寸限制。 |



#### stream_id与P-STD_buffer_bound_scale与P-STD_buffer_size_bound的关系

stream_id是一个8位的字段，用于区分一个MPEG Program Stream中的不同类型的数据流，例如音频流，视频流，私有数据流等。这个字段的值在解码时被用来确定如何处理每一个数据包，因为不同类型的数据包需要被不同的解码器处理。

例如，音频流的stream_id可能是110x xxxx (十六进制的C0-CF)，视频流的stream_id可能是1110 xxxx (十六进制的E0-EF)。这种区分方式允许一个MPEG Program Stream中可以包含多个音频流和视频流，而每一个流都有一个唯一的标识。

* 常用：
  * 若 stream_id 等 于 ‘ 1011 1000 ’， 则 跟 随 stream_id 的 P-STD_buffer_bound_scale 和P-STD_buffer_size_bound 字段涉及节目流中的所有音频流。
  * 若 stream_id 等 于 ‘ 1011 1001 ’， 则 跟 随 stream_id 的 P-STD_buffer_bound_scale 和P-STD_buffer_size_bound 字段涉及节目流中的所有视频流。



`例子`

```
stream_id = '1011 1000'

P-STD_buffer_bound_scale = 0

P-STD_buffer_size_bound  = 9

表示该流是一个音频流，且流id为1011 1000，目标解码器需要预留9*128 字节的空间来缓冲该音频数据


stream_id = '1011 1001'

P-STD_buffer_bound_scale = 1

P-STD_buffer_size_bound  = 1000

表示该流是一个视频流，且流id为1011 1001，目标解码器需要预留1000* 1024 字节的空间来缓冲该视频数据
```





### PSM

节目流映射，PSM 提供节目流中基本流的描述及其相互关系。作为一个PES分组出现。

| 字段                          | 长度  | 介绍                                                         |
| ----------------------------- | ----- | ------------------------------------------------------------ |
| packet_start_code_prefix      | 24bit | 同跟随它的 map_stream_id 一起组成包起始码标识包的始端。固定为 0x000001。 |
| map_stream_id                 | 8bit  | 固定为0xBC                                                   |
| program_stream_map_length     | 16bit | 表示该字段之后PSM的长度                                      |
| current_next_indicator        | 1bit  | 置‘ 1’时指示发送的节目流映射为当前有效。置‘ 0’时，表示下一个节目流映射表将生效。 |
| reserved                      | 2bit  | 保留位字段                                                   |
| program_stream_map_version    | 5bit  | 节目流映射版本<br />整个节目流映射的版本号。每当节目流映射的定义改变时，该版本号必须增 1 模 32。 current_next_indicator 置为‘ 1’时， program_stream_map_version 应是当前有效的节目流映射的版本。 current_next_indicator 设置为‘ 0’时， program_stream_map_version 应是下一个有效的节目流映射的版本。 |
| reserved                      | 7bit  | 保留位字段                                                   |
| marker_bit                    | 1bit  | 标记位字段                                                   |
| program_stream_info_length    | 16bit | 表示了该字段之后描述的长度                                   |
| ps描述                        | nbit  | ps信息描述                                                   |
| elementary_stream_map_length  | 16bit | ES流信息总长度，。它包括stream_type、 elementary_stream_id 以及elementary_stream_info_length 字段。 |
| stream_type                   | 8bit  | 流类型。 stream_type 字段仅标识 PES 包中包含的基本流。 0x05 赋值被禁用。比如在GB28181中 H264为0x1B。G711A为0x90。 |
| elementary_stream_id          | 8bit  | 基本流标识，指出该基本流所在PES分组的PES分组标题中stream_id字段的值，其中0x(C0~DF)指音频，0x(E0~EF)为视频 |
| elementary_stream_info_length | 16bit | 指示紧随此字段的描述符长度，以字节为单位。                   |
| es描述                        | nbit  | es信息描述                                                   |
| CRC_32                        | 32bit | 32位CRC校验值                                                |



### PES Header

PES包头
[toc]

## 介绍

h264裸码流，属于ES流(Elementary Stream，基本码流）的一种，是由编码器输出的原始基础码流，它只含有解码器所必需的、并与原始图象或原始音频相接近的信息。由由压缩器输出的用于传送 单路视音频信号的原始码流。ES只包含一种内容的数据流，如只含视频或只含音频等。

## NALU结构

H.264原始码流(裸流)是由⼀个接⼀个NALU组成，它的功能分为两层，VCL(视频编码层)和 NAL(⽹络提取层)：

- VCL：包括核⼼压缩引擎和块，宏块和⽚的语法级别定义，设计⽬标是尽可能地独⽴于⽹ 络进⾏⾼效的编码。
- NAL：负责将VCL产⽣的⽐特字符串适配到各种各样的⽹络和多元环境中，覆盖了所有⽚级 以上的语法级别。

在VCL进⾏数据传输或存储之前，这些编码的VCL数据，被映射或封装进NAL单元。下面是一个NALU的组成：

```text
理论数据封装：
	⼀个NALU = ⼀组对应于视频编码的NALU头部信息 
    	      +
        	  ⼀个原始字节序列负荷(RBSP,Raw Byte Sequence Payload).
          
实际传输：
	⼀个NALU = 加入仿校验字节的⼀组对应于视频编码的NALU头部信息 
    	      +
        	  扩展字节序列载荷(EBSP).
 
```

* ⼀个原始的H.264 NALU单元通常由[StartCode] [NALU Header] [NALU Payload]三部分组成，其中 Start Code ⽤于标示这是⼀个NALU 单元的开 始，必须是"00 00 00 01" 或"00 00 01"，除此之外基本相当于⼀个NAL header + RBSP。

`startcode使用场景`

1. 包含sps,pps的NALU前面要加zero_byte（4字节）。
2. 当一帧被分为多个slice时，首个NALU前面要加zero_byte（4字节）参见7.4.1.2.3。也就是，当一个完整的帧被编为多个slice的时候，除掉第一个NALU，剩下的都用3字节的，其余的都是4字节。

P1(slice0) 、P1(slice1)同理。



## NALU负载数据流形式

SODB：数据比特串，最原始的编码数据 

RBSP：原始字节序列载荷，在SODB的后面填加了结尾比特（RBSP trailing bits一个bit“1”）若干比特“0”,以便字节对齐

EBSP：扩展字节序列载荷，在RBSP基础上填加了仿校验字节（0X03）。

`"防止竞争 emulation prevention"机制`

为了防止NAL内部出现0x000001的数据，在编码完一个NAL时，如果检测出有连续两个0x00字节，就在后面插入一个0x03，则在NAL数据内肯定不会存在NAL起始码0x000001。当解码器在NAL内部检测到0x000003的数据，就把0x03抛弃，恢复原始数据。

* 包括NALU头部



## NALU头信息

```
| 1 | 2 3 | 4 5 6 7 8 |
| F |  R  |     T     |
```

* T: 负载数据类型(nal_unit_type)，1～12由H.264使⽤，24～31由H.264以外的应⽤

  | **nal_unit_type ** | **NAL 单元和 RBSP 语法结构的内容  **                         |      |
  | ------------------ | ------------------------------------------------------------ | ---- |
  | 0                  | 未指定                                                       |      |
  | 1                  | 一个非IDR图像的编码条带  slice_layer_without_partitioning_rbsp( )                                                    P帧或B帧 |      |
  | 2                  | 编码条带数据分割块A  slice_data_partition_a_layer_rbsp( )    |      |
  | 3                  | 编码条带数据分割块B  slice_data_partition_b_layer_rbsp( )    |      |
  | 4                  | 编码条带数据分割块C  slice_data_partition_c_layer_rbsp( )    |      |
  | 5                  | IDR图像的编码条带  slice_layer_without_partitioning_rbsp( )   I帧 |      |
  | 6                  | 辅助增强信息 (SEI)  sei_rbsp( )                              |      |
  | 7                  | 序列参数集  seq_parameter_set_rbsp( )                               SPS |      |
  | 8                  | 图像参数集  pic_parameter_set_rbsp( )                                PPS |      |
  | 9                  | 访问单元分隔符  access_unit_delimiter_rbsp( )                |      |
  | 10                 | 序列结尾  end_of_seq_rbsp( )                                 |      |
  | 11                 | 流结尾  end_of_stream_rbsp( )                                |      |
  | 12                 | 填充数据  filler_data_rbsp( )                                |      |
  | 13                 | 序列参数集扩展  seq_parameter_set_extension_rbsp( )          |      |
  | 14...18            | 保留                                                         |      |
  | 19                 | 未分割的辅助编码图像的编码条带  slice_layer_without_partitioning_rbsp( ) |      |
  | 20...23            | 保留                                                         |      |
  | 24...31            | 未指定                                                       |      |

* R: 重要标识位(nal_ref_idc)，它用于指示当前NAL单元（Network Abstraction Layer 单元）的重要性。取值0~3。0的NALU解码器可以丢弃它而不影响图像的回放,0～3，取值越大，表示当前NAL越重要，需要优先受到保护。如果当前NAL是属于参考帧的片，或是序列参数集，或是图像参数集这些重要的单位时，本句法元素必需大于0。

* F:禁止位(forbidden_zero_bit)，在 H.264 规范中规定了这⼀位必须为 0。

 
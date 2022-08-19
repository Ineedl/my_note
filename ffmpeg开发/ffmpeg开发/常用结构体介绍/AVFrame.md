## 作用
AVFrame结构体一般是用来存储原始数据（视频数据是YUV和RGB等，音频数据是PCM等）。编码的时候也存储了一些相关的信息。


## 常用数据类型

> uint8_t *data[AV_NUM_DATA_POINTERS]：

解码后原始数据（对视频来说是YUV，RGB，对音频来说是PCM），具体使用的char数组数量与图片的存储格式有关，

对于planar yuv420，使用了3个数组来存储该数据(一个存储连续的y，一个存储连续的u，一个存储连续的v)

对于rgb24，rgb32，只是使用了一个数组来存储该数据(每个像素的rgb都在相邻的3个字节中)


> int linesize[AV_NUM_DATA_POINTERS]：

data中"一行"数据的大小。未必等于图像的宽，一般大于图像的宽。该int数组的长度与data中使用的数组数量一致。一般视频中的图片，都会要求根据当前系统位数对图片数据对其，来提高解析传输效率，如果不对其则补充字节。

* 一般对于rgb32与rgb24，只有一行需要对其，因为其用一行buf来存储数据
* 一般对于planar yuv420，有三行需要对其因为其存储使用了三个数组，

planar yuv420中的y分量长度一般=视频width对其长度
u与v分量长度相等，为y分量长度一半对其。

原因如下：

数字0表示填充的字节

![](https://note.youdao.com/yws/api/personal/file/WEB89c410924db8cd4235a17efcf9e719ab?method=download&shareKey=6a239f6d93f89f74bb128979c8737b72)


> int width, height：

视频帧宽和高（1920x1080,1280x720...）

> int nb_samples：

音频的一个AVFrame中可能包含多个音频帧，在此标记包含了几个

> int format：解

码后原始数据类型（YUV420，YUV422，RGB24...）

> int key_frame：

是否是关键帧

> enum AVPictureType pict_type：

帧类型（I,B,P...）

> AVRational sample_aspect_ratio：

宽高比（16:9，4:3...）

> int64_t pts：

显示时间戳

> int coded_picture_number：

编码帧序号

> int display_picture_number：

显示帧序号

> int8_t *qscale_table：

QP表

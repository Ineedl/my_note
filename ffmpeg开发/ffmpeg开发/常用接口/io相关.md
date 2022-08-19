## avformat_open_input

> 原型

```
int avformat_open_input(
    AVFormatContext **ps, 
    const char *url,
    const AVInputFormat *fmt, 
    AVDictionary **options
);
```

> 作用

1. 在用户没有提供AVFormatContext的情况下，创建一个格式上下文对象AVFormatContext；
2. 在用户没有提供IO层上下文对象AVIOContext的情况下，打开文件并创建IO层上下文对象AVIOContext；
3. 在用户没有指定输入文件格式AVInputFormat的情况下，探测文件格式，得到输入文件格式信息AVInputFormat；
4. 读取文件头，在文件头描述信息足够的情况下创建流AVStream以及获取并设置编解码参数相关信息；
5. 填充AVFormatContext其他字段信息。

> 参数

ps：用户提供的AVFormatContext的指针的指针，*ps可以指向NULL，当*ps指向NULL时，会自动分配一个AVFormatContext结构并且填充给用户

url：打开的视音频流的URL。

fmt：强制指定AVFormatContext中AVInputFormat的。这个参数一般情况下可以设置为NULL，这样FFmpeg可以自动检测AVInputFormat。

dictionay：附加的一些选项，一般情况下可以设置为NULL。



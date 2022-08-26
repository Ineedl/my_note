## ffprobe
ffprobe从多媒体流收集信息，然后以人可读和机器可读的方式打印出来。

ffprobe每个参数对应的打印都会在一个专门的字段内显示。

* ffprobe显示的信息只提供参考，该信息并不是在播放时会绝对保证的。

## 查看文件流信息并以json格式显示
```
ffprobe <file_name> -show_streams -print_format json
```

指定只输出音频流或视频流
```
ffprobe <file_name> -show_streams -select_streams <v/a> -print_format json 
```

## 常用选项
<<<<<<< HEAD
| 选项 | 含义 |
=======
| <span style="display:inline-block;width: 400px">选项</span> | 含义 |
>>>>>>> c1274add2561bbbff2ed1ab5a1b9a7f9f6e70532
| :------| :------ |
|-print_format 	<writer_name>|设置输出打印格式。|
|-show_streams|	显示包含在输入多媒体流中的每个媒体流的信息。|
|-show_programs|显示包含在输入多媒体流中的有关程序及其流的信息。|
|-select_streams <stream_specifier>|仅打印选择stream_specifier指定的流|
|-show_format|显示有关输入多媒体流的容器格式的信息。所有容器格式信息都打印在名为“format”的区域内。|
|-show_packets|显示包含在输入多媒体流中的每个数据包的信息。每个数据包的信息打印在一个名为“PACKET”的专用部分中。|
|-show_frames|显示包含在输入多媒体流中的每一帧和副标题的信息。每一帧的信息都被打印在一个名为“FRAME”或“SUBTITLE”的专用部分中。|
|-show_error|	显示在尝试探测输入时发现的错误信息。错误信息打印在名为“error”的部分中。|
|-show_data|以十六进制和ASCII转储的形式显示有效负载数据。常与show_packets选项一起使用来打印出数据包的原始数据信息，与show_streams将会打印流中的extradata|
|-show_log <loglevel>|显示包含在输入多媒体流中的每个媒体流的信息。这个选项需要-show_frames。|
|-count_frames|	计算每个流的帧数，并在相应的流部分报告。|
|-count_packets|计算每个流的包数，并在相应的流部分中报告它。|
|-i <input_url>|读input_url。|
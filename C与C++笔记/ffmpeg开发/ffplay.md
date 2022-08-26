## 作用
弹出一个窗口用于播放音视频文件。

```
ffplay videoOrAudio_file_name
```

## 运行后的播放控制

| 按键 | 含义 |
| :------| :------ |
| q,esc |退出 |
|f/左键双击|全屏切换|
|p,spc(空格)|暂停/继续(退出逐帧播放模式)|
|m|静音切换|
|9,0|加减音量|
|a|循环切换视频流|
|v|循环切换音频流|
|t|循环切换字幕流|
|c|切换节目(同时切换音频 视频 字幕流)|
|w|循环切换过滤器或显示模式|
|s|逐帧播放模式，如果已在该模式则进入下一帧|
|left/right|快进/快退 10秒|
|up/down|快进/快退 1分钟|
|右键在画面中横向拖动|进度条拖动|

## 常用选项
| <span style="display:inline-block;width: 200px">选项</span> | 含义 |
| :------| :------ |
|-x w|强行规定宽(不改变原有视频播放比例)|
|-y h|强行规定高|
|-fs|全屏播放|
|-an|禁用音频|
|-vn|禁用视频|
|-sn|禁用字幕|
|-seek_interval interval|自定义左/右键定位拖动间隔(以秒为单位)，默认值为10秒|
|-window_title title|自定义窗口标题|
|-noborder|无边框窗口|
|-nodisp|关闭图形化显示窗口，只在控制台显示播放过程信息|
|-ss t|从第t秒开始播放，t也可以是'55' 55 seconds, '12:03:45' ,12 hours, 03 minutes and 45 seconds, '23.189' 23.189 second等类似的时间单位|
|-t duration|设置播放视频/音频的时间长度，时间单位的填写如 -ss选项类似|
|-loop number|设置播放循环次数|
|-volume vol|设置起始音量百分比为vol|
|-showmode mode|设置显示模式，可用的模式值：0 显示视频，1 显示音频波形，2 显示音频频谱。缺省为0，如果视频不存在则自动选择2|
|-vf filtergraph|设置视频滤镜|
|-af filtergraph|设置音频滤镜|
|-f <fmt>|强制使用规定的格式解析文件|

## 常用

> 播放yuv集合

```bash
ffplay -video_size width*hight yuv集合文件路径
```

> 播放pcm音频

```bash
ffplay -ar <采样频率> -f f32le pcm文件路径
```


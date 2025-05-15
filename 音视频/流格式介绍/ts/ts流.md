[toc]

## ts

传输流，将具有共同时间基准或独立时间基准的一个或多个PES组合（复合）而成的单一数据流（用于数据传输）。

* TS流的包结构是长度是固定的；PS流的包结构是可变长度的。这导致TS流的**抵抗传输误码**的能力强于PS流

  TS码流由于采用了固定长度的包结构，当传输误码破坏了某一TS包的同步信息时，接收机可在固定的位置检测它后面包中的同步信息，从而恢复同步

  而PS包由于长度是变化的，一旦某一 PS包的同步信息丢失，接收机无法确定下一包的同步位置，就会造成失步，导致严重的信息丢失。

  因此，在信道环境较为恶劣，传输误码较高时，一般采用TS码流；而在信道环境较好，传输误码较低时，一般采用PS码流。

* TS流是基于Packet的位流格式，每个包是188个字节（或204个字节，在188个字节后加上了16字节的CRC校验数据，其他格式一样）。

## 格式

```
|    4字节        |    184字节  |
| packet head    | packet data |
```

* 对于音视频数据 data部分是PES，除此之外，都为ES协议中的信息表等数据。

### TS Head组成

| Packet Header（包头）信息说明 |                              |        |                                               |
| ----------------------------- | ---------------------------- | ------ | --------------------------------------------- |
| 1                             | sync_byte                    | 8bits  | 同步字节                                      |
| 2                             | transport_error_indicator    | 1bit   | 错误指示信息（1：该包至少有1bits传输错误）    |
| 3                             | payload_unit_start_indicator | 1bit   | 负载单元开始标志（packet不满188字节时需填充） |
| 4                             | transport_priority           | 1bit   | 传输优先级标志（1：优先级高）                 |
| 5                             | PID                          | 13bits | Packet ID号码，唯一的号码对应不同的包         |
| 6                             | transport_scrambling_control | 2bits  | 加密标志（00：未加密；其他表示已加密）        |
| 7                             | adaptation_field_control     | 2bits  | 附加区域控制                                  |
| 8                             | continuity_counter           | 4bits  | 包递增计数器                                  |

#### PID取值

PID是TS流中唯一识别标志，Packet Data是什么内容就是由PID决定的。

如果一个TS流中的一个Packet的Packet Header中的PID是0x0000，那么这个Packet的Packet Data就是DVB的PAT表而非其他类型数据（如Video、Audio或其他业务信息）。

* 部分信息的PID是固定不变的

| 表         | PID 值 |
| ---------- | ------ |
| PAT        | 0x0000 |
| CAT        | 0x0001 |
| TSDT       | 0x0002 |
| EIT,ST     | 0x0012 |
| RST,ST     | 0x0013 |
| TDT,TOT,ST | 0x0014 |

#### PSI

PSI（Program Specific Information）是一种关键的元数据信息，它用于指导接收设备如何正确解码和展示广播内容。

* PSI表格（如PAT、PMT等）会周期性地插入到TS流中，以固定的间隔重复发送

* 媒体内容（视频、音频等）的数据包与PSI表格的数据包交错存在于同一个TS流中

* 接收设备在接收到足够的PSI信息后就可以开始解码和播放媒体内容，不需要等待所有PSI信息全部接收完毕

这种设计有几个重要原因：

- 允许观众在任何时间点加入直播流（中途加入）
- 确保接收设备始终有最新的节目信息
- 提供冗余性，即使某些PSI包丢失也能恢复
- 支持动态变化的节目内容和结构

#### PAT和PMT

**PAT（Program Association Table）**

* PAT表定义了当前TS流中所有的节目，其PID为0x0000，它是PSI的根节点，要查寻找节目必须从PAT表开始查找。

- 作用：映射节目号（Program Number）到对应的 **PMT PID**。

- 内容示例：

  | Program Number | PMT PID |
  | -------------- | ------- |
  | 1              | 0x0100  |
  | 2              | 0x0101  |

  

- PAT只告诉你PMT在哪个PID，不包含PMT的内容。

**PMT（Program Map Table）**

- 作用：告诉你该节目有哪些流（音频、视频、字幕等），以及这些流对应的PID和类型。
- 例如，PMT里会列出：
  - 视频流 PID = 0x0102，类型 H.264，这个流的所有包的PID为xxxx1
  - 音频流 PID = 0x0103，类型 AAC，这个流的所有包的PID为xxxx1

- PMT是单独的表，存放在PAT指定的PID对应的包中。

##### PMT和PAT的作用

* PAT 和 PMT 是流的“目录”和“说明书”，它们告诉解码器，有哪些节目（PAT），每个节目包含的所有音视频流，以及对应的 PID（PMT），没有PAT和PMT，解码器将不知道哪些PID是音频，哪些是视频，无法正常解析。

* 流通常是周期性插入 PAT 和 PMT 表，PAT和PMT间隔一段时间重复发送，保证新加入的接收端也能及时获得表信息

##### PMT中常见音视频数据格式定义

| stream_type (hex) | 描述                      |
| ----------------- | ------------------------- |
| 0x01              | MPEG-1 Video              |
| 0x02              | MPEG-2 Video              |
| 0x03              | MPEG-1 Audio              |
| 0x04              | MPEG-2 Audio              |
| 0x0F              | AAC Audio                 |
| 0x1B              | H.264/AVC Video           |
| 0x24              | H.265/HEVC Video          |
| 0x81              | AC3 Audio (Dolby Digital) |

 


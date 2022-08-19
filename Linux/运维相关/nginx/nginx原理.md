## nginx原理图

![](https://note.youdao.com/yws/api/personal/file/8DA2B6315850464BAAB69D1DE21ADBE5?method=download&shareKey=b9c65b06dd28f1daba04d5b16e77063f)

nginx原理使用的是多进程处理方式，nginx以一个master进程与多个woker进程的方式工作。

> master进程

master进程用于在有请求到达nginx服务器时，通知所有的woker进程有请求到达并做好抢夺准备。以及管理所有的worker进程。

> woker进程

`worker对于请求的竞争`

nginx的woker进程在有请求过来时，会争夺这些请求的处理权限，woker工作即是将这些请求进行转发或是相关的处理。

`nginx可以热更新配置的原因`

woker的存在使得nginx的以重新加载配置文件进行热部署，因为重新加载配置文件后，正在处理的woker仍在处理，而原来没任务的worker将会进行处理规则的替换。

`worker之间的独立`

每个worker之间不需要加锁，是互相独立的。只要有一个worker仍然在工作，该nginx服务器仍然能正常工作。

`worker的多路复用(仅linux中,windows不清楚)`

每个worker都是通过I/O多路复用来处理客户端的连接的，其内部处理请求的只有一个线程，这使得worker在处理请求时能将cpu的性能利用到极致。


`worker的设置数量`

一般worker的数量等同于当前主机CPU的核数或是超线程数比较合理。


## 指定Redis服务启动时RDB文件的生成位置(RDB与AOF通用)
默认在启动Redis服务(使用redis-server redis.conf启动服务)的目录生成RDB文件

    dir ./

## 指定RDB文件的名字
默认生成的文件名为dump.rdb

    dbfilename dump.rdb

## RDB持久化无法写入磁盘时是否直接关闭写操作
默认是直接关闭

    stop-writes-on-bgsave-error yes
    
## RDB持久化的文件是否进行压缩存储
默认使用压缩

    rdbcompression yes
    
## RDB持久化时是否启用CRC64效验持久化的数据
存储数据拷贝在硬盘中后是否消耗部分性能来使用CRC64算法来进行数据校验，默认启用。
    
    rdbchecksum yes
    
## RDB持久化频率的设置
使用save来设置RDB持久化的评率。

    save 次数 秒数
    
save设定的格式是，在多少秒内至少改变了多少个键就存储。
        
默认情况下(每个版本的redis可能不同，详情请查看配置文件)：

1. 如果在3600秒后至少有1个键发生改变，进行持久化存储。

2. 如果在300秒后至少有100个键改变，进行持久化存储。

3. 如果在60秒后至少有10000个键改变，进行持久化存储。

`save存储规则`  

如果在第1s改变了一个key名称为k1，在第299s改变了一个key名称为k2，则在第300s的时候将会把k1与k2都持久化


如果在第1个60s内改变了10000个键，在第2个60s内改变了10000个键。则在第60s的时候持久化10000个键，在第120s这20000个键才初始化完毕。


如果在10s内改变了10001个键，在这10s内的最后第10s改变了最后一个键，则在第70s持久化前10000个键，在第3610s的持久化才把这10001个键全部持久化成功。

## RDB的关闭
配置文件中设置如下内容

    save ""



## 设置AOF的开启
默认情况下只会开启RDB，不会开启AOF

    appendonly no
    
## 设置AOF的文件名字
默认AOF文件名为appendonly.aof

    appendfilename "appendonly.aof"
    
## 设置AOF同步评率
默认情况下每秒同步用户的写操作

    # appendfsync always
    appendfsync everysec
    # appendfsync no

* no表示不会主动进行AOF同步，由操作系统来决定AOF的同步时机。

## 设置AOF重写时是否阻塞
默认情况下不启用

    no-appendfsync-on-rewrite no
    
启用时，会临时将内容写到临时文件，而不会阻塞用户操作。当用户操作完后再用临时文件同步实际文件。

## 设置AOF重写发生的阈值
默认情况下，文件大小大于64mb的1+100% 倍时 (128mb) 进行重写

    auto-aof-rewrite-percentage 100
    auto-aof-rewrite-min-size 64mb
    
> auto-aof-rewrite-percentage

重写基准值的比例

> auto-aof-rewrite-min-size

重写的基准值


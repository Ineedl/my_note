## Redis的启动

    //前台启动
    redis-server
    
    //后台启动
    //需要后台启动选项开启
    redis-server <redis配置文件位置>

## redis的关闭

    redis-cli shutdown


## 查看所有key

    keys *
    
## 判断某个key是否存在

    exists <key>
    
## 查看key的类型

    type <key>
    
## 删除指定的key

    del <key>
    
## 根据value选择非阻塞删除

    unlink <key>
    
* 该命令仅将keys从keyspace元数据中删除，真正的删除会在后续异步操作。

## 为给定的key设置过期时间

    expire <key> <num>
    
设定对应的key num秒后过期

* 过期后的值将无法获取

## 查看还有多少秒过期

    ttl <key>
    
* -1为永不过期
* -2为已过期
    
## 切换数据库

    select <num>
    
* Redis中默认有0-15编号的16个库，一般默认使用0号库

## 查看当前数据库中的key的数量

    dbsize
    
## 清空当前数据库

    flushdb
    
## 清空全部的数据库

    flushall
    
## 退出Redis数据库

    exit
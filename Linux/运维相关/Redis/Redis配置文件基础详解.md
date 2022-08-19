## Redis不重启配置修改命令

    config set  <配置key> <配置的value> [配置的value2]
    
`例`

    config set bind 127.0.0.1 -::1

## Redis获取配置命令

    config get <配置的key>
    
`例`

    config get port

## Redis配置文件中导入其他配置文件
因为Redis中启动服务可以指定配置文件，而且多个相同配置时后面的配置会替换前面的配置，故可以导入主配置文件来创建不同环境的子配置。

    include 其他配置文件名

## Redis主配置文件的位置
redis.conf文件，一般redis在后台开启一个服务需要指定redis.conf文件的位置。


## 大小单位的支持
配置文件中开头定义了一些基本的度量单位，只支持字节，不支持比特，而且对大小度量单位的大小写不敏感。

## 其他文件的包含
Redis的主配置文件可以使用include来包含其他的配置。配置文件中有举例。

## 地址访问设置
Redis中使用bind绑定一个可以远程连接本地Redis服务器的IP地址，当不写bind时(注释掉原有的)，默认对所有的主机开启Redis服务。

* 每个地址都可以用“-”作为前缀，这意味着如果该地址不可用，redis也不会启动失败

`默认设置`

    bind 127.0.0.1 -::1
    
默认配置表示只有本地127.0.0.1可以访问Redis服务。

第二个 -::1 表示只有本地的IPv6(相当于IPV6版的127.0.0.1)才能访问

::1前面加-表示当::1无法访问到该服务时，该服务启动不会实效。

## 保护模式

    protected-mode <bool>
    
默认配置为yes，表示不允许远程连接，为no时支持远程访问。

## 服务端口号
默认6379

    port 6379
    
## TCP连接队列的总数
默认情况下，允许与该Redis服务器建立最多511个TCP连接(包括未完成三次握手的TCP连接)

    tcp-backlog 511
    
## Redis服务的后台运行
默认不允许

    daemonize no
    
## 存放pid文件的位置
pid文件存放了Redis启动后的进程id

默认pid文件存放位置为

    pidfile /var/run/redis_6379.pid
    
## Redis日志的级别
默认为notice级别，只显示一般生产使用的日志。

    loglevel notice

## Redis日志文件位置
默认不产生日志文件，为空

    logfile ""
    
## 默认可使用的数据库数量
默认最多可以使用16个数据库，不管怎么设置，数据库下标范围为0 ~ databasesNum-1

    databases 16
    
## Redis访问密码设置
默认无密码，该选项被注释

    # requirepass foobared
    
* 在命令中设置密码只是临时的，服务启动后不会继承该设置。

`配置登录密码`

    requirepass <你的密码>

## 最大客户连接数
默认设置Redis同时最多可以与1W个客户端连接，不设置时默认为1W。目前未知最高上限。

    # maxclients 10000

## Redis的可用内存
默认不限制Redis的最大可用内存，设置后当Redis的内存使用超过一定限制时，将会按配置文件中配置的规则(maxmemory-policy中设置的规则与maxmemory-sample的设置)来释放内存空间到达该设定值下。

    # maxmemory <bytes>
    
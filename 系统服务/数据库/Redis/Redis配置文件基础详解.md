[toc]

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

## 内存淘汰机制

```
# -----------------------------------------------------------------------------
# 内存淘汰策略 (Eviction Policy)
# 当内存达到 maxmemory 限制时，Redis 将如何选择要删除的 Key。
#
# 【基础策略 - 自 Redis 1.0 起支持】
# 1. noeviction      -> 默认策略。不删除任何数据，内存满后写操作报错。
# 2. allkeys-lru     -> 在所有 Key 中，移除最近最少使用的 Key (LRU)。
# 3. volatile-lru    -> 在设置了 TTL 的 Key 中，移除最近最少使用的 Key (LRU)。
# 4. allkeys-random  -> 在所有 Key 中，随机移除某个 Key。
# 5. volatile-random -> 在设置了 TTL 的 Key 中，随机移除某个 Key。
# 6. volatile-ttl    -> 在设置了 TTL 的 Key 中，优先移除剩余存活时间最短的 Key。
#
# 【高级频率策略 - 自 Redis 4.0 起支持】
# 7. allkeys-lfu     -> 在所有 Key 中，移除访问频率最低的 Key (LFU)。
# 8. volatile-lfu    -> 在设置了 TTL 的 Key 中，移除访问频率最低的 Key (LFU)。
#
# 提示：如果你的 Redis 版本低于 4.0，设置 LFU 相关策略会导致启动失败。
```

* 算法精度调整

  Redis 的 LRU 和 LFU 算法是近似实现（为了节省 CPU），可以通过以下参数调整样本量。

  ```
  # Redis 默认随机抽取 5 个 Key 来检查。
  # 增加该值会更精确，但会消耗更多 CPU；减小该值则相反。
  maxmemory-samples 5
  ```

  

## 过期删除频率调整

```
# 执行后台任务（如关闭超时连接、清理过期 Key）的频率。
# 默认值为 10，即每秒执行 10 次。
# 范围为 1 到 500。值越大，清理过期 Key 越及时，但对 CPU 压力越大。
hz 10

# 开启动态频率调整。当连接数很多时，会自动略微调高 hz 以应对负载。
dynamic-hz yes
```

## 异步删除配置(**引入版本**：**Redis 4.0** (2017年发布))

针对大 Key（例如包含数万个元素的 List 或 Hash），同步删除会阻塞主线程。开启以下配置可以使其在后台异步执行。

```
# 释放过期 Key 时的行为是否异步
lazyfree-lazy-expire yes

# 内存满触发淘汰机制时，是否采用异步删除
lazyfree-lazy-eviction yes

# 针对隐式删除 (例如 RENAME 一个已存在的 Key) 是否异步
lazyfree-lazy-server-del yes

# 针对 Replica 同步清空数据时是否异步
replica-lazy-flush yes
```


<<<<<<< HEAD:系统服务/Redis/redis应用问题与应用/Redis缓存雪崩.md
## 缓存雪崩
过程同缓存击穿，但是缓存雪崩是指对多个key的突然访问量变大或是对多个热门key查询时，这些key突然过期。

即极少的时间段，查询的大量key集中过期了。

## 常用的基本解决方案

> 构建多级缓存架构

当某一级缓存失效后，让另一级来处理。

> 使用锁或队列

不适合高并发情况，使用锁或是队列的方式保证不会有大量的线程对数据库(不是缓存)，一次性进行读写，从而避免失效时大量的并发请求落到底层存储系统上。

> 设置过期标志更新缓存

记录缓存数据是否过期，过期会触发通知其他线程在后台去更新实际key的缓存。

> 将缓存实效时间分散开

=======
## 缓存雪崩
过程同缓存击穿，但是缓存雪崩是指对多个key的突然访问量变大或是对多个热门key查询时，这些key突然过期。

即极少的时间段，查询的大量key集中过期了。

* 缓存击穿和雪崩的区别：是否是多个key造成数据库压力增大。

## 常用的基本解决方案

> 构建多级缓存架构

当某一级缓存失效后，让另一级来处理。

> 使用锁或队列

不适合高并发情况，使用锁或是队列的方式保证不会有大量的线程对数据库(不是缓存)，一次性进行读写，从而避免失效时大量的并发请求落到底层存储系统上。

> 设置过期标志更新缓存

记录缓存数据是否过期，过期会触发通知其他线程在后台去更新实际key的缓存。

> 将缓存实效时间分散开

>>>>>>> aa31a0ee66c367db6b8407d052989feeb2d5a29a:Linux/运维相关/Redis/redis应用问题与应用/Redis缓存雪崩.md
避免大量key在同一时间全部实效。
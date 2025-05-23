## Redis中的事务
Redis事务是一个单独的隔离操作，十五中的所有命令都会序列化的按顺序执行。事务在执行的过程中不会被其他客户端发送来的命令请求所打断。

Redis事务的主要作用就是串联多个命令防止别的命令插队。

## Redis的事务操作
从输入multi命令开始，输入的命令都会依次进入命令队列中不会执行，直到输入exec命令，之后Redis会将之前命令队列中的命令依次执行。

输入multi命令后，输入exec命令前，在队列中插入命令的过程可以用discard来取消命令队列的组队(退出组队状态回滚到multi命令之前)。

* 输入multi命令后的组队阶段，如果其中有某个命令出现了报错，这整个队列在exec后都会失败。

`例`

    multi
    set key1 v1
    set key2
    exec
    
    //直接报错，两个命令都不会被执行

* 输入exec后的执行阶段如果其中有任何一个命令出错(组队阶段该命令没有出错)，那么只有该出错的命令不被执行，其他的命令都会被执行。

`例`

    multi
    set key1 v1
    incr key1
    exec
    
    //只有incr key1不会被执行

输入multi后会显示OK表示开始事务，之后输入的命令都会显示QUEUED。


## Redis事务特性

* Redis事务比起事务，更像是脚本。

> 没有隔离级别概念

事务中的命令在提交前都不会被实际执行。

> 不保证原子性

事务中如果有一条命令执行失败，也只有那条命令执行失败，事务不会回滚。

> 单独的隔离操作

事务在执行时不会被其他客户端发送的命令打断
=======
## Redis中的事务
Redis事务是一个单独的隔离操作，事物中的所有命令都会序列化的按顺序执行。事务在执行的过程中不会被其他客户端发送来的命令请求所打断。

Redis事务的主要作用就是串联多个命令防止别的命令插队。

## Redis的事务操作
从输入multi命令开始，输入的命令都会依次进入命令队列中不会执行，直到输入exec命令，之后Redis会将之前命令队列中的命令依次执行。

输入multi命令后，输入exec命令前，在队列中插入命令的过程可以用discard来取消命令队列的组队(退出组队状态回滚到multi命令之前)。

* 输入multi命令后的组队阶段，如果其中有某个命令出现了报错，这整个队列在exec后都会失败。

`例`

    multi
    set key1 v1
    set key2
    exec
    
    //直接报错，两个命令都不会被执行

* 输入exec后的执行阶段如果其中有任何一个命令出错(组队阶段该命令没有出错)，那么只有该出错的命令不被执行，其他的命令都会被执行。

`例`

    multi
    set key1 v1
    incr key1
    exec
    
    //只有incr key1不会被执行

输入multi后会显示OK表示开始事务，之后输入的命令都会显示QUEUED。


## Redis事务特性

* Redis事务比起事务，更像是脚本。

> 没有隔离级别概念

事务中的命令在提交前都不会被实际执行。

> 不保证原子性

事务中如果有一条命令执行失败，也只有那条命令执行失败，事务不会回滚。

> 单独的隔离操作

事务在执行时不会被其他客户端发送的命令打断

### 事物执行顺序

Redis事务执行是三个阶段：

- **开启**：以MULTI开始一个事务
- **入队**：将多个命令入队到事务中，接到这些命令并不会立即执行，而是放到等待执行的事务队列里面
- **执行**：由EXEC命令触发事务

当一个客户端切换到事务状态之后， 服务器会根据这个客户端发来的不同命令执行不同的操作：

- 如果客户端发送的命令为 EXEC 、 DISCARD 、 WATCH 、 MULTI 四个命令的其中一个， 那么服务器立即执行这个命令。
- 与此相反， 如果客户端发送的命令是 EXEC 、 DISCARD 、 WATCH 、 MULTI 四个命令以外的其他命令， 那么服务器并不立即执行这个命令， 而是将这个命令放入一个事务队列里面， 然后向客户端返回 QUEUED 回复。

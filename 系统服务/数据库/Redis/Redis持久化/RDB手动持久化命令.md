## save
save命令能在当前时刻进行持久化操作

    save
    
* save命令启动持久化后，在持久化完成之前将会阻塞redis的全部操作。

* save与bgsave都属于RBD命令，这两个命令对AOF不适用

* AOF与RDB同时开启或是RDB关闭的情况下的情况下，sav与bgsave同样可以持久化一个rdb文件。

## bgsave

    bgsave
    
bgsave同save，但是bgsave在持久化是异步的执行，在持久化的同时还可以响应客户端的操作



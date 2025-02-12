## 设置nginx服务器worker的数量
```
    worker_process <num>
```
 
## 给worker设置绑定的CPU(了解)
```
    //4个worker绑定4核cpu中的四个核
    worker_cpu_affinity 0001 0010 0100 1000
    
    //4个worker绑定8核cpu中的四个核
    worker_cpu_affinity 00010000 00100000 01000000 10000000
    
```
## 每个worker支持的最大并发连接数
```
    //最大支持1024个连接，这个和一个进程能打开的最大文件描述符数有关。
    worker_connection <num>

```
```

    静态访问最大并发数: worker_connection*worker_process/2
    正常访问的最大并发数: worker_connection*worker_process/4

``



该连接数指的是该worker与客户端，或是其他相关服务进行连接时的最大并发连接数。处理客户端连接仍然只有一个线程。
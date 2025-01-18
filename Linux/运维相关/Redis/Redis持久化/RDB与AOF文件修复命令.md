## 错误导致Redis无法连接
当人为修改持久化文件或是持久化文件发生损坏时，可能导致Redis服务无法正常启动或是Redis客户端无法连接到服务端，这个时候就需要来修复持久化文件。


## 损坏的RDB文件修复命令

    redis-check-rdb <rdb文件>
    
## 损坏的aof文件文件修复命令

    redis-check-aof --fix <aof文件>
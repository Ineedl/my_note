## nginx配置文件名
```
    nginx.conf
```

## 默认安装时nginx使用的配置文件位置
```
    /etc/nginx/nginx.conf
```

## 配置文件的组成
nginx的配置文件由三部分组成

> 全局块

从配置文件到events块之间的内容(其实这些配置放在最外层就行)，这些内容会响应nginx服务器整体运行的配置指令(进程pid文件位置，允许生成的工作进程数，日志存放位置等)

`例`
```
    user nginx;
    worker_processes auto;  #nginx处理并发的数量
    error_log /var/log/nginx/error.log;
    pid /run/nginx.pid;
```

> events块

events中设置影响用户与nginx服务器网络连接。

`例`
```
    events{
        worker connections 1024; #nginx服务器支持的最大连接数
    }
```

> 协议代理设置块(http/tcp等)

该部分是nginx中设置最频繁的部分，可以设置相关协议的代理，缓存以及日志定义等，

* 这些块中大多包含其他子块。

> HTTP块协议代理块

`server块`

该块中配置nginx服务器监听的端口以及本虚拟主机的名称或ip设置。

`location块`

一个server块可以存在多个location块，location块用于设置客户端申请url与其他或是本地主机相关服务的匹配。

> 配置文件结构

    //全局块位置，全局配置都写在最外面
    events {
    //event块位置，
    }
    
    http {
        //协议代理设置块位置
        server {
    
            }
        }
    
    }

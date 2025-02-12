## 配置文件参考

* [详细说明](https://github.com/fatedier/frp/blob/dev/README_zh.md)

* [github地址](https://github.com/fatedier/frp)

* frp支持多个端口映射到一个端口或是一个端口映射到多个端口，但还是推荐一对一映射

* frp支持映射本机所在局域网中其他机器的端口。

## frp服务器设置
`配置文件`  
frps.ini   
`启动文件`  
frps  
`启动命令`  

    ./frps -c ./frps.ini(此处为frps.ini文件位置,不写默认绑定7000端口)

## 服务器配置文件简单设置

    [common]
    bind_port = 7000        //绑定的服务器端口
    

## frp客户端设置
`配置文件`  
frpc.ini  
`启动文件`    
frpc  
`启动命令`  

    ./frpc -c ./frpc.ini(此处为frps.ini文件位置，必须指定)


## 客户端配置文件简单设置

    [common]
    server_addr = 120.24.243.216        //公网frp服务器ip地址
    server_port = 7000                  //公网frp服务连接端口
    
    [tcp01]                             //可以有多个名字随意
    type = tcp                          //支持 tcp, udp, http, https 协议
    local_ip = 127.0.0.1                //本地ip即可
    local_port = 3306                   //本地要映射的端口
    remote_port = 8000                  //服务器上对应映射的端口
    
    [tcp02]
    type = tcp
    local_ip = 127.0.0.1
    local_port = 3306
    remote_port = 8001

    

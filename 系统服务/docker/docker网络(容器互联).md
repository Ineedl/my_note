## --link
在执行 docker run的时候可以加上参数

    --link <容器名>
    
来指定运行的容器可以使用--link后的容器名为服务名来进行网络服务

`例子`

    docker run tomcat1
    
    //tomcat2中的虚拟机可以使用ping tomcat1来ping通tomcat1中虚拟机
    docker run --link tomcat1 tomcat2
    
### --link原理
--link相当于在对应的虚拟机的/etc/hosts文件中添加了对tomcat1服务的映射。

`例子`

    docker run --link tomcat1 tomcat2
    
    //tomcat2中的/etc/hosts文件中会有如下内容
    docker分配的ip  tomcat1   tomcat1容器id
    
    
* --link后只能进行单向服务，如果需要进行双向网路服务，则需要双向--link启动或是直接修改对应容器中的/etc/hosts文件

* --link不能指定docker0的网络(实机在docker网络中虚拟网卡)

* --link已被遗弃，不再推荐使用，但是其原理仍需要知道


## docker网络相关命令

    docker network --help

## 自定义网络
### docker中的网络模式
* bridge (默认网络模式选项)


    docker run --net=bridge

* none 不配置网络


    docker run --net=none

* host 和宿主机共享网络


    docker run --net=host

* container 容器网络连通，和已经存在的某个容器共享IP与端口(很少使用)

    docker run --net=container:<容器NAME/ID>


### 查看docker中已存在的网络

    docker network ls

* docker中每个网络模式都有一个默认存在的网络


### 查看某个网络的信息

    docker network inspect <网络名/网络id>

### 网络的自定义

    docker network create <自定义网络名>
    
* 常用选项


    --driver <使用的网络驱动>             指定创建网络的驱动(默认使用bridge建立一个桥接网络)。
    --subnet <子网掩码与ip前缀>         设置子网掩码和ip前缀
    --getway <网关ip>                   设置网关

* 建立一个新的网络后，将会自动生成一个网络id，之后便可以使用docker network ls查看

### 发布一个容器到某个docker网络
*在docker run中使用--net <使用的网络名>
    
    docker run --net <使用的网络名> --name=容器名 镜像名/镜像id
    

### docker之间的网络连通
该命令让一个其他网络中容器接入到了另外一个网络，之后该容器可以与该网络中的所有容器通信。

    docker network connect <要接入的docker网络名> <容器id1> 
    
#### 原理
使用了一个容器多个ip的方法(相当于虚拟机网路原理)，直接使用veth_pair技术给容器添加了一个新的在另一个网段中的的虚拟网卡。

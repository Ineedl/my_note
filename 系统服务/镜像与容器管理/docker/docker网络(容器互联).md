[toc]

## 网络介绍

### 桥接

Docker默认网络模式。它会在主机上创建一个名为docker0的虚拟网桥。此主机上启动的Docker容器会连接到这个虚拟网桥上，使得主机上的所有容器都通过交换机连接在一个二层网络中。

Docker会为每个新创建的容器分配独立的Network Namespace和IP段等。容器内部会有一个虚拟网卡，名为eth0，容器间可以通过这个虚拟网卡进行通信。该虚拟网卡的网关为docker0。

### Host 网络 

容器直接融入到主机的网络栈中，使得容器直接使用主机的网络接口和IP地址。和宿主机共用一个Network Namespace。容器内部的服务可以使用宿主机的网络地址和端口，无需进行NAT转换，网络性能较好。

### None网络

将容器与宿主机隔离开来，不提供任何网络能力。容器内部没有网卡、IP地址、路由等信息，只有一个回环网络（loopback）接口。容器不能访问外部网络，也不能被外部网络访问。
### container 模式

创建的容器和已经存在的一个容器共享一个Network Namespace，而不是和宿主机共享。新创建的容器不会创建自己的网卡、配置自己的IP地址，而是和一个已存在的容器共享IP地址、端口范围等网络资源。两个容器的进程可以通过lo网卡设备通信。但两个容器在其他方面，如文件系统、进程列表等，仍然是隔离的。

## 网络驱动程序

Docker使用Linux内核的一些特性来实现其网络功能，而这些功能是通过不同的网络驱动程序来实现的。Docker支持多种网络驱动程序，每种驱动程序都有其特定的用途和场景。

* bridge（桥接）：这是Docker的默认网络驱动程序。它会在宿主机上创建一个虚拟网桥（通常是docker0），并将容器连接到这个网桥上。容器之间以及容器与宿主机之间可以通过这个网桥进行通信。bridge模式适用于单个宿主机上的容器互联场景。
* host：host网络驱动程序将容器直接融入主机的网络栈中，容器将共享主机的网络接口和IP地址。这意味着容器内部的服务可以直接使用主机的网络地址和端口，无需进行NAT转换。host模式适用于需要容器与宿主机共享网络资源的场景，但需要注意安全性和隔离性问题。
* overlay：overlay网络驱动程序用于创建跨多个Docker守护进程的分布式网络。它通过内置的DNS服务实现容器之间的跨主机通信。overlay模式适用于需要构建分布式应用程序的场景，可以让容器在不同宿主机之间进行通信。
* macvlan：macvlan网络驱动程序允许容器使用宿主机的物理网络接口，并为其分配一个MAC地址。这样，容器可以像虚拟机一样直接连接到物理网络上，并与其他设备通信。macvlan模式适用于需要容器直接访问物理网络的场景。
* ipvlan：ipvlan是另一种类似于macvlan的网络驱动程序，但它基于IP地址而不是MAC地址来分配网络。ipvlan模式提供了更好的扩展性和灵活性，适用于不同的网络场景。
* none：none网络驱动程序不提供任何网络功能，容器将处于完全隔离的状态。它通常用于一些特殊场景，如运行与网络无关的应用程序或进行网络调试。
  

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


​    
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
* 在docker run中使用--net <使用的网络名>

    docker run --net <使用的网络名> --name=容器名 镜像名/镜像id


### docker之间的网络连通
该命令让一个其他网络中容器接入到了另外一个网络，之后该容器可以与该网络中的所有容器通信。

    docker network connect <要接入的docker网络名> <容器id1> 

#### 原理
使用了一个容器多个ip的方法(相当于虚拟机网路原理)，直接使用veth_pair技术给容器添加了一个新的在另一个网段中的的虚拟网卡。

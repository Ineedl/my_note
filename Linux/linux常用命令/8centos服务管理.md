## [systemctl相关命令介绍博客](https://blog.csdn.net/u012486840/article/details/53161574)

## systemctl
CentOS 7.x开始，CentOS开始使用systemd服务来代替daemon，原来管理系统启动和管理系统服务的相关命令全部由systemctl命令来代替。

* systemctl不止可以用来操作服务，其拥有很多强大的功能，此处只介绍服务相关操作

### 单元的概念
Systemd由一个叫做单元（Unit）的概念，它保存了服务、设备、挂载点和操作系统其他信息的配置文件，并能够处理不同单元之间的依赖关系。大部分单元都静态的定义在单元文件中，也有一些是动态生成的。

`单元的状态：`

处于活动（active）:当前正在运行

停止（inactive）:当前已经停止

启动中（activing）:当前正在启动

停止中（deactiving）:当前正在停止

失败（failed）:单元启动过程中遇到错误比如找不到文件、路径或者进程运行中崩溃了等。

* 一共有11种不同类型的单元，软件服务算单元的一种。


### 服务相关操作
`服务的启动与停止`

    //启动服务
    systemctl start <服务对应单元名>
    //停止服务
    systemctl stop <服务对应单元名>	
    //重启服务
    systemctl restart <服务对应单元名>
    
`服务的状态查询`

    //查看服务是否运行
    systemctl is-active <服务对应单元名>	

    //查看服务是否设置为开机启动
    systemctl is-enabled <服务对应单元名>
    
    //查看服务的完整状态
    systemctl status <服务对应单元名>
    
* 状态为四种单元状态中的一种。


`设置服务开机自启动`

    //设置服务开机自启
    systemctl enable <服务对应单元名>
    
    //设置服务开机不自启
    systemctl disable <服务对应单元名>
    
`查看系统上的服务`

    //列出所有启动的单元
    systemctl  
    systemctl list-units
    
    //列出所有的单元
    systemctl  -all
    systemctl list-units -all
    
    //列出所有单元对应的启动文件，enable表示开启自启。
    systemctl list-unit-files
    
    //列出所有service类型的unit
    systemctl list-units –type=service –all
    
    
## centos7防火墙的简单使用
从centos7开始，使用firewalld防火墙

* docker的端口映射可以绕过防火墙

`重启防火墙`

    firewall-cmd --reload


`查看已临时开放的端口(防火墙开启不会自动开启)`

    firewall-cmd --list-ports
    
`查看永久开放的端口(防火墙开启会自动开启)`

    firewall-cmd --list-ports --permanent
    
`添加临时tcp端口`

    firewall-cmd --zone=public --add-port=端口号/tcp
    
`添加永久的tcp端口`    

    firewall-cmd --zone=public --add-port=端口号/tcp --permanent
    
`移除临时tcp端口`
    
    firewall-cmd --zone=public --remove-port=端口号/tcp
    
`移除永久的tcp端口`

    firewall-cmd --zone=public --remove-port=端口号/tcp --permanent
    
* 防火墙规则设置后必须重启生效.
* 防火墙有很多的使用技巧此处只谈简单使用
* 该防火墙有很多的zone，默认情况下都使用public(zone不写也是public)
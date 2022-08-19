## yum
yum实质上是一个rpm管理工具，他根据用户需要自动分析某个软件所需要的依赖，然后从远程仓库中下载该依赖所需的全部rpm软件包并安装

`yum源文件位置`

    //yum源文件位置
    /etc/yum.repos.d/
    
    //系统基本yum源
    /etc/yum.repos.d/CentOS-Base.repo


`常用命令`
* 列出全部软件包

    
    yum list [包名]
    
加上某个包名时仅该包相关列表。

* 列出所有能更新的rpm软件包


    yum list updates
    
* 列出所有已安装的rpm软件包


    yum list installed


* 在软件仓库中搜索软件相关包


    yum search <软件名>

* yum安装


    yum install <软件名>
    
* yum卸载


    yum remove <软件名>

*  查看系统软件改变历史

    
    yum history
    
* 清空所有yum缓存的rpm包与相关缓存信息

    
    yum clean all 
    
* 列出yum源仓库信息


    //显示所有仓库
    yum repolist all 
    
    //显示所有可用仓库
    yum repolist enabled
    
`其他yum源的手动添加`
* 安装yum的扩展包


    yum install yum-utils -y
    
* 手动添加其他yum源

    
    yum-config-manager --add-repo=<其他软件源地址>
    

## rpm
## rpm命令
rpm命令用于给linux系统安装来用rpm包的形式安装软件
```
    rpm [选项] 你的rpm包文件
```

常用选项:
```
    -q      询问模式
    -v      显示命令执行过程
    -i      安装rpm包
    -e      卸载对应的软件
    -l      显示该软件安装后的文件位置
    -a      查询安装了的所有rpm软件包
    -f      查看文件所在的软件包
```

常用命令
```
安装rpm包                           rpm -ivh x.rpm/软件名
    
卸载rpm包                           rpm -evh x.rpm/软件名
    
查询rpm包的文件位置                 rpm -ql  x.rpm/软件名
    
列出全部已安装的rpm包               rpm -qa 
    
查询某个软件所在的软件包全名        rpm -q  软件名
    
查询某个文件所在的软件包的全名      rpm -qf 文件名
    
查询软件包的相关信息                rpm -qi x.rpm

查询某个文件所在软件包的信息        rpm -qif 文件名
    
```
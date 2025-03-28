## ACL
ACL为访问控制列表的缩写，该功能允许根据可以执行的命令和可以访问的键来限制某些连接。

类似mysql中的用户表，但是管理相对简单，允许添加相关用户以及赋予他们权限。

> ACL命令

`查看权限表`
```
    acl list
    
    //格式为
    固定格式user user_name 用户是否启用 密码 该用户允许操作的key 该用户允许执行的命令。
    
```

`当前用户允许的操作命令类别`
```
    //查看当前用户允许的全部操作类别
    //比如string，set，数据库一般操作等
    acl cat
    
    //查看具体某一个类别的全部指令
    acl cat <类别>
    //比如acl cat string
```
`查看我是哪个用户`
```
    acl whoami
```
`创建用户`
```
    acl setuser <user_name> [用户相关设置]
```    
* 用户的添加与设置详情百度。


`切换用户`
```
    auth <user_name> [password]
```


## Redis的I/O多线程

Redis6加入多线程，但是多线程只是用于解析网络协议，以及与多用户的数据传输等，对于数据的处理仍然使用单线程。

> IO多线程的配置

默认不开启I/O多线程，而且启动的I/O线程数量默认注释为4。

```
    #io-threads-do-reads no
    #io-threads 4
```
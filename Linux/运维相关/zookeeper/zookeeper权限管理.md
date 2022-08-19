## 添加一个用户认证
```
    addauth <认证方案> <用户名:密码>
```

* addauth只是临时给当前登录者给予一个临时认证，退出登陆后，需要重新认证，真正的相关认证信息都需要用setAcl来设置。

`例`

    addauth digest cjh:123456
    addauth digest kj:123456
    addauth digest ty:123456
    
    //我现在相当于即是cjh，也是kj，也是ty。但是退出客户端后我再次连接需要重新认证。

> 认证方案

|方案|描述|
|:--|:--|
|world|设置所有人都可以访问(该方案只有一个用户anyone)|
|ip|使用Ip地址认证|
|auth|使用已认证的用户添加到ACL表|
|digest|使用用户名:密码的方案来添加到ACL表|

> 权限

|操作|acl简写|意义|
|:--|:--|:--|
|CREATE|c|建立子节点权限|
|DELETE|d|删除子节点权限(该节点本身的删除权限没有，仅该节点的下一级，其下一级的下一级其没有权限删除)|
|READ|r|可节点数据与子节点列表|
|WRITE|w|可设置节点数据|
|ADMIN|a|获得设置节点的acl列表权限|

* acl用户权限只是针对于一个列表，而不是存储在zookeeper中的某一个用户，该用户只存在于acl列表中，一个客户端用户可以认证多个ACL身份。

## 设置权限
```
    setAcl <path> <acl>
```

`例`
```
    //world方案，设置/节点允许所有人r与w的acl权限
    //setAcl <path> world:anyone:<acl>
    
    setAcl / world:anyone:rw
    
    
    //ip方案，设置允许ip为192.168.1.1与192.168.1.2的主机对/节点有r与w的acl权限
    //setAcl <path> ip:[ip:...]:<acl>
    
    setAcl / 192.168.1.1:192.168.1.2:[...]:rw
    
    
    //auth方案，设置/节点，给与该节点一个cjh用户，只有用户认证了该cjh用户，才能对/节点进行cdrwa。
    //addauth digest <user>:<password> #添加认证用户
    //setAcl <path> auth:<user>:<acl>
    
    addauth digest cjh:123456
    setAcl / auth:cjh:cdrwa
    
    
    //digest方案，同auth，但是并不是使用已经认证的用户添加到对应路径的ACL表。
    //setAcl <path> digest:<user>:<password>:<acl>
    
    setAcl / digest:cjh:123456:cdrwa
    
```   
  
## 获得权限
```
    getAcl <path>
```


## 设置超级用户

> 设置root用户所需的操作

在zookeeper启动脚本中(linux为zkServer.sh)

查找nohup命令开头的命令，在命令的选项参数中添加(最好是$JAVA后面的几个参数之后添加)

    "-Dzookeeper.DigestAuthenticationProvider.superDigest=super:xQJmxLMiHGwaqBvst5y6rkB6HQs="

之后启动服务端，再使用客户端时使用super:admin既可以获得超级管理员认证，即在zookeeper中的root权限

    addauth digest super:admin
    
> 原理解释    
    
上述中的额外参数中的

    super:xQJmxLMiHGwaqBvst5y6rkB6HQs=
    
对应的是管理员的名称与加密后的密码，其相当于是直接使用加密后的密码与管理员名称添加了一个root用户在zookeeper中。


> 使用自定义的管理员用户与密码

密码是经过SHA1及BASE64处理的密文，在SHELL中可以通过以下命令计算：

    echo -n <user>:<password> | openssl dgst -binary -sha1 | openssl base64
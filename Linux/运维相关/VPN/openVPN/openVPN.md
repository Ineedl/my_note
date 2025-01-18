## 一个比较好的搭建教程

[1](http://www.linuxboy.net/linuxjc/128348.html)

## openVPN

[github地址](https://github.com/OpenVPN/openvpn)

OpenVPN的技术核心是虚拟网卡(tun与tap技术)，其次是SSL协议实现。


OpenVPN使用OpenSSL库来加密数据与控制信息。这意味着，它能够使用任何OpenSSL支持的算法。它提供了可选的数据包HMAC功能以提高连接的安全性。


## openVPN身份验证
OpenVPN提供了多种身份验证方式，用以确认连接双方的身份，包括：

① 预享私钥

② 第三方证书

③ 用户名／密码组合

　　预享密钥最为简单，但同时它只能用于创建点对点的VPN；基于PKI的第三方证书提供了最完善的功能，但是需要额外维护一个PKI证书系统。OpenVPN2.0后引入了用户名／口令组合的身份验证方式，它可以省略客户端证书，但是仍需要一份服务器证书用作加密。
　　
* 此处使用第三方证书来完成openVPN

## openVPN的安装
此处使用源码安装，安装后openvpn命令能使用即可


## easy-rsa
该工具用来制作openVPN的相关通信证书

* [easy-rsa可以从此处的github上的地址获取(常用版本3.0.5)](https://github.com/OpenVPN/easy-rsa)

> 证书信息文件的修改(可跳过)

解压该工具的压缩包后，easy-rsa目录下的vars.example为证书信息的模板文件，如果不需要默认的证书信息文件，使用自己的证书信息，则需要将该模板文件赋值并且去掉example命令，然后加入以下内容设置证书信息(当然不加也可以，该工具将会自动默认使用一个证书信息)

    set_var EASYRSA_REQ_COUNTRY     "国家"
    set_var EASYRSA_REQ_PROVINCE    "省市"
    set_var EASYRSA_REQ_CITY        "城市"
    set_var EASYRSA_REQ_ORG         "组织名"
    set_var EASYRSA_REQ_EMAIL       "邮箱"
    set_var EASYRSA_REQ_OU          "证书拥有者"
    
> 服务端证书的建立

在有easy-rsa程序的目录下

`初始化`

    ./easyrsa init-pki
    
`建立根证书(CA证书)`

    ./easyrsa build-ca
    
在上述部分需要输入PEM密码 PEM pass phrase，输入两次，此密码必须记住，不然以后不能为证书签名。还需要输入common name 通用名，这个你自己随便设置个独一无二的。

* 改证书用来建立服务端与客户端的证书，相当于是一个人本人的证书

`建立服务端的证书`

    ./easyrsa gen-req <证书名> nopass
    
该过程中需要输入common name，随意但是不要跟之前的根证书的一样    

    
`对证书的签约`

    ./easyrsa sign server <之前建立的服务端证书名>
    
该命令中.需要你确认生成，要输入yes，还需要你提供我们当时创建CA时候的密码。

`确保key穿越不安全网络的命令`

    ./easyrsa gen-dh

* 该命令默认建立一个dh.pem的文件    
    
`服务端相关证书与秘钥文件的位置`

生成位置都在服务端easy-rsa的家目录下的pki目录中

    //CA证书
    ../easy-rsa/easyrsa3/pki/ca.crt     //固定名称CA

    //服务端秘钥
    ../pki/private/服务端秘钥名.key 

    //服务端证书
    ../easyrsa3/pki/issued/服务端证书名.crt 

    //dh秘钥
    ../easyrsa3/pki/dh.pem              //固定名称dh
    
> 客户端证书的建立

再解压一次easy-rsa压缩包重新初始化客户端环境


`在有easy-rsa程序的目录下初始化`

    ./easyrsa init-pki
    
`建立req文件与客户端秘钥与证书` 
    
    ./easyrsa gen-req <证书与req文件与秘钥公用的名字>
    
* 此处要设置用户登录名与用户登录密码(登录名随意，反正使用证书登录)
    
`进入到服务端的easy-rsa目录下导入上步生成的req`

    cd 服务端easy-rsa目录
    
    ./easyrsa import-req  客户端目录下/pki/reqs/pki/reqs/<客户端req文件名>.req <req导入后信息文件名>
    
`使用导入信息签约证书`

    cd 服务端easy-rsa目录
    
    ./easyrsa sign client <req导入后信息文件名>

* 签约需要使用服务端CA密码

 `客户端相关信息文件的位置`
 
    //服务端CA证书
    服务端家目录/pki/ca.crt

    //签约的客户端的证书，该签约证书的名字与在服务端导入客户端req文件信息后的信息文件名一致
    服务端家目录/pki/issued/客户端签约证书名.crt

    //客户端的秘钥
    客户端家目录/pki/private/客户端秘钥名.key 
 
## openVPN服务端的启动
> 服务端配置文件的修改  

`配置文件的路径`

    //openVPN家目录下
    ./sample/sample-config-files/server.conf
    
    //或者就在家目录下
    server.conf

`简单使用时的相关配置`  

只需要下列配置的修改与添加，其余的在配置文件中默认，下列配置中有部分为默认值。
  
    //配置文件中;开头也算注释

    local 0.0.0.0       //允许连接本地openVPN服务的ip，0.0.0.0表示全部
    
    port 1194           //本地服务器开放端口
    
    proto tcp           //服务使用tcp还是udp连接
    
    dev tun             //使用的网络技术
    
    ca ca.crt           //ca证书位置(需要绝对路径)
    
    cert server.crt     //服务端证书位置(需要绝对路径)
    
    key server.key      //服务端秘钥位置(需要绝对路径)
    
    dh dh.pem           //dh秘钥位置(需要绝对路径)
    
    server 10.8.0.0 255.255.255.0       //给VPN中客户端分配的ip范围
    
    ifconfig-pool-persist ipp.txt       
    
    push "redirect-gateway def1 bypass-dhcp"     
    //设置VPN中客户端的数据全部由服务器的路由转发
    
    push "dhcp-option DNS 8.8.8.8"      //设置客户端dns1
    
    push "dhcp-option DNS 8.8.4.4"      //设置客户端dns2
    
    duplicate-cn                    //允许一个客户端证书被多个主机使用   
    
    keepalive 10 120                
    //存活时间，10秒ping一次,120 如未收到响应则视为断线
    
    comp-lzo             
    //启用允许数据压缩，客户端配置文件也需要有这项。
    
    max-clients 100     //最大客户端并发连接数
    
    user openvpn        
    group openvpn
    //定义openvpn运行时使用的用户及用户组，降低权限，windows上设置为nobody即可
    
    persist-key
    //通过keepalive检测超时后，重新启动VPN，不重新读取keys，保留第一次使用的keys。
    
    persist-tun
    //通过keepalive检测超时后，重新启动VPN，一直保持tun或者tap设备是linkup的。否则网络连接，会先linkdown然后再linkup。
    
    status 路径+文件
    //openVPN启动的状态日志文件位置
    
    log         路径+文件
    log-append  路径+文件
    //openVPN的日志文件位置

> openVPN的启动

    openvpn server.conf配置文件路径
    
> 启动路由转发

这样之后VPN中客户端才能上网

    iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
    
iptables将eth0网卡(服务器用来上网的网卡)中，来自VPN网段(10.8.0.0/24)的主机的数据包在路由后修改，使这些数据包的源IP为eth0网卡所在局域网中的ip地址(动态)
    

## 客户端的配置与启动
> 下载openVPN GUI

> 设置配置文件路径

> 修改配置文件部分内容

    client          //客户端
    dev tun         //使用tun技术
    proto tcp     //使用tcp连接
    remote 39.xxx.xxx.xxx 1194    //OpenVPN服务器的外网IP和端口，ip和域名都行
    
    resolv-retry infinite   
    //始终重新解析Server的IP地址（如果remote后面跟的是域名），保证Server IP地址是动态的使用DDNS动态更新DNS后，Client在自动重新连接时重新解析Server的IP地址。这样无需人为重新启动，即可重新接入VPN。
    
    nobind              //设置不需要指定本地端口号
    
    persist-key
    //通过keepalive检测超时后，重新启动VPN，不重新读取keys，保留第一次使用的keys。
    
    persist-tun
    //通过keepalive检测超时后，重新启动VPN，一直保持tun或者tap设备是linkup的。否则网络连接，会先linkdown然后再linkup。
    
    ca ca.crt           //服务端的CA证书
    cert client.crt     //客户端的签约证书(需要绝对路径)
    key client.key      //客户端的的密钥(需要绝对路径)
    
    comp-lzo            //设置数据压缩

* 注意客户端的连接需要服务端的CA证书以及自己服务端的key与证书    

> 使用客户端连接密码连接
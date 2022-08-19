## ssh
ssh命令使用ssh协议远程登录linux

    ssh 用户@ip 

或

    ssh ip
    //连接服务器并且以windows中当前用户对应的用户名来登录
    
`常用选项`  

    -p <端口>       用于指定ssh服务端口号(不指定默认22)
    -l <登录名>     不使用第一种方法时可以指定登录名
    
    -o 指定相关设置 
     常用：-o ServerAliveInterval=60 //每60秒发送一个空请求(心跳数据)保持持久连接
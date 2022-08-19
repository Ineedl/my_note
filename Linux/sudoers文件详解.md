## 文件所在目录
/etc/sudoers

## 举例说明

    test ALL=(ALL:ALL) ALL

    <userName> <Host>=(<otherUser>:<otherUser2>:...) [NOPASSWD:]<cmd>,[NOPASSWD:]<cmd2>....

##### userName：对应执行用户的名字或别名，或是一个组。  
使用<%用户组名>来指定用户组，此时该用户组中的所有成员都可以使用sudo获取权限。

##### Host：指定该用户使用哪些主机登录时才可以使用sudo命令。  
该主机名可以为ip，也可以为主机名。多个主机使用,隔开。

##### otherUser：该用运行sudo时，获得的权限所属的用户，ALL表示全部用户。
多个用户使用:隔开。

##### cmd：该用户使用sudo时允许执行的命令。  
在命令前加上NOPASSWD: 可以在sudo使用改命令时不用输入密码。
多个命令使用,隔开。
ALL表示可以sudo全部命令。


### sudoers拥有更复杂的设置，详情请百度
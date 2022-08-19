## trap命令
trap可以用来设置命令触发后要执行的命令与程序。在shell中或是shell脚本中，trap设置新的处理方式后原本信号的处理方式会被替换。

    trap commands signals

* 信号处可以使用信号编号

* 该命令为shell内建命令

* shell脚本是开启一个shell运行，所以trap在脚本和shell中的表现相同。

`例子`

    trap "echo ' Sorry! I have trapped Ctrl-C'" SIGINT
    //等同于
    trap "echo ' Sorry! I have trapped Ctrl-C'" 2
    
* 直接使用trap可以查询已设置要捕获的信号    
    
> 脚本退出信号的捕获

* EXIT信号在脚本或是shell退出前都会触发，trap设置的命令会在脚本或shell退出前调用。

    trap commands EXIT
    
`例子`

    trap "ls -la" EXIT
    
> 移除命令的捕获


    trap -- signals/signalsNum
    
该命令将会移除shell或是shell脚本中已绑定的信号，并把它们还原到初始状态。
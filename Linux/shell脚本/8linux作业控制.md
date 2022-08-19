## jobs命令
jobs能查询在当前shell中后台运行的程序进程。

    jobs
    
## fg命令
fg命令能把当前shell后台运行的程序进程拿到前台来继续运行。

    fg %job编号
    //或
    fg 进程id
    
`例子`

    //将jobs查询到的编号为1的后台进程拿到前台运行
    fg %1
    
## bg命令
bg命令将一个后台暂停的进程变为继续在后台执行(常与ctrl+z配合使用)

    bg %job编号
    //或
    bg 进程id
    
## nohup命令
nohup命令允许运行一个命令，之后运行该命令的shell终端退出将不会影响到该命令。

    nohup Command [ Arg … ] [　& ]
    
* 加&只是让命令能在后台运行从而能继续操作当前shell，在前台运行时关掉前台的shell该命令仍会继续运行。
    
`例子`

    nohup "java -jar server.jar" & >server.output

* 当不使用重定向来决定命令输出时，会在运行该命令的目录下建立一个nohup.out来存放命令输出。
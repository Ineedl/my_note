## shell脚本开头
在创建shell脚本文件时，必须在文件的第一行指定要使用的shell。其格式为：

    #!/bin/bash

在通常的shell脚本中，井号（#）用作注释行。shell脚本文件的第一行是个例外，#后面的惊叹号会告诉shell用哪个shell来运行脚本(当然不止可以用bash)。


## 获取命令的输出

`格式`

    `命令`
    
    $(命令)
    
上面两种方式都会生成子shell
    
例：
    
    echo `ls -la`
    
    docker rm $(docker ps -aq)


    //shell脚本中
    #!/bin/bash
    ...
    totay=$(date)
    
## IO重定向
> 输出重定向
输出重定向将某个程序文件或是命令的输出重定向到一个文件  
`覆盖方式输出重定向`
    
    ls -la > a.txt
    
    ./a.sh > b.log

`追加方式重定向输出`

    ls -la >> a.txt
    
    ./a.sh >> b.log
    
* 注意输出重定向只能定向然后输出到文件
    
> 输入重定向

输入重定向将某个程序文件或是命令的输入重定向到一个文件  
`普通重定向`

    cat < a.txt
    
`stdin输入重定向`  

该重定向将文件或是程序的输入重定向到stdin

    cat << EOF
    123
    456
    789
    EOF
    
    wc << EOF 
    test string 1 
    test string 2 
    test string 3 
    EOF

## 重定向到描述符

`文件描述符`  

    0=stdin  
    1=stdout  
    2=stderr  

* 注意每个程序的stdin,stdout,stderr描述符都独有一个，各不共享。

> stdin重定向

`格式`

    命令 0< 文件
    
    //命令输入重定向到文件
    命令 > 0

`例子`
    
    cat 0< a.sh
    
> stdout重定向

`格式`

    命令 1> 文件
    
`例子`

    cat a.sh > a.txt

> stderr重定向  

`格式`

    命令 2> 文件

`例子`

    cat 1$2321 2> a.txt

> stdout与stderr重定向

    命令 &> 文件
    
`例子`

    ls -la &> a.txt

> 将输出重定向到描述符

    命令 >& 描述符数字
    
* 将输出重定向到描述符时(不管是stdin还是stdout等)，都需要在输出重定向符号后面加&。

`例子`

    cat a.txt >& 1
    
    cat b.txt 1>& 0
    
    exec 6 <& 0


## 重定向到自定义的描述符

* 对于文件描述符的重定向均不支持追加方式

* 当某一个描述符的IO被重定向后，该IO原本的功能并不会消失。

`例`
        
    #!/bin/bash
    exec 3>> file1
    exec 4>> file1
    echo "123" >& 3
    echo "124" >& 4 


> exec命令  

可以用exec命令告诉shell在脚本执行期间重定向某个特定文件描述符。  
`格式`

    exec 当前描述符与重定向符号 文件描述符
    
* 当前描述符与重定向符号必须紧贴，不然报错。
* 
`例子：输出的重定向`

    #!/bin/bash 
    exec 1>testout      
    //该命令之后 该脚本的stdout全部都会输出到testout文件



`例子：输入的重定向`
read从stdin中读取数据，而exec 0< testfile将数据读入到了本脚本中的stdin中。

    #!/bin/bash 
    exec 0<testfile 
    count=1 
    while read line 
    do 
        echo "Line #$count: $line" 
        count=$[ $count + 1 ] 
    done

## 自己的重定向
在shell中最多可以有9个打开的文件描述符。  
其他6个从3~8的文件描述符均可用作输入或输出重定向。  
使用exec命令来将某个文件与描述符关联，然后再将脚本与该描述符相关联。

`例子，自定义输出重定向`

    //将描述符3的输出重定向到文件test13out
    exec 3>test13out 
    
    echo "This should display on the monitor" 
    
    //将命令的输出重定向到描述符3的输出
    echo "and this should be stored in the file" >& 3
    
    
`例子，自定义描述符的恢复`

    //对3输出数据会反映到显示器上。
    exec 3>&1 
    
    //对stdout的输出将会输出到文件test14out
    exec 1>test14out 
    
    //还原操作，对stdout的输出不再会反映到test14out文件中
    exec 1>&3
    
`例子，定义IO文件描述符`

    exec 3<> testfile 
    read line <&3 
    echo "Read: $line" 
    echo "This is a test line" >&3
    
## 描述符的关闭
`格式`

    exec 描述符>&-
    
* shell中关闭stdout时，会将不再反应命令结果，此时需要用exec 1>&0恢复，原理是stdin与stdout都指向一个文件。

## 无视命令的输出 
`格式`

    exec 命令 > /dev/null
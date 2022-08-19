## 结构化语句原理
结构化语句linux shell中是一个语句，其还是个linux命令，允许用户在控制台输入一个简单的命令，shell脚本中的结构化语句原理就是使用了对应linux命令。


## test命令
test命令提供了在if-then语句中测试不同条件的途径。如果test命令中列出的条件成立，test命令就会退出并返回退出状态码0。
> 以test命令的形式判断  

`格式`

    if test condition || test condition2 && test condition3
    then 
     commands
    fi

> 省略test命令的形式判断

    //此处一个方括号[]就是一个test命令
    if [ condition ] || [condition2] && [condition3]
    then 
     commands
    fi
    
* 注意[]的最左和最右和命令至少有一个空格差距
    
> test中比较命令

`数值比较`

* 数值比较可以用在变量上

| 比较 | 解释 |
|:--|:--|
| n1 -eq n2 | 检查n1是否与n2相等 |
| n1 -ge n2 | 检查n1是否大于或等于n2 |
| n1 -gt n2 | 检查n1是否大于n2 | 
| n1 -le n2 | 检查n1是否小于或等于n2 |
| n1 -lt n2 | 检查n1是否小于n2 |
| n1 -ne n2 | 检查n1是否不等于n2 |

`字符串比较`

| 比较 | 解释 |
|:--|:--|
| str1 = str2 | 检查str1是否和str2相同 |
| str1 != str2 | 检查str1是否和str2不同 |
| str1 < str2 | 检查str1是否比str2小 | 
| str1 > str2 | 检查str1是否比str2大 |
| -n str1 | 检查str1的长度是否不为0 |
| -z str1 | 检查str1的长度是否为0 |

`文本比较`

| 比较 | 解释 |
|:--|:--|
| -d file | 检查file是否存在并是一个目录 |
| -e file | 检查file是否存在 |
| -f file | 检查file是否存在并是一个文件 |
| -r file | 检查file是否存在并可读 |
| -s file | 检查file是否存在并非空 |
| -w file | 检查file是否存在并可写 |
| -x file | 检查file是否存在并可执行 |
| -O file | 检查file是否存在并属当前用户所有 |
| -G file | 检查file是否存在并且默认组与当前用户相同 |
| file1 -nt file2 | 检查file1是否比file2新 |
| file1 -ot file2 | 检查file1是否比file2旧 |

## 双括号运算
双括号命令允许你在比较过程中使用高级数学表达式。test命令只能在比较中使用简单的算术操作。双括号命令提供了更多的数学符号。  
`格式`

    (( expression ))
    
在双括号结构中，所有表达式可以像c语言一样，如：a++,b--等。  
在双括号结构中，所有变量可以不加入：“$”符号前缀。  
双括号可以进行逻辑运算，四则运算。  
双括号结构 扩展了for，while,if条件测试运算。  
支持多个表达式运算，各个表达式之间用“，”分开。  

`例子`  
    
    echo $((a>1?8:9));
    
    ((b!="a"))&& echo "err2";
    
    ((a<2))&& echo "ok";
    
    a=$((a+1,b++,c++));

## 双方括号运算
双方括号里的expression提供了模式匹配(正则表达式)。
    
    [[ expression ]]

`例子` 

    if [[ $USER == r* ]]


## if条件判断

* bash shell的if语句会运行if后面的那个命令。如果该命令的退出状态码是0(该命令成功运行)，位于then部分的命令就会被执行。

* bash shell中的if与else后不需要像静态语言那样使用{}括起来，每个if与else或elif下的命令都与上个if或是else或elif对其。

> if-then

`格式`

    if command
    then 
        commands
    fi
    

> if-then-else  

`格式`

    if command
    then 
        commands
    else 
        commands
    fi

> if-then-elif

`格式`

    if command1
    then 
        commands
    elif command2
    then 
        more commands
    fi
    
> if的测试命令

* if中允许在判断条件前执行多个其他命令


    if 
        otherCommand1
        otherCommand2
        ...
        test command 
    then 
        commands
    elif 
        otherCommand1
        otherCommand2
        ...
        test command 
    then 
        more commands
    fi

* 注意这些其他命令的执行在条件判断前。    

例：

    if 
        echo hello
        ((1>2))
    then
            echo ok1
    elif
            echo hell3
            ((1<2))
    then
            echo ok2
    fi


## case判断
`格式`  

    case $var_name/variable in 
    
    pattern1 | pattern2) commands1;; 
    
    pattern3) commands2;; 
    
    *) commands;; 
    
    esac
    
* 注意case中每个选项最后一定要;;结尾


## for语句
> 通常的shell for语句  

`格式`  

    for var in list 
    do 
        commands 
    done
    
`例子：从常量中读取`

    for test in Alabama Alaska Arizona Arkansas California Colorado 
    do 
        echo The next state is $test 
    done
    
    //------------
    
    for test in I don\'t know if "this'll" work 
    do 
        echo "word:$test" 
    done
    
    //------------
    //该输出不包含""
    for test in Nevada "New Hampshire" "New Mexico" "New York" 
    do 
        echo "Now going to $test" 
    done
    
* for循环假定每个值都是用空格分割的。

* for的变量列表中如果有变量包含空格，则需要使用""括起来"
    
`例子：从变量中读取`
    
    list="Alabama Alaska Arizona Arkansas Colorado"
    for state in $list 
    do 
        echo "Have you ever visited $state?" 
    done

* 普通for无法与数组直接配合，因为数组是用,分隔

`例子：从命令中读取`

    file="states" 
    for state in $(cat $file) 
    do 
        echo "Visit beautiful $state" 
    done
> C语言风格的for

`例子`

    for (( a = 1; a < 10; a++ ))
    
* 改风格的shell for在for中所有变量可以不加入：“$”符号前缀，而且其中运算使用条件同双括号运算。

## while语句

    while test command 
    do 
        other commands 
    done

* 注意while中也可以使用[]与双括号

> while的测试命令

* while中允许在判断条件前执行多个其他命令


    while   someCommand1
            someCommand2
            ...
            test command
    do 
        other commands 
    done

* 注意这些其他命令的执行在条件判断前。

例：

    a=5
    while echo hello 
          echo world
          echo !!!
    	((a>1))
    do
    	((a--))
    	echo $a
    done

## until语句
until语句的用法全部等同于while，但是其只在条件返回假的时候继续。

`格式`

    until test commands 
    do 
        other commands 
    done

`例子`
    
    a=5
    until echo hello 
          echo world
          echo !!!
    	((a<1))
    do
    	((a--))
    	echo $a
    done

## braek与continue
用法完全同C语言。  
但是shell中break允许用户连续跳出多层循环。  
shell中continue允许用户跳出当前循环并且继续执行某一外层循环。  
`格式`

    break n
    continue n

* 单独使用break是默认为break 1
* 单独使用continue时默认为continue 1

`例子`

    for (( a = 1; a < 4; a++ ))
        do
            echo "Outer loop: $a" 
            for (( b = 1; b < 100; b++ ))
            do
                if ((b>3))
                then
                break 2
                fi 
                echo " Inner loop: $b" 
                done
    done
    
    for (( a = 1; a < 4; a++ ))
        do
            echo "Outer loop: $a" 
            for (( b = 1; b < 100; b++ ))
            do
                if ((b>3))
                then
                continue 2      //此处相当于break 1
                fi 
                echo " Inner loop: $b" 
                done
    done
    
## 循环与条件判断输出的处理
在done或fi或esac等后面使用输出重定向可以将条件判断与循环中的输出输出到某个文件

`例子`

    //循环
    for file in /home/rich/* 
        do 
            if [ -d "$file" ] 
        then 
            echo "$file is a directory" 
        elif 
            echo "$file is a file" 
        fi 
    done > output.txt
    
    //if判断
    if ((1>0))
    then
    	echo 1234
    fi > a.out
    
    //case语句
    case 1 in
        1) echo 789;;
        2) echo 456;;
        *) echo 123;;
    esac > a.out

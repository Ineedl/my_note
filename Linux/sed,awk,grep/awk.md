### awk介绍
awk常用于对文本中的列进行处理，awk脚本中允许使用类似于C语言的语言来进行操作和数据处理。

例：

    awk '{a[NR]=$0}END {
    for(j=1;j<=NR;j++)
    {
        split(a[j],b,"value="); 
        if(j!=1&&(j-1)%57==0) 
            print(""); 
            if(b[2]=="") 
                printf "\\N"; 
        else 
            printf b[2]; 
        if((j)%57!=0&&j!=NR) 
            printf"|";
        
    }
        
    }' c.c > d.c

### 格式
awk [选项参数] '脚本内容' 处理的文件

awk [选项参数] -f 脚本文件 处理的文件

#### 选项参数
| 修饰符 | 含义 |
| :------| :------ |
| -F | 指定输入文件折分隔符，fs是一个字符串或者是一个正则表达式，如-F: |
| -v 变量名=值 | 设置一个用户自定义变量，可以在awk脚本中使用($+运算式使用，比如$(a+b+3)) |
| -f | 使用awk脚本文件执行 |

### awk内建变量
| 变量 | 含义 |
| :------| :------ |
| $n | 当前记录的第n个字段，字段间由FS变量值分隔 |
| $0 | 完整的输入记录 |
| ARGC | 命令行参数的数目 |
| ARGIND | 命令行中当前文件的位置(从0开始算)|
| ARGV | 包含命令行参数的数组 |
| CONVFMT |	数字转换格式(默认值为%.6g)ENVIRON环境变量关联数组 |
| ERRNO |	最后一个系统错误的描述 |
| FIELDWIDTHS |	字段宽度列表(用空格键分隔) |
| FILENAME |	当前文件名 |
| FNR |	各文件分别计数的行号 |
| FS |	字段分隔符(默认是任何空格) |
| IGNORECASE |	如果为真，则进行忽略大小写的匹配 |
| NF |	一条记录的字段的数目 |
| NR |	已经读出的记录数，就是行号，从1开始 |
| OFMT |	数字的输出格式(默认值是%.6g) |
| OFS |	输出字段分隔符，默认值与输入字段分隔符一致。 |
| ORS |	输出记录分隔符(默认值是一个换行符) |
| RLENGTH |	由match函数所匹配的字符串的长度 |
| RS |	记录分隔符(默认是一个换行符) |
| RSTART |	由match函数所匹配的字符串的第一个位置 |
| SUBSEP |  数组下标分隔符(默认值是/034) |

### awk详细格式
awk 'pattern + action' filenames

pattern 表示 AWK 在数据中查找的内容，而 action 是在找到匹配内容时所执行的一系列命令。花括号（{}）不需要在程序中始终出现，但它们用于根据特定的模式对一系列指令进行分组。

pattern就是要表示的正则表达式，用斜杠括起来。表示awk在匹配过程中需要

例：

    //输出第二列包含 "th"，并打印第二列与第四列
    awk '$2 ~ /th/ {print $2,$4}' log.txt
    
    // 输出包含 "re" 的行
    $ awk '/re/ ' log.txt

### BEGIN与END
BEGIN与END用于awk中的pattern中

在BEGIN之后列出的操作awk开始扫描输入之前执行

    awk -F ',' 'BEGIN{a=1;b=2;}' a.c

END之后列出的操作将在扫描完全部的输入之后执行

    awk -F ',' 'END{tmp = $NF; $NF = $1 ; $1=tmp; print $0}' a.c

注意END之后的操作只会执行一次。

比如

    //只会输出最后一行段倒数第一个字段和第一个字段交换后的内容
    awk -F ',' 'END{tmp = $NF; $NF = $1 ; $1=tmp; print $0}' a.c
    
    //交换倒数第一列和第一列
    awk -F ',' '{tmp = $NF; $NF = $1 ; $1=tmp; print $0}' a.c
    //$n为当前记录的第n个字段，字段间由FS变量值分隔，其在awk运行过程中时刻都在变
    
    
### awk运行原理
![awk运行原理图](https://note.youdao.com/yws/api/personal/file/4CE5F35FAFF8417C8A4785E8DE04E32A?method=download&shareKey=c9831bdcb606ce9f2e9eb61cc34dd45c)

#### [参考地址](https://www.runoob.com/w3cnote/awk-work-principle.html)

* #### 特别注意 如果有换行符，且换行符也被分隔了，那么awk每行最后一个字段都为\n

不加END也不加BEGIN的操作将会在awk的运行过程中每次都执行。

* 不被END也不被BEGIN标记的，具体是以行为单每次执行。

### awk数组

AWK 可以使用关联数组这种数据结构，索引可以是数字或字符串。

AWK关联数 组也不需要提前声明其大小，因为它在运行时可以自动的增大或减小。

AWK不支持多维数组

#### 数组定义格式
array_name[index]=value  

* array_name：数组的名称
* index：数组索引，可以不为数字
* value：数组中元素所赋予的值


    $ awk 'BEGIN {
        sites["runoob"]="www.runoob.com";
        sites["google"]="www.google.com";
        print sites["runoob"] "\n" sites["google"];
    }'

#### 数组的删除
可以使用 delete 语句来删除数组元素

格式如下：   
        delete array_name[index
        
    $ awk 'BEGIN {
        sites["runoob"]="www.runoob.com";
        sites["google"]="www.google.com";
        delete sites["google"];
        print fruits["google"];
    }'
    
#### 数组的列赋值
在awk中，可以把某一列赋值给某个数组

例：

    //把第四列赋值给数组a
    awk '{a[NR]=$3}END{.......}' a.c
    
### awk循环与判断
awk中可以使用循环与判断，类似于C语言中的，可以使用if，if-else，if-else-if
        
    if (condition)
    {
        action-1
        action-1
        .
        .
        action-n
    }
        
    if (condition)
        action-1
    else
        action-2
    
    if (a==10)
      print "a = 10";
    else if (a == 20)
      print "a = 20";
    else if (a == 30)
      print "a = 30";
    }'

* awk能使用while，for循环，同时支持continue与break。


    while (condition)
        action
        
    for (initialisation; condition; increment/decrement)
        action

同时if的判断里面可以使用相关的运算符

### awk运算符
awk运算符可以在条件判断以及变量赋值和awk内建函数传参中使用

| 运算符 | 含义 |
| :------| :------ |
| = += -= *= /= %= ^= **= | 赋值 |
| ?: | C条件表达式 |
| || | 逻辑或 |
| && | 逻辑与 |
| ~ 和 !~ | 匹配正则表达式和不匹配正则表达式 |
| < <= > >= != == |	关系运算符 |
| 空格 | 连接 |
| + -	| 加，减 |
| * / % | 乘，除与求余 |
| + - ! | 一元加，减和逻辑非 |
| ^ ***	| 求幂 | 
| ++ --	| 增加或减少，作为前缀或后缀 |
| $	| 字段引用(可以引用用户变量) |
| in | 数组成员 |

### awk常用内置函数  
* awk中可以使用C中的exit()函数，exit使用后会在调用处退出awk程序，同时返回值为填入exit的值。
#  [参考地址](https://www.runoob.com/w3cnote/awk-built-in-functions.html)
## linux shell函数原理
linux shell将函数当做一个小型脚本来使用(但是并没有建立子shell)，定义的函数将会以局部环境变量的形式存在。

* 注意一个shell脚本的运行环境中所有的变量函数都通用(因为都是环境变量)

## function命令
function用于在当前shell中或是shell脚本中定义一个shell函数，该函数会以局部环境变量的形式存在。

### 在shell脚本中定义函数

> 格式

```bash
function fun_name [()]
{
       command1
       command2
       ...        
}
```

* 括号可有可无

* shell函数的括号存在时只是相当于一个摆设，证明他是函数，shell函数的传参靠参数列表，不靠括号。

* {与函数名在同一行时，必须与函数名有至少一个空格的距离。    

> shell脚本的返回值

bash shell会把函数当作一个小型脚本，运行结束时会返回一个退出状态码。

`默认情况下的返回值`  
默认情况下，函数的退出状态码是函数中最后一条命令返回的退出状态码。在函数执行结束后，可以用标准变量$?来确定函数的退出状态码。

* 当函数中某个命令出现问题时，函数会退出，此时返回值是该命令的返回值

`使用return返回`  
bash shell使用return命令来退出函数并返回特定的退出状态码。return命令允许指定一个整数值来定义函数的退出状态码，从而提供了一种简单的途径来编程设定函数退出状态码。

```bash
return value
```

* return只能用于脚本中。

* return只能用于返回状态码，而不能用于返回其他类型的数值。

* 退出状态码必须是0~255，这个和命令的退出状态码要求一致。

* return无法用来进行大于255数值的传递形，如果需要大于255数值的返回，请使用环境变量传参或是下面说的一种方法。

`函数输出的使用`  
直接使用

```bash
value_name=$(fun_name)
#或
value_name=$?
```

在函数末尾使用echo传递返回值

```bash
#一个脚本例子

function dbl { 
    read -p "Enter a value: " value
    echo $[ $value * 2 ] 
}
result=$(dbl)
echo "The new value is $result"
```

* 通过这种方法，还可以返回浮点值和字符串值，也可以返回数组。


```bash
#返回数组脚本实例
#!/bin/bash 
# returning an array value 
function arraydblr { 
    local origarray 
    local newarray 
    local elements 
    local i 
    origarray=($(echo "$@")) 
    newarray=($(echo "$@")) 
    elements=$[ $# - 1 ] 
    for (( i = 0; i <= $elements; i++ )) 
    { 
        newarray[$i]=$[ ${origarray[$i]} * 2 ] 
    } 
    echo ${newarray[*]} 
}

myarray=(1 2 3 4 5) 
echo "The original array is: ${myarray[*]}" 
arg1=$(echo ${myarray[*]}) 
result=($(arraydblr $arg1)) 
echo "The new array is: ${result[*]}"
```

> 函数的参数与使用

`传参`  
bash shell会把函数当作一个小型脚本，可以像普通脚本那样向函数传递参数。

```bash
fun_name [args]
```

`使用参数`  
使用参数使用$n来调用对应的传入参数，$0为函数名

`local`  
local用于定义一个不会在环境变量中产生而是只能在函数中使用的变量

```bash
local var_name
```

* local只能在脚本中使用

### 在当前shell中定义函数

`格式`

```bash
#多行
> function fun_name [()]
> {
>       command1
>       command2
>       ...        
> }

#单行
> function fun_name [()]{command1;command1;command1;...}
```

* 在shell中直接定义函数必须使用{}作为函数分界符，EOF什么的不行

* 单行建立函数时必须用;分隔命令。

* ()可加可不加

函数定以后在用set查询时会以以下方式列出

```bash
fun_name () 
{ 
    command1
    command2
    ...   
}
```

`定义函数的使用`  
linux shell将函数当做一个小型脚本来使用，故在使用函数时可以像其他命令一样在后面传入参数来进行使用

```bash
> fun_name  [args]
```

* 使用函数的时候不需要加括号



`删除在shell中的函数`

```bash
unset 函数名
```

`函数的返回值的使用与return同在脚本中的使用`

`local也可以在命令行函数内部使用`


## 函数库的使用
shell脚本单独存放函数的脚本为函数库，shell脚本函数的定义与声明并不能分开。

### source命令
source命令将会重新运行一个shell脚本，在脚本中则是在当前位置运行该shell脚本

```bash
source 脚本文件的路径

. 脚本文件的路径
```

* source的别名是.

`函数库的使用`

```bash
source 函数文件的路径
#或
. 函数文件的路径
```

* 该原理是相当于把对应脚本在source的位置重新运行了一遍，但是由于函数库脚本中只存放了函数的定义。所以看上去只是加载了该函数库


```bash
例：
#myfuncs.sh
function addem { 
    echo $[ $1 + $2 ] 
} 
function multem { 
    echo $[ $1 * $2 ] 
} 
function divem { 
    if [ $2 -ne 0 ] 
    then 
    echo $[ $1 / $2 ] 
    else 
    echo -1 
    fi 
}
```


​    
```bash
#test.sh
#!/bin/bash 
# using functions defined in a library file 
. ./myfuncs         #此处加载了函数库脚本
value1=10 
value2=5 
result1=$(addem $value1 $value2) 
result2=$(multem $value1 $value2) 
result3=$(divem $value1 $value2) 
echo "The result of adding them is: $result1" 
echo "The result of multiplying them is: $result2" 
echo "The result of dividing them is: $result3"
```


​    
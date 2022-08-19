## 环境变量相关命令

* 查看当前shell中的全局环境变量
  
    env

* 查看当前shell中的全部的环境变量(局部与全局都有)

    set

## linux环境变量
`分类`  
全局变量：该类型变量定义后对该shell以及其子shell都是可见的。

局部变量：该类型变量只在定义他们的shell或是进程中可见。

* 全局变量在生成子shell后会被子shell继承

* 局部变量在生成子shell后无法继承

* 每个shell的环境变量继承关系是拷贝，不是公用



## 环境变量的定义
`局部环境变量的定义`

```bash
#含空格以及特殊字符
var_name="value"

#不含特殊字符
var_name=value
```

`全局环境变量的定义`

```bash
#含空格以及特殊字符
export var_name="value"

#不含特殊字符
export var_name=value
```

* shell中变量定义如果要加入"等有些特殊字符需要使用\转义。
  
* shell定义的全局环境变量在定义shell关闭时会自动关闭。系统中的shell环境变量为开机时开机脚本自动加载的。

* 如果想要永久定义一个全局环境变量(一般定义永久的局部变量没用)，需要在对应的开机脚本中加入定义式。
  
## 只读环境变量的声明
变量需要定义了才能声明为只读环境变量

```bash
readonly var_name
```

* 只读环境变量无法删除与更改，只能关闭当前shell或是重新启动后才会删除。

## 环境变量的调用

```bash
#使用的环境变量后没有紧贴其他字符时
$var_name

#使用的环境变量后紧贴其他字符时
${var_name}
```

`给环境变量赋值时也可以调用环境变量`

```bash
export PATH=$PATH:/usr/bin
```


## 环境变量的删除

```bash
unset var_name var_name2 ...
```

## linux shell重要配置文件
以下这五个配置文件在bash shell作为登录shell启动时会加载他们中的内容。

    /etc/profile
    
    $HOME/.bashrc
    
    #HOME/.bash_profile
    
    $HOME/.bash_login
    
    $HOME/.profile


​    
* 所有linux发行版都有第一个配置文件，但是剩下的四个一般linux发行版都只有其中的一个到两个

* 大多数linux发行版使用$HOME/.bashrc文件来存储个人用户的永久性shell变量。



## 数组变量
* 数组变量不能是环境变量，哪怕是使用export标记也不会成为环境变量。

`数组的赋值`

```bash
#统一初始化，该方法会覆盖之前同名数组
array_name=(value1 value2 value3 value4 ...)

#暂时只给某个位置赋值
#该赋值方法不需要数组已完成定义与全部赋值，但是如果其他下标对应位置中没有值，则默认为空
array_name[index]=value
```

`数组的调用`

```bash
#调用某个成员
${array_name[index]}

#调用全部成员并且以空格分隔
${array_name[*]}
```

`数组的删除`

```bash
#删除整个数组
unset array_name

#删除数组中某个位置
unset array_name[index]
```

## 部分重要环境变量
> IFS(内部字段分隔符)  

IFS环境变量定义了bash shell用作字段分隔符的一系列字符。默认情况下，bash shell会将空格,制表符,换行符当做分隔符。

* IFS为局部变量，所以对于所有脚本来说，修改当前环境中的IFS不会影响到脚本外的环境。

    //IFS默认值
    IFS=$' \t\n'
    
    //修改只对换行生效
    IFS=$'\n'
    
    //将123作为分隔符
    IFS=$'"123"'

* 注意IFS的的改变也会影响脚本输出(如果某个变量的值刚好是这个分隔符，则该变量的输出将会是空)，比如如果将123当做分隔符，那么输出中将不会再出现123这三个字符。

## shell脚本特殊环境变量
| <span style="display:inline-block;width: 80px"> 环境变量</span> | 意义 |
|:--|:--|
| $0 | 脚本名 |
| $n | 第n个脚本输入参数 |
| $# | 除了脚本名以外的脚本输入参数个数 |
| $* | 除脚本名以外的所有脚本输入参数，会将这些参数用""围起来当做一个整体 |
| $@ | 除脚本名以外的所有脚本输入参数，这些参数不会被""围起来，而是每个参数都是一个个体，可以用for循环看出 |
| $! | Shell最后运行的后台Process的PID |
| $$ | Shell本身的PID（ProcessID），即当前进程的PID。 |
| $? | shell中上一指令的返回值 |

> shift命令

shift命令可以用来左移shell中输入参数的位置，后面的数字为移动的数量。
`格式`

```bash
shift n
```

`例子`

```bash
#!/bin/bash
#name:a.sh
echo $1
shift 2
echo $2

./a.sh 1 2 3

out: 
1
2
```

* shift不能移动第0位的参数，即脚本名那个位置。
  
    
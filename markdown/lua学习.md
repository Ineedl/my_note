# Lua  
## Lua注释
单行注释： 采用“--”来对注释后面的字符进行注释,类似于 ISO C90之后的 C语言的注释"//"

多行注释：采用"--[[" "]]" 一对来注释，类似于C语言的 "/*" "*/"。

## Lua变量类型  
Lua 变量有三种类型：全局变量、局部变量、表中的域。

Lua 中的变量全是全局变量，那怕是语句块或是函数里，除非用 local 显式声明为局部变量。  
a = 5               -- 全局变量  
local b = 5         -- 局部变量

局部变量的作用域为从声明位置开始到所在语句块结束。
  
Lua 是动态类型语言，变量不要类型定义,只需要为变量赋值。 值可以存储在变量中，作为参数传递或结果返回。

lua中除了table类型为引用传递，其余的都是值传递，传函数给变量时函数也相当于值。
  
## Lua数据类型
Lua 中有 8 个基本类型分别为：nil、boolean、number、string、userdata、function、thread 和 table。
  
### type函数  
我们可以使用 type 函数测试给定变量或者值的类型  
`print(type("Hello world"))      --> string`  
`print(type(10.4*3))             --> number  `
`print(type(print))              --> function`  
`print(type(type))               --> function`  
`print(type(true))               --> boolean`  
`print(type(nil))                --> nil`  
`print(type(type(X)))            --> string`

### nil
nil	这个数据类型只有值nil属于该类，表示一个无效值（在条件表达式中相当于false）。   

变量的默认值均为 nil。  
  
对一个变量进行销毁，可以直接赋值nil，该变量的内存被回收；未赋值的变量，默认赋值为nil,不占用内存空间。  
  
nil 作比较时应该加上双引号 "    

    > type(X)
    nil
    > type(X)==nil
    false
    > type(X)=="nil"
    true
    >

### boolean
boolean	包含两个值：false和true。    

Lua 把 false 和 nil 看作是 false，其他的都为 true，数字 0 也是 true。

### number    
number	表示双精度类型的实浮点数  
  
Lua默认只有一种number类型--double（双精度）类型  
（默认类型可以修改 luaconf.h 里的定义）  
  
以下几种写法都被看作是 number 类型：  
  
    print(type(2))
    print(type(2.2))
    print(type(0.2))
    print(type(2e+1))
    print(type(0.2e-1))
    print(type(7.8263692594256e-06))

### string  
string	字符串由一对双引号或单引号来表示。    
  
    string1 = "this is string1"  
    string2 = 'this is string2'  
    
也可以用 2 个方括号 "[[]]" 来表示"一块"字符串。就像/\*和\*/注释  
  
    html = [[
    <html>
    <head></head>
    <body>
        <a href="http://www.baidu.com/">百度</a>
    </body>
    </html>
    ]]
    print(html)  
  
在对一个数字字符串上进行算术操作时，Lua 会尝试将这个数字字符串转成一个数字:  

    > print("2" + 6)
    8.0
    > print("2" + "6")
    8.0
    > print("2 + 6")
    2 + 6
    > print("-2e2" * "6")
    -1200.0  

而对于字符串之间的连接,使用两个点号（..）

    > print("a" .. 'b')
    ab
    > print(157 .. 428)
    157428
  
### function  
function	由 C 或 Lua 编写的函数。  
  
在Lua中，函数是被看作是"第一类值（First-Class Value）"。    

由于Lua的类型都是动态类型，所以函数参数一般都只有名字,没有类型。
  
函数可以存在变量里。 
  
    --test.lua
    function factorial1(n)
       if n == 0 then
           return 1
       else
           return n * factorial1(n - 1)
       end
    end
    print(factorial1(5))
    
    TestValue=factorial1    --把函数给一个变量存储
    print(TestValue(5))
    
    
    > lua .\test.lua
    120
    120


function 可以以匿名函数（anonymous function）的方式通过参数传递  
(类似于C++11的lambda表达式) 

    --test.lua
    function testFun(tab,fun)
        for k ,v in pairs(tab) do
                print(fun(k,v));
        end
    end

    tab={key1="val1",key2="val2"};
    testFun(tab,
    function(key,val)               --匿名函数,相当于lamdba表达式
            return key.."="..val;
    end
    );
    
    >test.lua 
    key1 = val1
    key2 = val2

### userdata  
userdata	表示任意存储在变量中的C数据结构  

userdata 是一种用户自定义数据，用于表示一种由应用程序或 C/C++ 语言库所创建的类型，可以将任意 C/C++ 的任意数据类型的数据（通常是 struct 和 指针）存储到 Lua 变量中调用。  
  
### thread  
thread	表示执行的独立线路，用于执行协同程序  

在 Lua 里，最主要的线程是协同程序（coroutine）。  
它跟线程（thread）差不多，拥有自己独立的栈、局部变量和指令指针，可以跟其他协同程序共享全局变量和其他大部分东西。

线程跟协程的区别：线程可以同时多个运行，而协程任意时刻只能运行一个，并且处于运行状态的协程只有被挂起（suspend）时才会暂停。

lua中的thread类型就是用于存放lua中的协程的。
  
### table  
table	Lua 中的表（table）其实是一个"关联数组"（associative arrays），数组的索引可以是数字、字符串或表类型。
  
在 Lua 里，table 的创建是通过"构造表达式"来完成，最简单构造表达式是{}，用来创建一个空表。  
      
    -- 创建一个空的 table
    local tbl1 = {}
     
    -- 直接初始表
    local tbl2 = {"apple", "pear", "orange", "grape"}
    
    -- table_test.lua 脚本文件
    a = {}
    a["key"] = "value"
    key = 10
    a[key] = 22
    a[key] = a[key] + 11
    for k, v in pairs(a) do
        print(k .. " : " .. v)
    end
    
    $ lua table_test.lua 
    key : value
    10 : 33  

不同于其他语言的数组把 0 作为数组的初始索引，在 Lua里表的默认初始索引一般以 1 开始。  
对于一般直接的初始化，例如上面的tab2,则key变成了1,2,3..这种数字。


    -- table_test2.lua 脚本文件
    local tbl = {"apple", "pear", "orange", "grape"}
    for key, val in pairs(tbl) do
        print("Key", key)
    end

    $ lua table_test2.lua 
    Key    1
    Key    2
    Key    3
    Key    4  

table 不会固定长度大小，有新数据添加时 table 长度会自动增长，没初始的 table 都是 nil。

    -- table_test3.lua 脚本文件
    a3 = {}
    for i = 1, 10 do
        a3[i] = i
    end
    a3["key"] = "val"
    print(a3["key"])
    print(a3["none"])
    
    $ lua table_test3.lua 
    val
    nil

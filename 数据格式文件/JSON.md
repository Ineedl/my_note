## JSON介绍
JSON是一种与开发语言无关,轻量级的数据格式。全称JavaScript Object Notation(JavaScript对象标记)。


JSON易于人的阅读与编写，易于程序的解析与生产。


`一个简单的JSOn样例`

    {
        "name" : "一本书",
        "author":cjh,
        "content":["无内容1","无内容2"],
        "readTime":{
            "value" : 30,
            "unit" : "分钟"
        }
    }
    
## JSON的组成

* 所有的JSON的数据一开始都在一个根的Object中

* 所有的数据除了最外面的那一层根Object外，都有一个对应的String类型的Key(或者说是数据变量名)

> 结构类型：  

花括号标识的 Object  
方括号表示的 Array

`Object结构`

使用{}括起来的一些键值对，key必须为String类型，value可以为基本类型或是结构类型

* Object类型可以一直嵌套下去


    {
        "name" :
        {
            "name2":
            {
                "name3" :
                {
                    .....
                }
            }
        }
    }
    

`Array类型`

使用[]括起来的一些值，这些值可以互相嵌套，可以是对象，也可是一个数组，也可是基本类型的数据，[]中的数据不需要key(或者说是变量名)。

    {
        "test" : ["1234",true,null,
        {
            "name":"cjh",
            "age":18
        },[1,2,3,4],null]
    }

> 基本类型：  

双引号中的字符串 string  
直接使用的 number数字类型  
直接使用的 true与false的bool类型  
空值 null

* 基本类型可以直接在key后面跟数值来使用
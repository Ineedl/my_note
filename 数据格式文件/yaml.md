## 介绍
yaml是一种用来做以数据为中心的配置文件的标记语言。


## 基本语法
> 使用key-value的方式定义数据

```
    key: value
    
```

定义的key只有一个值的时候为

* yaml对大小写敏感。

* 注意key:与value之间必须有一个空格。

* #表示注释。

* 字符串无需加引号，如果要加,''中的内容会被转义，""中的不会被转义。

`yaml使用缩进表示层级关系`
```
    //对象表示法
    k: 
        name: myname
        age: myage
        pet: 
                name: dog
                age: 1
    
    //也可以将一个简单的对象写在一行内
    k: {name: myname,age: myage,pet: {name: dog,age: 1}}
    
```

* 缩进的空格数不重要，但是同层级必须对其。


> 表示一个数组

`行内写法`

```
    k: [v1,v2,v3]
``` 
    
    
`普通写法`

```
    k: 
        - v1
        - v2
        - v3
```   
        
`传入HashMap的写法`

```
    k:
        - K1: V1
        - K2: V2
        ...
        
    //行内写法
    k: [K1: V1,K2: V2,...]
    
```
    
`对象数组`

```
    k:
        - {id: 123,name: 李四}
        - {id: 456,name: 张三}
        
    k:
        -
            id: 123
            name: 李四
        -
            id: 456
            name: 张三
        
    //行内写法
    
    k: [{id: 123,name: 李四},{id: 456,name: 张三}]
    
```     
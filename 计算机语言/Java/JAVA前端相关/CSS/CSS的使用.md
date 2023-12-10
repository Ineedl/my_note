## [样式参考网站](https://www.w3school.com.cn/css/index.asp)

## css优先级
1. 在属性后面使用 !important 会覆盖页面内任何位置定义的元素样式。  
2. 作为style属性写在元素内的样式。  
3. id选择器。  
4. 类选择器。  
5. 标签选择器。  
6. 通配符选择器。  
7. 浏览器自定义或继承。  

## 在标签的style中设置

    <div style="border: 1px solid red;">div内容</div>

`缺点`  
* 复用性太差
* 可读性很差
* 代码量庞大


## 在head标签中使用style定义相关标签对应样式属性或是选择器

    <style type="text/css">

        div {
            border: 1px solid red;
        }
    
    </style>

> 该方法可以将所有css样式写在一个css文件中再通过link标签引入复用

    //a.css
    div {
            border: 1px solid red;
    }
    

    //b.html
    .....
    <head>
    
        <link ref="stylesheet" type="text/css" href="a.css" />
        
    </head>
    .....
    

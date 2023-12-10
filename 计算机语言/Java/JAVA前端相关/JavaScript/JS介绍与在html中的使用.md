## JS介绍
JS与java没有任何关系，单纯是应用于浏览器的脚本语言。JS为弱类型语言，运行在浏览器客户端，只要是支持浏览器的平台，都可以在浏览器上支持JS的使用。


## JS的使用
> 直接在head标签中使用script标签插入使用

    <script type="text/javascript">
        js代码
    </script>
    
    
`例子`

    <head>
        <script type="text/javascript">
            alert("hello world");
        </script>
    </head>
    
> 使用script标签引入js文件

`例子`
    
    //a.js
    alert("hello world");

    //html文件
    <head>
        <script type="text/javascript" src="a.js"></script>
    </head>
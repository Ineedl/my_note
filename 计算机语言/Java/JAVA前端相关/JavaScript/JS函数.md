## 函数的定义

* JS中同函数名的第二次声明会覆盖上一次的声明。

> 方式一

    function 函数名(形参列表){
        函数体
        [return result;]
    }
    
* 注意JS形参不用加上类型名
    
`例子`

    function fun(a,b)
    {
        alert(a+b);
    }
    
> 方式二

    var 函数名= function(形参列表){
        函数体
        [return result;]
    }
    

## JS函数中的隐形参数arguments
arguments为一个装有传入var的所有参数的数组，每个JS函数都有。



## JS库的使用与加载
JS库的使用几乎等同于shell中调用脚本库，通过加载写好了相关接口的js代码文件来达到调用库的效果。
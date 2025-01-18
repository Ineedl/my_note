## 对象类型
JS允许先建立一个空对象，然后再往这个对象中增加成员变量与成员方法

* 注意必须往空对象里面添加东西，一般的变量不行。

## Object对象
JS中Object对象为一个空对象，没有属性也没有方法，需要创建后手动边添加边使用。

> 正常的使用自定义对象

    var obj=new Object();
    
    //添加一个成员变量并赋值
    obj.value1=1;
    //添加一个函数并定义
    obj.fun1=function(){}
    
> 用花括号创建自定义对象

    var obj={
        属性名: 值,
        属性名: 值,
        函数名: function(){}
    };

## JS创建对象的常用方法
> 使用函数包装的工厂模式

该方法相当于用函数构建对象

`例子`

    function createMyObject(name,age,job)
    {
        var obj=new Object();
        obj.name=name;
        obj.age=age;
        obj.say=function(){
            alert("hello world");
        }
        return obj;
    }
    
    var person = createMyObject(GK,11,undefined);
    
> 构造函数模式  

这种方法相当于一个函数就是一个类的定义


`例子`

    function MyObject(name,age,job)
    {
        this.name=name;
        this.age=age;
        this.say=function(){
            alert("hello world");
        }
    }
    
    var person = new MyObject(GK,11,undefined);
    
> 原型模式建立对象

每个函数都有一个prototype属性，这个属性是一个指针，指向一个对象。而这个对象的用途是 包含可以由 特定类型 的所有 实例 共享的属性和方法。

故给prototype指向的对象添加的属性和方法，对从该函数new来获取的对象来说都是公用的，相当于new多个对象公用一个对象

`例子`
    
    function MyObject(){
    }
    MyObject.prototype.name="GK";
    MyObject.prototype.age=18;
    MyObject.prototype.job="stu";
    
    //obj1与obj2指向的对象都一样。
    var obj1=new MyObject();
    var obj2=new MyObject();
    
    
## new的原理
在调用new的过程中做了四件事：
1. 新生成对象
2. 链接到原型
3. 绑定this
4. 返回新对象


    var p = new Object();

上述只是相当于生成了一个空对象a，然后调用了Object这个函数，给这个函数传入了一个隐藏的this参数，this指向空对象a，然后在函数内部给这个空对象进行赋值等操作，然后再返回this指向的对象。这个也是构造函数模式定义类的原理。

* 当构造函数为空时，等同于调用Object();
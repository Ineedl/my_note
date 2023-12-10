## 事件的介绍
JS事件就是指电脑设备在游览器中操作时与页面进行交互的响应。


## 事件的注册
JS事件的注册就是给事件绑定相应的JS功能代码，在事件响应后来运行这些功能代码。

> 事件注册的分类

`静态事件的注册`  
通过html标签的事件属性直接赋予事件响应后的代码。


`动态事件的注册`  
获取到html标签的dom对象，然后给dom对象上的对应事件来赋予事件响应后的代码。

> 常用事件

    onload          加载完成事件
    onclick         单击事件
    onblur          失去焦点事件
    onchange        内容发生改变事件
    onsubmit        表单提交事件
    
    
## 注册实例

* 注意在非窗口的标签上绑定事件时(比如div 等非head与body标签)，必须将内容写到window.onload的注册方法中中，因为如果直接写到script标签中，这些某些标签对象可能还未加载与创建，而window.onload保证了他们加载与创建完毕，以来让这些绑定的事件功能代码生效。

> 注册onload

`静态`

    <script type="text/javascript">
        function onUp(){
            alert("静态");
        }
    </script>
    
    //这个属性的""里面可以写多个JS语句，这里只用了一个函数调用
    <body onload="onUp();">
    </body>
    
`动态`

    <script type="text/javascript">
        window.onload=function(){alert("动态");}
    </script>
    
> 注册onclick   
    
`静态`

    <script type="text/javascript">
        function onUp(){
            alert("静态");
        }
    </script>
    <body>
        <button onclick="onUp();">fq</button>
    </body>

`动态`
    
    <script type="text/javascript">
        window.onload=function(){
            alert("动态");
            var butObj=document.getElementById("but1");
            butObj.onclick=function()
            {
                alert("动态");
            }
        }
    </script>
    <body>
        <button id="but1">fq</button>
    </body>
    
## DOM对象
DOM全称Document Object Model，相当于是Spring中管理所有对象的那个容器，这个容器中装的全部html中标签，文本与属性。

DOM中把所有的标签都对象化了，每一个标签都是一个对象，每个对象对应的注册方法与相关属性就相当于一般面向对象程序中对象的方法与属性。

我们可以通过document对象来访问全部的标签对象与注册其对应的事件。

> document常用方法

`getElementById(elementID)`
通过id属性寻找dom对象  
有多个相同的id时，返回数组
    
`getElementByName(elementName)`
通过name属性寻找dom对象  
有多个相同的name时，返回数组

`getElementByTagName(tagName)`
通过标签名寻找dom对象  
如果这个标签在html中多次使用，返回数组

* 三个查询方法的推荐优先顺序：id > name > tagName。


`createElement(tagName)`
通过标签名创建一个标签返回给变量。

> 标签对象常用方法与属性

`getElementsByTagName(TagName)`  
根据标签名获取当前标签对象的子标签(子代以后的亲缘关系对应标签无法获取)，当该子标签多次使用时，返回数组。

`appendChild(childNode)`
在这个标签的尾部添加一个新的子标签，需要传入标签对象。

`属性childNodes`  
包含该标签全部的子标签(子代以后的亲缘关系不算)

`属性firstChild`   
获取该标签第一个子标签

`属性lastChild`  
获取该标签最后一个子标签

`属性parenNode`    
获取该标签的父标签

`属性nextSibling`  
获取该标签上一个的同级标签

`属性previousSibling`  
获取该标签下一个的同级标签

`属性className`  
获取该标签的class属性值

`属性innerHTML`  
表格行的开始和结束标签之间的HTML内容(包含html标签)

`属性innetText`
表格行的开始和结束标签之间的HTML内容(不包含html标签)
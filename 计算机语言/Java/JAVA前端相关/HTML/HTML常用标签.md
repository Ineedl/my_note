## HTML特殊字符
|||
|:--|:--|
| \&lt; | < |  
| \&gt; |	    >   |  
| \&amp; |	    &   |  
| \&quot; |	    "   |  
| \&reg; |	    ®   |  
| \&copy; |	    ©   |  
| \&trade; |    ™   |  
| \&ensp; |	    半个空白位  |   
| \&emsp; |		一个空白位   |  
| \&nbsp; |	 	不断行的空白  |   


## font字体标签
font可以用来显示文本，font的属性可以规定文本的字体，字体尺寸，字体颜色。

> 格式

    <font color="color" face="字体" size="8" > 文本内容 </font>

## br标签
br标签插入一个简单地换行

    <font color="blue">hello<br/>world</font>

* br为空标签，不需要结束符号与结束标签。

## h1->h6标签
标题标签为h1到h6(字体从大到小)，标题标签用来指示一个文字为标题
> 格式

    <h1> 标题 </h1>
    
> 常用属性

    align   left    左对齐
            right   右对齐
            center  居中

## a标签
a标签用于给一段文字指定一个超链接
    
> 常用格式
    
    <a href="链接地址"> 文本内容 </a>
    
## ul与li标签
ul与li标签使用一种无序的列表方式将文本展示出来

> 格式

    <ul>
    <li>a</li>
    <li>b</li>
    <li>c</li>
    ...
    </ul>

## p标签
p标签会在段落的上下空出一行

## div
div标签独占一行

## span
span标签

## img标签
img用来插入一个图片。

> 常用规格

    <img src="图片绝对路径或相对路径" width="宽度，默认单位px" heigh="高度，默认单位px" />
    
## table标签
> 内部标签

`table`  
用于规定一个表格
    
* table可以设置跨行与跨列，详情百度。    
    
`tr`  
行标签，该标签用于规定table中的一行

`th`   
表头标签，该标签用于规定table中的表格

`td`   
单元格标签，该标签用于规定table中单元格的属性与内容

* 常用属性

    
    align   对齐格式


> table常用属性  

    width   表格的宽
    
    heigh   表格的高
    
    border  表格边框宽度
    
    cellspacing     单元格之间的空白宽度，单位为%px
    
> 实例

    <table border="1pt" width="300" height="300" cellspacing=0>
        <tr>
            <th>11</th>
            <th>12</th>
            <th>13</th>
        </tr>
        <tr>
            <td>21</td>
            <td>22</td>
            <td>23</td>
        </tr>
        <tr>
            <td>31</td>
            <td>32</td>
            <td>33</td>
        </tr>
    </table>

## from标签
from为表单标签，用于提交用户在网页上操作的数据

* 表单可以与table配合使用来进行格式化

* 表单进行发送时，每个表单项必须都有一个name

* 单选，复选框，下拉菜单等选择性的单元必须设置value(下拉菜单在option里面)，这样在提交后服务器才能收到对应选择的数据

> from属性

`action`  
该属性设置提交的服务器地址

`method`  
该属性设置表单提交方式(POST或SET)

> GET提交与POST提交的区别

`GET`  
GET在浏览器地址栏中表现为 action属性值[?+请求参数]  
请求参数格式为 name=value&name=value

* GET提交不安全而且有数据长度限制

`POST`  
POST提交在浏览器地址栏中只有action属性值

* POST提交更安全，理论上没有长度限制。


> input标签

input标签用于from内部，用来接受用户的输入

    <from>
        <input type="text" value="默认值"/><br/>
        <input type="password" value="默认值"/>
        <input type="radio" name="sex" />男<input type="radio" name="sex" checked="checked" />女<br/>
    </from>
    
`文本输入框`  
type=text或是password时input为文本输入框
    
* 文本输入框常用属性

    
    value       默认值
    size        文本框长度
    
`单选框`  
type=radio为单选框

* 单选框常用属性

    
    name        用于给单选框分组
    checked     用于规定该input加载时是否为预先选定，只有一个属性值checked
    
`复选框`  
type=checkbox为复选框

* 复选框常用属性

    
    name        用于给单选框分组
    checked     用于规定该input加载时是否为预先选定，只有一个属性值checked

`按钮`  
type=reset      定义重置按钮。重置按钮会清除表单中的所有数据。  
type=submit     定义提交按钮。提交按钮会把表单数据发送到服务器。  
type=file       定义输入字段和 "浏览"按钮，供文件上传。  
type=button     定义可点击按钮。  

* 按钮都可以通过属性值name来修改按钮上的文字

`隐藏字段`  
type=hidden     定义隐藏的输入字段，这些字段对用户不可见，但是会跟着表单一起上传服务器。
    
    
> select标签

使用select标签可以来使用下拉表选项，select标签用于from内部。

    <select>
        <option>选项1</option> 
        <option>选项2</option> 
        <option>选项3</option> 
        ...
    </select>
    
* option常用属性

        selected        设置是否为默认值，只有属性值selected
        
> textarea标签
  
textarea标签可以用显示一个多行文本输入框，textarea标签用于from内部
        
    <textarea>
        默认显示字符    
    </textarea>
    
* 常用属性

    row         限定的行数
    cols        限定每行字符宽度



# QSS学习  
* [QSS原理](#qss原理)
* [QSS选择器](#qss选择器)
* [QSS部分样式](#qss部分样式)
&ensp;  &emsp; &nbsp;

# 常用方法
*{outline:0px;} 去除焦点虚线

# QSS的原理
QSS相当于是CSS的子集，如果把QT的UI程序比作html+css+js代码，那么QSS就相当于CSS。  
#### 更多样式请在QT助手搜索Qt Style Sheets Reference并查找。

## 全局Qss加载代码

```
    QFile file("./styles/default.qss");  
    file.open(QFile::ReadOnly);  
    QString styleSheet = file.readAll();//QLatin1String(file.readAll());  
    qApp->setStyleSheet(styleSheet);
```

## setSytleSheet注意事项  
setSytleSheet不能多次使用，多次使用时，只取最后一次设置的样式  

## 自定义控件注意  
若自定义控件继承QWidget，则对齐设置样式的时候必须先设置某个属性或者重写一个函数。    

#### 需要重写的函数
[virtual protected] void QWidget::paintEvent(QPaintEvent *event)  

在自己的自定义类中写
void ClassName::paintEvent(QPaintEvent *)
{
  QStyleOption opt;
  opt.init(this);
  QPainter p(this);
  style()->drawPrimitive(QStyle::PE_Widget, &opt, &p, this);
}

#### 需要设置的属性   
在你自定义的QWidget里面设置  
this->setAttribute(Qt::WA_StyledBackground);

# QSS选择器  
QSS 的选择器有：  
* 通用选择器 *
* 类型选择器 (最常用)
* 类选择器   
* ID 选择器  (最常用)
* 属性选择器  
* 包含选择器  
* 子元素选择器  
* 伪类选择器  
* Subcontrol 选择器  

QT的选择器可以各种混合使用，非常的自由

### 通用选择器 *
*作为选择器，作用于所有的 Widget。也包括了全部这些窗口的全部子控件

### 类型选择器
类名作为选择器，作用于它自己和它的所有子控件与子类。使用时一定要注意是否也要求使用该选择器的类也要同步改变他们的子控件和子类。

### 类选择器  
. + 类名 或者 . + class的属性值作为选择器，只会作用于它自己，它的子类与子控件不受影响。  

### ID选择器
#+objectName 作为选择器，只作用于用此 objectName 的对象。 不会作用于除了该类以外的对象。

### 属性选择器
选择器[属性="值"] 作为选择器，这个属性可用通过 object->property(propertyName) 访问的，Qt 里称为 Dynamic Properties。  

例：  
QPushButton[level="dangerous"] { background: magenta; }  

这个样式只有程序中某个QPushButton对象在程序中调用了setProperty("level", "dangerous");才会把该PushButton设置为这个样式  。

详情见property与setProperty

该样式被同意设置后不会影响其子控件与子类

### 后代选择器
选择器之间用空格隔开，改样式只要前面控件的后代中有排最后一个控件的对象。
注意，QT中已有控件中，某些控件是一些子控件组成的，像下面这样这样是可以让该控件中子控件生效的。

    主控件 子控件{
        样式;
    }


其他一些例例：  
    QWidget QPushButton{  
        border-color:rgb(255,255,255);  
    } 

该样式中，只要某个PushButton是QWidget子控件或是其子控件中的某个子控件，都会对该样式生效。  
注意这种选择器中若某个类的基类是指定的类，那么也算，但是反过来不算
例： 

    QWidget QPushButton{  
        border-image: url(:/CQss/Resources/desktop_icon.png);  
    }
    //这种QFrame中的QPushButton也会使用，但是如果这里是QFrame开头，就不会在QWidget中生效


### 子元素选择器
选择器之间用 > 隔开，改样式严格要求了生效的亲代结构  

例：  
QFrame > QWidget > QPushButton

这个要求必须是QFrame的QWidget的QPushButton才能设置该样式  
注意这种选择器中若某个类的基类是指定的类，那么也算，但是反过来不算

例：

    QFrame > QWidget > QPushButton{  
        border-image: url(:/CQss/Resources/desktop_icon.png);  
    } 
    //这种如果某个PushButton单单只是一个QWidget中的PushButton则不会使用该样式


### 伪类选择器
选择器:状态 作为选择器，支持 ! 操作符，表示 非。  
例:  

    QPushButton:hover { color: white }
    QCheckBox:checked { color: white }
    QCheckBox:!checked { color: red }
该选择器表示选择某个控件或类某个时候的状态的样式来设置。  
比如鼠标划过，鼠标按下，鼠标松开等。  

其余的许多状态，详情请见QT手册。

### Subcontrol选择器  
选择器::subcontrol 作为选择 Subcontrol 的选择器。  

有的控件是由多个控件组成后设置对应属性而形成的，该选择器用于设置这些控件中组成他们的小控件的属性，例如QScrollArea的滚动条 

例：  

```
QCheckBox::indicator {  
    width: 20px;  
    height: 20px;  
}    

QCheckBox {  
spacing: 8px;  
}
```

更多的Subcontrol详情请看QT助手  

# QSS部分样式  
px为像素单位，pt为磅单位，一般文字大小用pt。  
注意QtCreator中的sizePolicy，许多时候布局后无法自动调整大小是这个所导致的。
## Box样式

#### width：宽度  

#### height：高度  

#### max-width：最大宽度  

#### max-height：最大高度  

#### min-width：最小宽度  

#### min-height：最小高度  

### 注意内外边框均不会改变控件原有大小，两个边距所用的边框中间那个边框就是border的


#### margin：外边距尺寸  

该属性在布局中非常明显，本质上是使原来该控件的窗口边界与外面设置边距方向上的某个控件的边界距离扩大设定尺寸那么多。原理上只是把控件的内容给缩小了一部分。

在QSS中不能一次设置四个方向不同的值。只能分次设置或是一次设置:  
margin-top 顶部   
margin-right 右边   
margin-bottom 底部    
margin-left 左边   
margin 设置所有的外边距

#### padding：内边距尺寸  

该属性与margin反过来，本质上是使原来该控件的窗口边界与该控件内部设置边距方向上的某个控件的边界距离扩大设定尺寸那么多。

同margin，该属性在QSS中不能一次设置四个方向。只能分次设置或是一次设置:  
padding-top  顶部
padding-right  右边
padding-bottom  底部
padding-left  左边
margin 设置所有的内边距  

位置样式

#### position：定位属性 //暂时不会用，等待补充

如果position是relative（默认值），则将子控件移动一定的偏移量;
如果position是absolute，则指定子控件相对于父控件位置  
top 
right  
bottom  
left  

## 字体样式  
#### font-family：字体类型  
[QT支持的部分字体](https://blog.csdn.net/qq_35297310/article/details/103350074)

#### font-size：字体大小
一般字体使用大小单位为pt

#### font-style：字体风格    
normal	正常  
italic	斜体  
oblique	倾斜的字体

#### font-weight：字体粗细  
normal	默认值。定义标准的字符。  
bold	定义粗体字符。  
bolder	定义更粗的字符。  
lighter	定义更细的字符。
数字(100-900) 定义由粗到细的字符。400等同于normal，而700等同于bold。

#### color：字体颜色   

## 文本样式  
#### text-decoration：文本修饰  
none 正常  
underline 下划线文本  
overline 上划线文本  
line-through 删除线文本

#### text-align：水平对齐

目前只有QPushButton和QProgressBar支持

left	把文本排列到左边。默认值。  
right	把文本排列到右边。  
center	把文本排列到中间。  
justify	实现两端对齐文本效果。  

## 背景样式  
#### background-color：背景颜色  
transparent 透明色  //background:transparent;  
rgb(x,y,z)      颜色值  
rgba(x,y,z,a)   颜色值+透明度

#### background-image：背景图片  

#### background-repeat：背景重复  
该属性在背景图片不足以铺满整个页面时使背景图片重复来达到铺满背景的效果   
repeat	默认。背景图像将在垂直方向和水平方向重复。  
repeat-x	背景图像将在水平方向重复。  
repeat-y	背景图像将在垂直方向重复。  
no-repeat	背景图像将仅显示一次。

#### background-position：背景定位

默认值：0% 0%。

##### 固定方向:  
top left  
top center  
top right  
center left  
center center  
center right  
bottom left   
bottom center  
bottom right  
如果您仅规定了一个关键词，那么第二个值将默认使"center"。

##### 百分比方向:
x% y%	
第一个值是水平位置，第二个值是垂直位置。

左上角是 0% 0%。右下角是 100% 100%。

如果您仅规定了一个值，另一个值将是 50%。

##### 像素方向:
xpos ypos	  

第一个值是水平位置，第二个值是垂直位置。

左上角是 0 0。单位是像素 (0px 0px) 或任何其他的单位(比如pt)。

如果您仅规定了一个值，另一个值将是50%。  

可以混合使用 % 和 position 值。

#### background-attachment：背景固定  
该属性规定是否背景图在容器有滚动条时，跟着滚动条滑动。

scroll	默认值。背景图像会随着页面其余部分的滚动而移动。  
fixed	当页面的其余部分滚动时，背景图像不会移动。

#### background-clip：设置元素的背景（背景图片或颜色）是否延伸到边框下面。  
该属性和margin与padding一起使用效果很明显

margin  填充满到外边框处。   
border  默认情况。(设置了padding和margin后的原边框位置处，相当于padding)   
padding 填充满到内边框处。  
content 填充满到内容框处。

#### background-origin：指定背景图片background-image属性的原点位置的背景相对区域
该属性决定了background-position的定位点  
margin  相对于外边框处。   
border  默认情况。(设置了padding和margin后的原边框位置处，相当于padding)   
padding 相对于内边框处。  
content 相对于内容框处。



## 边框样式

边框可以只设置一边来达到分割线的效果

#### border-color：边框颜色  
#### border-style：边框风格  
#### border-width：边框宽度
### 上边框
border-top          
border-top-color  
border-top-style  
border-top-width  
### 右边框
border-right  
border-right-color  
border-right-style  
border-right-width
### 下边框
border-bottom  
border-bottom-color  
border-bottom-style  
border-bottom-width 
### 左边框
border-left  
border-left-color  
border-left-style  
border-left-width  

#### border-image：边框图片
选择的图片会扩充直到边框处。  

可以用这个来设置边框图片(一些旁边是精美样式但是中间是空的图片)  

也选择一个图片设置边框为0后将该图片填满某个控件


#### border-radius：元素的外边框圆角弧度    
只有一条边也可以设置外边框圆角弧度
border-top-left-radius              左上角  
border-top-right-radius             右上角  
border-bottom-right-radius          左下角  
border-bottom-left-radius           右下角
border-radius                   所有脚

使用加单位的数字(pt,px等)，不加单位的数字都可以，能调整到想要的弧度就行。  

官方解释如下:  
长度的一两次出现。如果只指定了一个长度，它将被用作定义角的四分之一圆的半径。如果指定了两个长度，则第一个长度是四分之一椭圆的水平半径，而第二个长度是垂直半径。

#### border-style 边框样式
##### 没写边框样式表示没有边框  
设置边框是如何显示的  
none	定义无边框。  
dot-dash 定义方块状缺失和呈现边框  
dot-dot-dash  定义方块状缺失和呈现边框
dotted	定义点状边框。  
dashed	定义虚线。(默认)  
solid	定义实线。  
double	定义双线。双线的宽度等于 border-width 的值。  
groove	定义 3D 凹槽边框。其效果取决于 border-color 的值。  
ridge	定义 3D 垄状边框。其效果取决于 border-color 的值。  
inset	定义 3D inset 边框。其效果取决于 border-color 的值。  
outset	定义 3D outset 边框。其效果取决于 border-color 的值。  

## 颜色样式

#### alternate-background-color：交替行颜色

#### gridline-color：QTableView中网格线的颜色

#### selection-color：所选文本或项目的前景色

#### selection-background-color：所选文本或项目的背景色


## 轮廓样式  

outline用于设置点击后的聚集焦点样式(常用于与模型相关的View里面的Item显示中)

#### outline: 设置轮廓大小

#### outline-color：设置一个元素轮廓的颜色

#### outline-offset：设置 outline 与元素边缘或边框之间的间隙

#### outline-style：设置元素轮廓的样式  

#### outline-radius：设置元素的轮廓圆角弧度  

outline-bottom-left-radius  
outline-bottom-right-radius  
outline-top-left-radius  
outline-top-right-radius  
同 border-radius
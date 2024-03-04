# QT部分样式
[Box样式](#box样式)  
[位置样式](#位置样式)  
[字体样式](#字体样式  )  
[文本样式](#文本样式)  
[背景样式](#背景样式)  
[边框样式](#边框样式)  
[颜色样式](#颜色样式)  
[轮廓样式](#轮廓样式)  
[其他样式](#其他样式)
## Box样式
#### width：宽度  
#### height：高度  
#### max-width：最大宽度  
#### max-height：最大高度  
#### min-width：最小宽度  
#### min-height：最小高度  
#### margin：边距尺寸  
margin-top  
margin-right  
margin-bottom  
margin-left    
#### padding：填充尺寸  
padding-top  
padding-right  
padding-bottom  
padding-left  
## 位置样式  
#### position：定位属性  
如果position是relative（默认值），则将子控件移动一定的偏移量;  
如果position是absolute，则指定子控件相对于父控件位置  
top  
right  
bottom  
left  
## 字体样式  
#### font：字体样式  
#### font-family：字体类型  
#### font-size：字体大小  
#### font-style：字体风格  
#### font-weight：字体粗细  
#### color：字体颜色  
## 文本样式  
#### text-decoration：文本修饰  
#### text-align：水平对齐  
## 背景样式  
#### background：背影样式  
#### background-color：背景颜色  
#### background-image：背景图片  
#### background-repeat：背景重复  
#### background-position：背景定位  
#### background-attachment：背景固定  
#### background-clip：设置元素的背景（背景图片或颜色）是否延伸到边框下面。  
#### background-origin：指定背景图片background-image属性的原点位置的背景相对区域    
## 边框样式  
#### border：边框样式  
border-top  
border-top-color  
border-top-style  
border-top-width  
border-right  
border-right-color  
border-right-style  
border-right-width  
border-bottom  
border-bottom-color  
border-bottom-style  
border-bottom-width  
border-left  
border-left-color  
border-left-style  
border-left-width  
#### border-color：边框颜色  
#### border-style：边框风格  
#### border-width：边框宽度  
#### border-image：边框图片  
#### border-radius：元素的外边框圆角  
border-top-left-radius  
border-top-right-radius  
border-bottom-right-radius  
border-bottom-left-radius  
## 颜色样式  
alternate-background-color：交替行颜色  
gridline-color：QTableView中网格线的颜色  
selection-color：所选文本或项目的前景色  
selection-background-color：所选文本或项目的背景色  
## 轮廓样式  
#### outline：轮廓属性  
#### outline-color：设置一个元素轮廓的颜色  
#### outline-offset：设置 outline 与元素边缘或边框之间的间隙  
#### outline-style：设置元素轮廓的样式  
#### outline-radius：设置元素的轮廓圆角  
outline-bottom-left-radius  
outline-bottom-right-radius  
outline-top-left-radius  
outline-top-right-radius  

## 其他样式  
opacity：控件的不透明度  

icon-size：控件中图标的宽度和高度。

image：在子控件的内容矩形中绘制的图像

image-position：在Qt 4.3及更高版本中，可以使用相对或绝对位置指定图像图像位置的对齐

spacing：控件中的内部间距

subcontrol-origin：父元素中子控件的原始矩形。

subcontrol-position：subcontrol-origin指定的原始矩形内子控件的对齐方式。

button-layout：QDialogBu​​ttonBox或QMessageBox中按钮的布局

messagebox-text-interaction-flags：消息框中文本的交互行为

dialogbuttonbox-buttons-have-icons：QDialogBu​​ttonBox中的按钮是否显示图标

titlebar-show-tooltips-on-buttons：是否在窗口标题栏按钮上显示工具提示。

widget-animation-duration：动画应该持续多少（以毫秒为单位）。值等于零意味着将禁用动画

lineedit-password-character：该QLineEdit的密码字符作为Unicode数字。

lineedit-password-mask-delay：在将lineedit-password-character应用于可见字符之前，QLineEdit密码掩码延迟（以毫秒为单位）

paint-alternating-row-colors-for-empty-area：QTreeView是否为空白区域（即没有项目的区域）绘制交替的行颜色

show-decoration-selected：控制QListView中的选择是覆盖整个行还是仅覆盖文本的范围。
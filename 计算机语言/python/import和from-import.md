## import和from-import

`import` 语句用于导入整个模块。使用这种方式导入模块后，必须通过模块名来访问模块中的函数、类或变量。

`from ... import ...` 语句用于从一个模块中导入特定的函数、类或变量。使用这种方式导入后，可以直接使用导入的成员，而不需要通过模块名。

## 绝对导入

python中使用import为绝对导入，其会在sys.path中规定的目录去寻找模块，可以往sys.path中加入自己模块所在路径来支持用import导入。

* 这也是为什么经常用import无法导入自己的模块

## 相对导入

python中可以使用from import来进行相对导入，格式如下：

```python
from <已当前py文件的路径为准相对路径的模块> import <子模块/模块的方法/变量/定义等>
```

* 该方式导入模块很方便
* 导入自己的模块时，通常使用相对导入导入自己的子模块

例：

```python
#.加模块名 表示 导入当前目录下的模块
from .CPyMainWindow_designed import Ui_CPyMainWindow
# 按路径导入
from . import CPyMainWindow_designed.Ui_CPyMainWindow
```



## \_\_init\_\_.py文件

该文将用来将当前目录组成一个python包，并且规定导出当前目录下的python模块以及控制他们的行为。

* 导入该文件对应的模块时，也会同时导入\_\_init\_\_.py中import或from import的模块

例：

```python
# package目录下
# package目录变为一个模块
# __init__.py
import re
import urllib
import sys
import os

# a.py
import package 
print(package.re, package.urllib, package.sys, package.os)
```


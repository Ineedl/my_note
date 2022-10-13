## vars()
返回当前模块中全部内置变量

## os.\_\_file\_\_
返回当前文件所在当前目录的绝对路径

## \_\_package\_\_
导入的py文件所在的包路径

## \_\_name\_\_
如果当前程序为主程序，则为程序名，否则为模块名

## \_\_all\_\_

\_\_all\_\_变量是一个特殊的变量，可以在py文件中，也可以在包的__init__.py中出现。在包中定义\_\_all\_\_后，只有\_\_all\_\_内指定的属性、方法、类可以被其它模块导入。

* \_\_all\_\_经常在\_\_init\_\_.py中使用

例：

```python
#test1.py
__all__=["test"]
 
def test():
    print('----test-----')
      
def test1():
    print('----test1----')

#main.py
from test1 import *
      
def main():
    test()
      
    #test1()		//无法使用test1
      

```


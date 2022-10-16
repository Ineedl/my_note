## 注意

1. python中运算符重载的单个函数不止针对于相同类型对象之间，还针对于不同类型对象、对象与普通变量之间。

2. python没有限制运算符重载的返回值，比如对于需要返回bool的运算符重载(比如==)这些函数的返回值不一定非得是bool，也可以是其他类型。



## \_\_call\_\_()

()重载，偏函数，仿函数调用

* 参数列表不限制，但是必须含有self。

例:

```python3
class CLanguage:
    # 定义__call__方法
    def __call__(self,name,add):
        print("调用__call__()方法",name,add)

clangs = CLanguage()
clangs("1","2")
```



## \_\_init\_\_()

类构造函数

例:

```python
class ss:
    def __init__(self,age,name):
        self.age = age
        self.name = name
```

## \_\_del\_\_()

类析构函数，使用 del objName 时，该函数会被调用

例:

```python
class ss:
    def __del__(self):
        print("__del__")
```

## \_\_str\_\_与\_\_repr\_\_()

等同于Java中的toString()，\_\_str\_\_与\_\_repr\_\_作用相同，但是repr不会被外部repr()方法调用

例：

```python
class ss:
    def __str__(self):
        return str(self.age)+",,wozenmezhemeshuai,,"+self.name
```



## \_\_add\_\_()

## \_\_iadd\_\_

## \_\_radd\_\_

## \_\_sub\_\_()

## \_\_mul\_\_()

## \_\_truedie\_\_()

## \_\_floordiv\_\_()

## \_\_mod\_\_()

## \_\_pow\_\_()

## \_\_or\_\_()

## \_\_and\_\_()

左+、+=、右+-、*、/、//(向下取整除法)、%、** (1**2 = 1的二次方)、|、&

例:

```python
class A:
    def __add__(self, other):
        self.age += other
        return self
```

## \_\_getitem\_\_()与\_\_setitem\_\_()与\_\_delitem\_\_()

通过实现这三个方法，可以通过诸如 X[i] 的形式对对象进行取值和赋值和清空，还可以对对象使用切片操作。

例:

```python
class Indexer:
	data = [1,2,3,4,5,6]
	def __getitem__(self,index):
		return self.data[index]
	def __setitem__(self,k,v):
		self.data[k] = v
		print(self.data)
  def __delitem__(self,index)
  	del self.data[index] = 0
```

## \_\_len__()

重写该方法后可以被len()方法调用，等同于容器类的size()方法

例:

```python
class Students:
    def __init__(self, *args):
        self.names = args
    def __len__(self):
        return len(self.names)
```

## \_\_gt\_\_()/\_\_lt\_\_()/\_\_ge\_\_()/\_\_le\_\_()/\_\_eq\_\_()/\_\_ne\_\_()

\>,\<,>=,<=,==,!=

例:

```python
class A:
    def __eq__(self, other):
        self.name += other.name+"1"
        return self
```

## \_\_contains\_\_()

重载python中的in运算，in运算通常用于判断一个变量是否为某个类的一部分

* in运算也可以拿来返回一些东西，而非bool

例:

```python
class abc:
    def __contains__(self, m):
        if self.name: 
            return self.name + "1"
```



## \_\_mro\_\_

只能由类来调用，查看类的继承顺序

例:

```python
class Electrical(object):
 
    def chat(self):
        print('Chat with friend in electrical!')
 
    def watch_movie(self):
        print('Watch movie in electrical!')
 
    def game(self):
        print('Play game in electrical!')
 
 
class Phone(Electrical):
 
    def game(self):
        print('Play game in phone!')
 
 
class Computer(Electrical):
 
    def watch_movie(self):
        print('Watch movie in computer!')
 
    def game(self):
        print('Play game in computer!')
 
 
class HuaWei(Phone, Computer):
    pass

print(HuaWei.__mro__)
```

```
output:
(
<class '__main__.HuaWei'>, 
<class '__main__.Phone'>, 
<class '__main__.Computer'>, 
<class '__main__.Electrical'>, 
<class 'object'>
)
```

## \_\_dict\_\_

打印出该对象或类中已有的成员变量

例:

```python
class A:
    name1 = "234"
    def __init__(self, name, age):
        self.__name = 5
        self.age = age

a = A("cjh", 22)
print(a.__dict__)
  
#没有打印出类变量，只有对象的变量  
output:
  {'_A__name': 5, 'age': 22}
```

```python3
class A:
    name1 = "234"
    def __init__(self, name, age):
        self.__name = 5
        self.age = age
a = A("cjh", 22)
    print(A.__dict__)
  
#打印出类变量  
output:
  {'__module__': '__main__', 
   'name1': '234', 
   '__init__': <function A.__init__ at 0x10092ac10>, 
   '__dict__': <attribute '__dict__' of 'A' objects>, 
   '__weakref__': <attribute '__weakref__' of 'A' objects>, 
   '__doc__': None}
```

## \_\_slots\_\_

用来限定该类对象能够拥有的属性。

* 在使用\_\_slots\_\_前，使用\_\_dirt\_\_来存储这些属性
* 使用\_\_slots\_\_提前限定好属性再来存储比\_\_dirt\_\_使用的内存消耗小，而且效率高。

例:

```python3
class Person(object):

    # 限定Person对象只能绑定_name, _age和_gender属性
    __slots__ = ('_name', '_age', '_gender')

    def __init__(self, name, age):
        self._name = name
        self._age = age
        self.other_other = '1' 		#此处报错
```


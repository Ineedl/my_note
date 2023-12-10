## python装饰器

python的装饰器用来将一个函数装饰(装饰器模式)，使得该函数在调用前后做一些特殊处理

python使用

​			@+函数名

来声明@后的那个函数修饰了@下面声明的那个函数

### 无参装饰器

例：
    

```python
def log(f):
    def fn(x):
        print('call ' + f.__name__ + '()...')
        return f(x)
return fn

@log
def factorial(n):
    return reduce(lambda x,y: x*y, range(1, n+1))

print(factorial(10))

#上述factorial(10)等同于
factorial=log(factorial(10))
```

### 带参装饰器

例：
    

```python
def log(prefix):
def log_decorator(f):
    #args按顺序接受了装饰函数的参数，并组合成一个元组
    #kw 以map的方式接受了装饰函数的参数，并组合成一个字典
    def wrapper(*args, **kw):
        print(args)
        print(kw)
        print('[{}] {}()...'.format(prefix, f.__name__))
        return f(*args, **kw)
    return wrapper
return log_decorator

@log('DEBUG')
def my_func(a,b,c,e):
    pass

my_func("a","b","c",e=9)

#其中装饰器函数(log)的参数为装饰器接受的参数(此处接受了'DBUG')
#这算是一个基本格式，嵌套了两层，第二层才真正处理装饰函数的参数，第一次处理传入装饰器的参数
```


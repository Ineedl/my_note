## python lambda表达式

python中可以将函数当作一个对象，lambda就是一个临时的函数对象
例：
    

```python
lambda [list] : 表达式
#等同于

def name(list):
    return 表达式
name(list)

#或
def name(list):
    表达式
    #无return
name(list)
```


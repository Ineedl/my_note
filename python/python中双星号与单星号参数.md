## *参数

星号参数把接收的参数合并为一个元组。

* 可以使用 \* 加带括号的元组列表将元组传入带 \* 的参数重

例:

```python
def singalStar(common, *rest):
    print("Common args: ", common)
    print("Rest args: ", rest)
    
#'world'以及其后面的参数值会被组成为一个元组传递给rest    
singalStar("hello", "world", 24)
```



## **参数

双星号参数把接收的参数合并为一个字典。

* 可以使用 \*\ *加带括号的字典将字典传入带 \* 的参数重

例:

```python
def singalStar(common, **rest):
    print("Common args: ", common)
    print("Rest args: ", rest)
    
#'world'以及其后面的参数值会被组成为一个字典传递给rest    
singalStar("hello", x="world", y=24)
```



## 

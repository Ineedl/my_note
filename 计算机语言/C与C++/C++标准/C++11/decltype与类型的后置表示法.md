## decltype
decltype和auto 的功能一样，都用来在编译时期进行自动类型推导。  
auto是根据变量的初始值来推导出变量类型的,需要初始化与赋值同时进行，而 decltype不要求。

### decltype使用格式

```c++
decltype(<exp>) varname;
```


exp：exp是一个普通的表达式,它可以是任意复杂的形式(包括放入带有函数的计算式子,也可以放入重载了各种符号的类和结构体)。

* 必须要保证 exp 的结果是有类型的，类类型与结构体类型也可以，但不能是void。

* exp 结果可以是指针类型，包括void*指针。

* exp中也可以包括函数调用，但是exp最后结果一定要有一个类型的对象或者是数值的右值。

### 使用实例

```c++
int a = 0;
decltype(a) b = 1;  //b 被推导成了 int
decltype(10.8) x = 5.5;  //x 被推导成了 double
decltype(x + 100) y;  //y 被推导成了 double
decltype(a) b2;		//decltype不同于auto,他可以在变量不初始化的时候就直接定义。
```

decltype推导结构体和类类型

```c++
class A{};
decltype( new A() ) p()
{
	return new A();
}
```


### 使用实例
用decltype来推断模板中函数的返回值类型。

```c++
template<typename A.typename B>
decltype( (*(A*)0)+(*(B*)0) ) add(A a,B b)		//注意此处decltype也可以使用函数来推导返回值
{
		return a+b;
}
//(A*)0 -> 转换成A类型指针
// (*(A*)0) -> 引用这个左指 虽然此处一般不合法，但是在这里可以用于推导类型
```

* `(*(A*)0)` 是一种**不安全但“仅用作类型推导”的写法**，不能真的运行。

  更安全的写法是使用 `std::declval<A>()`：

或

```c++
template<typename A.typename B>
decltype( (A)0 + (B)0 ) add(A a,B b)
{
		return a+b;
}
```

## 函数返回值类型后置表示法
返回类型后置（trailing-return-type,又称跟踪返回类型）语法,将 decltype 和 auto 结合起来完成返回值类型的推导。

### 格式

```c++
auto <functionName>([parameterList]) ->  decltype(<exp>)
{
    <functionBody>
}
```


### 使用实例
该例子比上述来推断模板中函数的返回值类型例子中，单独使用decltype的前置表示法更加醒目清晰。

```c++
template <typename T, typename U>
auto add(T t, U u) -> decltype(t + u)
{
	return t + u;
}
```

当然你也可以像这样来推导,虽然看上去非常多余.
	
```c++
auto add() -> int
{
	return 1;
}
```
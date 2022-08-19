## lambda表达式介绍
c++中lambda表达式最后被解析成了一个临时的仿函数对象，而非一个指向某个新建函数的指针。
	例:
	
```c++
auto p=[=](int x){return x+1;};
std::cout<<typeid(p).name()<<std::endl;   //输出结果虽然看不懂,但是很明显并不是一个函数指针
//类型全称为main()::lambda(参数列表)
//哪个函数定义的前面就是哪个函数,此处例子lambda表达式定义在main函数
```

* lambda表达式可以使用类型推导

* lambda表达式如果要传给一个函数，必须用std::function包装，或者该函数是泛型函数

## lambda表达式格式
### 格式介绍

```c++
[captrueList] ([parameterList]) [mutable] [noexcept]/[throw([exceptionType],...)]-> [returnType]/[decltype表达式] { <functionBody>}
```

##### captrueList	
捕获列表，必须出现在表达式开始，用于捕获上下文变量；
	
##### parameterList					
参数列表，非必须，如果没有参数，可以和参数括号一起省略不写;

##### mutable								
lambda表达式默认为const函数，即仿函数对象为const，()重载也为const，仿函数函数体内部将无法修改捕获的变量。  

mutable可以改变函数常量性，如果使用mutable，参数列表不可省略。

例：
    
```c++
int a=6;
auto p=[a]()->int{a=1;return a;};
std::cout<<p();//报错
auto d=[a]()mutable->int{a=1;return a;};
std::cout<<p();//不报错
```



##### noexcept/throw(exceptionType,...)
抛出异常情况，虽然动态异常规范在c++11已经弃用，但是仍然可以使用。

##### returnType/(decltype表达式)
lambda表达式返回值的类型，也可以使用decltype推导

* 对于有明确返回值的函数，可以不写lambda表达式的返回类型与->

##### functionBody
函数体，可以使用参数列表中的参数，还可以使用捕获列表捕获的变量。

##### 一个复杂的的例子

```c++
auto p=[=](int p)mutable throw(int,char)->decltype(1+1){return p+8;};
```

### 捕获列表详解
|捕获列表形式|作用|
|:--|:--|
|[=]	|			按值传递，捕获父域所有变量(包括this指针)|
|[&]|				传引用，捕获父域所有变量(包括this指针)|
|[this]|			按值传递，捕获this指针|
|[var]		|	按值传递，捕获变量var|
|[&var]		|	传引用，捕获变量var|
|[=,&var]	|	传引用捕获变量var，按值传递捕获其余所有变量|
|[&,var]		|	按值传递捕获变量var，其余所有变量传引用捕获|

* 注意：[=,var],[&,&var]的写法不正确，编译器会报错.要么都弄,要么只有个例

* lambda表达式中，仿函数本身this指针的捕获算在=里面。

* lambda捕捉的上面出现的变量，不管是引用还是变量，只要用到了，都作为仿函数的成员变量存储到了这个lambda临时仿函数对象里面，这些值与引用会跟随lambda表达式一起到移动。

### lambda表达式大小
在捕捉变量时写入捕捉域的赋值类型的(=)的变量的大小一并算入lambda表达式的临时对象的大小中(计算大小同类大小的计算)，但是对于全部捕捉的这种([=]),只有用到的变量才会算入lambda表达式的临时对象大小中。

对于[&]这种，因为引用的本质是指针，所以当捕获后且用到时，大小作为8计算到lambda大小中。

例：

```c++
int a=4;
char b;
int c;
int d;
auto p=[a,b,c,d]()->int{return 2;};
std::cout<<sizeof(p)<<std::endl;

//p2大小为16但p1,p大小均为类的最小默认值1
auto p1=[=]()->int{return 3;};
std::cout<<sizeof(p1)<<std::endl;

auto p2=[a,b,c,d]()->int{return a+(int)b+c+d;};
std::cout<<sizeof(p2)<<std::endl;
```

c++引用的原理实质上相当于一个指针所以引用大小和指针是一致的,所以lambda表达式同理,传入引用的大小等同传入当前环境下指针的大小。
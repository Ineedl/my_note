### C++相关

#### operator
该关键字用于运算符重载

#### extern										
该关键字用于额外声明    	//	extern class typename	
#### static_cast
该关键字用于静态转换

#### dynamic_cast
该关键字用于动态转换

#### const_cast										
该关键字用于强制消除对象的常量性

#### virtual										
该关键字用来定义纯虚函数和虚函数,并且用来进行虚继承

#### protected									
声明该函数或变量为受保护访问类型

#### public	
声明该函数或变量为公开类型

#### private										
声明该变量或函数只能在类的内部访问.
									
															
#### inline									
该关键字用于函数，用来声明内联函数,内联函数可以给编译器优化,提高效率(内联函数可以在需要的地方向宏一样展开,而不需要调用函数那样寻址再返回)

* 任何在类内部定义的函数都为内联函数(默认加上inline)，构造和析构还有拷贝等函数都也是。
	
* 在类内声明确在内外定义的函数,除非在类内声明处或类外定义处添加了inline关键字,就不是内联函数，构造和析构还有拷贝等函数都也是。
	
* 内联函数都一般是1-5行的短函数,过于长的函数不要轻易声明为内联函数

* 内联函数中不能存在任何形式的循环语句,不能存在过多的条件判断语句,函数体不能过于庞大,不能对函数进行取址操作

* 函数内联后会将函数体会被插入到函数调用的地方,这样很容易使代码膨胀。

* 声明inline关键字后,是可能变为内联函数,而不是一定变为内联函数。
	
* C也可以声明内联函数,原理同C++。
																

#### friend										
该关键字用来声明为有元函数或有元类

例：
		
```c++
	1.友元类声明
	
	class A{
		friend class B;

	};
	class B{
	};
	B类对象中可以访问A类对象的所有成员函数和变量
	
	2.友元函数声明:
	
	class CDriver
	{
	public:
		void ModifyCar(CCar* pCar);  //改装汽车
	};
	class CCar
	{
	private:
		int price;
		friend int MostExpensiveCar(CCar cars[], int total);  //声明友元
		friend void CDriver::ModifyCar(CCar* pCar);  //声明友元
	};
	上述中成员函数ModifyCar和类外函数MostExpensiveCar可以访问类CCar中所有成员变量和成员函数
```


#### explicit								
该关键字用来表示某函数必须以显式方式声明与调用，一般用于构造函数。

#### template									
该关键字用来声明模板类和模板函数
											
```c++
template<class T,typename T,class T>
```

* 使用typename和class在定义类模板或是函数模板时是一样的,但是某些时候typename有特殊作用
						

另外 模板参数分类型参数和非类型参数

非类型参数可以使用任何类型,包括引用,指针,函数指针,void类型指针等,还有指针的引用,成员函数指针等
函数模板例子:

```c++
template<typename T, void (*f) (T &v)>
void foreach(T array[], unsigned size) {
	for (unsigned i = 0; i < size; ++i)
		f(array[i]);
}
```

类模板例子:
		
```c++
template<char number,class mode>
class trueA{
public:
	mode t;
	int a[(int)number];
public:
	trueA(int p){
		int i;
		for(i=0;i<(int)number;i++)
			this->a[i]=p;
	}
};
```


##### 初始化函数模板的方法

对于上面的类模板例子

```c++
//tureA可以这样new一个对象
trueA<'a',string> *A=new trueA<'a',string>(5);
```

对于上述函数模板例子
											
```c++
int array[] = {1, 2, 3, 4, 5, 6, 7, 8};
foreach<int, print<int>>(array, 8);
```

* 无论什么时候,用new初始化模板时都要在前面和后面加上类型声明。
	
* 模板类在声明的时候也要加模板参数


```c++
template <typename T,class B>class A;
int a;
template <typename T,class B>
class A
{
	public:
		B b;
		T t;
	A(){}
};
```



#### mutable									
该关键字用来声明变量可改变,在const成员函数中也可以使用并改变，该关键字只可用于变量

#### noexcept									
该关键字为C++11新特性相关关键字，用于标识函数，告诉编译器函数中不会发生异常,这有利于编译器对程序做更多的优化。

* 只是告诉,实际上也可能抛出异常,而且抛出异常之后就会终止程序

* 相当于函数后面加throw()

#### constexper									
该关键字为c++11新特性相关关键字。用于表示常量表达式变量与常量表达式函数，来进行优化。
											
#### volatile	
在多线程中使用,被该关键字标记的变量，系统总是重新从它所在的内存读取数据，即使它前面的指令刚刚从该处读取过数据。
												

#### typeid
typeid会返回一个type_info类的对象,该类属于c++标准库，name()方法属于type_info类方法，typeid用来获取变量类型(要包含头文件typeinfo)

```c++
	typeid(a).name()       //获取变量a的类型
```

当然,这个也可以放类型
	
```c++
    typeid(int).name()
```

* typeid只能识别类型是什么,可以识别出指针类型，但是也只能获取到类型一个而已。
	
### C/C++相关
#### restrict									
该关键字用来标识变量，该关键字声明编译器不能通过除该指针以外所有其他直接或者间接方法修改该变量(对象)的内容,

* 如果变量用其他其他方法修改其实也可以，用其他方法修改后也不会报错，这个只是为了提醒编译器，然后可以获得优化，但是你这样做会导致程序结果不确定。

例:

```c++
int add(int* __restrict a,int* __restrict b)		//GUN	cc写法
{
	*a = 5;
	*b = 6;
	return *a+*b;
}
```

假设传入的两个参数为同一变量。比如add(&a,&a)，则可能会出现以下情况。

如果两个形参不加restrict修饰，上述代码返回12。  

若两个形参加restrict修饰，上述代码返回11。  

* 原因：在编译期就已计算出5+6,加了restrict后把从存储器中取数据那段操作优化了

* 该结果跟编译器优化有关，不一定永远是这个情况。

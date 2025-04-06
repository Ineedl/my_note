## static新特性

c++11保证定义static对象在构造时，对象的内存分配，对象的构造，对象的地址返回这三步是一个原子操作，即定义静态变量是线程安全的。

* c++11前的单例模式

```c++
class A{
	static A* getA(){
		各种复杂的操作，保证线程同步，然后返回对象A
	}
}
```

* c++11后的单例模式

```c++
class A{
	static A* getA(){
		static A a;
    return &a;
	}
}
```


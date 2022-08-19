## nullptr
* 所需头文件 <cstdlib>

### 传统null的定义

```c++
/* Define NULL pointer value */
#ifndef NULL
	#ifdef __cplusplus					//c++	
		#define NULL    0
	#else  								//c语言定义
		#define NULL    ((void *)0)
	#endif  
#endif  
```

使用传统的null定义，当某类中的单参数函数重载时，如果同时拥有整数数值类型和指针类型，当传入null时，可能执行的是整数数值类型参数的构造函数，从而造成错误。

nullptr就是为了解决上述问题。

nullptr关键字用于标识空指针，是std::nullptr_t类型的（constexpr）变量。
	它可以转换成任何指针类型和bool布尔类型（主要是为了兼容普通指针可以作为条件判断语句的写法），但是不能被转换为整数。
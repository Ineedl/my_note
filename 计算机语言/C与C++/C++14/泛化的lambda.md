## auto参数

在C++14中，对此进行优化，lambda表达式参数可以直接是auto

```c++
auto f = [] (auto a) { return a; };
cout << f(1) << endl;
cout << f(2.3f) << endl;
```

* auto参数类型的原理是把lambda表达式看做了一个类(struct)模板

```c++

auto lambda = [](auto x, auto y) {return x + y;}

等价于

struct unnamed_lambda {
  template<typename T, typename U>
    auto operator()(T x, U y) const {return x + y;}
};
auto lambda = unnamed_lambda{};


```

## Lambda捕获参数中使用表达式
C++14允许lambda成员用任意的被捕获表达式初始化,也允许了任意声明lambda的成员，而不需要外层作用域有一个具有相应名字的变量,该变量不需要在lambda表达式所处的闭包域中存在，如果在闭包域中存在也会被新初始化的变量覆盖

```c++

auto ptr = std::make_unique<int>(10);
auto lambda = [value = std::move(ptr)] {return *value;}

---------

int x = 4;
auto y = [&r = x, x = x + 1]()->int
{
	r += 2;
	return x * x;
}(); 
cout << "x = " << x << " y = " << y << endl;

```
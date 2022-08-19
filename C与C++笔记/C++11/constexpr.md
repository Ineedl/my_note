## constexpr
constexpr修饰的是真正的常量，它会在编译期间就会被计算出来，整个运行过程中都不可以被改变。

constexpr可以用于修饰函数，这个函数的返回值会尽可能在编译期间被计算出来当作一个常量，但是如果编译期间此函数不能被计算出来，那它就会当作一个普通函数被处理。

c++11中constexpr函数只能包含一个返回语句。

```
#include<iostream>
using namespace std;

constexpr int func(int i) {
    return i + 1;
}

int main() {
    int i = 2;
    func(i);// 普通函数
    func(2);// 编译期间就会被计算出来
}
```
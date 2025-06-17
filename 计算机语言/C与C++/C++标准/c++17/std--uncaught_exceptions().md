## std::uncaught_exceptions()

该函数返回当前线程中未捕获的异常对象的数量。

```c
#include <iostream>
#include <exception>

struct Observer {
    int count = std::uncaught_exceptions();
    ~Observer() {
        if (std::uncaught_exceptions() > count) {
            std::cout << "Destructor called during exception\n";
        } else {
            std::cout << "Destructor called normally\n";
        }
    }
};

void test() {
    Observer o;
    throw std::runtime_error("fail");
}

int main() {
    try {
        test();
    } catch (...) {}
}
```

`多层嵌套场景`

```c++
try {
    Observer o1;
    throw 1;
} catch (...) {
    Observer o2;
    try {
        throw 2;
    } catch (...) {
        Observer o3;
        // 此时 std::uncaught_exceptions() == 2
    }
}
```



## 未处理异常

在 `throw` 出异常，C++ 会自动从当前作用域到 `catch` 之间**依次析构所有局部变量**；

- 在这期间，这个异常还没真正被处理——它**正在向上传播中**；
- 这个传播过程，就叫 **stack unwinding**；
- 在这个过程中，`std::uncaught_exceptions()` 会返回一个大于 0 的值（表示有异常“还在传播”）。
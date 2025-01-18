## explicit
explicit专用于修饰构造函数，表示只能显式构造，不可以被隐式转换，根据代码看explicit的作用：

不用explicit：
```c++
struct A {
    A(int value) { // 没有explicit关键字
        cout << "value" << endl;
    }
};

int main() {
    A a = 1; // 可以隐式转换
    return 0;
}
```
使用explicit:
```c++
struct A {
    explicit A(int value) {
        cout << "value" << endl;
    }
};

int main() {
    A a = 1; // error，不可以隐式转换
    A aa(2); // ok
    return 0;
}
## final
1.final可以标记在一个基类后面，表示该类无法被继承。

2.final可以标记在一个虚函数后面，表示该虚函数后续被继承后不能被重写。

```c++
struct Base final {
    virtual void func() {
        cout << "base" << endl;
    }
};

struct Derived : public Base{ // 编译失败，final修饰的类不可以被继承
    void func() override {
        cout << "derived" << endl;
    }
s
};
```


## override
override用于要重写的虚函数后面，表示该虚函数是重写的，如果该函数不是一个重写函数，那么将会报错。
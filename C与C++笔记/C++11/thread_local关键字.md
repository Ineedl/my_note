## thread_local
用thread_local修饰的变量具有thread周期，每一个线程都拥有并只拥有一个该变量的独立实例，一般用于需要保证线程安全的函数中。

```
#include <iostream>
#include <thread>

class A {
public:
    A() {}
    ~A() {}
public:
    void test(const std::string &name) {
        //每个线程都拥有一个，而不共享
        thread_local int count = 0;
        ++count;
        std::cout << name << ": " << count << std::endl;
    }
};

void func(const std::string &name) {
    A a1;
    a1.test(name);
    a1.test(name);
    A a2;
    a2.test(name);
    a2.test(name);
}

int main() {
    std::thread(func, "thread1").join();
    std::thread(func, "thread2").join();
    return 0;
}
```
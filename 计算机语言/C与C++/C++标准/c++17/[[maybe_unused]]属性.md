## 变化

`[[maybe_unused]]` 是一个标准属性，用来**告诉编译器某个变量、参数、函数、结构体等即使未被使用也不是错误或问题**，避免触发“unused”类的警告。

```cpp
[[maybe_unused]] int x = 42;
```

哪怕 x 后面完全没被用到，编译器也不会发出 “unused variable” 警告。
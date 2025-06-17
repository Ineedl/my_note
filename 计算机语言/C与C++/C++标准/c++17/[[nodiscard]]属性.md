## 变化

c++17新增 [[nodiscard]]，用于强调函数的返回值不应该被丢弃，否则会出现编译器警告。

```c++
[[nodiscard]] int foo();
void bar() {
    foo(); // 发出警告，foo的返回值不应该被丢弃
}
```

此属性也可以应用于类型，以便将返回该类型的所有函数标记为[[nodiscard]]：

```cpp
[[nodiscard]] struct DoNotThrowMeAway{};
DoNotThrowMeAway i_promise();
void oops() {
    i_promise(); // Warning emitted, return value of a nodiscard function is discarded
}
```

## 变化

允许您使用参数包中所有类型的*using 声明*注入名称。

为了 operator() 从可变参数模板中的所有基类公开，我们过去不得不求助于递归：

```cpp
template <typename T, typename... Ts>
struct Overloader : T, Overloader<Ts...> {
    using T::operator();
    using Overloader<Ts...>::operator();
    // […]
};

template <typename T> struct Overloader<T> : T {
    using T::operator();
};
```

现在我们可以简单地扩展*using-declaration*中的参数包：

```cpp
template <typename... Ts>
struct Overloader : Ts... {
    using Ts::operator()...;
    // […]
};
```
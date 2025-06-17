## 变化

C++ 的 static-if！这允许您在编译时根据常量表达式条件丢弃 if 语句的分支。

```cpp
if constexpr(cond)
     statement1; // Discarded if cond is false
else
     statement2; // Discarded if cond is true
```

这消除了很多标签分发和 SFINAE 的必要性，原因是：

而 **C++17 的 `if constexpr`（俗称 static-if）本质上是让你**：

- 在模板里**像写普通代码一样写分支**
- 编译器根据条件只实例化被选中的代码路径
- 非选中路径的非法代码不会报错（类似 SFINAE 效果）

这就直接取代了这两种老手段。

## SFINAE

当模板实例化时，如果某个**模板参数替换失败**，**编译器不会报错**，而是**丢弃这个重载/特化/偏特化**，**去尝试其他更匹配的候选项**。

`例子`

```c++
#include <type_traits>
#include <iostream>

template <typename T>
typename std::enable_if<std::is_integral<T>::value, void>::type
print(T x) {
    std::cout << "整数: " << x << std::endl;
}

template <typename T>
typename std::enable_if<!std::is_integral<T>::value, void>::type
print(T x) {
    std::cout << "非整数: " << x << std::endl;
}
```

`std::enable_if<condition, T>::type` 在 `condition=false` 时没有 `type` 成员，触发替换失败；

因此编译器丢弃那个函数重载，而选择另一个。

## 标签派发

标签派发就是：**将类型特征“打标签”，然后根据标签重载函数**，从而实现编译期的静态分发。

```c++
#include <iostream>
#include <type_traits>

template <typename T>
void process_impl(T x, std::true_type) {
    std::cout << x << " 是整数类型\n";
}

template <typename T>
void process_impl(T x, std::false_type) {
    std::cout << x << " 是非整数类型\n";
}

template <typename T>
void process(T x) {
    // 将 type traits 转换成标签 true_type / false_type
    process_impl(x, std::is_integral<T>{});
}

```


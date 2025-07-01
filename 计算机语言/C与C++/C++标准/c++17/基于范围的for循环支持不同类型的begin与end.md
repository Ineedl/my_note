## 变化

### 背景问题：C++11/C++14 中的限制

在 C++11/C++14 中，你写：

```
for (auto x : range) {
    ...
}
```

编译器会大致展开为：

```c++
auto&& __range = range;
for (auto __it = begin(__range); __it != end(__range); ++__it) {
    auto x = *__it;
    ...
}
```

这里的关键问题在于：**`begin(__range)` 和 `end(__range)` 的类型必须一致**，否则编译报错。

这对很多**自定义区间类**（特别是只读视图、半开区间、哨兵结束迭代器）是一种**强加的限制**。

### C++17 改进点

> 允许 `begin()` 和 `end()` 返回**不同类型**，前提是这两个类型：
>
> - 可互相比较（`operator!=` 可用）
> - `begin()` 的类型可 `++`，并能解引用（即基本满足 InputIterator）

### 示例

```c++
struct MySentinel {};  // 哨兵：只做比较，不支持++
struct MyIter {
    int value = 0;
    int operator*() const { return value; }
    MyIter& operator++() { ++value; return *this; }
    bool operator!=(const MySentinel&) const { return value < 5; }
};

struct MyRange {
    MyIter begin() const { return {}; }
    MySentinel end() const { return {}; }  // 注意类型不同
};

int main() {
    for (int x : MyRange()) {
        std::cout << x << ' ';
    }
}
```

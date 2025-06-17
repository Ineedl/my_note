## 变化

C++17 引入了一个非常实用且影响深远的特性：**`constexpr lambda` 表达式**。这个特性是 C++ 在编译期计算能力演进中的关键一步。

下面我将从语法、能力、限制和应用四个方面给你做个深入介绍，并指出你应当怀疑的坑点。

### 定义

> C++17 支持你用 `constexpr` 修饰 lambda，使其可以在**编译期作为常量表达式使用**，前提是 lambda 的内部逻辑也满足 `constexpr` 要求。

### 基本语法

```c++
constexpr auto add = [](int a, int b) { return a + b; };
static_assert(add(1, 2) == 3, "Compile-time check");
```

你可以像普通函数一样将其用于编译期上下文，例如：

- `static_assert`
- `constexpr` 变量初始化
- `template` 非类型参数（C++20后）

------

## ✅ C++17 相比 C++14 的关键突破点

| 特性                  | C++14             | C++17                       |
| --------------------- | ----------------- | --------------------------- |
| lambda 支持 constexpr | ❌ 不能修饰 lambda | ✅ `constexpr` 可用于 lambda |
| 能否用于编译期表达式  | ❌                 | ✅                           |



C++14 的 lambda 是不可 `constexpr` 的。即使你手动写一个 lambda 逻辑全部是编译期表达式，也不能当作 `constexpr` 用。
 C++17 打破了这个限制，首次**允许 lambda 出现在编译期上下文中**。

------

## ✅ 捕获变量的限制（这是关键点）

### C++17 的限制：

- lambda **可以有值捕获**，但**要想在编译期使用，捕获变量本身也必须是 `constexpr`**。
- 只要捕获非 `constexpr` 的变量，lambda 本身就不是 `constexpr` 了。

### 示例：

```c++
int x = 10;
constexpr auto f = [x](int y) { return x + y; }; // ❌ 错误，x 不是 constexpr

constexpr int cx = 10;
constexpr auto g = [cx](int y) { return cx + y; }; // ✅ OK
```

简言之：**捕获的变量必须是编译期常量，才能生成真正的 `constexpr lambda`**。

------

## ✅ 使用限制（不要被表象骗了）

即便写了 `constexpr auto f = [](int x){ return x+1; };`，它的可否用于编译期上下文仍取决于：

- **调用参数是 constexpr**
- **内部语句全部是合法的编译期表达式**
- **返回值也是 constexpr 可支持的类型**
[toc]

## c++11 constexpr的限制

在 C++11 中，`constexpr` 函数必须满足：

- 只能包含**单个 return 语句**（不能有循环、`if`、`switch` 等）
- 函数体中不能有：
  - 局部变量定义
  - 赋值语句
  - 分支或循环
- 递归是**唯一**支持的逻辑控制方式

```c++
constexpr int add(int a, int b) { return a + b; }  // OK in C++11
constexpr int x = add(1, 2);                       // OK
```

不能写：

```c++
constexpr int sum(int n) {
    int s = 0;
    for (int i = 0; i <= n; ++i) s += i;
    return s;
}
```

## C++14 对 `constexpr` 的强化

C++14 允许在 `constexpr` 函数中使用：

| 特性                     | C++11               | C++14      |
| ------------------------ | ------------------- | ---------- |
| 多语句                   | ❌ 不允许            | ✅ 允许     |
| 局部变量                 | ❌ 不允许            | ✅ 允许     |
| 循环 (`for`/`while`)     | ❌ 不允许            | ✅ 允许     |
| 条件分支 (`if`/`switch`) | ❌ 不允许            | ✅ 允许     |
| `return` 多个可选点      | ❌ 只允许一个 return | ✅ 支持多个 |

## c++14 constexpr的限制

| 类别               | 禁止内容                                     | 说明                                           |
| ------------------ | -------------------------------------------- | ---------------------------------------------- |
| **异常相关**       | `throw` 表达式                               | 不允许抛出异常                                 |
|                    | 使用 `try-catch`                             | 完全禁止异常处理                               |
| **运行时行为**     | 动态内存分配 `new/delete`                    | 所有分配操作被禁止                             |
|                    | `malloc` / `free` 等低级操作                 | 任何堆操作都是非法的                           |
|                    | 使用非 `constexpr` 函数                      | 函数必须也是 `constexpr`                       |
|                    | 函数指针调用（间接调用）                     | C++14 不支持 constexpr 中的间接函数调用        |
|                    | 使用虚函数                                   | 包括调用虚函数、虚析构等都不允许               |
|                    | 类型转换 `dynamic_cast` / `reinterpret_cast` | 不允许任何运行时相关转换                       |
|                    | I/O 操作                                     | 如 `std::cout`, `printf`, 文件读写等           |
|                    | 汇编语句（`asm`）                            | 所有底层汇编都不允许                           |
|                    | `volatile` 操作                              | 不允许使用 volatile 类型或访问 volatile 变量   |
| **多线程**         | 原子操作 / 线程库                            | `std::atomic`, `std::thread`, `mutex` 都不支持 |
| **运行时类型信息** | `typeid`                                     | 编译期不能使用 RTTI                            |
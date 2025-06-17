[toc]

## 变化

C++17 开始，`if` 和 `switch` 语句都支持在条件判断之前写一个**初始化语句**（init-statement），这让代码更紧凑、更安全，减少作用域外泄漏的变量。

## 语法格式

### if 语句

```c++
if (init-statement; condition) {
    // 条件为真时执行
}
```

- `init-statement` 是一条语句，通常是变量声明或赋值；
- 这个变量的作用域限于 `if` 语句（包含 `else` 块）内。

### switch 语句

```c++
cpp


复制编辑
switch (init-statement; condition) {
    case ...:
        ...
}
```

- 同理，`init-statement` 是在条件表达式前执行的初始化语句，作用域限于 `switch` 语句内部。

------

## 例子

### if 语句

```c++
if (int x = foo(); x > 0) {
    std::cout << "x is positive: " << x << "\n";
} else {
    std::cout << "x is zero or negative: " << x << "\n";
}
// x 在这里不可访问
```

### switch 语句

```c++
switch (int code = getCode(); code) {
    case 1: std::cout << "code 1\n"; break;
    case 2: std::cout << "code 2\n"; break;
    default: std::cout << "unknown code\n";
}
// code 在这里不可访问
```

------

## 优点

- **变量作用域受限**：`init-statement` 中的变量只在 `if` 或 `switch` 块内有效，避免污染外部作用域；
- **简化代码**：不用提前声明变量，减少代码行数和复杂度；
- **避免未初始化使用**：变量一定初始化后才用，提升安全性。
## 变化

c++17新增 [[fallthrough]] 属性，启用于指示case不加break是故意行为，不应该警告

```cpp
switch (c) {
case 'a':
    f(); // 会出现警告
case 'b':
    g();
[[fallthrough]]; // 不会出现警告
case 'c':
    h();
}
```


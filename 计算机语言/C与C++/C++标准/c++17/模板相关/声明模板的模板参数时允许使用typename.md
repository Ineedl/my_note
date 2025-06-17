## 变化

允许您在声明模板模板参数时使用 typename 而不是 class。 普通类型参数可以互换使用它们，但模板模板参数仅限于类，因此此更改在某种程度上统一了这些形式。

```cpp
template <template <typename...> typename Container>

//c++11/c++14必须为
template <template <typename T> class Container>
```
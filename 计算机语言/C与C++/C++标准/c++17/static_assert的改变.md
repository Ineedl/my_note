## 变化

它允许在不传递消息的情况下拥有条件，带有消息的版本也将可用。它将与其他断言兼容BOOST_STATIC_ASSERT（从一开始就没有接收任何消息）。

```cpp
#include <iostream>
constexpr int identity(int x)
{
    return x;
}

int main()
{
    static_assert(identity(10) == 10, "expected the same value"); // since C++11
    static_assert(identity(10) == 10); // no message, since C++17
    return 0;
}
```
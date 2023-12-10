## deprecated
deprecated属性允许标记不推荐使用的实体，该实体仍然能合法使用，但会让用户注意到使用它是不受欢迎的，并且可能会导致在编译期间输出警告消息。 deprecated可以有一个可选的字符串文字作为参数，以解释弃用的原因和/或建议替代者。

```c++
[[deprecated]] int f();

[[deprecated("g() is thread-unsafe. Use h() instead")]]
void g( int& x );

void h( int& x );

void test() {
  int a = f(); // 警告：'f'已弃用
  g(a); // 警告：'g'已弃用：g() is thread-unsafe. Use h() instead
}
```
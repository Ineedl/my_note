## 变化

c++17现在默认在类函数中捕获lambda

```c++
struct S {
   int x ;
   void f() {
      // The following lambda captures are currently identical
      auto a = [&]() { x = 42 ; } // OK: transformed to (*this).x
      auto b = [=]() { x = 43 ; } // OK: transformed to (*this).x
      a();
      assert( x == 42 );
      b();
      assert( x == 43 );
   }
};
```


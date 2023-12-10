## wchar_t和WCHAR

wchar_t是Unicode字符的数据类型，WCHAR实际就是wchar_t。实际定义：

```c++
typedef unsigned short wchar_t;
typedef wchar_t WCHAR; 
```

wchar_t 可用字符串处理函数：wcscat(),wcscpy(),wcslen()等以wcs打头的函数。为了让编译器识别Unicode字符串，必须以在前面加一个“L”。

```c++
wchar_t *szTest=L"This is a Unicode string.";
```


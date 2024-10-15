## Go调C

CGO在使用C/C++资源的时候一般有三种形式

* 直接使用源码：在`import "C"`之前的注释部分包含C代码，或者在当前包中包含C/C++源文件。
* 链接静态库：通过在LDFLAGS选项指定要链接的库方式链接。
* 链接动态库：通过在LDFLAGS选项指定要链接的库方式链接。

## 使用C静态库

```go
package main

//#cgo CFLAGS: -I./number
//#cgo LDFLAGS: -L./number -lnumber
//
//#include "number.h"
import "C"
import "fmt"

//number库就在当前目录下 名为libnumber.a
func main() {
    fmt.Println(C.number_add_mod(10, 5, 12))
}
```

`number/number.h`头文件只有一个纯C语言风格的函数声明：

```c
int number_add_mod(int a, int b, int mod);
```

`number/number.c`对应函数的实现：

```c
#include "number.h"

int number_add_mod(int a, int b, int mod) {
    return (a+b)%mod;
}
```

## 2.9.2 使用C动态库

动态库和静态库的基础名称都是libnumber，只是后缀名不同而已。因此Go语言部分的代码和静态库版本完全一样：

```go
package main

//#cgo CFLAGS: -I./number
//#cgo LDFLAGS: -L./number -lnumber -Wl,-rpath=./ 

//#include "number.h"
import "C"
import "fmt"

func main() {
    fmt.Println(C.number_add_mod(10, 5, 12))
}
```

* 链接静态库时，在`LDFLAGS命令`中也可以指定gcc参数`-Wl,-rpath=./`来指定程序生成后，新增的寻找动态库的位置
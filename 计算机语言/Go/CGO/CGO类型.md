## 数值类型

| C语言类型              | CGO类型     | Go语言类型 |
| ---------------------- | ----------- | ---------- |
| char                   | C.char      | byte       |
| singed char            | C.schar     | int8       |
| unsigned char          | C.uchar     | uint8      |
| short                  | C.short     | int16      |
| unsigned short         | C.ushort    | uint16     |
| int                    | C.int       | int32      |
| unsigned int           | C.uint      | uint32     |
| long                   | C.long      | int32      |
| unsigned long          | C.ulong     | uint32     |
| long long int          | C.longlong  | int64      |
| unsigned long long int | C.ulonglong | uint64     |
| float                  | C.float     | float32    |
| double                 | C.double    | float64    |
| size_t                 | C.size_t    | uint       |

`stdlib.h`

| C语言类型 | CGO类型    | Go语言类型 |
| --------- | ---------- | ---------- |
| int8_t    | C.int8_t   | int8       |
| uint8_t   | C.uint8_t  | uint8      |
| int16_t   | C.int16_t  | int16      |
| uint16_t  | C.uint16_t | uint16     |
| int32_t   | C.int32_t  | int32      |
| uint32_t  | C.uint32_t | uint32     |
| int64_t   | C.int64_t  | int64      |
| uint64_t  | C.uint64_t | uint64     |

## 字符串类型

在Go语言中，数组是一种值类型，而且数组的长度是数组类型的一个部分。Go语言字符串对应一段长度确定的只读byte类型的内存。Go语言的切片则是一个简化版的动态数组。

Go语言和C语言的数组、字符串和切片之间的相互转换可以简化为Go语言的切片和C语言中指向一定长度内存的指针之间的转换。

CGO的C虚拟包提供了以下一组函数，用于Go语言和C语言之间数组和字符串的双向转换：

```go
// Go string to C string
// The C string is allocated in the C heap using malloc.
// It is the caller's responsibility to arrange for it to be
// freed, such as by calling C.free (be sure to include stdlib.h
// if C.free is needed).
func C.CString(string) *C.char

// Go []byte slice to C array
// The C array is allocated in the C heap using malloc.
// It is the caller's responsibility to arrange for it to be
// freed, such as by calling C.free (be sure to include stdlib.h
// if C.free is needed).
func C.CBytes([]byte) unsafe.Pointer

// C string to Go string
func C.GoString(*C.char) string

// C data with explicit length to Go string
func C.GoStringN(*C.char, C.int) string

// C data with explicit length to Go []byte
func C.GoBytes(unsafe.Pointer, C.int) []byte
```

* 其中`C.CString`针对输入的Go字符串，克隆一个C语言格式的字符串；返回的字符串由C语言的`malloc`函数分配，不使用时需要通过C语言的`free`函数释放。

* `C.CBytes`函数的功能和`C.CString`类似，用于从输入的Go语言字节切片克隆一个C语言版本的字节数组，同样返回的数组需要在合适的时候释放。

* `C.GoString`用于将从NULL结尾的C语言字符串克隆一个Go语言字符串。

* `C.GoStringN`是另一个字符数组克隆函数。

* `C.GoBytes`用于从C语言数组，克隆一个Go语言字节切片。

`CGO字符串转换原理`

该组辅助函数都是以克隆的方式运行。

当Go字符串和切片向C转换时，克隆的内存由C的`malloc`函数分配，最终可以通过`free`函数释放。

当C字符串或数组向Go转换时，克隆的内存由Go语言分配管理。

* 通过该组转换函数，转换前和转换后的内存依然在各自的语言环境中，它们并没有跨越Go和C。克隆方式实现转换的优点是接口和内存管理都很简单，缺点是克隆需要分配新的内存和复制操作都会导致额外的开销。

* 显示的使用以上的函数时，如果是Go->C的转换，需要注意在使用后调用C.free()来释放空间

`释放例子`

```go
/*
#include <stdlib.h>
*/
import "C"

func fun() {
  str := "Hello"
  cstr := C.CString(str)
  defer C.free(unsafe.Pointer(cstr))
}
```

## 指针类型的转换

> unsafe.Pointer类型

该类型相当于C中的 void*

* 任何类型的指针都可以通过强制转换为`unsafe.Pointer`指针类型去掉原有的类型信息，然后再重新赋予新的指针类型而达到指针间的转换的目的。

`使用方法`

```
var a int = 1
b:=unsafe.Pointer(&a)
```

> uintpitr类型

Go针对`unsafe.Pointr`指针类型特别定义了一个uintptr类型。可以让uintptr为中介，实现数值类型到`unsafe.Pointr`指针类型到转换，来实现数值和指针的转换。

`示例`

```go
package main

import (
    "fmt"
    "unsafe"
)

func main() {
    i := 10
    ip := &i // 获取 i 的地址
    fmt.Printf("ip: %p\n", ip)

    up := uintptr(unsafe.Pointer(ip)) // 将 *int 类型的指针转换为 uintptr
    fmt.Printf("up: %v\n", up)

    ip2 := (*int)(unsafe.Pointer(up)) // 将 uintptr 类型转换为 *int 类型的指针
    fmt.Printf("ip2: %p\n", ip2)
}
```

```go
//取出变量a第二个字节开始的两个字节数据
package main

import (
   "fmt"
   "unsafe"
)

func main() {
   var a uint32 = 0x12345678
   fmt.Printf("a: 0x%X\n", a)

   // 转换为指针类型
   p := unsafe.Pointer(&a)

   // 将指针类型转换为 uintptr 类型，进行加减操作
   p = unsafe.Pointer(uintptr(p) + 1)

   // 将指针类型转换为需要的类型，进行值操作
   b := *(*uint16)(p)
   fmt.Printf("b: 0x%X\n", b)
}

//output 
//a: 0x12345678
//b: 0x3456
```

## 结构体、枚举、共用体的调用

> 结构体

Go中，可以通过`C.struct_xxx`来访问C语言中定义的`struct xxx`结构体类型。

* C中的结构体、枚举、共用体通过`typedef`定义名称，在go中调用时直接可以使用`C.xxx`,否则，需要只能使用`C.struct_xxx`、`C.union_xxx`、`C.enum_xxx`来使用他们。

* 如果结构体、枚举、共用体的成员名字中碰巧是Go语言的关键字，可以通过在成员名开头添加下划线来访问。
* 结构体的内存布局按照C语言的通用对齐规则，在32位Go语言环境C语言结构体也按照32位对齐规则，在64位Go语言环境按照64位的对齐规则。对于指定了特殊对齐规则的结构体，无法在CGO中访问。

`访问实例`

```go
/*
struct A {
    int tmp;
};
*/
import "C"
import "fmt"

func main() {
    var a C.struct_A
    fmt.Println(a.tmp)
}


/*
struct A {
    int type; // type 是 Go 语言的关键字
    			//关键字名字的c成员变量 使用_+名字访问
    			//此处为_type
};
*/
import "C"
import "fmt"

func main() {
    var a C.struct_A
    fmt.Println(a._type) // _type 对应 type
}

//但是如果有2个成员：一个是以Go语言关键字命名，另一个刚好是以下划线和Go语言关键字命名，那么以Go语言关键字命名的成员将无法访问（被屏蔽）
/*
struct A {
    int   type;  // type 是 Go 语言的关键字
    float _type; // 将屏蔽CGO对 type 成员的访问
};
*/
import "C"
import "fmt"

func main() {
    var a C.struct_A
    fmt.Println(a._type) // _type 对应 float的 _type
}
```

`特别结构成员`

C语言结构体中位字段对应的成员无法在Go语言中访问，如果需要操作位字段成员，需要通过在C语言中定义辅助函数来完成。对应零长数组的成员，无法在Go中直接访问数组的元素，但其中零长的数组成员所在位置的偏移量依然可以通过`unsafe.Offsetof(a.arr)`来访问。

```go
/*
struct A {
    int   size: 10; // 位字段无法访问
    float arr[];    // 零长的数组也无法访问
};
*/
import "C"
import "fmt"

func main() {
    var a C.struct_A
    fmt.Println(a.size) // 错误: 位字段无法访问
    fmt.Println(a.arr)  // 错误: 零长的数组也无法访问
}
```

> 联合体

Go中并不支持C联合类型，它们会被转为对应大小的字节数组。

```go
/*
#include <stdint.h>

union B1 {
    int i;
    float f;
};

union B2 {
    int8_t i8;
    int64_t i64;
};
*/
import "C"
import "fmt"

func main() {
    var b1 C.union_B1;
    fmt.Printf("%T\n", b1) // [4]uint8

    var b2 C.union_B2;
    fmt.Printf("%T\n", b2) // [8]uint8
}
```

如果需要操作C语言的联合类型变量，一般有三种方法：

* 第一种是在C中定义辅助函数。
* 第二种是通过Go的"encoding/binary"手工解码成员(需要注意大端小端问题)。
* 第三种是使用`unsafe`包强制转型为对应类型(这是性能最好的方式)。下面展示通过`unsafe`包访问联合类型成员的方式：

```go
/*
#include <stdint.h>

union B {
    int i;
    float f;
};
*/
import "C"
import "fmt"

func main() {
    var b C.union_B;
    fmt.Println("b.i:", *(*C.int)(unsafe.Pointer(&b)))
    fmt.Println("b.f:", *(*C.float)(unsafe.Pointer(&b)))
}
```

虽然`unsafe`包访问最简单、性能也最好，但是对于有嵌套联合类型的情况处理会导致问题复杂化。对于复杂的联合类型，推荐通过在C语言中定义辅助函数的方式处理。

> 枚举

在C语言中，枚举类型底层对应`int`类型，支持负数类型的值。我们可以通过`C.ONE`、`C.TWO`等直接访问定义的枚举值。

`示例`

```go
/*
enum C {
    ONE,
    TWO,
};
*/
import "C"
import "fmt"

func main() {
    var c C.enum_C = C.TWO
    fmt.Println(c)
    fmt.Println(C.ONE)
    fmt.Println(C.TWO)
}
```


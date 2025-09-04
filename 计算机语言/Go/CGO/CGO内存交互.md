## CGO内存交互

`内存模型问题`

如果在CGO处理的跨语言函数调用时涉及到了指针的传递，则可能会出现Go和C/C++共享某一段内存的场景。C/C++的内存在分配之后就是稳定的，但Go语言因为函数栈的动态伸缩可能导致栈中内存地址的移动。

* 如果C/C++语言持有的是移动之前的Go栈上指针，那么以旧指针访问Go对象时会导致程序崩溃（因为go会扩充和缩栈）。

* C语言空间的内存是稳定的，只要不是被人为提前释放，那么在Go语言空间可以放心大胆地使用。

`Go访问C内存实例`

```go
//因为Go实现的限制，我们无法在Go中创建大于2GB内存的切片（具体请参考makeslice实现代码）。
//借助cgo，我们可以在C语言环境创建大于2GB的内存，然后转为Go语言的切片使用
package main

/*
#include <stdlib.h>

void* makeslice(size_t memsize) {
    return malloc(memsize);
}
*/
import "C"
import "unsafe"

func makeByteSlize(n int) []byte {
    p := C.makeslice(C.size_t(n))
    return ((*[1 << 31]byte)(p))[0:n:n]
}

func freeByteSlice(p []byte) {
    C.free(unsafe.Pointer(&p[0]))
}

func main() {
    s := makeByteSlize(1<<32+1)
    s[len(s)-1] = 255
    print(s[len(s)-1])
    freeByteSlice(s)
}
```

> C临时访问传入的Go内存

* CGO调用的C语言函数返回前，cgo保证传入的Go语言内存在此期间不会发生移动。
* C代码的长时间执行会导致被他引用的Go内存在C返回前不能被移动，从而间接导致Go内存栈对应的goroutine不能动态伸缩栈内存，导致这个goroutine被阻塞。在需要长时间运行的C函数（特别是在纯CPU运算之外，还可能因为需要等待其它的资源而需要不确定时间才能完成的函数），需要谨慎处理传入的Go语言内存。

`实例`

```go
package main

/*
#include<stdio.h>

void printString(const char* s, int n) {
    int i;
    for(i = 0; i < n; i++) {
        putchar(s[i]);
    }
    putchar('\n');
}
*/
import "C"

func printString(s string) {
    p := (*reflect.StringHeader)(unsafe.Pointer(&s))
  	//printString返回前，go保证调用 func printString 的goroutine不会动态伸缩栈内存
    C.printString((*C.char)(unsafe.Pointer(p.Data)), C.int(len(s)))
}

func main() {
    s := "hello"
    printString(s)
}
```

> GO使用指针的错误示例

```go
//uintptr 是 Go 语言中的一个无符号整数类型，其大小和指针的大小相同，
//在 32 位系统上为 32 位，在 64 位系统上为 64 位。
//uintptr 类型通常用于处理指针和内存地址
tmp := uintptr(unsafe.Pointer(&x)) 
-----部分操作
//上述操作过程中 可能发生该段代码所在的goroutine发生内存的动态伸缩
//但是tmp不为指针类型，所以tmp并不会随着栈的扩充而指向移动后的x
pb := (*int16)(unsafe.Pointer(tmp))
*pb = 42
```

> C调用GO的代码

```bash
GODEBUG=cgocheck=0
```

该参数用来制定是否检查CGO指针传递行为，默认为1，表示一个默认严格程度的检查，0表示关闭

* cgocheck是为了保证传入go指针给C/C++时，该指针的内存被go动态释放了的情况，通常情况下请避免传入go指针给C/C++。
* GO可以随意使用从C/C++中分配的内存，只需要注意使用完后释放即可，因为C/C++没有自动释放的垃圾回收机制。

`cgocheck=1报错实例`

```go
/*
extern int* getGoPtr();

static void Main() {
    int* p = getGoPtr();		//此处使用了GO的指针，如果cgocheck>=1 则会报错
    *p = 42;
}
*/
import "C"

func main() {
    C.Main()
}

//export getGoPtr
func getGoPtr() *C.int {
    return new(C.int)
}
```


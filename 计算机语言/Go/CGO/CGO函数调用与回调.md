## GO调用C

对于一个启用CGO特性的程序，CGO会构造一个虚拟的C包。通过这个虚拟的C包可以调用C语言函数。

```go
/*
static int add(int a, int b) {
    return a+b;
}
*/
import "C"

func main() {
    C.add(1, 1)
}
```

## C函数的返回值

对于有返回值的C函数，我们可以正常获取返回值。

```go
/*
static int div(int a, int b) {
    return a/b;
}
*/
import "C"
import "fmt"

func main() {
    v := C.div(6, 3)
    fmt.Println(v)
}
```



`错误返回类型`

C不支持返回多个结果，C中`<errno.h>`标准库提供了一个`errno`宏用于返回错误状态。我们可以近似地将`errno`看成一个线程安全的全局变量，可以用于记录最近一次错误的状态码。

CGO针对`<errno.h>`标准库的`errno`宏做的特殊支持：在CGO调用C函数时如果有两个返回值，那么第二个返回值将对应`errno`错误状态。

```go
/*
#include <errno.h>

static int div(int a, int b) {
    if(b == 0) {
        errno = EINVAL;
        return 0;
    }
    return a/b;
}
*/
import "C"
import "fmt"

func main() {
    v0, err0 := C.div(2, 1)
    fmt.Println(v0, err0)

    v1, err1 := C.div(1, 0)
    fmt.Println(v1, err1)
}
```

运行这个代码将会产生以下输出：

```
2 <nil>
0 invalid argument
```

我们可以近似地将div函数看作为以下类型的函数：

```go
func C.div(a, b C.int) (C.int, [error])
```

第二个返回值是可忽略的error接口类型，底层对应 `syscall.Errno` 错误类型。



`void函数返回值`

C语言函数还有一种没有返回值类型的函数，用void表示返回值类型。一般情况下，我们无法获取void类型函数的返回值，因为没有返回值可以获取。cgo对errno的特殊处理，对于void类型函数，依然有效。

以下的代码是获取没有返回值函数的错误状态码：

```go
//static void noreturn() {}
import "C"
import "fmt"

func main() {
    _, err := C.noreturn()
    fmt.Println(err)
}
```

也可以尝试获取void类型的返回值，它对应的是C语言的void对应的Go语言类型：

```go
//static void noreturn() {}
import "C"
import "fmt"

func main() {
    v, _ := C.noreturn()
    fmt.Printf("%#v", v)
}
```

运行这个代码将会产生以下输出：

```
main._Ctype_void{}
```

我们可以看出C语言的void类型对应的是当前的main包中的`_Ctype_void`类型。其实也将C语言的noreturn函数看作是返回`_Ctype_void`类型的函数，这样就可以直接获取void类型函数的返回值：

```go
//static void noreturn() {}
import "C"
import "fmt"

func main() {
    fmt.Println(C.noreturn())
}
```

运行这个代码将会产生以下输出：

```
[]
```

在CGO生成的代码中，`_Ctype_void`类型对应一个0长的数组类型`[0]byte`，因此`fmt.Println`输出的是一个表示空数值的方括弧。

以上有效特性虽然看似有些无聊，但是通过这些例子我们可以精确掌握CGO代码的边界，可以从更深层次的设计的角度来思考产生这些奇怪特性的原因。

## C调用Go导出函数

CGO允许将Go函数导出为C函数。

* 我们可以定义好C接口，然后通过Go语言实现，来完成C回调GO函数

```go
import "C"

//export add
func add(a, b C.int) C.int {
    return a+b
}
```

CGO生成的 `_cgo_export.h` 文件回包含导出后的C语言函数的声明。我们可以在纯C源文件中包含 `_cgo_export.h` 文件来引用导出的add函数。如果希望在当前的CGO文件中马上使用导出的C语言add函数，则无法引用 `_cgo_export.h` 文件。因为`_cgo_export.h` 文件的生成需要依赖当前文件可以正常构建，而如果当前文件内部循环依赖还未生成的`_cgo_export.h` 文件将会导致cgo命令错误。

* `_cgo_export.h` 文件，它会在每次运行 `go build` 命令时自动生成和更新，C在使用GO代码时不需要强制导入该文件
* CGO混合使用时，在C中调用GO需要使用extern声明下GO中的函数。

```c
//#include "_cgo_export.h"

extern int add(int a,int b);

void foo() {
    add(1, 1);
}
```

当导出C语言接口时，需要保证函数的参数和返回值类型都是C语言友好的类型，同时返回值不得直接或间接包含Go语言内存空间的指针。

`Go传入Go函数给C回调`

* Go代码

```go
func (cli *EventClient) SubscribeEvent() error {
  
	opa := (*C.opa_t)(C.malloc(C.opaSize()))
	opa.opaque = unsafe.Pointer(cli)
 	
  //调用C中函数传递回调
  //C.EventCallback为一个函数指针的类型
	ret := C.event_subscribe(cli.eventCtx, C.EventCallback(C.eventCgoCall), opa)
	if ret < 0 {
		return errors.New("event_subscribe error")
	}
	return nil
}

//export eventCgoCall
func eventCgoCall(p unsafe.Pointer, result *C.event_result_t) {
	client := (*EventClient)(p)
  //将结果给go代码操作
	client.Call(result)
}

func (cli *EventClient) Call(result *C.event_result_t) {
	//拿到C.event_result_t操作
}
```

* C代码

`.h代码`

```c
//a.h
#ifndef __EVENT_TRANSFER_H__
#define __EVENT_TRANSFER_H__

#ifdef __cplusplus
extern "C" {
#endif

typedef struct event_ctx_s event_ctx_t;
typedef struct event_result_s event_result_t;

//和回调函数一样的函数指针类型
typedef void (*EventCallback)(void *, event_result_t*);


struct event_ctx_s {
    EventCallback           eventCb;
    opa_t                   *cbParam;
};

struct event_result_s {
    BYTE    *data;
    DWORD   data_len;
    int     event_type;
};

int event_subscribe(event_ctx_t *ctx, EventCallback cb, opa_t *cbParam);

//声明Go的函数，但是实现在GO中
void eventCgoCall(void *p, event_result_t *result);

#ifdef __cplusplus
}
#endif

#endif
```

`.c代码`

```c
//a.c
#include "a.h"


int  CCallback(BYTE *pBuffer, DWORD dwBufSize, LDWORD dwUser)
{
    event_ctx_t *ctx;
    ctx = (event_ctx_t *)dwUser;

    event_result_t result;
    memset(&result, 0, sizeof(result));
    result.data = pBuffer;
    result.data_len = dwBufSize;
  	result.event_type = 6
      
    //调用CGO函数
    ctx->eventCb(ctx->cbParam->opaque, &result);
    return 0;
}



int event_subscribe(event_ctx_t *ctx, EventCallback cb, opa_t *cbParam) {
    ctx->eventCb = cb;
    ctx->cbParam = cbParam;
    return 0;
}


```


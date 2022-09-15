## log日志包

可以像使用 `fmt` 包一样使用此包。 该标准包不提供日志级别，且不允许为每个包配置单独的记录器。其为go自带的标准包。

## 常用方法

>  Print(string)

输出yyyy/mm/dd hh:mm:ss "msg" 格式的日志

```go
import (
    "log"
)

func main() {
    log.Print("Hey, I'm a log!")
}

//output
//2020/12/19 13:53:19  Hey, I'm an error log!
//exit status 1
```

> Fatal(string)

输出同log.Print的日志，并结束程序

```go
package main

import (
    "fmt"
    "log"
)

func main() {
    log.Fatal("Hey, I'm an error log!")
    fmt.Print("Can you see me?")
}

//output
//2020/12/19 13:53:19  Hey, I'm an error log!
//exit status 1
```

> SetPrefix(string)

设置log包后续所有的输出日志的前缀

```go
package main

import (
    "log"
)

func main() {
    log.SetPrefix("main(): ")
    log.Print("Hey, I'm a log!")
    log.Fatal("Hey, I'm an error log!")
}

//output
//main(): 2021/01/05 13:59:58 Hey, I'm a log!
//main(): 2021/01/05 13:59:58 Hey, I'm an error log!
//exit status 1
```
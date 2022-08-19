### 逻辑值
bool

### 字符串
string

### 有符号整形
int  int8  int16  int32  int64

### 无符号整形
uint uint8 uint16 uint32 uint64 uintptr


* int, uint 和 uintptr 在 32 位系统上通常为 32 位宽，在 64 位系统上则为 64 位宽。

## 浮点类型
float32 float64


## 复数类型
complex64  实部与虚部都是32位float

complex128  实部与虚部都是64位float


### 别名类型
rune // int32 的别名
    用来处理UT8或者Unicode编码

byte // uint8 的别名


## GO变量的默认值

GO变量的默认值都为空，没有明确初始值的变量声明会被赋予它们的 零值。

零值是：

    数值类型为 0，
    布尔类型为 false，
    字符串为 ""（空字符串）。


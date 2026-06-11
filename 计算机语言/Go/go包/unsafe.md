[toc]

## unsafe

Go 官方库里的一个**特殊包**，它绕过了 Go 类型安全系统，允许你直接操作底层内存。

> **简而言之：** unsafe 让 Go 变得“不安全”但能干“低层次”的事。

## unsafe 提供的核心功能

| 函数/类型                | 作用                                               |
| ------------------------ | -------------------------------------------------- |
| `unsafe.Pointer`         | 通用指针，允许任意类型指针互相转换                 |
| `unsafe.Sizeof(v)`       | 获取变量 v 占用的内存大小（字节数）                |
| `unsafe.Alignof(v)`      | 获取变量 v 的对齐值                                |
| `unsafe.Offsetof(field)` | 获取 struct 某个字段相对于 struct 起始位置的偏移量 |
| `uintptr`                | 与 unsafe.Pointer 可互转的整型，代表内存地址       |

## unsafe.Pointer

Go 普通指针不允许你随意类型转换，但 **unsafe.Pointer 可以**。

它可以把 `*int` 转成 `*float64`，也能转成 `uintptr`（地址数值），反过来也可以。

但是：一旦用错，程序直接异常退出，编译器不会帮你检查。

* unsafe.Pointer类似于C里面的void*

## **unsafe的使用时机**

- **内存对齐优化**（性能调优场景）
- **实现低层数据结构（如 mmap、共享内存）**
- **与 C 语言交互（CGO 层底层 hack）**
- **实现反射或动态类型系统底层逻辑**
- **写高性能序列化库（zero-copy 的 struct <-> []byte 转换）**
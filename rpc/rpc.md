## rpc

**Remote Procedure Call**（远程过程调用），核心是：

- 在本地像调用函数一样，实际上执行的是远程机器上的函数/方法。
- 关键点：**抽象掉网络细节，让远程调用像本地调用**。

RPC 框架通常需要：

- **接口定义**（IDL，比如 gRPC 的 proto 文件）
- **序列化/反序列化**（JSON、Protobuf、Thrift…）
- **传输协议**（TCP、HTTP/2、QUIC…）

## http和rpc的区别

RPC 是一种 **调用语义/模式**，是一个模型，其并不是一个协议。

http可以作为各种rpc中的底层协议来进行传输。


[toc]

## 版本定义

proto的常用版本为3，该笔记限定版本也是3

proto文件的开头需要声明版本号，此处开头如下

```protobuf
syntax = "proto3";
```

* 不加默认proto2

## 消息类型

```protobuf
syntax = "proto3";

message SearchRequest {
  string query = 1;
  int32 page_number = 2;
  int32 results_per_page = 3;
}
```

### 字段后的数字介绍

* 必须为1到536,870,911之间的数字
* 给定的数字在该消息的所有字段中必须是唯一的。
* 字段号19,000到19999是为协议缓冲区实现保留的。如果您在消息中使用这些保留字段号之一，proto编译器将报错。
* Protobuf 解析二进制数据时，只根据 **字段编号** 解析，而**不存储字段名**。若重复编号，序列化后的数据就无法正确解析。
* **1~15 使用 1 个字节存储**（Tag 编码优化），**16~2047 使用 2 个字节存储**（适用于较大的 `message`）。
* 这些编号这使得 **序列化** 和 **反序列化** 更高效。

### 字段后数字巧用

* 对于高频访问的字段，应尽量使用 **1~15 之间的编号**，这样可以减少存储开销。

* 编号可以跳过，这样做的好处是，未来可以在跳过编号处之间插入新字段，而不会影响已有数据

  * ```
    message Person {
      string name = 1;
      int32 age = 10;  // 跳过 2~9 号编号
    }
    ```

### 消息类型字段支持类型

1. 基本数据类型：bool、int32、int64、uint32、uint64、float、double、string、bytes (byte数组)。

2. 枚举类型：使用关键字enum定义。
3. 消息类型：使用关键字message定义。
4. Oneof类型：表示这些字段中只能有一个字段被设置了值，类似于C中的共用体。
5. Map类型：表示key-value映射关系的数据类型。
6. Any类型：表示任意类型的数据。
7. Duration类型：表示时间间隔。
8. Timestamp类型：表示时间戳。
9. 数组类型

### 举例

```protobuf
syntax = "proto3";

import "google/protobuf/any.proto";
import "google/protobuf/duration.proto";
import "google/protobuf/timestamp.proto";

// 枚举类型
enum Status {
    OK = 0;
    ERROR = 1;
}

// 消息类型
message InnerMessage {
    int32 inner_number = 1;
    string inner_name = 2;
}

// Oneof 类型
oneof value {
    string text = 12;
    int32 number_value = 13;
}

message ExampleMessage {
  // 基本数据类型
  bool flag = 1;
  int32 number = 2;
  int64 big_number = 3;
  uint32 unsigned_number = 4;
  uint64 unsigned_big_number = 5;
  float float_number = 6;
  double double_number = 7;
  string name = 8;
  bytes data = 9;
  
  Status status = 10;
 
  // Oneof 类型
  InnerMessage inner = 11;

  // Map 类型 不限于基本类型
  map<string, int32> name_to_id = 14;

  // Any 类型
  google.protobuf.Any any_data = 15;

  // Duration 类型
  google.protobuf.Duration duration_value = 16;

  // Timestamp 类型
  google.protobuf.Timestamp timestamp_value = 17;

  // 数组类型
  repeated int32 numbers_array = 18;
}
```





## import字段

proto支持使用import来使用其他proto文件中定义的类型，上述例子中导入了timestamp和duration与any类型



## reserved字段

reserved表示某些字段为保留字段。



下面例子，字段编号2/15/9/11曾经使用过，保留；字段名 foo/bar 曾经使用过，保留。请勿在后续中使用这些字段。

```protobuf
message Foo {
    reserved 2, 15, 9 to 11;
	reserved "foo", "bar";
}
```

* 如果一个字段不再需要，如果删除或者注释掉，则其他人在修改时会再次使用这些字段编号，那么旧的引用程序就可能出现一些错误，所以使用保留字段，保留已弃用的字段编号或字段名 ，可解决该问题



## required标记和optional标记

* required用于message内的字段中，表示该字段是必须的，在rpc调用时，必须不为空，否则报错
* optional用于message内的字段中，表示该字段是可选的，在rpc调用时，可以为空，否则报错，什么都不标记时默认是optional标记

```protobuf
message InnerMessage {
    required int32 inner_number = 1;
    optional string inner_name = 2;
    string inner_name2 = 3; //默认optional
}
```



## rpc定义

使用service字段来定义一个rpc接口

```protobuf
service <service_name> {
  rpc <func_name>(<request_message_name>) returns (response_message_name);
}
```

### 多个service和单个service的区别

实现上，每个service在常见的编程语言中，会被实现为一组接口(java中的interface，go中的interface，C++中的纯虚函数)等，并且对这些接口进行一个基础的实现，以方便开发者扩展。



## package关键字

**package**是proto的包名,一个文件就是一个package

```
syntax = "proto3";

package proto;	//声明包为proto
```





## option关键字

.proto文件中的个别声明可以被一定数据的选项(option)注解. 选项不改变声明的整体意义, 但是在特定上下文会影响它被处理的方式. 可用选项的完整列表定义在google/protobuf/descriptor.proto.

有些选项是文件级别, 意味着他们应该写在顶级范围, 而不是在任何消息,枚举,或者服务定义之内. 有些选项时消息级别, 意味着他们应该写在消息定义内. 有些选项是字段级别, 意味着他们应该写在字段定义内. 选项也可以写在枚举类型, 枚举值, 服务定义和服务方法上. 但是, 目前没有任何有用的选项存在这些地方.



这些选项使用option关键字来声明，一般不怎么使用，此处忽略。



使用例子：

```protobuf
syntax = "proto3";

package proto;	//声明包为proto

option go_package = "github.com/wymli/bc_sns/dep/pb/go/enumx;enumx";
//;分割开后 后面是就是生成go代码时，package名，前面的为该go代码包路径
//如果没有;只有前面的那一串，则同时表示包名和包路径两个意义

```



## stream

请求和响应中添加stream在grpc中将表示这次的请求体或响应体是流式传输

例:

```protobuf
syntax = "proto3";

package chat;

// 定义消息格式
message ChatMessage {
  string user = 1;      // 发送消息的用户
  string message = 2;   // 消息内容
  int64 timestamp = 3;  // 时间戳
}

message Empty {}

// 定义服务接口
service ChatService {
  
  // 单次请求/响应：客户端发送一条消息，服务器返回确认信息
  rpc SendMessage (ChatMessage) returns (Empty);

  // 服务器流：客户端请求消息历史记录，服务器流式返回所有聊天记录
  rpc GetMessageHistory (Empty) returns (stream ChatMessage);

  // 客户端流：客户端上传多条消息，服务器在结束后返回确认
  rpc SendMultipleMessages (stream ChatMessage) returns (Empty);

  // 双向流：客户端和服务器可以实时进行双向聊天
  rpc ChatStream (stream ChatMessage) returns (stream ChatMessage);
}
```


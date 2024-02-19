## 版本定义

proto的常用版本为3，该笔记限定版本也是3

proto文件的开头需要声明版本号，此处开头如下

```protobuf
syntax = "proto3";
```

* 不加默认proto

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



## rpc定义

使用service字段来定义一个rpc接口

```protobuf
service <service_name> {
  rpc <func_name>(<request_message_name>) returns (response_message_name);
}
```

### 多个service和单个service的区别

实现上，每个service在常见的编程语言中，会被实现为一组接口(java中的interface，go中的interface，C++中的纯虚函数)等，并且对这些接口进行一个基础的实现，以方便开发者扩展。
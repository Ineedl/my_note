kratos使用了http转发映射，他使用了google提供的protobuf文件

```protobuf
syntax = "proto3";

package helloworld.v1;

import "google/api/annotations.proto";

option go_package = "helloworld/api/helloworld/v1;v1";
option java_multiple_files = true;
option java_package = "dev.kratos.api.helloworld.v1";
option java_outer_classname = "HelloworldProtoV1";

service Greeter {
  rpc SayHello (HelloRequest) returns (HelloReply) {
  	//来将这个 gRPC 方法 SayHello 映射为一个 HTTP GET 请求。
    option (google.api.http) = {
      get: "/helloworld/{name}",
      post: "/v1/greeter/say_hello",
      body: "*"	// 将整个 HTTP 请求体映射到 HelloRequest 消息
    };
  }
}

// The request message containing the user's name.
message HelloRequest {
  string name = 1;
}

// The response message containing the greetings
message HelloReply {
  string message = 1;
}

```

**HTTP API** 是通过 protoc-gen-go-http 插件进行生成 http.Handler，然后可以注册到 HTTP Server 中：

```go
import "github.com/go-kratos/kratos/v2/transport/http"

greeter := &GreeterService{}
srv := http.NewServer(http.Address(":9000"))
v1.RegisterGreeterHTTPServer(srv, greeter)
```

**gRPC API** 是通过 protoc-gen-go-grpc 插件进行生成 gRPC Register，然后可以注册到 GRPC Server 中；

```go
import "github.com/go-kratos/kratos/v2/transport/grpc"

greeter := &GreeterService{}
srv := grpc.NewServer(grpc.Address(":9000"))
v1.RegisterGreeterServer(srv, greeter)
```


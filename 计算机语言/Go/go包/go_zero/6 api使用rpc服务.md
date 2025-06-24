## 位置

1. 在生成的文件中的internal/config/config.go中添加对应rpc配置

```go
package config

import (
	"github.com/zeromicro/go-zero/rest"
	"github.com/zeromicro/go-zero/zrpc"
)

type Config struct {
	rest.RestConf
	//新增 可以有多个 
	UserRpc zrpc.RpcClientConf
}

```

2. 在生成的文件中的internal/svc/servicecontext,go中完善rpc配置

```go
package svc

import (
	"go_test/gateway/api/internal/config"
	"go_test/user/rpc/userserver"

	"github.com/zeromicro/go-zero/zrpc"
)

type ServiceContext struct {
	Config  config.Config
  
  //可以有多个配置 但是都要初始化
  //对应rpc服务 tpyes目录下的grpc接口
	UserRpc userserver.UserServer
}

func NewServiceContext(c config.Config) *ServiceContext {
	return &ServiceContext{
		Config:  c,
    
    //可以有多个配置 但是都要初始化
		UserRpc: userserver.NewUserServer(zrpc.MustNewClient(c.UserRpc)),
	}
}
```

3. 在api服务的logic目录下的逻辑实现中，就可以使用该rpc服务了

```go
func (l *AddUserLogic) AddUser(req *types.AddUserRequest) (resp *types.GeneralResponse, err error) {
	// todo: add your logic here and delete this line
	resp.Code = 200
	resp.Msg = "success"
	_, rpcErr := l.svcCtx.UserRpc.UserInsert(context.Background(), &user.UserInsertReq{
		UserName: req.Username,
		Password: req.Password,
		Content:  req.Username + "_" + req.Password,
	})
	err = rpcErr
	if err != nil {
		resp.Code = 500
		return
	}
	return
}
```

4. 在api的配置文件中，新增对应rpc的服务。

```yaml
Name: Gateway
Host: 0.0.0.0
Port: 8888

UserRpc:		#注意和配置名字对应
  Etcd:
    Hosts:
      - 127.0.0.1:2379
    Key: user.rpc
```


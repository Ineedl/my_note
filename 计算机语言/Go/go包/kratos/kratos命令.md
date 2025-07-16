[toc]

## 项目生成

```bash
kratos new helloworld

kratos new app/user --nomod
```

* --nomod：添加服务，但是公用go.mod，适合添加子模块

## 接口生成

```bash
# 生成 proto 模板
kratos proto add api/helloworld/v1/greeter.proto
# 生成 client 源码
kratos proto client api/helloworld/v1/greeter.proto
# 生成 server 源码
kratos proto server api/helloworld/v1/greeter.proto -t internal/service
```


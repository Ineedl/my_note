## Go.mod介绍

Go.mod为Golang1.11版本新引入的官方包管理工具。

Go.mod相当于c++中的cmake与java中的maven，但是为go自带的

Go.mod的使用必须要在GOPATH/src目录之外



## GO111MODULE变量

GO111MODULE为go自带的一个环境变量，它决定了go命令行是否支持module功能。

GO111MODULE有三个值：off, on和auto（默认值）。

* on：go命令行会使用modules，而一点也不会去GOPATH目录下查找。
* off：go命令行将不会支持module功能，寻找依赖包的方式将会沿用旧版本那种通过vendor目录或者GOPATH模式来查找。
* auto :默认模式，当项目路径在 GOPATH 目录外部时， 设置为 GO111MODULE = on 当项目路径位于 GOPATH 内部时，即使存在 go.mod, 设置为 GO111MODULE = off



## Go.mod命令

> 初始化模块

```go
go mod init + 模块名称
```

运行完之后，会在当前目录下生成一个go.mod文件,之后的包的管理都是通过该文件管理。

除了go.mod之外，go命令还维护一个名为go.sum的文件，其中包含特定模块版本内容的预期加密哈希。 

go命令使用go.sum文件确保这些模块的未来下载检索与第一次下载相同的位，以确保项目所依赖的模块不会出现意外更改，无论是出于恶意、意外还是其他原因。 go.mod和go.sum都应检入版本控制。 

go.sum 不需要手工维护，所以可以不用太关注。

> go.mod命令管理

go.mod文件中提供了module, require、replace和exclude 四个命令来进行包管理

- `module` 语句指定包的名字（路径）
- `require` 语句指定的依赖项模块
- `replace` 语句可以替换依赖项模块
- `exclude` 语句可以忽略依赖项模块

> 安装package

go run 运行代码时， go mod 会自动查找依赖自动下载

> 拉取最新依赖

```go
go get [-u] package[@version] //将会升级到指定的版本号version
```

* -u表示会更新在本地的制定包，如果不加-u，当本地存在该包时，什么都不会做。

* go get后会自动在go.mod中添加对应的require。

> 清理go.mod

```go
go mod tidy
```

改名了会删除未使用的模块依赖，并且添加需要用但是go.mod没有的模块
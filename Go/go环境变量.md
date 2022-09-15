## go环境变量

go环境变量同linux环境变量，但go环境变量只能用go env查看且供go使用

## go常用环境变量

* GO111MODULE：go1.11后才有，决定了go命令行对module功能的行为。
* GOPROXY：第三方依赖包下载源地址
* GOSUMDB：下载的模块数据校验地址，是一个服务器，如果不希望校验，可设置成off。
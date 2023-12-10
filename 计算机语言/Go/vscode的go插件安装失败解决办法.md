先在终端输入(要有go环境)

```bash
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.io,direct
```

再重启viscose，在插件提醒时选择install all
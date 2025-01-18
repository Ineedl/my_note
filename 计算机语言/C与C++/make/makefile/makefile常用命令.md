## .PHONY
声明一些命令并不是文件名

`实例`
```
# 声明all与clean为make命令 而不是文件名
# 而不会在make clean时去寻找clean作为makefile

.PHONY:all clean
```
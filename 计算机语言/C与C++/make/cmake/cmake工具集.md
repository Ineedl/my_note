## cmake -E

`cmake -E` 是一个 cmake 的子命令，它提供了一组有用的工具命令，可在 cmake 脚本中执行各种常见的系统操作，例如文件操作、目录操作、环境变量操作、打包压缩等等。

* `cmake -E` 子命令是 cmake 的一个独立部分，可以在不使用 cmake 构建系统的情况下单独使用。

> 其中常用工具命令

```bash
#创建一个名为 dir 的新目录。
cmake -E make_directory dir 

#删除名为 file 的文件。
cmake -E remove file

#删除名为 dir 的目录及其所有内容。
cmake -E remove_directory dir 

#将名为 source 的文件复制到名为 destination 的位置。
cmake -E copy source destination 

#将名为 source 的目录及其所有内容复制到名为 destination 的位置。
cmake -E copy_directory source destination

#将名为 oldname 的文件或目录重命名为 newname。
cmake -E rename oldname newname 

#将名为 `file1`、`file2` 等文件打包为 archive.tar.gz 文件。
cmake -E tar czf archive.tar.gz file1 file2 ... 

#设置一个名为 VAR 的环境变量，并在环境变量设置的基础上运行一个命令。
cmake -E env VAR=VALUE command arg1 arg2 ... 

#在名为 destination 的位置创建一个名为 source 的符号链接。
cmake -E create_symlink source destination 
```


## hostPath

pod中单个容器与主机共享目录或文件

```yaml
apiVersion: v1
kind: Pod
metadata:
	...
spec:
	containers:
	......
	- image: ...
      volumeMounts:
      - name: volume_name    #挂载volumes中哪个数据卷
        mountPath: "/home/test" #将数据卷中的文件加载到哪个目录下
        readOnly: true #只读
        subPath: <file_path> #
	volumes:
	  - name: volume_name	#数据卷名称
	    hostPath:
	      path: /data #主机目录
	      type: DirectoryOrCreate #检查类型，挂载前对挂载目录做什么检查，默认为空，即不做任何检查
...
```

### hostPath可用类型

| 取值              | 行为                                                         |
| ----------------- | ------------------------------------------------------------ |
| 空                | 不做任何检查                                                 |
| DirectoryOrCreate | 如果主机给定的路径上什么都不存在，则以0755权限创建空目录，具有与kubelet相同的组和权限 |
| Directory         | 主机给定路径必须为目录                                       |
| FileOrCreate      | 如果主机给定的路径上什么都不存在，则以0644权限创建空文件，具有与kubelet相同的组和权限 |
| File              | 主机给定路径必须为文件                                       |
| Socket            | 主机给定路径必须为unix套接字文件                             |
| CharDevice        | 主机给定路径必须为字符设备文件                               |
| BlockDevice       | 主机给定路径必须为块设备文件                                 |

## EmptyPath

用于一个pod中，不同容器共享目录

```yaml
apiVersion: v1
kind: Pod
metadata:
	...
spec:
	containers:
	......
	- image: ...
	  name: co1
      volumeMounts:
      - name: volume_name    #挂载volumes中哪个数据卷
        mountPath: "/home/test1" #将数据卷中的文件加载到哪个目录下
        readOnly: true #只读
    - image: ...
      name: co2
      volumeMounts:
      - name: volume_name    #挂载volumes中哪个数据卷
        mountPath: "/home/test2" #将数据卷中的文件加载到哪个目录下
        readOnly: true #只读
	volumes:
	  - name: volume_name	#数据卷名称
	    emptyDir: {}
...
```

上述配置将co1和co2的两个指定目录共享了，即co1的/home/test1和co2的/home/test2中的内容共享。
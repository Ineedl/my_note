[toc]

## 介绍

存储的非加密健值对

* 当以文件的形式生成configMap时，configMap会以文件名作为key，文件内容作为v。
* 以文件的形式使用configMap和以键值对的方式使用configMap其实原理相同，只是文件方式是将文件名(或创建时别名)作为key，文件内容作为v

## 创建

```bash
#文件格式
<key>=value
<key>: value
host=192.168.1.1
port=30

host2: 192.168.1.2
port: 30

#用文件夹/文件创建
kubectl create configmap <configmap_name> --from-file=[alias_name=]<dir_path/file_path>

#k/v形式创建
kubectl create configmap <configmap_name> --from-literal=<k>=<v> --from-literal=<k2>=<v2> ...
```

## pod中configMap的引用

### 直接引用

```yaml
apiVersion: v1
kind: Pod
metadata:
	...
spec:
	containers:
	......
	env:
	  -name: <key_name>
	   valueFrom:
	   	 configMapKeyRef:
	   	   name: <configMap_name>
	   	   key: <ref_key_name>
	  -name: <key_name>
	   valueFrom:
	   	 configMapKeyRef:
	   	   name: <configMap_name>
	   	   key: <ref_key_name>
	  ...
```

### 使用文件加载 

```yaml
apiVersion: v1
kind: Pod
metadata:
	...
spec:
	containers:
	......
	env:
	  volumeMounts:
	  - name: db-config    #加载哪个数据卷
	    mountPath: "/home/test" #将数据卷中的文件加载到哪个目录下
	    readOnly: true #只读
 	...
	volumes:
	  - name: db-config
	    configMap:
	      name: <configMap_name>
	      items: #对config中的key进行映射，如果不指定，则会将configmap中所有的key全部转换为对应的同名文件
	      - key: <file_name> #configMap中的key，就是describe时显示的文件名
	        path: <file_path>
...
```

* 上述操作会将configMap中的数据以文件的方式加载到pod中

* 上述items，如果只定义了部分configMap中的文件的key，则只会加载部分key，如果没有定义item，则会加载所有的文件的key。
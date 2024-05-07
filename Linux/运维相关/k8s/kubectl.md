[toc]

## 介绍

kubectl为k8s操作命令，他能对k8s集群做许多的操作。

## 对象的创建

```创建命令
kubectl create -f <yaml_file> #使用yaml文件创建对象
```



[官方教程与清单](https://v1-26.docs.kubernetes.io/zh-cn/docs/tasks/configure-pod-container/)

### k8s资源清单(常用)

#### 必需字段

| 参数名                   | 字段类型 | 说明                                                         |
| :----------------------- | :------- | :----------------------------------------------------------- |
| apiVersion               | String   | 这里是指的k8s API 的版本，目前基本是v1，可以 用kubectl api-version命令查询 |
| kind                     | String   | 这里指的是yam文件定义的资源类型和角色，比如：Pod、Deployment、RS、RC |
| metadata                 | Object   | 元数据对象，固定值就写 metadata                              |
| metadata.name            | String   | 元数据对象的名字，这里由我们编写，比如如名POd的名字          |
| metadata namespace       | String   | 元数据对象的命名空间，由我们自身定义                         |
| spec                     | Object   | 详细定义对象，固定值就写Spec                                 |
| spec containers[]        | list     | 这里是Spec对象的容器列表定义，是个列表                       |
| spec containers[].name   | String   | 这里定义容器的名字                                           |
| spec containers[]. image | String   | 这里定义要用到的镜像名称                                     |

#### 主要字段

| 参数名                                        | 字段类型 | 说明                                                         |
| :-------------------------------------------- | :------- | :----------------------------------------------------------- |
| spec containers[]. name                       | String   | 定义容器的名字                                               |
| spec containers[]. image                      | String   | 定义要用到的镜像名称                                         |
| spec containers[]. imagePullPolicy            | String   | 走义镜像拉取策路，有 Always、 NeverIfNotPresent三个值可选（1) Always：意思是每次都芸试重新拉取镜像（2) Never：表示仅使用本地镜像（3) IfNotPresent：如果本地有镜像就使用本地镜像，没有就拉取在线镜像。上面三个值都没设置的话，默认是 Always。 |
| spec containers[]. command[]                  | list     | 指走容器启动命令，因为是数组可以指定多个，不指定则使用镜像打包时使用的启动命令。 |
| spec containers[]. args[]                     | list     | 指定容器启动命令参数，因为是数组可以指定多个。               |
| spec containers[]. workingDir                 | String   | 指定容器的工作目录                                           |
| spec containers[]. volumeMounts[]             | list     | 指定容器内部的存储卷配置                                     |
| spec containers[]. volumeMounts[].name        | String   | 指定可以被容器挂载的存储卷的名称                             |
| spec containers[]. volumeMounts[].mountrPath  | String   | 指定可以被容挂载的存储芢的路径                               |
| spec containers[]. volumeMounts[].readOnly    | String   | 设置存储卷路径的读写模式，ture或者 false,认为读写模式        |
| spec containers[]. ports[]                    | list     | 指走容器需要用到的满口列表                                   |
| spec containers[].ports[]. name               | String   | 指定端口名称                                                 |
| spec containers[].ports[]. containerPort      | String   | 指定容器需要监听的端口号                                     |
| spec containers[]. ports[]. hostPort          | String   | 首定容器所在主机需要监听的端口号，默认跟上面 containerPort相同，注意设置了 hostPort同一台主机无法启动该容器的相同副本（因为主机的端口号不能相同，这样会冲突) |
| spec containers[]. ports[]. protocol          | String   | 指定端口协议，支持TCP和UDP，认值为TCP                        |
| spec containers[]. env[]                      | list     | 指定容器运行前需设置的环境变量列表                           |
| spec containers[].env[]. name                 | String   | 指定环境变量名称                                             |
| spec containers[].env[] value                 | String   | 指走环境变量值                                               |
| spec containers[]. resources                  | Object   | 指定资源限制和源请求的值（这里开始就是设置容器的资源上限)    |
| spec containers[]. resources.limits           | Object   | 指定设置容器运行时资源的运行上限                             |
| spec containers[]. resources.limits. cpu      | String   | 指定CPU的限制，单位为core数，将用于docker run-cpu- shares参数（这里前面文章Pod资源限制有讲过） |
| spec containers[].resources.limits. memory    | String   | 指定MEM内存的限制，单位为MIB、GiB                            |
| spec containers[]. resources. requests        | Object   | 指定容器启动和调度时的最小限制设置                           |
| spec containers[]. resources. requests. cpu   | String   | CPU请求，单位为core数，容器启动时初始化可用数量              |
| spec containers[]. resources. requests memory | String   | 内存请求，单位为MIB、GiB，容器启动的初始化可用数量           |

#### 额外参数

| 参数名                 | 字段类型 | 说明                                                         |
| :--------------------- | :------- | :----------------------------------------------------------- |
| spec. restartPolicy    | String   | 定义Pod的重启策路，可选值为 Alays、 Onfailure，默认值为Always。1 Always:Pod-且终止运行，则无论容器是如何终止的， kubelet服务都将重启它。2. failure：只有Pod以非零退出码终止时， kubeletオ会重启该容器。如果容器正常结束（退出码为0),则 kubelet将不会重启它3. Never:Pod终止后， kubelet将退出码报告给 Master，不会重启该Pod |
| spec. nodeSelector     | Object   | 定义Node的Labe过滤标签，以 key: value格式指定                |
| spec. imagePullSecrets | Object   | 定义pu像时便用 secrets名称，以 name secretkey格式指定        |
| spec.hostNetwork       | Boolean  | 定义是否使用主机网络模式，默认值为 false。设置true表示使用宿主机网络，不使用 docker网桥，同时设置了tue将无法在同一台宿主机上启动第二个副本。 |

```
//pod创建实例的yaml

apiVersion: v1
kind: Pod
metadata:
  labels:       #定义pod的标签 可以随意自定义
    type:       app
    version: 1.1.0
  name: nginx-demo
  namespace: default
spec:
  containers:
  - name: nginx
    image: nginx:1.7.9
    imagePullPolicy: IfNotPresent
    command:
    - nginx
    - -g
    - 'daemon off;'
    workingDir: /usr/shar/nginx/html
    ports:
    - name: http
      containerPort: 80
      protocol: TCP
    env:
    - name: CJH
      value: '666666666666'
    resources:
      requests:
        cpu: 100m
        memory: 128Mi
      limits:
        cpu: 200m
        memory: 256Mi
  restartPolicy: OnFailure
```



## 资源的获取

```
kubectl get pods 
			-n	<namespace_name> #某命名空间里的pods
			-A #全部pods
			-o wide #详细信息


kubectl get nodes
kubectl get deploy
kubectl get services
```

## 资源的删除

```
kubectl delete deploy <deploy_name>
kubectl delete svc <svr_name>
```

## pod详情

```
kubectl describe po <po_name>
```


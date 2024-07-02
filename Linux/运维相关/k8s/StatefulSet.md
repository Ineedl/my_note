[toc]

## 参考yaml

* 该yaml同时创建了一个service

```
---			#包含service的yaml配置
kind: Service
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  ports:
  - port: 80
    name: web
  clusterIP: None
  selector:
    app: nginx
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: "nginx" #使用哪个service来管理dns
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports: #容器内暴露的端口
        - containerPort: 80 # 具体端口
          name: web   #该端口配置的名字
          
          
 #--------以下配置没有存储卷可以不用写 直接使用默认的
        volumeMounts: #加载数据卷
        - name: www   #指定加载那个数据卷
          mountPath: /usr/share/nginx/html #加载到容器中的哪个目录
  volumeClaimTemplates: # 数据卷模板
  - metadata: # 数据卷描述
      name: www #数据卷名称
      annotations:  # 数据卷注解
        volume.alpha.kubernetes.io/storage-class: anything
    spec: #数据卷的规约
      accessModes: ["ReadWriteOnce"] #访问模式
      resources:
        requests:
          storage: 1Gi

```

## StatefulSet中dns格式

```bash
statefulSetName-{0~N-1}.serviceName.namespace.svc.cluster.local

#serverName: headless Service的名字
#0~N-1：pod所在序号，从0开始
#statefulSetName：StatefulSet的名字
#namespace：服务所在的namespace。Headless Service和StatefulSet必需在相同的namespace
#cluster.local：为本地集群的域名
```

## 扩容缩容

```bash
kubectl scale statefulset <statefulset_name> --replicas=<副本数量>
```

## 更新

修改stateful运行配置的yaml中的镜像的版本后，stateful将会开始更新

* 在更新过程中，如果再次进行了更新操作，那么将会把上次未更新完所创建的东西(比如rs，pod)与操作，全部删除。
* 不只是镜像版本号的修改，资源的使用情况修改也算作更新。

### 常用命令

```bash
kubectl rollout status sts nginx-sts #查看deploy更新相关状态(更新/回滚等都可以查看)


kubectl rollout history sts nginx-sts #查看历史版本
																			--revision=<REVISION> #查看该版本详细信息
																			
kubectl rollout undo sts nginx-sts --to-revision=<REVISION> #回滚版本到REVISION


kubectl rollout pause sts <deploy_name> #暂停更新，更新暂停后修改deploy的信息不回导致更新

kubectl rollout resume sts <deploy_name> #恢复更新
```

### 滚动更新

#### 原理

StatefullSet进行滚动更新时，会逐步的、一个个的关闭原有的旧版本pod，并启动新版本pod，(关闭一个、开一个)。
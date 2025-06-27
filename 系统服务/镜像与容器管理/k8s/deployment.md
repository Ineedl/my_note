[toc]

## 有状态应用的管理

deploy包装rs来管理pod

## 常用命令

```bash
kubectl create deploy <deploy_name> -image=<要创建的镜像名称> #创建

kubectl get deploy <deploy_name> -o yaml #查看创建的yaml

kubectl edit deploy <deploy_name> # 修改运行中deploy的yaml
```

## 简单版yaml配置(删除大部分不太重要后的配置)

```
apiVersion: apps/v1		#deployment api 版本
kind: Deployment		#资源类型 为deployment
metadata:						#元信息
  labels:						#deploy的标签
    app: nginx-deploy	
  name: nginx-deploy	#deploy的名字
  namespace: default	#所在的命名空间
spec:
  replicas: 1 				#期望副本数
  revisionHistoryLimit: 10		#滚动更新后保留的最大历史版本数，如果为0 则相当于不允许deployment回退，没有任何历史版本
  selector:										#匹配器 用来匹配管理的pod
    matchLabels:							#用标签匹配对应的pod
      app: nginx-deploy
  strategy:										#更新策略	
    rollingUpdate:						#滚动更新配置
      maxSurge: 25%						#滚动更新时 更新超过多少比例算成功
      maxUnavailable: 25%			#滚动更新时 最大不可用比例 所有副本数中 最多有多少个不更新成功
    type: RollingUpdate				#更新类型 采用滚动更新
  
  template:										#pod模板
    metadata:
      labels:
        app: nginx-deploy
    spec:
      containers:
      - image: nginx:latest
        imagePullPolicy: IfNotPresent				#镜像拉取策略 如果不存在 就拉取
        name: nginx
      restartPolicy: Always									#重启策略
      terminationGracePeriodSeconds: 30			#pod删除时 删除时间
```

## deploy中容器和rs的命名规则

```
<deploy-name>-<rs_id>-<pod_id>
```

## 更新

修改deploy运行配置的yaml中的镜像的版本后，delploy将会开始更新

* 在更新过程中，如果再次进行了更新操作，那么将会把上次未更新完所创建的东西(比如rs，pod)与操作，全部删除。
* 不只是镜像版本号的修改，资源的使用情况修改也算作更新。

### 常用命令

```bash
kubectl rollout status deploy nginx-deploy #查看deploy更新相关状态(更新/回滚等都可以查看)


kubectl rollout history deploy nginx-deploy #查看历史版本
																			--revision=<REVISION> #查看该版本详细信息
																			
kubectl rollout undo deploy nginx-deploy --to-revision=<REVISION> #回滚版本到REVISION


kubectl rollout pause deploy <deploy_name> #暂停更新，更新暂停后修改deploy的信息不回导致更新

kubectl rollout resume deploy <deploy_name> #恢复更新
```

### 滚动更新

#### 原理

deploy进行滚动时，会先创建一个新的rs，然后逐步的、一个个的关闭原有rs中的旧版本pod，并在新的rs中启动新版本pod，(关闭一个、开一个)，更新完毕后就替换旧的rs为新的rs

## 对deploy的扩容缩容

* 通常不指定情况下 扩容和缩容的目标都是pod

````
kubectl scale --replicas=<副本数量> deploy nginx-deploy
````

## deploy删除顺序

deploy删除后 会删除对应的rs和pod，但是删除pod不会影响deploy和rs，从上到是全删，从下到上不影响上面。
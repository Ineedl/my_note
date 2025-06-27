[toc]

## 介绍

service负责pod内每个pod互相的网络(内部代理)，但是有时，service也可以将pod内部网络映射出去。

## 常用命令

```
kubectl create -f <svc_yaml_name> #通过yaml创建

kubectl get svc
```



### pause容器

每个pod中都存在用于管理pod的资源以及网络等重要资源。

### service的原理

每个service都会对应一个endpoint，service会在endpoint中管理容器的IP。

* 使用顺序为service找endpoint，然后endpoint会使用一个映射表找kube-proxy，kube-proxy则会去找pod中对应的pause容器。

### yaml配置

```yaml
## service
apiVersion: v1
kind: Service
metadata:
	name: nginx_svc
	labels:
		app: nginx
spec:
	selector:
		app: nginx-deploy #根据label 匹配pod
	ports:
	- port: 80			#service自己端口
	  targePort: 80	#目标pod端口
	  name: web			#端口名字
	  nodePort: 32000 #指定node的端口
	  protocol: tcp #端口类型
	 type: NodePort #
	 
	 
## endpoints
apiVersion: v1
kind: Endpoints
metadata:
	labels:
		app: nginx  ##用于被service 匹配
	name: nginx-svc—external
	namespace: default
subsets:
- addresses:
	- ip: 111.111.111.111 #通过service访问映射端口时，映射端口对应的ip地址
	ports:
	- name: http          #用于匹配service中port的名字
		port: 80
		protocol: TCP
		
## 上述两个配置，service使用CListerIP时，可以将外部地址用ip的方式映射进来。
```

* 不指定selector时，不会创建endpoint。

### type类型(常用)

#### NodePort (适用于调试)

随机启动一个端口射，映射到ports中的端口，该端口是直接绑定到node上(有默认范围 30000 -32767)，集群中每个node都会绑定这个端口。每个node都可以用该随机端口访问对应ports中目标pod端口。该类型可以将服务暴露给外部，但是该方式效率较低，不影响使用。底层实现为轮训，效率为O(n)。

可以使用nodePort来固定该ip。

* 端口范围可以通过kubectl的systemd的配置文件kube-apiserver.service文件修改。

```
spec:
  ports:
    - port: 80			#service自己端口
      targePort: 80	#目标pod端口
      name: web			#端口名字
      nodePort: 32000 #指定node的端口 ,多个pod时，访问nodePort会出发负载均衡，访问的具体pod不确定
      protocol: tcp #端口类型
     type: NodePort 
```

#### ClisterIP

```
spec:
  ports:
    - port: 80			#service自己端口
      targePort: 80	#目标pod端口
      name: web			#端口名字
      protocol: tcp #端口类型
     type: ClisterIP
```



* 默认类型
* 该方式配合手动创建endpoint可以用于将外部服务映射进node。

只在本集群内映射，该类型会在集群内部创建一个虚拟IP地址，该服务只能在集群内部访问。

#### ExternalName

```
spec:
	type: ExternalName
	externalName: www.baidu.com
```

将Service映射到域名，内部服务访问service映射的port时，将会直接跳转到域名

#### LoadBalancer

使用云服务商的外部负载均衡器，将流量分发到NodePort和ClusterIP
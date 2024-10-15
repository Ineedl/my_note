## 作用

能更方便的在多台计算机上统一的管理容器

## 组件与分层架构介绍

#### 控制面板组件(master节点上)

* etcd
* kube-apiserver
* kube-controller-manager
* cloud-controller-manager
* kube-scheduler

#### 节点组件(从节点上)

* kubelet
* kube-proxy
* container runtime

#### 附加组件

* Ingress Controller
* Heapster
* Dashboard
* Federation
* Fluentd-elasticsearch

### 分层架构

* 生态系统
* 接口层
* 管理层
* 应用层
* 核心层


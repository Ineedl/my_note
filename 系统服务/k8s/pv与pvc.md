## PV(持久卷)

拥有独立于pod外的生命周期，用于提供pod的存储，pod不关心pv背后的实现，无论pv的卷是本地的还是nfs服务的还是其他的。

* pv相当于所有存储的统一规范的实现
* pv被pod绑定时，pv无法被删除



### PV的创建

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv0001  #pv名字
spec:
  capacity:
    storage: 5Gi #pv需求存储量
  volumeMode: Filesystem #Filesystem:存储类型为文件系统 Block:作为块设备挂载
  accessModes:
    - ReadWriteOnce     #可以取值,ReadWriteOnce:只能被该pod读写   ReadWriteMany:可以被所有使用pod读写  ReadOnlyMany:只能被该pod读取
  persistentVolumeReclaimPolicy: Recycle #回收策略 Recycle:pv被回收后保留其中数据  Delete:被回收后删除其中数据，清理存储卷 Retain:只清除卷中数据
  storageClassName: slow #创建的PV存储类型，PVC使用该PV时，该值必须一致
  mountOptions:
    - hard # NFS 挂载选项，指定在 NFS 服务器不可用时，客户端将会持续尝试重新连接。
    - nfsvers=4.1 #指定nfs版本
  nfs:
    path: /home/jiahui/nfs/rw/test-pv
    server: 192.168.1.39

```

* Recycle和Delete的区别
  Recycle：数据被清除，存储卷可以被重新利用。适合需要重复使用同一个存储资源的情况（例如本地存储、NFS）。
  Delete：存储卷及其底层资源被彻底删除，适合不再需要存储资源的场景（例如云存储卷）。

*  storageClassName为动态构建时，sc中自定义用于给PVC绑定，或是静态创建时自己指定。
* mountOptions对于不同的卷类型有不同的设置
* PV没有namespace的概念

### PV的获取

```bash
kubectl get pv
```

### PV的状态

Available：空闲

Bound：已被PVC绑定

Released：PVC被删除，资源已回收，目前没有被使用

Failed：自动回收失败



## PVC(PV控制者)

用于选择PV供给pod使用，可以配置需要的存储大小，存储周期，清理逻辑等。



### PVC的创建

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nfs-pvc
spec:
  accessModes:
    - ReadWriteMany #需要与匹配的PV相同
  volumeMode: Filesystem
  resources:
    requests:
      storage: 8Gi #可以小于请求的PV 但是绝对不能大于
  storageClassName: slow #如果没有现成的满足条件的PV 那么将会去请求动态创建PV
  #selector:
  #  matchLabels:
  #    release: "stable"
  #  matchExpressions:
  #    - {key: environment, operator: In,values: [dev]}
```

* PVC可以用selector+label来精确的指定PV



### pod中绑定PVC

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pd1
spec:
  containers:
  - image: swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/nginx:1.27.0
    name: test-container
    volumeMounts:
    - mountPath: /usr/share/nginx/html
      name: test-volume
  volumes:
  - name: test-volume
    persistentVolumeClaim: #关联pvc
      claimName: nfs-pvc #关联到哪个pvc
```

## 静态构建

手动编写PV来给PVC匹配实现给容器分配存储



## 动态构建

根据一定规则，自动生成PV来给PVC分配给容器存储。
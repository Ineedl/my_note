## StorageClass

sc的用处是批量的创建PV供PVC使用，以防止大批量的手动创建PV

* pvc指定sc，当pvc绑定pv时，如果指定sc可用且存在，sc将动态创建pv给pvc绑定



## StorageClass的创建

sc的创建需要以下几个东西

* 制备器
* RBAC配置：sc和权限有关，所以必须要RBAC
* sc配置

## 制备器

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nfs-client-provisioner
  namespace: kube-system
  labels:
    app: nfs-client-provisioner
spec:
  replicas: 1
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: nfs-client-provisioner
  template:
    metadata:
      labels:
        app: nfs-client-provisioner
    spec:
      serviceAccountName: nfs-client-provisioner
      containers:
        - name: nfs-client-provisioner
          image: swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/gmoney23/nfs-client-provisioner:latest
          volumeMounts:
            - name: nfs-client-root
              mountPath: /persistentvolumes
          env:
            - name: PROVISIONER_NAME
              value: fuseim.pri/ifs
            - name: NFS_SERVER
              value: 192.168.1.39
            - name: NFS_PATH
              value: /home/jiahui/nfs/rw
      volumes:
        - name: nfs-client-root
          nfs:
            server: 192.168.113.121
            path: /data/nfs/rw
```

### RBAC

```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: nfs-client-provisioner
  namespace: kube-system
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: nfs-client-provisioner-runner
  namespace: kube-system
rules:
  - apiGroups: [""]
    resources: ["persistentvolumes"]
    verbs: ["get", "list", "watch", "create", "delete"]
  - apiGroups: [""]
    resources: ["persistentvolumeclaims"]
    verbs: ["get", "list", "watch", "update"]
  - apiGroups: ["storage.k8s.io"]
    resources: ["storageclasses"]
    verbs: ["get", "list", "watch"]
  - apiGroups: [""]
    resources: ["events"]
    verbs: ["create", "update", "patch"]
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: run-nfs-client-provisioner
  namespace: kube-system
subjects:
  - kind: ServiceAccount
    name: nfs-client-provisioner
    namespace: default
roleRef:
  kind: ClusterRole
  name: nfs-client-provisioner-runner
  apiGroup: rbac.authorization.k8s.io
---
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: leader-locking-nfs-client-provisioner
  namespace: kube-system
rules:
  - apiGroups: [""]
    resources: ["endpoints"]
    verbs: ["get", "list", "watch", "create", "update", "patch"]
---
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: leader-locking-nfs-client-provisioner
  namespace: kube-system
subjects:
  - kind: ServiceAccount
    name: nfs-client-provisioner
roleRef:
  kind: Role
  name: leader-locking-nfs-client-provisioner
  apiGroup: rbac.authorization.k8s.io
```

### SC配置

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: managed-nfs-storage
  namespace: kube-system
provisioner: fuseim.pri/ifs # 外部制备器提供者，编写为提供者的名称
parameters:
  archiveOnDelete: "false" # 是否存档，false 表示不存档，会删除 oldPath 下面的数据，true 表示存档，会重命名路径
reclaimPolicy: Retain # 回收策略，默认为 Delete 可以配置为 Retain
volumeBindingMode: Immediate # 默认为 Immediate，表示创建 PVC 立即进行绑定，只有 azuredisk 和 AWSelasticblockstore 支持其他值
```

## 使用例子

* 上述资源全部创建后，再创建下面的statefulset将会自动创建pv并绑定。

```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-sc
  labels:
    app: nginx-sc
spec:
  type: NodePort
  ports:
  - name: web
    port: 80
    protocol: TCP
  selector:
    app: nginx-sc
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: nginx-sc
spec:
  replicas: 1
  serviceName: "nginx-sc"
  selector:
    matchLabels:
      app: nginx-sc
    template:
      metadata:
        labels:
          app: nginx-sc
      spec:
        containers:
        - image: nginx
          name: nginx-sc
          imagePullPolicy: IfNotPresent
          volumeMounts:
          - mountPath: /usr/share/nginx/html
            name: nginx-sc-test-pvc
  volumeClaimTemplates:
  - metadata:
      name: nginx-sc-test-pvc
    spec:
      storageClassName: managed-nfs-storage
      accessModes:
      - ReadWriteMany
      resources:
        requests:
          storage: 1Gi
```

### 高版本k8s制备器无法创建pv的问题

* 使用 helm 安装 nfs驱动，并修改成自己的 nfs服务器ip 和 path，然后将上述的provisioner处全部换成 nfs-subdir-external-provisioner

```bash
#!/bin/bash
 helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/


helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner --set nfs.server=192.168.1.39 --set nfs.path=/home/jiahui/nfs/rw --set image.repository=swr.cn-north-4.myhuaweicloud.com/ddn-k8s/registry.k8s.io/sig-storage/nfs-subdir-external-provisioner --set image.tag=v4.0.2
```
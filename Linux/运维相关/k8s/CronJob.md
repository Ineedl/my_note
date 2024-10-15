## 定时调度

k8s中周期性的运行k8s任务，语法同CronJob

* CronJob属于k8s的一个资源

* CronJob也会创建pod

## 配置文件

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: hello
spec:
  concurrencyPolicy: Allow # 并发调度策略：Allow 允许并发调度，Forbid：不允许并发执行，Replace：如果之前的任务还没执行完，就直接执行新的，放弃上一个任务
  failedJobsHistoryLimit: 1 # 保留多少个失败的任务
  successfulJobsHistoryLimit: 3 # 保留多少个成功的任务
  suspend: false # 是否挂起任务，若为 true 则该任务不会执行，该选项用于手动编辑暂停任务。
  startingDeadlineSeconds: 30 # 允许任务启动的截止时间，如果任务在该时间内未能启动，则跳过执行，不会重新调度任务，最小10s
  schedule: "* * * * *" # 调度策略 cron表达式
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: hello
            image: busybox:1.28
            imagePullPolicy: IfNotPresent
            command:
            - /bin/sh
            - -c
            - date; echo Hello from the Kubernetes cluster
          restartPolicy: OnFailure

```

## 资源简化名称

```bash
kubectl get cj

kubectl describe cj
```


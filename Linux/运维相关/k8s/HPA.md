[toc]

## 介绍

根据pod的CPU使用率等资源，对pod进行自动扩容和缩容，所有pod资源超过指定时，扩容，所有pod资源都小于指定时，缩容。

## 配置

```bash
# CPU使用率大于20时自动扩容，最小2个，最大5个
kubectl autoscale <resource_type> <resource_name> -cpu-percent=20 --min=2 --max=5
```


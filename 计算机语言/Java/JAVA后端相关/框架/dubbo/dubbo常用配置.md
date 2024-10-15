## [dubbo标签以及标签中属性配置文档](https://dubbo.apache.org/zh/docs/v3.0/references/xml/)

## 启动时检查的check选项
dubbo:reference  
dubbo:registry  
dubbo:service  
等标签都可以使用该字段，表示启动应用时检查接口或服务是否可用，默认为true，表示启动时服务不可用就抛出异常。

可以将其设置为false，关闭检查，当你的程序需要调试依赖或是Spring容器的懒加载与延迟API调用时，需要关闭该设置


## 重试次数retrise
dubbo:registry  
dubbo:service   
标签可以使用该字段，表示对于远程接口调用或注册服务失败时的重试次数(不包括第一次)

    <dubbo:service retrise="2">
        
## 超时事件timeout
dubbo:registry  
dubbo:service   
标签可以使用该字段，表示使用服务时最大的尝试时间，单位为毫秒

    <dubbo:service timeout="2000">
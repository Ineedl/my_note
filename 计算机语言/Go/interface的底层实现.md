## 底层原理

interface 是一个 pair：

- `type`：接口实际实现类型。
- `data`：实现该接口的实际数据指针。

空 interface：`type=nil, data=nil`。

**但是这个type和data与反射的type和data无关**


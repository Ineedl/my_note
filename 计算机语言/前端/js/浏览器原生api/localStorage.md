## localStorage

它是 Web 浏览器提供的一种**本地键值对存储机制**，用于将数据存储在客户端，即用户的浏览器中。

- 存储在本地磁盘，不会随页面刷新而消失
- 存储的内容是字符串类型
- 生命周期是**永久有效**，除非手动删除
- 存储上限通常为 5MB 左右（各浏览器略有不同，为每个域名独有）

`示例`

```ts
//不需要引入库
// 保存数据
localStorage.setItem("token", "abc123")

// 读取数据
const token = localStorage.getItem("token")  // "abc123"

// 删除数据
localStorage.removeItem("token")

// 清空所有数据
localStorage.clear()

```


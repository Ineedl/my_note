## 基本概念

- **存储位置**：浏览器内存（页面会话期间有效）
- **生命周期**：浏览器标签页或窗口关闭时，数据清空
- **作用域**：同源且限于单个标签页，多个标签页互不共享 sessionStorage
- **存储大小**：一般几 MB，和 localStorage 差不多（因浏览器而异）
- **存储格式**：字符串键值对

## 基本 API

| 方法                  | 说明                                | 示例                                          |
| --------------------- | ----------------------------------- | --------------------------------------------- |
| `setItem(key, value)` | 存储键值对（value 必须是字符串）    | `sessionStorage.setItem('user', 'cjh')`       |
| `getItem(key)`        | 获取对应键的值，如果不存在返回 null | `const user = sessionStorage.getItem('user')` |
| `removeItem(key)`     | 删除对应键的存储                    | `sessionStorage.removeItem('user')`           |
| `clear()`             | 清空所有 sessionStorage 中的数据    | `sessionStorage.clear()`                      |
| `key(index)`          | 返回第 index 个 key 值              | `sessionStorage.key(0)`                       |

## 示例

```ts

sessionStorage.setItem('token', 'abc123')

const token = sessionStorage.getItem('token')
console.log(token)  // 输出 'abc123'

sessionStorage.removeItem('token')

sessionStorage.clear()
```


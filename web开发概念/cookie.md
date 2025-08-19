[toc]

## cookie

HTTP Cookie（也叫 Web Cookie 或浏览器 Cookie）是服务器发送到用户浏览器并保存在本地的一小块数据。

浏览器会存储 cookie 并在下次向同一服务器再发起请求时携带并发送到服务器上。

通常，它用于告知服务端两个请求是否来自同一浏览器——如保持用户的登录状态。

Cookie 使基于[无状态](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Guides/Overview#http_是无状态，有会话的)的 HTTP 协议记录稳定的状态信息成为了可能。

## cookie的创建

服务器收到 HTTP 请求后，服务器可以在响应标头里面添加一个或多个 [`Set-Cookie`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/Set-Cookie) 选项。

浏览器收到响应后通常会保存下 Cookie，并将其放在 HTTP [`Cookie`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/Cookie) 标头内，用于向同一服务器发出请求时一起发送。

## Set-Cookie和Cookie标头

服务器使用 [`Set-Cookie`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/Set-Cookie) 响应头部向用户代理（一般是浏览器）发送 Cookie 信息。一个简单的 Cookie 可能像这样：

```http
Set-Cookie: <cookie-name>=<cookie-value>
```

* 指示服务器发送标头告知客户端存储一对 cookie：

```http
HTTP/1.0 200 OK
Content-type: text/html
Set-Cookie: yummy_cookie=choco
Set-Cookie: tasty_cookie=strawberry

[页面内容]
```

* 之后，对发送过上述请求的服务器发起的每一次新请求，浏览器都会将之前保存的 Cookie 信息通过 [`Cookie`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/Cookie) 请求头部再发送给服务器。

```http
GET /sample_page.html HTTP/1.1
Host: www.example.org
Cookie: yummy_cookie=choco; tasty_cookie=strawberry
```

## cookie 的生命周期

定义Cookie 生命周期的两种方式，cookie的生命周期相关字段为 `Expires` 和 `Max-Age` 

### 会话期cookie

没有设置 `Expires` 或 `Max-Age` 的 Cookie，它的存活时间由 **浏览器会话（session）** 决定，而不是固定日期。当浏览器认为“当前会话结束”时，这类 Cookie 就会被删除。

#### 结束条件

浏览器会话通常指 **浏览器进程从启动到关闭的时间段**。

也可能包括：

1. **关闭浏览器窗口/标签**（取决于浏览器实现）
2. **关闭整个浏览器进程**

现代浏览器可能有 **会话恢复功能**：

- 如果启用了“恢复上次会话”或“保存标签页”，浏览器可能在重启后恢复上一次的会话 Cookie。
- 这会导致会话 Cookie 被“延长”，看起来像是持久化 Cookie。

### 持续性cookie

*持久性* Cookie 在过期时间（`Expires`）指定的日期或有效期（`Max-Age`）指定的一段时间后被删除。

## SameSite 属性

[`SameSite`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Reference/Headers/Set-Cookie#samesitesamesite-value) 属性允许服务器指定是否/何时通过跨站点请求发送（其中[站点](https://developer.mozilla.org/zh-CN/docs/Glossary/Site)由注册的域和*方案*定义：http 或 https）。这提供了一些针对跨站点请求伪造攻击（[CSRF](https://developer.mozilla.org/zh-CN/docs/Glossary/CSRF)）的保护。它采用三个可能的值：`Strict`、`Lax` 和 `None`。

Strict：跨站请求不携带cookie。

Lax：跨站GET请求携带，但其他的请求不懈怠。（从不带cookie的站跨到产生过cookie的站，并且cookie仍在生命周期内，会携带cookie）（默认选择）

None：总是携带cookie，但是要求请求为https。（从不带cookie的站跨到产生过cookie的站，并且cookie仍在生命周期内，会携带cookie）
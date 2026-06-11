[toc]

## JWT（JSON Web Token）

通过 数字签名的方式，以JSON对象为载体，在不同的服务终端之间安全的传输信息。

* JWT**保证 token 内容（payload）在传输过程中不被篡改** —— 这是签名的核心作用。

  签名机制通过密钥把数据“绑定”起来，任何改动都会导致签名验证失败。

* JWT不保证数据不被解密。

## 组成

JWT由3部分组成，用 **.** 拼接

`例子`

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE3NTMwNjM4MTQsInN1YiI6IuWvhuWPi-eUqOaItyIsInVzZXJJZCI6IjIwMDA0NyJ9.WPOxBesTS-6OOKR5DCwnW5RaP2ADprfthYsieIEU3XI
```

### Header

header包含两个信息，token类型和使用的算法

```
{
	'typ':'JWT',
	'alg':'HS256'
}
```

### Payload

payload用于存储开发者希望的信息，没有特殊规定

```
{
	"sub":'123',
	"name":'john',
	"admin":true
}
```

### Signature

将base64后的header与payload用 **.** 拼接，然后使用header中声明算法，进行加盐加密。

```
encodedString = base64UrlEncode(header) + . +base64UrlEncode(payload)
signature = HMACSHA256(encodedString,"盐str")
```

## Claim

“JWT 里把 payload 叫做 claim”，这背后是有规范和语义考量的，且不只是“payload”，它更具体更语义化。直白地说：

**“Claim” 是 JWT 标准里的正式术语**

JWT 标准（RFC 7519）里，把 token 里的信息字段定义为 **claims（声明）**：

- Claims 表示声明了某些事实（attributes/facts），比如“这个用户是谁”，“这个 token 什么时候过期”等。
- Payload 是 JWT 中承载 claims 的部分，是 JSON 对象，里面放的就是这些声明。

### payload 和 claims 的区别

- **Payload** 是容器，是 JWT 的第二段，是 Base64URL 编码后的数据。
- **Claims** 是 payload 里面实际的语义内容，JSON 里的 key-value。

换句话说：

> Payload 是载体，Claims 是数据。

### Payload 内容包括三类 Claims（声明）

- **注册声明（Registered claims）**
   这是标准定义的字段，虽然可选，但推荐使用，如：
  - `iss`（Issuer，签发者）
  - `sub`（Subject，主题）
  - `aud`（Audience，受众）
  - `exp`（Expiration time，过期时间）
  - `nbf`（Not before，生效时间）
  - `iat`（Issued at，签发时间）
  - `jti`（JWT ID，唯一标识）
- **公共声明（Public claims）**
   这些是可以自定义，但应避免与已注册声明冲突，且建议使用 URI 格式的命名空间来防止冲突。
- **私有声明（Private claims）**
   应用自定义字段，比如用户ID、角色等业务相关数据，双方约定即可。

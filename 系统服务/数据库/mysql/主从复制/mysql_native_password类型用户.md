## mysql_native_password

MySQL 的 `mysql_native_password` 插件。这个插件本质上是 MySQL 用来验证客户端连接的身份认证机制之一。

## 主从复制限制

MySQL 主从复制的 `replication` 用户必须使用 `mysql_native_password` 类型的账户。

或者是主从复制时开始ssl安全认证。
## 注意
* 请注意事务本来的性质，而不要过度关注该函数的性质

* 以下使用mysql中支持事务的默认引擎仍然是InnoDB


## 开启事务(关闭自动提交)
void setAutoCommit(boolean autoCommit) throws SQLException

* 该方法为Connection接口的方法

* 默认情况下JDBC是开启自动提交的

* 参数
autoCommit - true启用自动提交模式; false禁用它

* 如果发生数据库访问错误，或在参与分布式事务时调用setAutoCommit（true），或者在闭合连接上调用此方法会抛出SQLException异常

## 提交事务
void commit() throws SQLException

* 该方法为Connection接口的方法

* 如果发生数据库访问错误，或在参与分布式事务时调用该方法，或者在闭合连接上调用此方法会抛出SQLException异常
 
## 回滚事务
void rollback() throws SQLException

* 该方法为Connection接口的方法

* 如果发生数据库访问错误，或在参与分布式事务时调用该方法，或者在闭合连接上调用此方法会抛出SQLException异常

## 保存点相关
##### Savepoint setSavepoint(String name) throws SQLException

* 该方法为Connection接口的方法

* 该方法设置一个带名字的保存点

* 如果发生数据库访问错误，或在参与分布式事务时调用该方法，或者在闭合连接上调用此方法会抛出SQLException异常

##### void releaseSavepoint(Savepoint savepoint) throws SQLException

* 该方法为Connection接口的方法

* 该方法删除对应保留点以及其后面的所有保留点

* 如果发生数据库访问错误，或在参与分布式事务时调用该方法，或者在闭合连接上调用此方法会抛出SQLException异常

##### void rollback(Savepoint savepoint) throws SQLException

* 该方法为Connection接口的方法

* 该方法回滚到对应保留点

* 如果发生数据库访问错误，或在参与分布式事务时调用该方法，或者在闭合连接上调用此方法会抛出SQLException异常
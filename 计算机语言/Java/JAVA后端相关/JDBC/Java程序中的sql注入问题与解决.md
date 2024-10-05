## Java程序中的sql注入问题

    例:
        
        String sql="select * from userTable where id = '"+
        userId+
        "' and password='"+
        password+
        "';"
        
        rs = stmt.executeQuery(sql);
        
        if(rs.next())
        {
            //登录成功
            loginFlag=true;
        }
        
绕过上述程序登陆成功实例：
    
    String userId = "tmp";
    String password = "tmp' or '1'='1";
    
上述sql语句将变为

    //sql优先级中先执行and，再执行or
    select * from userTable where id = 'tmp' and password = 'tmp' or '1' = '1';
    
将会成功绕过该程序

## Java程序中sql注入原因
用户传入的参数参与了sql语句的编译，利用了程序中拼接sql语句的方式，该方式使得该程序的作用不是获取从用户那得来的数据作为条件，而是将用户那里得到的数据作为sql语句的一部分。

## Java程序中sql注入解决办法
使sql语句预先编译(SQL的模板化)，让用户传入的数据只能作为条件，而不是参与sql语句的组成。  
以上述例子为例，提前编译好sql语句，让sql语句知道他只需要userId与password这个条件。
当不存在用户tmp或是当用户的密码不为tmp' or '1'='1时，报出错误。


## PreparedStatement接口
实现该接口的对象表示一个预编译的SQL语句。

* 一般PreparedStatement的使用比Statement多

* 改接口所需包
java.sql.PreparedStatement

### 获取PreparedStatement对象
PreparedStatement prepareStatement(String sql) throws SQLException

* 该方法为Connection接口的方法

* 发生数据库访问错误或在闭合连接上调用此方法将会抛出SQLException异常

* 参数：
sql：该字符串中包含一个含有?的sql语句，?即为一个占位符

例：

    String sql = "select * from ? where id=?";
    
?的下标从1开始，第一个?下标为1。

* 注意?处必须是字段值等。

### 设置模板化PreparedStatement对象中的参数
void setString(int parameterIndex,String x) throws SQLException

* 该方法将指定的参数设置为给定的Java String值。

* 如果parameterIndex不对应于SQL语句中的参数标记或发生数据库访问错误或在关闭的PreparedStatement上调用此方法，将会抛出SQLException异常

* 参数下标以prepareStatement方法传入的sql语句中?下标为准。

parameterIndex：第n个?处

### 执行PreparedStatement对象中的sql语句
int executeUpdate() throws SQLException

ResultSet executeQuery() throws SQLException

* 这两个方法为PreparedStatement的方法。用法同Statement中的那两个同名方法。

* 这两个方法会将PreparedStatement对象中已模板化传参后的语句执行。并且返回对应结果


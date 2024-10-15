## Connection接口的介绍
实现改接口的类如果被实例化则表示了对一个数据库的会话。

* 改接口所需包：java.sql.Connection

## sql的执行
### 返回语句控制类
Statement createStatement() throws SQLException

* 该方法为Connection接口的方法

* 数据库访问错误或是访问关闭数据库时抛出SQLException异常

### Statement类的介绍
Statement类用于执行静态SQL语句并返回其生成的结果的对象。

* 改接口所需包：java.sql.Statement

### 执行语句的方法
int executeUpdate(String sql) throws SQLException

* 该方法为Statement类的方法

* 如果发生数据库访问错误或此方法在关闭的 Statement上调用将会抛出SQLException异常。

* 该方法只是常用于DML语句

* 参数介绍

| 参数 | 作用 |
|:--|:--|
| sql | 要执行的sql语句字符串 |

* 返回值
该函数将会返回sql语句修改的数据条目的个数。

## 资源的释放
void close() throws SQLException

* 该方法Statement类与Connection接口实现对象都需要在数据库处理完后调用。

* 当发生数据库访问错误时抛出SQLException异常。

* 该方法调用后会释放Statement类与Connection接口实现对象的资源。

* 先释放Connection接口实现对象，因为其相当于一个连接会话。

## 完整的注册与资源释放实例

    Driver driver=null;
        Statement stmt = null;
        Connection conn=null;
        try {
            Driver driver = new com.mysql.jdbc.Driver();
            DriverManager.registerDriver(driver);
            String url = "jdbc:mysql://127.0.0.1:3306/bjpowernode";
            String user = "root";
            String password = "zxc563221659";
            conn = DriverManager.getConnection(url,user,password);
            stmt=conn.createStatement();
        } catch (SQLException e) {
            e.printStackTrace();
        }finally
        {
            try {
                if (null != stmt) {
                    stmt.close();
                }
                if (null != conn) {
                    conn.close();
                }
            }catch(SQLException e)
            {
                e.printStackTrace();
            }
        }

* 注意driver对象只是相当于一个驱动对象，其在注册成功后将不再有用。

### 返回查询结果集的方法
ResultSet executeQuery(String sql) throws SQLException

* 该方法为Statement接口的方法

* 如果发生数据库访问错误，或是访问了关闭的数据库则返回SQLException异常

* 参数  
sql 要执行的sql语句
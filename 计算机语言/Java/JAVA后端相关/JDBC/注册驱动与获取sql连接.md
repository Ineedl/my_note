## 注册驱动
### 相关包 
java.sql.DriverManager

### DriverManager类介绍
DriverManager类用于管理一组JDBC驱动程序的基本服务，其几乎public方法都为static方法。

### 注册驱动方法
public static void registerDriver(Driver driver) throws SQLException

* 该方法为DriverManager静态方法

* 当注册发生错误时，抛出SQLException异常
                  
### Driver接口介绍
每个驱动程序类必须实现的接口。  
Java SQL框架允许多个数据库驱动程序。  
每个驱动程序都应该提供一个实现Driver接口的类。  

### mysql驱动注册实例

    try {
            Driver driver = new com.mysql.jdbc.Driver();
            DriverManager.registerDriver(driver);
    } catch (SQLException e) {
        e.printStackTrace();
    }

## 获取连接
## 所需包
java.sql.Connection (DriverManager的基础上)
### 连接的获取方法
public static Connection getConnection(String url,String user,String password)throws SQLException

* 该方法为DriverManager静态方法

* 当连接发生错误时，抛出SQLException异常

* 该方法调用后，DriverManager将会在已注册的JDBC驱动程序中找到一个合适驱动程序。

* 该方法成功调用后，程序将会和对应的数据库建立起连接，直到连接异常中断或是手动断开。

* 参数介绍

| 参数 | 作用 |
|:--|:--|
| url | 形式为 jdbc:subprotocol:subname的数据库网址，url由协议，IP，端口号，资源名组成|
| user | 连接数据库所用的用户名 |
| password | 用户密码 |

### mysql连接实例

    try {
            Driver driver = new com.mysql.jdbc.Driver();
            DriverManager.registerDriver(driver);
            String url = "jdbc:mysql://127.0.0.1:3306/myTest";
            //jdbc:mysql 协议名
            //127.0.0.1 IP
            //3306端口
            //myTest 资源，这里指连接后打开myTest数据库
            
            String user = "root";
            String password = "zxc563221659";
            Connection conn = DriverManager.getConnection(url,user,password);
            System.out.println("SQL对象="+conn);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
## 类加载的方式注册驱动

    Class.forName("com.mysql.jdbc.Driver");
    
* 该方法使得可以让用户把驱动类名写在文件中。

* 几乎数据库驱动类中都有静态代码区，该静态代码区会对应注册驱动。这就是只用forName就可以注册驱动的原因。
## mysql命令行登录
    
    mysql [选项][参数]
    
* 常用选项说明

| 选项 | 说明 |
|:---|:---|
| -u | 指定用户名 |
| -P | 指定mysql服务端口号(一般默认为3306) |
| -p | 可以在选项后面直接跟上明文密码，如果不直接跟上明文密码，则会在mysql登录命令结束后以不现实的方式输入对应用户密码 |
| -h | 服务器名称，一般为ip地址或是域名 |
| -D | 指定登录后打开的数据库 |

例:

    //以密码123456在本地服务器上使用3305端口的mysql服务登入数据库中的root账户，然后使用名字为mysql的数据库
    mysql -uroot -p123456 -P3305 -h127.0.0.1 -Dmysql

## sql语句分类
* DQL(数据查询语言)  
查询语句

* DML(数据操作语言)  
对表中数据进行增删改查的语句

* DDL(数据定义语言)  
对表的结构进行修改(字段的增删改查等)  

* TCL(事务控制语言)
sql中的事务控制

* DCL(数据控制语言)
授权，权限修改，对外开放，用户创建等。

## mysql使用脚本导入数据
    source 脚本全路径

* 注意当导入数据需要对应的表或数据库时，需要先建立对应的表与库。

## 使用某个数据库

    use databaseName;

## 查看当前使用的数据库

    select database();
    //使用了database()函数

## 查看所有数据库
    
    show databases;

## 查看使用数据库中的所有表

    show tables;

## 查看某个数据库中的所有表

    show tables from <databaseName>;

## 查看建表语句

    show create table <tablename>;

## 数据库创建

    create database <DatabaseName>;

该命令创建的数据库编码格式由mysql内部设置决定，可以使用如下命令查看创建数据库时的采用的编码：

    show variables like 'character%';

修改数据库创建时编码需要修改my.ini文件，除此之外，也可以在创建数据库的命令中指定对应编码。

## 表结构查询语句

    desc <tableName>

    show columns from <tableName>;
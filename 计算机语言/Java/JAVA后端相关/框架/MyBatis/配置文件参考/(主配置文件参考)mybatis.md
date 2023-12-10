```

<?xml version="1.0" encoding="UTF-8" ?>

<!--约束文件设置-->
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">

<!--更多配置请参考https://mybatis.org/mybatis-3/zh/configuration.html-->

<configuration>
    <!--
    settings用于控制mybatis全局行为
    -->
    <settings>
        <!--
        设置mybatis输出日志
        logImpl表示配置日志
        STDOUT_LOGGING表示输出到控制台
        -->
        <setting name="logImpl" value="STDOUT_LOGGING"/>
    </settings>


	<!--类型重命名(基本在映射文件中才会用到重命名的类型名)-->
	<typeAliases>
        <typeAlias type="indi.cjh.mapper.Student" alias="Student"/>
    </typeAliases>

    <!--
        environments表示多个数据库连接信息
        default必须与某个数据库的连接信息一致,表示默认使用某个连接
    -->
    <environments default="development">
        <!-- 配置数据源  -->
        <!--
            一个environment表示一个数据库连接信息,environment可有多个
            一个唯一id对应一个唯一连接
        -->
        <environment id="development">

            <!--
                transactionManager表示MyBatis的事务类型
                type="JDBC"表示myBatis底层事务使用JDBC事务管理
                使用JDBC中的Connection的commit与rollback
                type="MANAGED"表示把myBatis底层事务委托给其他容器
            -->
            <transactionManager type="JDBC"/>

            <!--
                dataSource表示获取数据源的方式
                type=POOLED 表示使用连接池获取数据源，MyBatis会创建连接池，创建PooledDataSource类
                type=UPOOLED 表示不使用连接池，每次执行sql语句时，会建立sql连接，执行sql，然后关闭。
                             MyBatis会创建UnPooledDataSource类，管理Connection对象的使用。
                type=JNDI   使用一种命名服务接口访问数据库，详情百度JNDI
            -->
            <dataSource type="POOLED">
                <!--
                    此处的property固定,必须有这四个
                -->
                <property name="driver" value="com.mysql.jdbc.Driver"/>
                <property name="url" value="jdbc:mysql://127.0.0.1:3306/test"/>
                <property name="username" value="root"/>
                <property name="password" value="zxc563221659"/>
            </dataSource>

        </environment>
    </environments>

    <!-- mappers表示sql映射文件路径的集合 -->
    <mappers>
        <!--
           一个mapper指定一个sql映射文件
        -->
        <mapper resource="indi/cjh/dao/StudentDao.xml"/>
    </mappers>

</configuration>


```
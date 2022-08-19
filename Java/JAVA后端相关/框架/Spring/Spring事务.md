## Spring事务
Spring提供了一种处理事务的统一模型，能使用统一步骤完成多种数据库访问技术的事务处理。

* 注意此处介绍的事务只针对于数据库操作，不针对其他应用功能。

## Spring处理事务模型
使用步骤都是固定的。把事务使用的信息提供给Spring就可以了。事务内部的提交，回滚事务都由事务管理器来完成


### PlatformTransactionManager接口
该接口为Spring中事务管理器接口，其用来提交回滚事务以及获得事务的状态信息。其定义了commit与rollback方法。

* Spring中会自动根据你使用的数据库来访问技术来创建对应的PlatformTransactionManager接口实现类。`你只需要告诉Spring你使用的是何种数据库访问技术即可`

用mybatis访问数据库Spring中对应的事务管理器类的是DataSourceTransactionManager。  
`例`  
在Spring配置文件中用IOC建立一个DataSourceTransactionManager对象(bean中)，Spring就知道你是用的是mybatis的数据库访问技术。


## Spring AOP中@Transactional注解处理事务
该注解为Spring框架自己的注解，用于public方法上面表示该方法具有事务。

* 该方式只适合小心项目，事务的配置与代码相关，而且如果多个方法需要配置则需要多次配置，每个方法的事务配置不可复用。

`注解使用的属性`

| 属性名 | 作用 |
|:--|:--|
| propagation | 用于设置事务的传播行为，属性类型为Propagation类型的枚举，默认为REQUIRED |
| isolation | 用于设置事务隔离级别，属性为Isolation类型的枚举 |
| readOnly | 用于设置该方法对数据库操作是否只读，属性为boolean类型，默认为false |
| timeout | 用于设置与数据库连接的超时时限，属性类型为int类型，默认为-1永不超时 |
| rollbackFor | 用于指定需要回滚的异常类，类型为Class[]，默认为空 |
| rollbackForClassName | 用于指定需要回滚的异常类的名称，类型为String[]，默认为空 |
| noRollBackFor | 同rollbackFor，但是为不需要回滚的异常。 |
| noRollbackForClassName | 同rollbackForClassName，但是为不需要回滚的异常 |

`Propagation枚举值`  

    REQUIRED=0  
    SUPPORTS  
    MANDATORY  
    REQUIRES_NE  W
    NOT_SUPPORTED  
    NEVER  
    NESTED  

`Isolation值`  

    DEFAULT=-1  
    READ_UNCOMMITTED=1  
    READ_COMMITTED=2  
    REPEATABLE_READ=4  
    SERIALIZABLE=8

`指定回滚异常注意事项`
如果方法抛出某个异常，该异常不在rollbackFor的列表中且为运行时异常(RuntimeException)，事务将回滚。

* 一般isolation使用Isolation.DEFAULT即可

`事务的传播行为`

* Spring中的事务传播行为有7个，前三个为最常用且需要掌握的。

| 传播行为名称 | 作用 |
|:--|:--|
| PROPAGATION_REQUIRED | 该传播行为为Spring默认传播行为，指定的方法必须在事务中运行，若当前存在事务就加入，如果没有事务就新建一个事务。 |
| PROPAGATION_REQUIRES_NEW | 指定的方法运行时总是新建一个事务运行，如果当前已有事务，则将当前事务挂起，执行建立的新事务，运行完毕后在执行之前挂起的事务 |
| PROPAGATION_SUPPORTS | 指定的方法支持事务，如果当前调用他的方法有事务，则在事务中运行，如果单独运行他或是用无事务的方法调用它，则他将不会在事务中运行。 |
|||
| PROPAGATION_MANDATORY |  |
| PROPAGATION_NESTED |  |
| PROPAGATION_NEVER |  |
| PROPAGATION_NOT_SUPPORTED |  |

`PROPAGATION_REQUIRED例子`  
如果该传播行为在doOther方法上，当doSome调用doOther时，如果doSome已加入一个事务TS，doOther中的事务会加入到doSome的事务TS中。如果doSome上没有事务，则doOther会自己开启一个新事务(此时与doSome无关)newTS，并且在事务上执行。


`PROPAGATION_REQUIRES_NEW例子`  
如果该传播行为在doOther方法上，当doSome调用doOther时，如果doSome已加入一个事务TS，doOther会挂起该事务TS然后建立一个新的事务newTS先执行，当newTS执行完毕后，再执行TS。如果如果doSome没有加入事务，doOther也会建立一个新的事务newTS先执行。


### @Transactional注解使用步骤
1.在Spring主配置文件中声明事务管理对象(比如一个DataSourceTransactionManager的bean)。  

2.开启事务注解驱动，告诉Spring框架将要使用注解的方式来完成事务。


`主配置文件中例子`
    
    
    <beans xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       
       //次行为tx:annotation-driven标签需要的命名空间
       xmlns="http://www.springframework.org/schema/beans"
       
       xmlns:tx="http://www.springframework.org/schema/tx"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
       
       //次行为tx:annotation-driven需要配置
       http://www.springframework.org/schema/tx  
       
       //次行为tx:annotation-driven需要的约束文件
       http://www.springframework.org/schema/tx/spring-tx.xsd">
       
    .......
    
    <!--连接池数据源-->
    <bean id="myDataSource"
          class="com.alibaba.druid.pool.DruidDataSource"
          init-method="init"
          destroy-method="close">
        <property name="url" value="jdbc:mysql://localhost:3306/test" />
        <property name="username" value="root" />
        <property name="password" value="zxc563221659" />
        <property name="maxActive" value="20" />
    
    
    <!--使用Spring的事务管理-->
    <!--声明事务管理器-->
    <bean id="MysqlTransactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <!--需要指定数据源，来让该事务管理器对数据库操作来进行提交与回滚-->
        <property name="dataSource" ref="myDataSource" />
    </bean>

    <!--
    开启事务注解驱动
    此处告诉Spring要使用注解的方式来完成事务，要创建事务代理对象
    -->
    <!--给他事务管理器id-->
    <tx:annotation-driven transaction-manager="MysqlTransactionManager" />

`事务方法例子`

    @Transactional(         //Transactional注解标记事务方法
            propagation = Propagation.REQUIRED,
            isolation = Isolation.DEFAULT,
            readOnly = false,
            rollbackFor = {NullPointerException.class,RuntimeException.class}
    )
    public void buy(Integer goodsId, Integer nums){}

`@Transactional注解原理`  
Spring会使用aop给@Transactional注解标记的方法的对象生成一个代理对象，然后对该代理对象中的方法使用Spring aop给你的业务方法来增加事务提交与回滚业务。  

Spring将会给代理对象中你要添加事务的方法的代理方法加上几个环绕注解标记的切面方法，这些方法中就有事务的提交与回滚功能。

`@Transactional注解失效场景`

* 必须以代理对象的方式调用被注解标记的方法，否则Transactional注解会失效。

* @Transactional注解只有标记在public方法上才不会失效

* @Transactional注解的方法必须抛出指定或默认异常时，才会回滚，如果被指定的异常在该方法内部被try-catch捕获，则@Transactional注解失效。

* @Transactional注解不支持当前使用的数据库引擎。

* 代码系统中未开启AOP

* 标记的方法在Spring事务中的传播方式异常，导致事务模式没有正常工作。

## Spring AOP配置文件方式处理事务
该方式让事务与代码完全分离，不同于使用注解的那样与代码相关。该方式将事务的配置放在配置文件中。

`使用步骤`  
1.声明事务管理器对象。  
2.声明方法需要的事务类型。  
3.声明方法需要的事务属性。  
4.使用AOP来标记哪些类要创建代理来使用事务。  


`Spring配置文件例子`


    <?xml version="1.0" encoding="UTF-8" ?>
    <beans xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns="http://www.springframework.org/schema/beans"
       xmlns:tx="http://www.springframework.org/schema/tx"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
       http://www.springframework.org/schema/tx
       http://www.springframework.org/schema/tx/spring-tx.xsd
       http://www.springframework.org/schema/aop
       http://www.springframework.org/schema/aop/spring-aop-4.0.xsd">


    <!--使用连接池的一个数据库数据源-->
    <bean id="myDataSource"
          class="com.alibaba.druid.pool.DruidDataSource"
          init-method="init"
          destroy-method="close">
        <property name="url" value="jdbc:mysql://localhost:3306/test" />
        <property name="username" value="root" />
        <property name="password" value="zxc563221659" />
        <property name="maxActive" value="20" />

    </bean>

    ...

    <!--使用Spring的事务管理-->
    <!--声明事务管理器-->
    <bean id="MysqlTransactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <!--需要指定数据源-->
        <property name="dataSource" ref="myDataSource" />
    </bean>

    <!--
    声明业务方法他的事务属性
    -->
    <!--
    给他事务管理器id
    其id表示tx:advice标签之间的内容
    -->
    <tx:advice id="myAdvice" transaction-manager="MysqlTransactionManager">
    <!--
        tx:attributes用来配置事务属性
    -->
        <tx:attributes>
            <!--tx:method可以有多个,代表多类或者多种方法-->
            <!--
                tx:methon可以有多个，给具体的方法配置事务属性
                name            方法名称(不带包和类名的完整的方法名称,该方法名可以使用通配符)
                propagation     事务传播行为
                isolation       隔离级别
                rollback-for    指定的回滚异常类型,需要全类名。
            -->
            <tx:method name="buy" propagation="REQUIRED" isolation="DEFAULT" rollback-for="java.lang.NullPointerException,java.lang.RuntimeException" />

            <!--该项目中没有该方法,只是举例-->
            <!--使用通配符的tx:method-->
            <tx:method name="select*" propagation="REQUIRED" isolation="DEFAULT" rollback-for="java.lang.NullPointerException,java.lang.RuntimeException" />

            <!--tx:method先寻找对应名方法配置,再找部分通配方法配置,最后再找全统配配置,所以他们都存在时并不影响-->
            <tx:method name="*" propagation="REQUIRED" isolation="DEFAULT" rollback-for="java.lang.NullPointerException,java.lang.RuntimeException" />
        </tx:attributes>
    </tx:advice>

    <!--AOP配置-->
    <aop:config>
        <!--配置切入点表达式,指定哪些包中的类要使用事务-->
        <!--之后aop会对应建立代理-->
        <!--
            配置所有service包以及其子包中的所有类的不限制参数的方法都进行动态代理的创建
        -->
        <aop:pointcut id="servicePt" expression="execution(* *..service..*.*(..))" />

        <!--
        配置增强器,用来关联advice中的设置与切入点表达式,
        让创建的动态代理与配置的相关方法的事务对应
        -->
        <aop:advisor advice-ref="myAdvice" pointcut-ref="servicePt" />
    </aop:config>

`事务方法例子`  
该方式不需要关联相关代码
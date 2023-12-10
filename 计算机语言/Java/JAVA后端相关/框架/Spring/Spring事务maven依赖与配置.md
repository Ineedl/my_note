## 事务需要的maven依赖
需要Spring aop

    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-aspects</artifactId>
      <version>版本号</version>
    </dependency>

再加上

    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-tx</artifactId>
      <version>版本号</version>
    </dependency>
    
    
## Spring事务在bean中标签所需要的约束文件与命名空间

### 使用注解方式


    <beans
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        ...
        xmlns:tx="http://www.springframework.org/schema/tx"
        ...
        xsi:schemaLocation="
        ...
        //事务的
        http://www.springframework.org/schema/tx
        http://www.springframework.org/schema/tx/spring-tx.xsd
        ...">
        
        

### 外部配置文件AOP方式


    <beans 
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       ...
       xmlns:tx="http://www.springframework.org/schema/tx"
       xmlns:aop="http://www.springframework.org/schema/aop"
       ...
       xsi:schemaLocation="
       ...
       //事务的
       http://www.springframework.org/schema/tx
       http://www.springframework.org/schema/tx/spring-tx.xsd
       //AOP的
       http://www.springframework.org/schema/aop
       http://www.springframework.org/schema/aop/spring-aop-4.0.xsd
       ...">

## IOC
`maven配置`  
[maven仓库地址](https://mvnrepository.com/artifact/org.springframework/spring-context)


    <!-- https://mvnrepository.com/artifact/org.springframework/spring-context -->
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-context</artifactId>
        <version>版本</version>
    </dependency>

`约束文件配置`

    <beans 
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       ...
       xmlns="http://www.springframework.org/schema/beans"
       ...
       xsi:schemaLocation="
       ...
       http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
       ...">

## AOP
[maven仓库地址](https://mvnrepository.com/artifact/org.springframework/spring-aspects)

    <!-- https://mvnrepository.com/artifact/org.springframework/spring-aspects -->
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-aspects</artifactId>
        <version>版本</version>
    </dependency>

`约束文件配置`

    <beans 
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       ...
       xmlns:aop="http://www.springframework.org/schema/aop"
       ...
       xsi:schemaLocation="
       ...
       http://www.springframework.org/schema/aop
       http://www.springframework.org/schema/aop/spring-aop-4.0.xsd
       ...">
## SpringBoot依赖管理的maven依赖

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.3.4.RELEASE</version>
    </parent>

该父依赖中几乎声明了所有开发中常用的包依赖与Spring中所有的框架依赖以及他们的的版本号。

> 版本管理

在导入后如果需要其他的依赖版本，则可以在子项目中手动指定，依赖选择为就新原则，在子项目中手动指定版本后就会使用子项目中的依赖版本。

`例，手动指定mysql`

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.3.4.RELEASE</version>
    </parent>
    
    <properties>
        <mysql.version>5.1.43</mysql.version>
    </properties>
    
* 一般来说有父依赖，不需要写相关版本号，但是如果父依赖中没有还是得写。
    
> 导入场景启动器

当需要一种开发的环境时，不再关心是否需要导入哪些依赖，只需要导入该父依赖中的一个场景启动器(包含该场景的所有依赖)即可

`场景依赖模板`

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-*</artifactId>
        </dependency>
    </dependencies>

* *表示某种场景

* 当然支持自定义场景，详情见文档

`所有场景依赖最基本的依赖`  
所有的依赖场景都由其为基地添加修改依赖项来完成

    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter</artifactId>
      <version>2.3.4.RELEASE</version>
      <scope>compile</scope>
    </dependency>


#### [SpringBoot支持的场景启动器](https://docs.spring.io/spring-boot/docs/current/reference/html/using.html#using.build-systems.starters)

`例，开发web项目导入启动器`


    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.3.4.RELEASE</version>
    </parent>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
    </dependencies>
## SpringBoot中可以同时使用其他的Spring框架的标签，但有时候配合SpringBoot的配置文件可能需要同SpringBoot的注解一起使用。


## @SpringBootApplication
该标签告诉SpringBoot标记的类为SpringBoot应用，该标记的类为主程序类与主配置类，该类相当于是所有SpringBoot启动的入口。

`@SpringBootApplication的扫描范围`  
@SpringBootApplication默认扫描其标记的类所在的包下或是其子包下是否有Spring注解标识的类。如果某个Spring应用注解标识的类所在的包在不在@SpringBootApplication标记的类所在的包或其子包下。该类将不会被考虑是否被扫描进入IOC容器中。


> SpringBootApplication标签定义中实际起作用的定义

    @SpringBootConfiguration
    @EnableAutoConfiguration
    @ComponentScan(
        excludeFilters = {@Filter(
        type = FilterType.CUSTOM,
        classes = {TypeExcludeFilter.class}
    ), @Filter(
        type = FilterType.CUSTOM,
        classes = {AutoConfigurationExcludeFilter.class}
    )}
    )
    public @interface SpringBootApplication

`@SpringBootConfiguration`  

实际上就是一个@Configuration注解，只不过换了个名字，表示该注解标识的类是一个配置类

`@EnableAutoConfiguration`

该注解由@AutoConfigurationPackage与@Import注解合成。

1. @AutoConfigurationPackage实际上是一个@Import，该@Import给IOC容器导入了一个批量注册其他类的类，该组件将批量注册@AutoConfigurationPackage这个注解标记的类所在包中的其他组件类。  

    该批量注册类的对象将 @AutoConfigurationPackage 这个注解标记类 所在包中的全部组件导入进来(在Spring Boot应用启动时)。  
    
    (比如@AutoConfigurationPackage标记的主类Main在indi.cjh.test包中，那么将扫描该包中的全部@Component(或那些@Server等)标记的类) 

    相当于制定了自动扫描包的规则，自动导入组件。

2. @Import也导入了一个批量注册类的对象，但是该对象批量注册的类为Spring Boot应用启动时，当前开发环境所需要的配置类与组件，同时根据部分配置来筛选掉一些不需要加载的类。  

    该类最后会加载筛选之后的所有jar包中META-INF/spring.factories文件中的内容。  
    
    实际上最终要被加载的配置文件是pring-boot-autoconfigure:2.3.4.RELEASE/META-INF/spring.factories，这个配置文件中指定了死了在当前开发环境下Spring IOC容器需要加载的类。  
    
    但是并不会全部加载，最后会使用许多@Conditional的子注解(条件装配)来筛选掉大部分类，当用户导入某些功能的包时，某些功能的类才会被加载。


`@ComponentScan`  

指定了将要被扫描组件的包。

## application.properties
该文件用于存放SpringBoot中对于其他环境的配置信息，该文件为固定名称，在SpringBoot项目启动时自动导入。


* 名称固定，只能为application.properties


`原理`  
SpringBoot在加载时会默认加载许多对象到IOC容器中，之后通过这些对象来进行应用的相关设置，该配置文件相当于修改这些对象内部的属性值，使用了@ConfigurationProperties标签标记了那些类。
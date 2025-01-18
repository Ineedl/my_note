## 注意SpringBoot中的注解大多都由许多的注解组合而成，下面介绍的全部注解可能并不是不可分的一个元注解，而且SpringBoot中的许多注解可能都以他们为成分


## @ComponentScan
@ComponentScan常和@SpringBootApplication配合使用，其用于指定Spring IOC要扫描的可能含注解标识类的包的路径

`例`

    //目录结构
    indi
      |-cjh
      |  |-Main.java
      |
      |-config
         |-MyConfig.java
         
    //Main.java
    @SpringBootApplication
    //ComponentScan指定SpringBoot扫描路径在indi包以及其子包以下，可以扫描到MyConfig类并进行IOC控制
    //如果不加，SpringBoot只会扫描indi.cjh包以及其子包中的注解标识类。
    @ComponentScan("indi")
    public class Main {
        public static void main(String[] args){
            ConfigurableApplicationContext run = SpringApplication.run(Main.class,args);
        }
    }
    
    //MyConfig
    @Configuration(value="8888ddd",proxyBeanMethods = true)
    public class MyConfig {
        @Bean
        public user user01()
        {
            return new user("zhangsan",18);
        }
    }
    
`使用方法`

    //指定一个包及其子包
    @ComponentScan("包路径1")
    //指定多个
    @ComponentScan({"包路径1","包路径2"})

* 该注解只管扫描，剩余的什么命名规则归原本的注解管。

## @Configuration
该注解用来标记一个类，告诉SpringBoot该类是一个配置类，配置类本身是一个组件。

* @Configuration标记的类被IOC容器加载后，也会对应把用@Bean标记的方法返回的对象加载入IOC容器

> 常用的注解属性

`proxyBeanMethods`  
是否代理@Bean标记的方法


    boolean proxyBeanMethods() default true;
    
默认为true，表示会给标记类生成代理对象并存储到IOC容器中，之后通过该代理对象调用@Bean标记的方法来返回IOC容器中的对象时，永远只返回的是容器中的单实例对象，而不会重新创建。

为false时，被标记的类不会生成代理对象，但是仍然会根据原对象生成一个类放入到IOC容器中。并且之后使用被@Bean标记的方法也都会生成一个对象放在IOC容器中，但是之后用这些方法来返回对象时，都为一个新对象。

* 设置成false可以使SpringBoot更轻量级，运行更快，因为在用@Bean标记一个方法的时候，不再会再把IOC容器中创建的对应对象拿出来而是直接新new一个。

`value`  
该类在IOC容器中对象或是代理对象的Bean Id值，不写时默认为类型名的小写。



## @Bean
该注解用于被@Configuration标记的类中，用于标记方法，被标记的方法会返回一个对象，该对象会被IOC中的容器存储，这个对象的配置可以在该方法种进行，方法名就是容器中对象的ID。

`例，用Bean标记`

    public class MyConfig{
    
        //默认id使用方法名为user01
        @Bean
        public User user01()
        {
            //User(String name,int age)
            return new User("myName",18);
        }
        
        //指定id
        @Bean("tomcat")
        public Pet pet()
        {
            return new Pet("newPet");
        }
    }
    
`常用的注解属性`  

默认的value属性，表示IOC容器中该对象的id

    //@AliasFor表示别名，@AliasFor标记的属性必须成对存在
    @AliasFor("name")
    String[] value() default {};

    @AliasFor("value")
    String[] name() default {};
    
    
> @Bean高级用法，修改用户在IOC容器中某个对象的bean id并且使其规范化。

    @Bean
    @ConditionalOnBean(AClass.class)
    @ConditionalOnMissingBean(name=iWant)
    public AClass iWant(AClass userClass)
    {
        return userClass;
    }
    //@ConditionalOnBean(AClass.class)会查看IOC容器中是否有Aclass类
    //@ConditionalOnMissingBean(name=iWant)会查看IOC容器中是否有一个叫iWant的bean对象
    //上述两步加起来就是查看是否有一个Aclass类型的bean对象id叫iWant
    
    //@Bean标记的方法会往IOC容器中存入一个对象，而且bean id=方法名，类型为返回值类型
    //无论调用该方法多少次，该对象只会在IOC容器中存在一个(哪怕是你配置类指定proxyBeanMethods=false)。
    
    //当用户传入自己未规范化bean id的IOC容器中对象时，根据上述过程，该对象在容器中的id就会被修改为方法名(方法名使用想要规范化的名字就可以)
    
## 返回IOC容器对象  
ConfigurableApplicationContext 在 ApplicationContext(IOC容器接口)的基础上增加了一系列配置应用上下文的功能。配置应用上下文和控制应用上下文生命周期的方法在此接口中被封装起来，以免客户端程序直接使用。

    ConfigurableApplicationContext run = SpringApplication.run(Main.class,args);
    
    
## @Import  
@Import注解用来帮助我们把一些需要定义为Bean的类导入到IOC容器里面。  

@Import引入普通的类可以帮助我们把普通的类定义为Bean。@Import可以添加在@SpringBootApplication(启动类)、@Configuration(配置类)、@Component(组件类)对应的类上。

@RestController、@Service、@Repository标记的类都属于被@Component标记的组件类。  

@Import标注的要导入的类会在被@Import的类导入IOC容器时同时导入。  


`例`

    @Import({a.b.c.d.class,
             a.b.c.d2.class,....})
             
             
* 类名可以使用简类名(包在java文件中被导入时)，其他时候必须使用全类名。



`注解常使用的变量`  
@Import内部只有一个class类型的数组，表示要被装入IOC容器的类。




## @Conditional
该注解为条件导入注解，用来让标记的类或标记的类中的方法所表示的类在一定条件时才会导入IOC容器中

* @Conditional有很多的子标签，他们可以应用于许多场景的条件导入(为web项目时导入，某个IOC容器中对象存在时导入...)。


* 许多使用用的都是Conditional的子类，而非他本身。

`例，使用ConditionalOnBean，在某个类存在时才导入相关的类进入IOc容器`  


    @Configuration
    @ConditionalOnBean(name = "tom")
    public class MyConfig
    {
        @Bean
        public User user01()
        {
            User zhangsan=new User("zhangsan",18);
            return zhangsan;
        }
    }
    
    //MyConfig这个配置类加载入IOC容器时，当容器中没有tom这个Bean ID的对象时  
    //才生成user01对象存入IOC容器中。

## @ImportResource
该注解用来读取Spring原始的IOC创建配置文件，用原始的XML文件的方式创建对象放到IOC中

该注解标记的类在加载时，会同步解析xml，并把其中的bean对象创建并存入IOC容器中。


`例`

    @Configuration
    @ImportResource("classpath:beans.xml")
    public class MyConfig
    {
        @Bean
        public User user01()
        {
            User zhangsan=new User("zhangsan",18);
            return zhangsan;
        }
    }
    
    //在IOC中创建MyConfig的对象的同时，也会解析beans.xml文件并且创建相关的bean对象。


## @ConfigurationProperties  
该标签可以将标记的类中的部分属性与application.properties中的部分内容相匹配并且可以通过该文件来设置该类相关对象中的部分属性。  

* #### 只有该类对应被加载到容器中后，才能进行对应配置，光标记不加载入容器无法使用配置文件配置。

* #### 该方式支持yml配置，但是yml文件的前缀必须还得是application。


* #### 该注解一般与@EnableConfigurationProperties或是 使用后会加载到Spring IOC容器 中的注解一起使用。

* 该注解只能跟组件注解一起使用。

* 注意要用文件注入成员的对象，不可以存在以属性值为形参的构造函数，存在这样的构造函数代表将要使用自动注入。

* 该注解不为IOC容器中对应的对象命名bean id，其只是决定该对象使用配置文件时的前缀，IOC容器中该对象的bean id由其他有命名功能的注解决定

> 全部属性值

`互为别名的String值，决定了在配置文件中该类对象的前缀`  

    @AliasFor("prefix")
    String value() default "";

    @AliasFor("value")
    String prefix() default "";


`ignoreInvalidFields`  

决定在配置文件中的属性值和对应属性的类型不匹配时，是否忽略且不抛出异常，为true时对应的不匹配属性值为0或null。

    boolean ignoreInvalidFields() default false;

`ignoreUnknownFields`

如果有该对象有未知的属性在配置文件中出现，是否忽略且不抛出异常。

    boolean ignoreUnknownFields() default true;

`例`  

    
    @Component
    @ConfigurationProperties(prefix = "mycar")
    public class Car{
        private String brand;
        private Integer price;
        
        //get,set与toString
        ...
    }
    
    //application.properties文件
    mycar.brand=BYD
    mycar.price=100000
    
    
## @EnableConfigurationProperties
该注解一般标记在配置类上，用于加载被@ConfigurationProperties标记的类到IOC容器中，来让他们的属性可以与配置文件绑定。

> 常用属性值

`默认的value`

    Class<?>[] value() default {};
    
该value用于接受被@ConfigurationProperties标记的类。


`例`

    @ConfigurationProperties(prefix = "mycar")
    public class Car{
        private String brand;
        private Integer price;
        
        //get,set与toString
        ...
    }
    
    //MyConfig.java
    @EnableConfigurationProperties(Car.class)
    public MyConfig{
        ...
    }
    


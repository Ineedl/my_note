## [dubbo标签以及标签中属性配置文档](https://dubbo.apache.org/zh/docs/v3.0/references/xml/)

## 在Spring配置文件中需要的约束文件

    <?xml version="1.0" encoding="UTF-8"?>
    <beans 
       ...
       xmlns:dubbo="http://dubbo.apache.org/schema/dubbo"
       xsi:schemaLocation="
       ...
       http://dubbo.apache.org/schema/dubbo http://dubbo.apache.org/schema/dubbo/dubbo.xsd
       ...">
       
## dubbo应用标识标签
该标签标识一个dubbo应用(服务提供者或是消费者)，应用的命名必须唯一，为dubbo内部使用的唯一标识，一般使用项目名，消费者与服务提供者都要设置。


    <dubbo:application name="your_name" />
    
## 设定访问服务协议的名称及端口号
使用dubbo时，使用的远程接口访问协议为几乎都为dubbo，其一般使用端口为20880。
该标签服务提供者与消费者都要设置。

    <!--访问服务协议的名称及端口号
        name：指定协议名称
        port：指定协议端口号(dubbo协议默认20880)
    -->
    <dubbo:protocol name="dubbo" port="20880"/>
    
## 直连方式的远程接口相关设定(dubbo:reference标签的使用)

* 注意调用接口时的传入的参数对象必须继承了Serializable允许实例化。

* 注意设定都是在Spring配置文件中配置，dubbo的下层使用了Spring的IOC技术。

> 提供者(dubbo:service标签)


    <!--
        暴露服务接口
        interface：暴露服务接口的全限定类名
        ref：接口引用的实现类在spring容器中的标识
        registry：如果不使用注册中心，则值为N/A，直连
    -->
    <!--此处实例的接口为indi.cjh.service.SomeService-->
    <dubbo:service interface="indi.cjh.service.SomeService" ref="myInterface" registry="N/A"/>

    
    <!--将接口的实现类加载到Spring容器中，为上述的ref提供实现类-->
    <!--
        此处实例中indi.cjh.service.SomeService的实现类为
        indi.cjh.service.impl.SomeServiceImpl
    -->
    <bean id="myInterface" class="indi.cjh.service.impl.SomeServiceImpl"/>
    
    
> 消费者(dubbo:reference标签)

    <!--
        引用远程服务接口:
        id:远程服务接口对象名称
        interface:调用远程接口的全限定类名
        url:访问服务接口的地址
        registry:不使用注册中心,值为:N/A
    -->
    <dubbo:reference id="userService" interface="indi.cjh.service.SomeService" url="dubbo://localhost:20880" registry="N/A"/>
    
    
    
## 使用zookeeper注册中心方式的远程接口相关设定

> 提供者(dubbo:service标签)


    <!--
        指定注册中心
        此处使用zookeeper
    -->
    <dubbo:registry address="zookeeper://120.24.243.216:2181" />

    <!--
        暴露服务接口
        interface：暴露服务接口的全限定类名
        ref：接口引用的实现类在spring容器中的标识
        registry：如果不使用注册中心，则值为N/A，直连
    -->
    <dubbo:service interface="indi.cjh.outInterface.MyInterface" ref="userServiceImp" />

    <!--将接口的实现类加载到Spring容器中-->
    <bean id="userServiceImp" class="indi.cjh.Imp.MyInterfaceImp"/>
    
    
> 消费者(dubbo:reference标签)


    <!--指定注册中心-->
    <dubbo:registry address="zookeeper://120.24.243.216:2181" />

    <!--
        远程接口的引用
    -->
    <dubbo:reference id="userService" interface="indi.cjh.outInterface.MyInterface" />
    
    
## 设定之后的使用
设置之后启动dubbo应用，只需要在消费者中调用即可

`例，使用自动注入来调用远程接口`

    //此处使用SpringMVC中的控制类演示
    @Controller
    public class UserController {
    
        //表面上获取了提供者提供的实现类的对象，实际上只是远程调用接口。
        @Autowired
        private SomeService someService;
    
        @RequestMapping(value="/user")
        public String userDetail(Model model , Integer id){
            User user = someService.queryUserById(id);
            model.addAttribute("user",user);
            return "userDetail";
    
        }
    }

## dubbo:reference标签的version字段
dubbo:reference的version字段可以让提供者给同一个接口规定不同的版本，然后消费者根据版本调用同一接口但是实现略有差别的远程功能接口。


> 提供者

    <dubbo:service interface="indi.cjh.outInterface.MyInterface" ref="userServiceImp" version="1.0.0" />
    
    <dubbo:service interface="indi.cjh.outInterface.MyInterface2" ref="userServiceImp" version="2.0.0" />

    <!--将接口的实现类加载到Spring容器中-->
    <bean id="userServiceImp" class="indi.cjh.Imp.MyInterfaceImp"/>
    
    <bean id="userServiceImp2" class="indi.cjh.Imp.MyInterfaceImp"/>
    
    
> 消费者

引用远程接口时，引用过多时，自动注入的@Autowired的byType方式将再次使用byName方式给消费者中的接口服赋值，当接口版本唯一时，@Autowired仍是byType。

    <!--
        远程接口的引用
    -->
    <dubbo:reference id="userService" interface="indi.cjh.outInterface.MyInterface" version="1.0.0" />
    
    <dubbo:reference id="userService2" interface="indi.cjh.outInterface.MyInterface" version="2.0.0" />
    
    
    //使用SpringMVC来使用远程接口
    @Controller
    public class MyController {
    
        @Autowired      //引用声明的id=userService的那个远程接口
        private MyInterface userService;
        
        @Autowired      //引用声明的id=userService2的那个远程接口
        private MyInterface userService2;
    
        @RequestMapping(value="/user")
        public String user(Model model , String name){
            ...
        }
    }

    

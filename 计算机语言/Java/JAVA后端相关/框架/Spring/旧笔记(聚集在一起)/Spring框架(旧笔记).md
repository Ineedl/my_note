## IOC(Inversion of Control，控制反转)

### 概念
IOC的概念是将对象的创建，赋值，管理工作都交给代码之外的容器等来实现，对象的创建由其他外部资源来实现。

* 控制是指对象的构建与兑现之间的关系管理。
* 反转是指把控制的权限转移给代码之外的容器等来实现，由容器等外部资源来代替开发人员构建对象。
* 此处的容器指的是一个软件或是框架等外部资源。

### IOC的作用
* 可以减少代码的改动，在不改动代码的前提下可以增加不同的功能。
* 可以大幅度减少代码的耦合性。

### IOC所使用的技术
IOC使用了DI(Dependency Injection，依赖注入)的技术来实现，使用DI，在需要对象使，只需要在程序中提供要使用的对象名称就可以，赋值，查找等操作全由容器内部实现。

### spring框架的配置文件

* spring配置文件最好有多个分开使用而不是一个用到死，一个文件就相当于一个容器。

#### 主配置文件
* 主配置文件，不定义对象，用来包含其他配置文件
 著配置文件使用import标签来包含其他的配置文件。


    <import resource="其他配置文件路径" />
    <!--classpath表示类路径，当在spring的配置文件中要指定其他文件的位置时，classpath告诉spring去哪加载读取文件-->
    <!--classpath一般是当前项目下的classes目录(类路径)-->
    <import resource="classpath:cjh/other.xml" />
    
* 注意可以使用*等通配符与正则表达式

[配置文件参考](https://note.youdao.com/ynoteshare/index.html?id=ce912af199e1696cf17211b04bc40c18&type=note&_time=1631541891241)



## Spring存放对象的容器的接口ApplicationContext
ApplicationContext本为一个接口，实现了该接口的类该类为Spring框架中存放IOC对象的那个容器。  

### ApplicationContext的两个实现

* FileSystemXmlApplicationContext
该类用于在磁盘其他地方读取Spring框架的配置文件


* ClassPathXmlApplicationContext
该类用于从类路径(项目构建后的classes目录下)中加载spring框架的配置文件

### 创建一个ApplicationContext的实现
    
    String config="Spring框架配置文件在磁盘中的路径";
    ApplicationContext ac = new FileSystemXmlApplicationContext(config);
    
    
    String config="类路径下的Spring框架配置文件";
    ApplicationContext ac = new ClassPathXmlApplicationContext(config);
    
* 上述两个类建立后，其构造函数就通过反射将Spring配置文件中将要创建的类通过反射全部创建完毕并且存储在这两个类的对象中(会调用默认构造方法来构造一个什么属性都没初始化的空对象)。

### 获取Spring配置文件中声明的对象
* public Object getBean(String id)，该方法为ApplicationContext接口的方法。  
该方法通过Spring配置文件中给创建对象赋予的id来获取那个创建的对象。  


    String config="./beans.xml";
    ApplicationContext tmp = new ClassPathXmlApplicationContext(config);
    MyThing thing = (MyThing)tmp.getBean("MyClass1");
    thing.doSome();

### 获取ApplicationContext的实现对象容器中存储的对象个数以及名字

#### 获取对象个数  
public int getBeanDefinitionCount()，该方法为该方法为ApplicationContext接口的方法。  

#### 获取所有对象的名字  
public String[] getBeanDefinitionNams()，该方法为该方法为ApplicationContext接口的方法。  


## 注入
注入即为对spring配置文件的xml文件中的bean声明的对象的属性进行初始化。

注入相关使用请查看实例的spring配置xml文件

### 注入的分类
#### 基于XML的注入
即在XML直接给bean中声明对象赋值，该种注入也分为两种方式。

* set注入  
    Spring通过xml配置文件中的描述，调用类中对应变量的set方法来实现对象的注入。  
    如果没有对应的set方法，那么反射对象时会发生异常。  
    

* 构造注入  
    Spring通过xml配置文件中的描述，调用类的对应构造方法来实现对象的注入。

#### 基于XML的引用类型自动注入

* byName方式自动注入
    Java类中应用类型的属性名和Spring配置文件中的bean中的声明对象的id一致，那么Spring将会把该用bean声明的对象自动赋值给该引用类型属性。

    注意byName注入会根据引用类型属性的名字对应xml文件中对应bean的id来进行属性的注入(大小写必须一致)，
如果对应bean中id名不为属性，则对应引用类型属性不能完成注入。

    另外注意，对应的set函数还是必须要有，其原理中还是调用了set函数。
    
    
* byType方式自动注入
    Java类中应用类型的属性名和Spring配置文件中的bean中的声明对象的class属性是同源关系(父子类关系或同类关系或接口继承关系)，那么Spring将会把这些用bean声明的对象自动赋值给该引用类型属性。

    byType要求属性对应的类形的对象在xml文件中符合条件的只有一个，否则将会报错告诉你有多个同类对象无法选择。

### 基于注解的注入
对于DI使用注解，将不用在Sprinp配置文件中声明bean，只需要在源文件中使用注解标记类，然后再Spring文件中配置组建扫描器就可以扫描注解。 

#### Spring中会使用到的注解

* @Component  
    标记要创建对象的类的注解，该注解只能在类上使用。  
    import org.springframework.stereotype.Component;

    该注解有一个属性(value)，用来表示该类被Spring创建出对象后在Spring容器中使用的ID字符，创建的对象在Spring容器中只有一个。  
    
    之后可以在Spring配置文件中配置组件扫描器，在配置文件被读取时扫描被Component标记的类并创建对象。
    
    Component也可以不传入value参数，此时Spring在导入配置文件后会给创建的对象一个默认名称，为类名的首字母小写版本。
    
    例：
    
        @Component(value = "myTest1")
        public class MyCompoentTest1 {
        }
        
        @Component("myTest2")
        public class MyCompoentTest1 {
        }
        
        @Component
        public class MyCompoentTest1 {
        }

* @Respotory  
    标记要创建对象的类的注解，该注解只能在类上使用，该注解用在持久层(dao)类上，用来创建持久层(dao)的对象(比如数据库访问类的对象)。  

* @Service  
    标记要创建对象的类的注解，该注解只能在类上使用，该注解用在service的实现类上，用来创建service对象。  
    service对象是做业务处理，可以有事务等功能的。  
    用法同Component，但是拥有额外的功能。

* @Controller  
    标记要创建对象的类的注解，该注解只能在类上使用，该注解用在控制器的实现类上，用来创建控制器对象。  
    控制器对象能够接收用户提交的参数，显示请求处理的结果。  

* @Respotory，@Service，@Controller用法同@Component，都是用来创建对象，但是有额外功能，他们是给项目分层的。 @Component用于创建这三个标签之外的类的对象。

* @Value  
* @Autowired  
* @Resource  


#### 对象属性赋值相关注解
* @Value  
    该注解由Spring提供，该注解只有一个参数，用于给用@Respotory，@Service，@Controller，@Component标记的类在被Spring创建对象时给对应的属性赋值.  

    该注解可以放置在属性或set方法上，表示由Spring来创建该对象时，给该对象赋予对应的值，其只能给对象基本类型或String类型的属性赋值。

    注意被@Value标记的单参数方法都会自动调用，无论他返回值类型或名字是否带set，只要他是单参数方法而且对应参数的类型为基本类型与String类型。
    
    使用@Value标记属性时，无需考虑该属性的访问类型。

例：

    @Component(value = "myTest1")
    public class MyCompoentTest1 {
        @Value(value="123456")
        private int nId;
        @Value(value="123456")
    
        private String strName;
        public String toString()
        {
            return strName+nId;
        }
    
        @Value(value="456789")
        public void setStrName(int p)
        {
            System.out.println("--------------");
        }
        
        @Value("456789")    //注解只有value属性时可以不写
        public void other(int p)
        {
            System.out.println("--------2222222------");
        }
    }
    
    
* @Autowired  
    该注解由Spring提供，Autowired有一个唯一参数required。该注解用于给用@Respotory，@Service，@Controller，@Component标记的类在被Spring创建对象时给对应的引用类型属性赋值，其原理使用了XML注入中的自动注入。

    参数required用于标记当使用@Autowired找不到合适的对象的时候程序是否报异常并中止运行，默认为true会报异常并且提示找不到合适的类，如果为false，则在找不到合适对象的时候会将null赋给对应属性，并且本次赋值不会报异常。

    该注解支持byName注入和byType注入，默认使用byType注入。
    当该注解不和@Qualifier一起使用时，为默认。
    
    当使用byName注入，需要加上另外一个注解@Qualifier，@Qualifier有一个唯一参数value，@Qualifier用于根据id寻找在Spring容器中创建的对象，并且把他们赋予用@Autowired标记的属性值。

例：

    //byType方式
    @Component("MyTest2")
    public class MyCompoentTest2 {
    
        @Autowired   
        //此处会在Spring创建的对象里用自动注入的byType寻找一个MyCompoentTest1类对象并赋值给test1;
        //无论对应的对象是用注解创建还是在XML中标记创建
        //不适用@Qualifier注解则为@Autowired的默认使用
        MyCompoentTest1 test1;
    }
    
    
    //byName方式
    
    @Component("MyTest2")
    public class MyCompoentTest2 {
        @Autowired
        @Qualifier("MyTest1")
        //两个标签的位置不做要求，但是一般@Autowired放上面
        MyCompoentTest1 test1;
    }
    
* @Resource
    该注解本为JDk的注解，但是Spring也对其提供了使用支持，其原理也是自动注入，其提供byName注入和byType注入。

    @Resource可以在属性或者set方法上使用。
    
    @Resource默认为byName(以标记属性对应类型名的小写为ID字符串从Spring容器中寻找对应对象)，但是在使用byName找不到对应的对象时，他会使用byType来寻找对象。手动指名byName名称时不会有该效果。手动指名ID字符时，使用其name属性。
    
    
例：

    @Component("MyTest3")
    public class MyCompoentTest3 {
        @Resource
        MyCompoentTest1 test1;
        
        @Resource(name="MyTest1")
        MyCompoentTest1 test1;
        
    }
    
### AOP
#### 定义
AOP(Aspect Orient Programming)即为面向切面编程。切面是指给代理对象的功能方法中增加的非事务方法(非主要功能的操作，但是可以增强业务的部分非主要功能)，这些方法一般可以独立使用，与业务功能无关。

AOP就是一个给业务方法增加功能的一个规范。

#### AOP常用术语
* 切面(Aspect)  
即完成一个非业务功能的一堆代码。

* 连接点(JoinPoint)  
连接点是在应用执行过程中能够插入切面（Aspect）的一个点。这些点可以是调用方法时、甚至修改一个字段时。

* 切入点(Pointcut)  
即你将要具体添加切面功能的业务方法，是一个集合。

* 通知(Advice)  
表示切面的执行时间。

#### 切面的注意点
* 切面功能
* 切面的执行位置(用切入点表示)
* 切面的执行时间(通知)


### aspectJ
aspectJ为当前业界中最适合做AOP的框架，Spring中已集成了该框架

* aspectJ有两种使用方法  
使用注解(常用)  
使用xml配置

#### 注解方式使用aspectJ
注解方式使用aspectJ中需要在xml中使用一个标签(如下原样输入)，来扫描Spring配置文件中标识的所有类(包括切面类)，然后再通过标识类中的aspectJ相关注解来寻找要被目标类，并且生成其代理。

<aop:aspectj-autoproxy />

* 扫描与代理对象的生成由Spring框架来完成，只需要输入该标签即可

* 在Spring配置文件中标识的类生成代理对象后，再通过IOT获取对象(getBean)时，如果对应类有代理对象，则获得其代理对象。

* Spring中自动生成代理对象得原理使用的就是JDK中代理对象的生成。(com.sun.proxy.$Proxy?类)  
如同下面的实例，获取getBean返回对象的类型时，会发现其返回的不是被代理对象的类型。



    //applicationContext.xml
    ....
    <bean id="MyImpl" class="indi.cjh.MyImpl.MyImpl" />

    <bean id="MyAspect" class="indi.cjh.MyImpl.MyAspect" />

    <aop:aspectj-autoproxy />
    ....
    
    @Test
    public void test01()
    {

        String config="applicationContext.xml";
        ApplicationContext tmp = new ClassPathXmlApplicationContext(config);
        MyInterface tmpImpl = (MyInterface)tmp.getBean("MyImpl");
        System.out.println("返回对象类型："+tmpImpl.getClass());

    }
    
    //output
    返回对象类型：class com.sun.proxy.$Proxy6

##### 切面类
* 切面类使用Aspect注解来表示一个切面类，切面类用来存放切面功能。

例：

    import org.aspectj.lang.annotation.Aspect;
    
    @Aspect
    class Aspect
    {
        @Before(value="execution(public void indi.cjh.MyImpl.MyImpl.doSome(..))")
        public void myBefore()
        {
            System.out.println("切面功能before");
        }
    }
    
    
##### 执行位置  

执行位置使用切入点表达式来实现，切入点表达式使用在执行时间的注解的属性中

格式：

    execution(访问权限 方法返回值类型 包名类名全称+方法名(参数类型和参数个数) 抛出异常类型)
    
* 一般包名类名全称不会写，但是其常和方法名连在一起写，故这里使用+号

* 其中，访问权限，包名类名全称，抛出异常类型可以不要
    
* 该式一共有四部分，访问权限，方法返回值类型，想要增强的业务方法，会抛出的异常类型
    
* 该表达式中常用如下三个通配符：  

| 符号 | 作用 |
| :------| :------ |
| * | 匹配0或多个字符 |
| .. | 用在方法参数中，表示任意多个参数，用在包名后表示当前包及其子包路径 |
| + | 用在类名后表示当前类及其子类，用在接口后表示当前接口以及其实现类 |

* 式子举例：


    execution(public * *(..)) 
    //所有public方法都可以作为切入点
    
    execution(* set*(..))   
    //所有名字为set开头的方法都可以作为切入点
    
    execution(* com.cjh.*.*(..))   
    //com.cjh包下的所有类与接口的方法都可以作为切入点
    
    execution(* com.cjh..*.*(..))   
    //com.cjh包下以及其子包下的的所有类与接口的方法都可以作为切入点
    
    execution(* *..cjh.*.*(..))   
    //所有包下的cjh子包中的所有类与接口中的所有方法都可作为切入点
    
    execution(* *.cjh.*.*(..))   
    //一级包下所有cjh包中的所有类的方法都可以作为切入点
    

##### 执行时间  

用于决定切面的执行时间(通知，也叫增强)的常用五个注解,这五个注解表示了五个执行时间。

@Before  
@AfterReturning  
@Around  
@AfterThrowing  
@After  

这些注解都用于切面方法上，用来表示该切面方法何时执行

* Before，前置通知，在业务方法执行前会执行该切面功能  

    Before常用value属性，该属性输入切入点表达式来决定该注解标记的方法为哪个方法服务。

    前置通知的使用有这些硬性要求：切面方法为public，无返回值，参数可有可无(有时参数为固定的，不能为自定义)


    public class MyImpl implements MyInterface {
        @Override
        public void doSome(String name, int id) {
            System.out.println(name+"---"+id);
        }

    }
    
    class ..
    {
        
        @Before(value="execution(public void indi.cjh.MyImpl.MyImpl.doSome(..))")
        public void myBefore(JoinPoint t)
        {
            System.out.println("切面功能before");
        }
        
    }

* AfterReturning，后置通知，在业务方法执行后会执行该切面功能  

    AfterReturning常用value属性与returning    
    
    value属性，自定义变量，输入切入点表达式来决定该注解标记的方法为哪个方法服务。  
    
    returning属性，自定义变量标识通知方法的返回值，该属性的值必须和通知方法的形参名一样。
    
    后置通知的使用有这些硬性要求：切面方法为public，无返回值，必须有一个自定义参数(推荐该自定义参数类型为Object,不包括一个JoinPoint类型)。该自定义参数存放业务方法运行后的返回值，同时和该注解的returning属性配合使用。

    AfterReturning能够捕捉到业务方法的返回值,并且对其进行修改(注意，基本类型和没有对对象内部数据的修改不生效，这个原理是因为Java中的类的赋值都是引用)。修改需谨慎，因为切面只是增强而不是改变功能。
    
    
    
    public class MyClass {
        public int a;
        public MyClass()
        {
            a=0;
        }
    }
    
    public class MyImpl implements MyInterface {
        @Override
        public MyClass doSome2()
        {
            return new MyClass();
        }
    }
    
    class ..
    {
        
        @AfterReturning(value="execution(public MyClass indi.cjh.MyImpl.MyImpl.doSome2(..))",
        returning = "thatReturn")
        public void myAfter(Object thatReturn)
        {
            ((MyClass)thatReturn).a=10;
        }
        
    }

* Around，环绕通知   
    该通知功能最强，可以修改业务方法的返回值(该注解标记方法的返回值就是业务方法的返回值)，他在业务方法的前后都可以增强功能，而且其可以决定业务方法是否被调用。

    环绕通知相当于JDk动态代理中的InvocationHandler接口实现类。

    环绕通知的使用有这些硬性要求：切面方法为public，有返回值，该返回值类型必须和业务方法的一致，必须有一个自定义参数类型为ProceedingJoinPoint(该类继承自JoinPoint接口，可以当作JoinPoint使用)。
    
    注意，环绕通知的返回值就是业务方法的返回值，故环绕通知可以随意修改业务方法的返回值，而不是像After那样只能改引用对象内部的值。
    
    Around常用value属性，该属性输入切入点表达式来决定该注解标记的方法为哪个方法服务。
    
    Around标记方法中的ProceedingJoinPoint相当于Method类可以决定何时调用业务方法，以及怎么调用。
    
    Around通知相当于是把业务方法的整个调用给拦截了，业务方法的调用只是环绕通知中的一个方法调用。
    
    
    public class MyImpl implements MyInterface {
        @Override
        public String doSome3()
        {
    
            return "66666";
        }
    }
    
    @Around(value="execution(public String indi.cjh.MyImpl.MyImpl.doSome3(..))")
    public String myround(ProceedingJoinPoint thatReturn) throws Throwable
    {
        //调用业务方法
        Object tmp = thatReturn.proceed();

        return  tmp+"123";
    }
    
    
    //------------------------，改参数调用版本
    public class MyImpl implements MyInterface {
        @Override
        public String doSome3(String tp)
        {
            tp="666666";
            return tp;
        }
    }
    
    @Around(value="execution(public String indi.cjh.MyImpl.MyImpl.doSome3(..))")
    public String myround(ProceedingJoinPoint thatReturn) throws Throwable
    {
        Object[] tmp2= new Object[1];
        tmp2[0]="4567";
        Object tmp = thatReturn.proceed(tmp2);

        return  tmp+"123";
    }
    
    
    
#### JoinPoint 
JoinPoint为自定义切面方法中的一个自定义参数，该类里面蕴含了业务方法的相关信息，切面方法的该参数的赋值由框架来完成，用户只需要在切面方法中使用它并知道其含业务方法的相关信息有即可。

* JoinPoint在所有通知中都能使用，但是必须放在所有通知注解标注的方法参数中的第一位

常用以下三个方法来获取对应业务方法的信息。

* public Signature getSignature()，该方法为JoinPoint的方法  
该方法将会获取一个Signature对象，Signature存储了方法相关信息。Signature类实现了toString，直接打印可以获得该方法的全部定义。

* public String getName()，该方法为Signature的方法  
返回对应方法名

* public Object[] getArgs()，该方法为JoinPoint的方法  
获取所有对应参数的传入值(注意是业务方法执行前传入的值，不是参数类型和参数名)

例：

        @AfterReturning(value="execution(public MyClass indi.cjh.MyImpl.MyImpl.doSome2(..))",
        returning = "thatReturn")
        public void myAfter(JoinPoint point,Object thatReturn)
        {
            ((MyClass)thatReturn).a=10;
        }
        
        
        @Before(value="execution(public void indi.cjh.MyImpl.MyImpl.doSome(..))")
        public void myBefore(JoinPoint t)
        {
            System.out.println("切面功能before");
        }
        
#### ProceedingJoinPoint
ProceedingJoinPoint同JoinPoint，其继承了JoinPoint接口，同时增加了方法调用的功能，提供了两个调用业务方法的方法。

* Object proceed() throws Throwable，该方法为ProceedingJoinPoint的方法  
以传入业务方法的参数来调用业务方法。

* Object proceed(Object[] var1) throws Throwable，该方法为ProceedingJoinPoint的方法  
以传入该方法的参数来调用业务方法。



##### 一个完整的增加切面例子

    //MyInterface.java      MyInterface接口
    package indi.cjh.MyInterface;

    public interface MyInterface {
        void doSome(String name,int id);
    }

    
    //MyAspect.java    切面类
    package indi.cjh.MyImpl;

    import org.aspectj.lang.annotation.Aspect;
    import org.aspectj.lang.annotation.Before;
    
    @Aspect
    public class MyAspect {
    
            @Before(value="execution(public void indi.cjh.MyImpl.MyImpl.doSome(..))")
            public void myBefore()
            {
                System.out.println("切面功能before");
            }
    }
    
    //myImpl.java       目标对象
    package indi.cjh.MyImpl;

    import indi.cjh.MyInterface.MyInterface;
    
    public class MyImpl implements MyInterface {
        @Override
        public void doSome(String name, int id) {
            System.out.println(name+"---"+id);
        }
    }
    
    
    //测试类               
    @Test
    public void test01()
    {

        String config="applicationContext.xml";
        ApplicationContext tmp = new ClassPathXmlApplicationContext(config);
        MyInterface tmpImpl = (MyInterface)tmp.getBean("MyImpl");
        tmpImpl.doSome("cjh",16);

    }
    
    //spring配置文件中
    //applicationContext.xml
    ....
    <bean id="MyImpl" class="indi.cjh.MyImpl.MyImpl" />

    <bean id="MyAspect" class="indi.cjh.MyImpl.MyAspect" />

    <aop:aspectj-autoproxy />
    ....


### 解耦合标签
* <context:property-placeholder location="classpath:......." />

classpath为类路径

该标签可以让你指定一个文件，可以在该文件中中定义变量然后在源代码中用${变量名}调用

例：
    
    //bean.xml
    * <context:property-placeholder location="classpath:a.propertios" />
    
    //a.propertios
    myname=123
    other=456
    
    //A.java
    @Component("A")
    public class A {
        @Value("${other}")
        private name;
        
        @Value("${myname}")
        private id;
        
    }
    
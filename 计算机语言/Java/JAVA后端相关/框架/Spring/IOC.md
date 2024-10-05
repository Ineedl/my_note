## IOC(Inversion of Control，控制反转)

## 概念
IOC的概念是将对象的创建，赋值，管理工作都交给代码之外的容器等来实现，对象的创建由其他外部资源来实现。

* 控制是指对象的构建与兑现之间的关系管理。
* 反转是指把控制的权限转移给代码之外的容器等来实现，由容器等外部资源来代替开发人员构建对象。
* 此处的容器指的是一个软件或是框架等外部资源。

## IOC的作用
* 可以减少代码的改动，在不改动代码的前提下可以增加不同的功能。
* 可以大幅度减少代码的耦合性。

## IOC所使用的技术
IOC使用了DI(Dependency Injection，依赖注入)的技术来实现，使用DI，在需要对象时，只需要在程序中提供要使用的对象名称就可以，赋值，查找等操作全由容器内部实现。

## spring框架的配置文件

* spring配置文件最好有多个分开使用而不是一个用到死，一个文件就相当于一个容器。

### 主配置文件
* 主配置文件，不定义对象，用来包含其他配置文件
 著配置文件使用import标签来包含其他的配置文件。


    <import resource="其他配置文件路径" />
    <!--classpath表示类路径，当在spring的配置文件中要指定其他文件的位置时，classpath告诉spring去哪加载读取文件-->
    <!--classpath一般是当前项目下的classes目录(类路径)-->
    <import resource="classpath:cjh/other.xml" />
    
* 注意可以使用*等通配符与正则表达式

[配置文件参考](https://note.youdao.com/ynoteshare/index.html?id=ce912af199e1696cf17211b04bc40c18&type=note&_time=1631541891241)



## Spring存放对象的容器的接口ApplicationContext
ApplicationContext本为一个接口，实现了该接口的类的对象为Spring框架中存放对象的那个IOC容器。  

`ApplicationContext接口导包`

    import org.springframework.context.ApplicationContext;

### ApplicationContext的两个实现

`导包`

    import org.springframework.context.support.ClassPathXmlApplicationContext; 

or

    import org.springframework.context.support.FileSystemXmlApplicationContext;

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

### XML对象的引用类型属性的值的自动注入方式

* byName方式自动注入
    Java类中引用类型的属性名和Spring配置文件中的bean中或是标记注解中的声明对象的id一致，那么Spring将会把该用bean声明的对象自动赋值给该引用类型属性。

    注意byName注入会根据引用类型属性的名字对应xml文件中对应bean的id来进行属性的注入(大小写必须一致)，
如果对应bean中id名不为属性，则对应引用类型属性不能完成注入。

    另外注意，对应的set函数还是必须要有，其原理中还是调用了set函数。
    
    
* byType方式自动注入
    Java类中应用类型的属性名和Spring配置文件中的bean中的声明对象或是标记注解标记类的class属性是同源关系(父子类关系或同类关系或接口继承关系)，那么Spring将会把这些标记对象对象自动赋值给该引用类型属性。

    byType注入不会对属性名称进行判断；而@Autowired当找到有多个此类型的Bean时，会再按照属性名进行筛选。

    byType要求属性对应的类形的对象在xml文件中符合条件的只有一个，否则将会报错告诉你有多个同类对象无法选择。

    

## 注入的分类
### 基于XML的注入
`基于XML的注入`  
即在XML直接给bean中声明对象赋值，该种注入也分为两种方式。

* set注入  
    Spring通过xml配置文件中的描述，调用类中对应变量的set方法来实现对象的注入。  
    如果没有对应的set方法，那么反射对象时会发生异常。  
    

* 构造注入  
    Spring通过xml配置文件中的描述，调用类的对应构造方法来实现对象的注入。


### 基于注解的注入
对于DI使用注解，将不用在Sprinp配置文件中声明bean，只需要在源文件中使用注解标记类，然后再Spring文件中配置组建扫描器就可以扫描注解。 

#### 使用到的注解
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

* @Value，@Autowired，@Resource用于IOC对象的属性赋值。

> @Respotory，@Service，@Controller用法同@Component，他们只是用来标识不同功能的类，在功能上几乎一致。 @Component用于创建这三个标签之外的类的对象。

`该四个注解都不能互相共存而且不能重复存在以来让某个类型拥有多个对象在IOC容器中，该方式无法对同一个类型创建多个对象存入IOC容器。`

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
    当该注解不和@Qualifier一起使用时，为默认使用byType。
    
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
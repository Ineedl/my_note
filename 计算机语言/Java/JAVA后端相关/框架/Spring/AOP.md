## AOP
### 定义
AOP(Aspect Orient Programming)即为面向切面编程。切面是指给代理对象的功能方法中增加的非事务方法(非主要功能的操作，但是可以增强业务的部分非主要功能)，这些方法一般可以独立使用，与业务功能无关。

AOP就是一个给业务方法增加功能的一个规范。

### AOP常用术语
* 切面(Aspect)  
即完成一个非业务功能的一堆代码。

* 连接点(JoinPoint)  
连接点是在应用执行过程中能够插入切面（Aspect）的一个点。这些点可以是调用方法时、甚至修改一个字段时。

* 切入点(Pointcut)  
即你将要具体添加切面功能的业务方法，是一个集合。

* 通知(Advice)  
表示切面的执行时间。

### 切面的注意点
* 切面功能
* 切面的执行位置(用切入点表示)
* 切面的执行时间(通知)


### aspectJ
aspectJ为当前业界中最适合做AOP的框架，Spring中已集成了该框架

* aspectJ有两种使用方法  
使用注解(常用)  
使用xml配置

#### 注解方式使用aspectJ
注解方式使用aspectJ中需要在Spring的配置文件xml中使用一个标签(如下原样输入)，来扫描Spring配置文件中标识的所有类(包括切面类)，然后再通过标识类中的aspectJ相关注解来寻找要被目标类，并且生成其代理。(注意，只有对切面类生成代理对象)

    <aop:aspectj-autoproxy />

将Spring配置文件中的标签


    <aop:aspectj-autoproxy />
    
改为
    
    <aop:aspectj-autoproxy proxy-target-class="true" />
    
可以让Spring内部的aspectJ全部使用cglib框架的代理方式。

* aspectJ在目标类没有实现接口仅仅只是代理某个类的时候，使用的时cglib框架代理方式。  

* aspectJ在目标类实现了接口时使用的时JDk内部动态代理方式。  

* JDK动态代理要比cglib代理执行速度快，但性能不如cglib好。所以在选择用哪种代理还是要看具体情况，一般单例模式用cglib比较好。

* 扫描与代理对象的生成由Spring框架来完成，只需要输入该标签即可

* 在Spring配置文件中标识的类生成代理对象后，再通过IOT获取对象(getBean)时，如果对应类有代理对象，则获得其代理对象。

* Spring中自动生成代理对象得原理使用的就是JDK中代理对象的生成。(com.sun.proxy.$Proxy?类)，不使用<aop:aspectj-autoproxy proxy-target-class="true" />标签时，返回的对象的类型确是原类型。

`实例`

获取getBean返回对象的类型时，会发现其返回的不是被代理对象的类型。



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

    Around通知相当于是把业务方法的整个调用给拦截了，业务方法的调用只是环绕通知中的一个方法调用。
    
    该通知功能最强，可以修改业务方法的返回值(该注解标记方法的返回值就是业务方法的返回值)，他在业务方法的前后都可以增强功能，而且其可以决定业务方法是否被调用。
    
    注意，环绕通知的返回值就是业务方法的返回值，故环绕通知可以随意修改业务方法的返回值，而不是像After那样只能改引用对象内部的值。
    
    Around常用value属性，该属性输入切入点表达式来决定该注解标记的方法为哪个方法服务。

    环绕通知的使用相当于JDk动态代理中的InvocationHandler接口实现类。

    环绕通知的使用有这些硬性要求：切面方法为public，有返回值，该返回值类型必须和业务方法的一致，必须有一个自定义参数类型为ProceedingJoinPoint(该类继承自JoinPoint接口，可以当作JoinPoint使用)。
    
    Around标记方法中的ProceedingJoinPoint相当于Method类可以决定何时调用业务方法，以及怎么调用。
    
    
    
    
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
    
* AfterThrowing，异常通知

    该注解标注的方法在其指定的业务方法抛出异常时，会调用该方法。
    
    AfterThrowing用法同Before，而且其标注方法的参数定义也与Before一样(可以定义一个JoinPoint参数，也可以不要参数)，同时该注解的属性使用也同Before，可以说AfterThrowing就是一个在业务方法发生异常时会才会调用的方法的Before标注。
    
    AfterThrowing常用于监控业务方法。
    
* After，最终通知  
    
    该注解无论目标业务方法是否执行成功，只要他执行完毕(哪怕是抛出异常后返回)，该注解标记的方法都会被自动调用。

    After用法同Before，而且其标注方法的参数定义也与Before一样(可以定义一个JoinPoint参数，也可以不要参数)，同时该注解的属性使用也同Before，可以说After就是一个在业务方法运行完毕后，无论如何都会调用标注方法的Before标注。
    
    After标注常用于资源的释放和清除。
    
#### Pointcut标注
Pointcut用于定义一个简单的方法名字给通知标注的切入点表达式来使用。   
Poincut用于管理切入点。
    
Pointcut有一个常用属性value，用于输入切入点表达式。

Pointcut给其value属性赋予切入点表达式后，其标注的方法就是该切入点表达式的一个别名了。


例：

    //之后再通知表达式中可以直接使用mypt来代表该切入点表达式
    @Pointcut(value="execution(public String indi.cjh.MyImpl.MyImpl.doSome3(..))")
    public void mypt()
    {
        
    }
    
    @Around(value="mypt()") //注意要括号
    public String myround(ProceedingJoinPoint thatReturn) throws Throwable
    {
        //调用业务方法
        Object tmp = thatReturn.proceed();

        return  tmp+"123";
    }
    
    
    @AfterReturning(value="mypt()",
        returning = "thatReturn")
        public void myAfter(Object thatReturn)
        {
            ((MyClass)thatReturn).a=10;
        }
        
        
    一般Pointcut的重命名与访问类型无关，标注的方法最好为private，因为这个满足了OOP中迪米特法则.

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

注意该两个方法都会抛出Throwable异常。



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
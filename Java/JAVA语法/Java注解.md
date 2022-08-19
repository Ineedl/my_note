### 意义
注解属于一种引用数据类型，编译后也会生成.class文件

### 注解的定义

    [修饰符列表] @interface 注解名
    {
    
    }

* 注解使用时格式


        @注解名

* 注解可以出现在类上，方法上，属性上，变量上，注解上，接口上，枚举上等


    @myZhujie
    public class test
    {
        @myZhujie
        private int no;
        
        @myZhujie
        public test(@myZhujie
                    String name)
        {
        };
        
        @myZhujie
        public void m{};
    }
    
### JDK中常用注解
#### java.lang下的两种常用注解
* @Override
* @Deprecated

##### @Override
Override只能注解方法，切该注解给编译器参考，与运行阶段无关。
Override注解的方法必须是重写父类的方法。

##### @Deprecated
@Deprecated表示被注解的东西过时了(划掉，而且编译后会被警告)  
Deprecated可以注解所有的东西

#### 常用元注解
元注解是用来注解 注解 的注解

* @Target
* @Retention
* @Inherited

##### @Target
Target用来标注注解，其限定了被标注的注解只能出现在哪

@Target(ElementType.METHOD) 表示该注解只能标注在方法上  
更多类型详情剑ElementType枚举

@Target(value={CONSTRUCTOR,FIELD,LOCAL_VARIABLE,METHOD,PACKAGE,MODULE,PARAMETER,TYPE})，Target注解只有value属性，其实可以省略  
表示该注解可以出现在一些成分上

##### @Retention
Retention用来标注被标注的注解最终保留在什么地方


(枚举RetentionPolicy有三个枚举值)  
@Retention(RetentionPolicy.SOURCE) 表示注解保留在java源文件中

@Retention(RetentionPolicy.CLASS) 表示该注解被保存在class文件中

@Retention(RetentionPolicy.RUNTIME) 表示该注解保存在class文件中而且可以用反射机制读取

##### @Inherited
@Inherited作用是，使用此注解声明出来的自定义注解，在使用此自定义注解时，如果注解在类上面时，子类会自动继承此注解，否则的话，子类不会继承此注解。


#### 常见的@Documented
@Documented注解只是用来做标识，没什么实际作用。  

在自定义注解的时候可以使用@Documented来进行标注，如果使用@Documented标注了，在生成javadoc的时候就会把@Documented注解给显示出来。

### 注解中的属性
* 在注解中定义属性时，属性后得加括号  


    public @interface myZhujie
    {
        String name();
        int color();
        int age default 25;//属性默认值
    }

* 属性中的类型只能为基本数据类型与Class和String类型以及他们的数组，其他类型一律不行

* 如果注解有属性在使用时必须给注解赋值，否则会报错，除非某些属性有默认值


    @MyZhujie(name = "123",color = 6)
    class test
    {
        
    }

* 如果注解只有一个属性且该属性的名字为value，则可以省略属性名

    public @interface myZhujie
    {
        int value();
    }
    
    @MyZhujie(6)
    class test
    {
        
    }
    
    public @interface myZhujie
    {
        int value();
        String name();
    }
    
    @MyZhujie(value = 6,name = "1230")  //必须写全
    class test
    {
        
    }
    
* 注解数组类型赋值


    public @interface myZhujie
    {
        int[] value();
    }
    @MyZhujie(value = {1,2,3,4,5,6})
    

### 注解的作用
* 用注解与反射区分某个类或是属性或是方法或是变量是否正常
    例：给一些类打上注解，并且通过反射来查看这些类是否有某个必须名字的变量(比如String的ID,String的password)，如果没有就程序中报错
        
    例：
    
    @HaveID
    class A
    {
        int id;   
    }
    
    @HaveID
    class B
    {
        
    }
    //之后通过反射检查A和B是否有成员变量ID，没有程序直接报异常
    
* 提供代码观赏性
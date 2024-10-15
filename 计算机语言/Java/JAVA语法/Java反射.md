# 目录
## [反射相关类](#反射机制相关的类)

## [Class](#class类)
* [获取Class对象](#获取class类)
* [获取类的名称](#获取简单类名和带包全类名)
    
## [Field](#field类)
* [获取类的全部属性](#获取一个类的全部属性)
* [获取属性名字](#获取属性的名字)
* [获取对应属性的类型](#获取一个属性的类型)
* [获取对应属性的修饰符](#获取某个属性前面的修饰符)

## [Method](#method类)
* [获取类的全部方法](#获取一个类的全部方法)
* [获取类的一个指定方法](#获取一个类的某个方法)
* [获取类的方法的名字](#获取方法的名字)
* [获取方法的返回值类型名](#获取方法的返回值类型)
* [获取对应方法前面的修饰符](#获取某个方法前面的修饰符)
* [获取对应方法的参数列表](#获取方法的参数列表)

## [Constructor](#constructor类)
* [获取一个类的全部构造](#获取一个类的全部构造方法)
* [获取构造方法前的修饰符](#获取某个构造方法前面的修饰符)
* [获取构造的参数列表](#获取构造方法的参数列表)   
* [使用Constructor反射一个对象](#通过constructor反射创建一个对象)

## [获取类的父类](#获取一个类的父类)

## [获取类的实现接口](#获取类实现的接口)

## [注解的反射](#反射注解)
* [获取注解的Class](#获取注解)
* [获取注解中的属性](#获取注解对象的属性)

## [反射的应用与作用](#反射的作用)

## [更多接口请查询api文档中java.lang.reflect包下相关类以及java.lang.Class](https://docs.oracle.com/javase/8/docs/api/)

----------------------------------------------

### 反射机制相关的类
* java.lang.Class   包含了一个类的所有信息
* java.lang.reflect.Method  包含了一个类中所有方法的信息(构造方法不算)
* java.lang.reflect.Constructor 包含了一个类中所有构造方法的信息
* java.lang.reflect.Field 包含了一个类中所有属性的信息(成员变量)


* 反射机制相关类所需要的包 java.lang.reflect.*

### Class类
##### 获取Class类

1.public static Class forName(String className)，Class类的静态方法

该方法会导致类加载

例：

    //className必须是一个完整的带包的类名    
    Class c1 = Class.forName("java.lang.String")

forName方法在没有找到类的时候会抛出一个 类未找到异常(反射中定义的异常)


2.public Class getClass()，Object类的方法

例：
    
    String s = "abc";
    Class x = s.getClass();

3.所有的类型都有一个class成员变量(Class class)存放Class对象

例：
    
    Class c = String.class;
    Class k=int.class;
    Class dob=double.class;

* java所有类型，包括基本类型都有Class类型(包括基本类型，入上述例子所示)

* 注意每个类的Class对象在装在到JVM里面时只装载一份，故某个类的不同对象获取到的Class对象和forName获取到的Class对象都是一个

例：

    Class c1 = Class.forName("java.lang.String")
    String s = "abc";
    Class C2 = s.getClass();
    System.out.rpintln(c1==c2) //返回true
    
##### 获取简单类名和带包全类名
* public String getName()，Class类方法，获取全类名
* public String getSimpleName()，Class类方法，获取简单类名
    
##### 通过反射实例化对象
* public Object newInstance()，Class类的方法，该方法已在JDK.9弃用

该函数会使用类的无参数构造方法实例化一个对象，如果没有无参构造函数，则会抛出异常，注意该方法会抛出异常，要正常使用该方法必须拥有无参构造或无构造函数

例：

    Class c = Class.forName("com.cjh.myClass");
    Object obj = c.newInstance();
    
### Field类
##### 获取一个类的全部属性
* public Field[] getFields()，该方法为Class类的方法  
该方法只能获取public属性  

例：

    Class myClass=Class.forName(com.cjh.myClass);
    Field[] fields=myClass.getFields();
    
* public Field[] getDeclaredFields()，该方法为Class类的方法
该方法可以获取一个类中的全部属性(包括private和protected属性)

例：

    Class myClass=Class.forName(com.cjh.myClass);
    Field[] fields=myClass.getDeclaredFields();

##### 获取属性的名字
* public String getName()，该方法为Field类的方法

##### 获取一个属性的类型    
* public Class getType()，该方法为Field类的方法

例：
    
    //获取属性类型
    Class tmpClass = Field.getType();
    String type = tmpClass.getName();

##### 获取某个属性前面的修饰符
修饰符是指public,static,final等
* public int getModifiers()，该方法为Field类的方法
* public static String toString()，该方法为Modifier类的方法
* 该方法根据修饰符，返回一个数字，之后再通过Modifier类的toString转换为可视前缀

例：

    int nTmp = fields[0].getModifiers();
    String strTmp = Modifier.toString(nTmp);

### Method类
##### 获取一个类的全部方法
* public Method[] getMethods()，该方法为Class类的方法  
该方法只能获取public方法  

例：

    Class myClass=Class.forName(com.cjh.myClass);
    Field[] Methods=myClass.getMethods();
    
* public Field[] getDeclaredMethods()，该方法为Class类的方法
该方法可以获取一个类中的全部方法(包括private和protected方法，不包括构造方法)

例：

    Class myClass=Class.forName(com.cjh.myClass);
    Field[] Methods=myClass.getDeclaredMethods();

##### 获取一个类的某个方法
* public Method getDeclaredMethod(String methodName,Class... class)，该方法为Class的方法

例：

    Method myMethod  = myClass.getDeclaredMethod("login",int.class,String.class);

##### 获取方法的名字
* public String getName()，该方法为Method类的方法

##### 获取方法的返回值类型
* public Class getReturnType()，该方法为Method类的方法

例：
    
    //获取属性类型
    Class tmpClass = myMethod.getReturnType();
    String type = tmpClass.getName();
    
##### 获取某个方法前面的修饰符
修饰符是指public,static,final等
* public int getModifiers()，该方法为Method类的方法
* public static String toString()，该方法为Modifier类的方法
* 该方法根据修饰符，返回一个数字，之后再通过Modifier类的toString转换为可视前缀

例：

    int nTmp = method[0].getModifiers();
    String strTmp = Modifier.toString(nTmp);
    
##### 获取方法的参数列表   
* public Class[] getParameterTypes()，该方法为Method类的方法  
之后就可以通过getName获取类型

### Constructor类
##### 获取一个类的全部构造方法
* public Constructor[] getDeclaredConstructors(),该方法为Class类方法  
获取一个类的全部构造方法

##### 获取某个构造方法前面的修饰符
修饰符是指public,static,final等
* public int getModifiers()，该方法为Constructor类的方法
* public static String toString()，该方法为Modifier类的方法
* 该方法根据修饰符，返回一个数字，之后再通过Modifier类的toString转换为可视前缀

例：

    int nTmp = constructors[0].getModifiers();
    String strTmp = Modifier.toString(nTmp);

##### 获取构造方法的参数列表   
* public Class[] getParameterTypes()，该方法为Constructor类的方法  
之后就可以通过getName获取类型

##### 通过Constructor反射创建一个对象
通过Constructor创建对象可以使用无参构造也可以使用有参构造
* public Constructor getDeclaredConstructor(Class... args)，Class类的方法
* public Constructor getDeclaredConstructor()，Class类的方法
* public Object newInstance(Object... args)，Constructor类的方法
* public Object newInstance()，Constructor类的方法

使用无参的反射构造函数时，该类如果没有无参构造函数，则会抛出异常，注意该方法会抛出异常，要正常使用该方法必须拥有无参构造或无构造函数

例：

    Class c = Class.forName("com.cjh.myClass");
    Constructor con = c.getDeclaredConstructor(int.class);
    Object newObj = con.newInstance(150);

### 获取一个类的父类
* public Class getSuperclass()，该类为Class的方法

### 获取类实现的接口
* public Class[] getInterfaces()，该类为Class的方法，注意接口也有class对象

### 反射注解
注意，注解可能在方法或是变量或是属性或类上，在哪个上面就对对应的对象(Constructor，Class，Method，Field)进行判断

##### 获取注解
* public bool isAnnotationPresent(Class class)，该方法为Class的方法  
用来判断class这个注解是否存在于调用的Class上(注解也有Class对象)

* public Object getAnnotation(Class class)，该方法为Class的方法  
用于获取调用Class的上的注解的Class

例：

    //Test类上使用了注解@MyZhujie
    Class c = Class.forName("com.cjh.Test");
    MyZhujie tmpZhujie = (MyZhujie)c.getAnnotation(MyZhujie.class)

##### 获取注解对象的属性
直接对注解对象使用.属性()(相当于使用类中public属性，也很像C#中的属性访问器)


### 反射的作用
* 可以通过文件来动态创建需要的类：  
    把类名写入文件，然后可以通过读取文件动态创建一个类。
* 使用Class的forName函数，手动加载某个类中的静态代码块  

例：


    public static void main(String[] args)
    {
        try{
            Class.forName("com.cjh.myClass");
        }catch(ClassNotFoundException e)
        {
            e.printStackTrace();
        }
    }
    
    class myClass
    {
        static{
            System.out.println("myClass类静态代码已执行");
        }
    }

* 可以通过反射把一个类给模拟出来，获取某个类的全部方法和属性后，直接映射为字符串然后把类写入文档，当然只能获得属性和方法名，不能获得其实现原理。


* 通过反射设置对象的变量值  
    public void set(Object obj,T value)，该函数为Field的方法，拥有很多的重载，该方法无法设置public以及默认权限以外的属性。  
    public void setAccessible(bool b)，该方法为Field的方法，该方法设置true可以打破权限封装。

例：

    //设置有访问权限的变量
    Object myObj=myClass.newInstance();
    Field[] Fields=myClass.getDeclaredFields();
    //假设Fileds[0]对应类型为int
    Fileds[0].set(myObj,12);
    
    //设置无访问权限的变量
    Object myObj=myClass.newInstance();
    Field[] Fields=myClass.getDeclaredFields();
    Fields[0].setAccessible(true);
    //假设Fileds[0]对应类型为int
    Fileds[0].set(myObj,12);

* 通过反射机制调用一个对象的方法
    public Object invoke(Object obj,Object... args)，该方法为Method的方法

例：

    Object myObj=myClass.newInstance();
    Method myMethod  = myClass.getDeclaredMethod("login",int.class,String.class);//
    Object returnValue = myMethod.invoke(myObj,1,"1234");

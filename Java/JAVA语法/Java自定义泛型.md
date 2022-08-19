## 语法
    class class_name<typeName1,typeName2,...> {
        public typeName1 testFun()
        {
            return new typeName1();
        }
    }

* 泛型不可以是基本类型，必须为引用类型。

> 一般来讲使用如下的两个字母来表示类型

    E   元素
    T   类型


## <?>
?是通配符,泛指所有类型，同时在使用泛型时，?也可以限制类的类型

    //限定该类型必须为T的子类，或其后代类型
    ? extends T
    //限定使用的类型必须为T的父类，或其祖类
    ? super T


`例`


    SuperClass<?> sup = new SuperClass<String>("lisi");

    sup = new SuperClass<People>(new People());
    
    sup = new SuperClass<Animal>(new Animal());
    
    //传给Student类的类型必须是Number的超类
    public static void function(Student<? super Number> s){ 
        System.out.println("姓名是："+s.getName()); 
    }
    
    //传给Student类的类型必须是Number的子类
    public static void function(Student<? extends Number> s){ 
        System.out.println("姓名是："+s.getName()); 
    }
    
    
    //限定传入类型只能是Fruit的子类
    public void test(? extends Fruit){};
    
* ?只能在定义了泛型模板后再匹配使用，直接使用是不行的


    //报错
    class Test<?>
    {
        ...
    }
    
    //报错
    class Test<? extends T>
    {
        ...
    }
    
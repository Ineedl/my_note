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
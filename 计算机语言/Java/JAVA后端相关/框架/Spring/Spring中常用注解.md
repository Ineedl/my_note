## @AliasFor
@AliasFor用于给注解中的某个属性起一个别名，同时其也支持继承其他注解的功能。

`注解定义`

    @Retention(RetentionPolicy.RUNTIME)
    @Target({ElementType.METHOD})
    @Documented
    public @interface AliasFor {
    
        @AliasFor("attribute")
        String value() default "";
    
        @AliasFor("value")
        String attribute() default "";
    
        Class<? extends Annotation> annotation() default Annotation.class;
    }

``

> 别名的使用

    public @interface MyTest {
     
    	@AliasFor("path")
    	String[] value() default {};
     
    	
    	@AliasFor("value")
    	String[] path() default {};
    	
    }

此时MyTest注解中path与默认的value互为别名，在使用时指定path和不指定直接默认给value传值是一样的效果

* @AliasFor用于起别名时必须保证两个属性值一致，不一致时会出错。

* @AliasFor只能用于注解的属性上面。

> 继承其他注解的功能


    //spring中组件注解Service的实际实现
    @Target({ElementType.TYPE})
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Component
    public @interface Service {
    
        @AliasFor(annotation = Component.class)
        String value() default "";
        
    }
    
    
> 继承其他注解的功能，并且对那个注解的某个属性进行重命名

    @ContextConfiguration
     public @interface MyTestConfig {
     
        @AliasFor(annotation = ContextConfiguration.class, attribute = "locations")
        String[] value() default {};
     
        @AliasFor(annotation = ContextConfiguration.class, attribute = "locations")
        String[] groovyScripts() default {};
     
        @AliasFor(annotation = ContextConfiguration.class, attribute = "locations")
        String[] xmlFiles() default {};
     }

* 该方式复写的元注解的别名可以存在不止两个(注解中的隐性别名)。

* 也可以这样定位到注解自己本身的某个属性中，这样被称为注解中的可传递隐性别名。
 

    //实际上groovy定位的是@ContextConfiguration中的locations属性
    public @interface GroovyOrXmlTestConfig {
 
        @AliasFor(annotation = MyTestConfig.class, attribute = "groovyScripts")
        String[] groovy() default {};
     
        @AliasFor(annotation = ContextConfiguration.class, attribute = "locations")
        String[] xml() default {};
    }
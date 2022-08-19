## Gson的开始使用
Gson一开始建立一个Gson对象，然后就可以使用该对象来传入数据来生成自己需要的JSON格式数据


    

## Gson类
Gson类拥有大量将JSON转换成bean对象或是将bean对象转换成JSON的方法

> Gson构造方法

Gson的对外构造方法只有无参数的构造方法。


    Gson gson = new Gson(0);


* 使用默认构造方法生成的Gson对象在生成JSON数据格式时，使用默认的配置，默认排除static属性与transient属性。

> String toJson(Object src)

该方法将一个bean对象转换成JSON数据格式，默认情况下转换的JSON数据会挤在一起没有排版。  

* toJson可以识别出JDK中自带的容器类型(ArrayList，Set等)。

1. 对于bean对象中值为null的String属性，不写入JSON数据中，对于不为null的String类型或是其他的基本数据类型，默认会用属性名给key命名，值为value写入到JSON的根Object中。  

2. 对于bean对象中不包含其他复合的复合类型属性，toJson方法会将这些复合类型的对象以JSON中Object类型的方式写入JSON中，该复合属性的Object在该bean对应的JSON中Object对象内。

3. 对于bean对象中的包含其他各种复合类型的复合类型属性的这种情况，toJson方法会递归调用自己来讲这些复合类型对象逐层步步解析型，然后以JSON中Object的方式写入到JSON数据中
。

`例`

    class User
    {
        private String name;
        private Pet pet;
        //get与set
    }
    class Pet
    {
        private String name;
        private Other other;
        //get与set
    }
    class Other
    {
        private String name;
        private Other2 other;
    }
    ...
    
    //转换后的JSON
    {
        "name" : "myname",
        "pet" : {
            "name" : "thisname",
            "other" : {
                "name" : "thisname",
                "other2" : {
                    "name" : "thisname",
                    "other3" : {
                        ...
                    }
                }
            }
        }
    }
    

> <T> T fromJson(String json, Class<T> classOfT) throws JsonSyntaxException

该方法用于将String类型的JSON数据格式转换成对应的类型

`例`

    GsonBuilder builder = new GsonBuilder();
    Gson gson = builder.create();
    System.out.println(gson.fromJson(gson.toJson(user),User.class));

* 该方法可以识别出JDK中自带的容器类型(ArrayList，Set等)。

* fromJson与toJson一样都会嵌套调用函数来解析/生成JSON格式的数据
    
## GsonBuilder类
该类用于配置Gson对象中的属性，控制Gson生成JSON或是将JSON转换成bean的细节。
    
> 构造方法      

GsonBuilder只有一个默认的public构造方法

> Gson create()

该方法根据对GsonBuilder配置来生成一个Gson对象，当不进行任何配置时，与直接用默认构造new出来一个Gson对象的作用一样。

> GsonBuilder(return this) setPrettyPrinting()

该方法配置Gson对象生成JSON数据时，数据不再紧密在一起，在数据中心使用空格与换行来对JSON数据进行排版。

> GsonBuilder excludeFieldsWithModifiers(int... modifiers)

该方法用来设置在转换成JSON数据格式时，带有什么样修饰词的属性会被忽视

* 不设置时默认忽视带有transient或static修饰词的属性

`支持的属性词的枚举值如下`

    //import javax.lang.model.element.Modifier;
    public enum Modifier {
    
        // See JLS sections 8.1.1, 8.3.1, 8.4.3, 8.8.3, and 9.1.1.
        // java.lang.reflect.Modifier includes INTERFACE, but that's a VMism.
    
        /** The modifier {@code public} */          PUBLIC,
        /** The modifier {@code protected} */       PROTECTED,
        /** The modifier {@code private} */         PRIVATE,
        /** The modifier {@code abstract} */        ABSTRACT,
        /**
         * The modifier {@code default}
         * @since 1.8
         */
         DEFAULT,
        /** The modifier {@code static} */          STATIC,
        /** The modifier {@code final} */           FINAL,
        /** The modifier {@code transient} */       TRANSIENT,
        /** The modifier {@code volatile} */        VOLATILE,
        /** The modifier {@code synchronized} */    SYNCHRONIZED,
        /** The modifier {@code native} */          NATIVE,
        /** The modifier {@code strictfp} */        STRICTFP;
    
        /**
         * Returns this modifier's name in lowercase.
         */
        public String toString() {
            return name().toLowerCase(java.util.Locale.US);
        }
    }

> GsonBuilder(return this) setDateFormat(String pattern)

该方法设置Date类的解析格式，当该方法设置后，转换与解析JSON数据格式时会自动解析/生成Date类型数据。

`例子`

    Gson gson = new GsonBuilder()
                    .setDateFormat("yyyy-MM-dd")
                    .create();

> GsonBuilder(return this) excludeFieldsWithoutExposeAnnotation()

该方法开启@Expose注解的使用，调用后使用@Expose来设置某个类在被JSON序列化和反JSON序列化时需要的属性。

## @SerializedName注解

该注解用于要转换成JSON数据格式的bean类的属性上，转换成JSON格式后，会以该名字来命名对应属性的key。

@SerializedName注解在JSON数据导入与生成的时候都能生效。

> @SerializedName的属性

`String value()`       

设置对应的key的名字

`String[] alternate() default {}`  

对应的key名字被占用时的替补名数组

> 使用例

    public class User {
        @SerializedName("NAME")
        private String name;
        private String age;
        //各种get与set
    }
    
    //用toJson转换成JSON格式
    {
        "NAME" : "myName",
        "age" : "myage"
    }


## @Expose注解
@Expose用于标注bean类中的属性，用来控制某个属性是否支持JSON的序列化与反序列化。

该注解标记的属性只有在GsonBuilder调用excludeFieldsWithoutExposeAnnotation()后生成的Gson对象进行JSON的序列化与反序列化才会被判断该属性是否支持。

* 调用excludeFieldsWithoutExposeAnnotation()前，@Expose注解的使用是无效的。

* 调用excludeFieldsWithoutExposeAnnotation()后，没有使用@Expose注解注解的属性将不被考虑


> @Expose的属性

`boolean serialize() default true;`

是否支持JSON的序列化，默认支持

`boolean deserialize() default true;`

是否支持JSON的反序列化，默认支持


`例`

    public class UserSimple {  
        @Expose()
        String name; // equals serialize & deserialize
 
        @Expose(serialize = false, deserialize = false)
        String email; // equals neither serialize nor deserialize
 
        @Expose(serialize = false)
        int age; // equals only deserialize
 
        @Expose(deserialize = false)
        boolean isDeveloper; // equals only serialize
        
        boolean myBool;
    }
    
    //GsonBuilder调用excludeFieldsWithoutExposeAnnotation()返回的Gson对象操作UserSimple
    
    //UserSimple 序列化 JSON时 输出只有 name 和 isDeveloper，其他连个字段就不会被输出，因为 serialize 都是 false；
    
    //UserSimple JSON反序列化时，只有 email 和 isDeveloper 被忽略，因为 deserialize = false
    
    //myBool不被JSON序列化与JSON反序列化，因为他没有被@Expose标记。
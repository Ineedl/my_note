## jedis的依赖

    <!-- https://mvnrepository.com/artifact/redis.clients/jedis -->
    <dependency>
            <groupId>redis.clients</groupId>
            <artifactId>jedis</artifactId>
            <version>版本</version>
    </dependency>
    
* 光导入jedis的依赖，会导致jedis在加载的时候没有默认的日志实现类而导致加载日志类报错，但是这个并不影响jedis的使用，如果需要相关的日志类或是看着不爽，可以加入以下依赖。


## slf4j的默认实现类包

    <!-- https://mvnrepository.com/artifact/org.slf4j/slf4j-simple -->
    <dependency>
        <groupId>org.slf4j</groupId>
        <artifactId>slf4j-simple</artifactId>
        <version>1.7.25</version>
    </dependency>
    
## slf4j的无实现类包
这个导入后依然会出现日志类无加载的错误，只做了解。

    <!-- https://mvnrepository.com/artifact/org.slf4j/slf4j-simple -->
    <dependency>
        <groupId>org.slf4j</groupId>
        <artifactId>slf4j-nop</artifactId>
        <version>1.7.25</version>
    </dependency>

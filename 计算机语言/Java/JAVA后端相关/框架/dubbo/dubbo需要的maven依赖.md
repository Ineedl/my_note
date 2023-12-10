## dubbo依赖

    <dependency>
      <groupId>com.alibaba</groupId>
      <artifactId>dubbo</artifactId>
      <version>版本</version>
    </dependency>
    
## zookeeper依赖(直连不需要)


    <dependency>
      <groupId>io.netty</groupId>
      <artifactId>netty-all</artifactId>
      <version>版本</version>
    </dependency>


    <!-- https://mvnrepository.com/artifact/org.apache.zookeeper/zookeeper -->
    <dependency>
      <groupId>org.apache.zookeeper</groupId>
      <artifactId>zookeeper</artifactId>
      <version>版本</version>
    </dependency>

    <!--版本必须为2.多，不然会有未知报错-->
    <dependency>
      <groupId>org.apache.curator</groupId>
      <artifactId>curator-framework</artifactId>
      <version>2.xxx</version>
    </dependency>
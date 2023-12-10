## Resources标签

* Resources为一个maven自带的插件

Resources标签允许maven在编译时将指定的配置文件放到对应的位置,maven默认是编译后不讲配置文件放入对应目录的

* 该标签在build标签中使用
    
一种常用的的resources模板

    <resources>
      <resource>
      
        <targetPath>src/file</targetPath>
      
        <directory>src/main/java</directory>
        
        <includes>
          <include>**/*.properties</include>   
          <include>**/*.xml</include>
        </includes>
        
        <filtering>false</filtering>
        <excludes>
            <exclude>**/*.pproperties</exclude>
        </excludes>
        
      </resource>
    </resources>

includes：一组文件名的匹配模式，用include匹配文件，被匹配的资源文件将被构建过程处理。


excludes：一组文件名的匹配模式，用exclude匹配文件，被匹配的资源文件将被构建过程忽略。同时也被includes的文件依然被忽略。

targetPath：该标签指定maven编译后资源文件的目标位置，不写时默认同编译时项目目录。

directory：该标签指定资源文件所在目录，不写时默认在类目录根下。

filtering：构建过程中是否对资源进行过滤，即不使用${属性名}来匹配properties配文件中的数据，默认false。

## filters标签

* filters为一个maven自带的插件

* 该标签在build标签中使

该标签给出对资源文件进行过滤的属性文件的路径。属性文件中定义若干了键值对，用于在构建过程中将资源文件中出现的变量（键）替换为对应的值。

即该标签指定properties配置文件位置并使用该配置文件，更多请参考java中Properties类。

    <filters>
        <filter>属性配置文件路径1</filter>
        <filter>属性配置文件路径2</filter>
        <filter>.....</filter>
    </filters>
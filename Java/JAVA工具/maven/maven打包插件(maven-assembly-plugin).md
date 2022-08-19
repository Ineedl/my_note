## [插件介绍主页](http://maven.apache.org/plugins/maven-assembly-plugin/)

## maven-assembly-plugin
该插件能将写的程序和它本身所依赖的jar包一起打包到一个包里，是maven中针对打包任务而提供的标准插件。


* 该插件提供一个把工程依赖元素、模块、网站文档等其他文件存放到单个归档文件里。

* 支持打包成指定格式分发包，支持各种主流的格式如zip、tar.gz、jar和war等，具体打包哪些文件是高度可控的。

* 能够自定义包含/排除指定的目录或文件。

* 该插件能够定制化打包

## 贴别注意
该插件在编译时不会自动编译，需要命令

    mvn package assembly:single

* 只有assembly:single很可能会导致你没有自己的工程Java类文件，而是只有依赖文件



## 依赖的添加与主要格式
`添加依赖时顺便的设置`

    <plugin>       
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-assembly-plugin</artifactId>
            <version>版本号</version> <!--一般2.多-->
            
            
            <configuration>
                    <finalName>${project.name}</finalName>
                      
                    <archive>
                        <manifest>
                            <addClasspath>true</addClasspath>
                            <mainClass>main函数所在类的类名</mainClass> <!-- 你的主类名 -->
                            <classpathPrefix>lib/</classpathPrefix>
                        </manifest>
                    </archive>
                    <descriptors>
                        <descriptor>src/assembly/assembly.xml</descriptor> 
                        <!--配置描述文件路径--> 
                    </descriptors>
                    </configuration>
            <executions>
              
                <execution><!-- 配置执行器 -->
                    <id>make-assembly</id>
                    <phase>package</phase>  <!--绑定到package生命周期阶段上-->
                    <goals>
                      <goal>single</goal>   <!--只运行一次-->   
                    </goals>
                    
                    
              
                </execution>
            </executions>
    </plugin>

该插件主要配置<configuration>标签中内容

* phase和goals默认就好，意思是绑定到maven的打包生命周期中并且只运行一次。

## configuration标签内的常用配置
### archive标签
只有jar和war程序集格式支持<archive>配置元素，archive标签用于进行jar与war包中信息文件的配置

[官方介绍](http://maven.apache.org/shared/maven-archiver/index.html#class_manifest)

`manifest标签`  
用于设置MANIFEST.MF文件中相关内容以及添加额外项目依赖。

* addClasspath标签：是否指定项目在自己classpath下的依赖(而不是在maven添加的依赖)。默认值为false。
* mainClass标签：jar运行时main函数所在主类名。
* classpathPrefix标签：指定依赖的时候声明前缀。

### 指定自己定制打包文件
descriptor标签可以指定自己定制打包文件的位置并用他里面的规则来打包文件。  
该文件一般是个xml。

    <descriptors>
        <descriptor>自己配置文件的位置</descriptor>
    <descriptors>

`例`

    <descriptors>
        <descriptor>src/main/assembly/assembly.xml</descriptor>
    <descriptors>

### 引用官方配置文件打包(不推荐使用)
使用descriptorRef标签即可指定官方的打包配置文件来规定项目打包规则，默认情况下，maven-assembly-plugin内置了几个可以用的assembly descriptor。

每个内置的选项都有一个对应的xml配置文件，可以到插件的jar包中去查看


    <descriptorRefs>
        <descriptorRef>内置定制的打包方式</descriptorRef> 
    </descriptorRefs>

`例`

    <descriptorRefs>
        <descriptorRef>jar-with-dependencies</descriptorRef> 
    </descriptorRefs>

官方的支持以下四种定制

* bin ： 类似于默认打包，会将bin目录下的文件打到包中；
* jar-with-dependencies ： 会将所有依赖都解压打包到生成物中，也包括你的项目文件。
* src ：只将源码目录下的文件打包；
* project ： 将整个project资源打包。

### finalName标签
该标签与自定义规则文件中id标签一前一后共同组成打包后的文件名，如果只想要finalName则加上以下标签。

    <appendAssemblyId>false</appendAssemblyId> 

## 自定义打包规则
### 自定义规则xml文件格式

    <?xml version='1.0' encoding='UTF-8'?>
    <!--约束文件-->
    <assembly xmlns="http://maven.apache.org/ASSEMBLY/2.1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/ASSEMBLY/2.1.0
    http://maven.apache.org/xsd/assembly-2.1.0.xsd">
        
        <id>demo</id>
        
        <formats>
            <format>jar</format>
        </formats>
        
        <includeBaseDirectory>false</includeBaseDirectory>
        
        
        <dependencySets>
            <dependencySet>
                <outputDirectory>/lib</outputDirectory>
                <excludes>
                    <exclude>${project.groupId}:${project.artifactId}</exclude>
                </excludes>
            </dependencySet>
            <dependencySet>
                <outputDirectory>/</outputDirectory>
                <includes>
                    <include>${project.groupId}:${project.artifactId}</include>
                </includes>
            </dependencySet>
        </dependencySets>
        
        
        <fileSets>
            <fileSet>
                <directory>${project.build.directory}/classes</directory>
                <outputDirectory>/</outputDirectory>
                <include>**/*.properties</include>
                <include>**/*.xml</include>
                <include>**/*.tld</include>
                <include>**/*.dtd</include>
                <fileMode>0666</fileMode>
            </fileSet>
        </fileSets>
    </assembly>
    
### id
与finalName一起组成文件名，id一般用来描述版本信息(x.x.x-Release等)。

### format与formats
指定打包的文件名，一个项目可以多次打包。

### includeBaseDirectory
指定是否包含打包层目录（比如finalName是output，当指定为true时，所有文件被放在output目录下，否则直接放在包的根目录下）。

### dependencySets与dependencySet
用于指定项目依赖与使用的jar包打包的方式  

* dependencySets与dependencySet打包时

    <dependencySet>
        <outputDirectory>jar包中目录</outputDirectory>
    </dependencySet>

表示打包当前项目中所有用到的maven依赖(不包括第三方手动导入的)。


`dependencySet内相关标签`
* directory 指定工作目录

* outputDirectory   指定包依赖目录，该目录是相对于根目录

* includes  指定要包含的依赖文件

* excludes	指定要排除的依赖文件

* useProjectArtifact 只能为true或false，是包含自己的jar(工程中自己的代码单独组成的一个jar)。true为是，默认为true。

* useProjectAttachments
只能为true或false，是否加入依赖的jar(除了工程中自己的代码单独组成的一个jar)。true为是，默认true。

* unpack    布尔值，false表示将依赖以原来的JAR形式打包，true则表示将依赖解成.class文件的目录结构打包。

* scope 表示符合哪个作用范围的依赖会被打包进去。compile与provided都不用管，一般是写runtime。

`<scope>system</scope>`可以将maven中本地手动导入的jar包打包进jar包，但是本地手动导入的jar包不能以jar包的形式存在，只能在根路径展开，即本地的jar包导入只能使用如下配置。

    <dependencySet>
        <outputDirectory>/</outputDirectory>
        <scope>system</scope>
        <unpack>true</unpack>
    </dependencySet>

* 注意这里如果手动导入的jar包不使用unpack展开，会出现调用找不到的问题，这里建议还是将本地的jar包安装进maven库并在maven引用后打包。


### fileSets与fileSet
用来设置一组文件在打包时的属性。

`fileSet内相关标签`

* directory 指定工作目录

* outputDirectory	String	指定文件集合的输出目录，该目录是相对于根目录
* includes	包含文件
* excludes	排除文件
* fileMode	指定文件的属性，同linux文件权限

### files与file
同fileSets与fileSet，但只用于单个文件。


`实例 官方定制文件`


    <assembly xmlns="http://maven.apache.org/ASSEMBLY/2.1.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/ASSEMBLY/2.1.0 http://maven.apache.org/xsd/assembly-2.1.0.xsd">
    <!-- TODO: a jarjar format would be better -->
    
        <id>jar-with-dependencies</id>
        
        <formats>
            <format>jar</format>
        </formats>
        <includeBaseDirectory>false</includeBaseDirectory>
        <dependencySets>
            <dependencySet>
                <outputDirectory>/</outputDirectory>
                <useProjectArtifact>true</useProjectArtifact>
                <unpack>true</unpack>
                <scope>runtime</scope>
            </dependencySet>
        </dependencySets>
    </assembly>
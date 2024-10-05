## maven多模块管理
maven允许使用继承的方式来进行以来的管理，可以存在一个父maven工程来继承所需要的依赖，之后java项目的mavn来继承该父maven工程中管理的依赖，来达到多工程依赖的统一管理的效果。


## maven父工程
maven父工程为给其他子maven继承的一个工程，maven父工程满足以下条件

1. 项目只有pom.xml文件以及与该pom.xml配置相关的文件是有用的，其余的代码文件什么的都不需要

2. packaging标签的值必须设置为pom



* 如果一个Java工程中的maven的配置文件在根据上述条件进行更改后，也可以称为一个maven父工程


`父工程效果`  
dependencies中的所有依赖与配置都会被子maven无条件继承

* maven允许多级继承，但是一定是最后辈的maven才有代码工程

## 子maven的继承的第一种方式
子maven使用parent标签来完成对父工程的继承，该标签在project标签内使用

    <parent>
        <artifactID>同父maven工程</artifactID>
        <groupID>同父maven工程</groupID>
        <version>同父maven工程</version>
        <relativePath>父pom所在路径<relativePath/>
    </parent>
    
* 子maven在继承父maven后groupID，version后都同父maven，但是artifactID可以自定义

#### 特别注意，当relativePath使用空的<relativePath/>或者是不写，表示在本地依赖库或是远程依赖库中寻找对应的父pom.xml


## 详细的模块管理
父maven中如果直接用一般默认的把<dependencies>中依赖全部继承给子类会造成子类中依赖的冗余。

* 其原理是父工程管理依赖的版本号

> 父maven使用<dependencyManagement>标签来控制子类依赖的继承

父工程通过把<dependencies>标签放入到<dependencyManagement>中来管理子maven的继承
    
    <dependencyManagement>
        <dependencies>
            <dependency>
                ...
            </dependency>
            <dependency>
                ...
            </dependency>
            <dependency>
                ...
            </dependency>
            ...
        </dependencies>
    </dependencyManagement>

> 在子maven中声明需要的依赖

之后在子maven的<dependencies>声明需要的模块就行，但是不需要声明依赖版本号，其继承来自父工程中依赖的版本。  

如果不需要继承来自父maven的依赖，而是从依赖库中拿取依赖，则需要自己指定版本号。

> 统一管理方法

父maven中使用<properties>标签定义版本的变量，之后在<dependencyManagement>使用来达到版本的统一修改。

`例`

    
    <properties>
        <junit-version>4.10</junit-version>
        <mysql-connector-java-version>8.0.19</mysql-connector-java-version>
        <dubbo.version>2.6.2</dubbo.version>
    </properties>
    
    <dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>${junit-version}<version>
        </dependency>
        <dependency>
            <groupId>mysql-connector-java</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>${mysql-connector-java-version}<version>
        </dependency>
        <dependency>
            <groupId>dubbo</groupId>
            <artifactId>dubbo</artifactId>
            <version>${dubbo.version}<version>
        </dependency>
    <dependencies>
    <dependencyManagement>
    
## 子maven继承的第二种方式

这种方法父工程同样要满足以下条件

1. 项目只有pom.xml文件以及与该pom.xml配置相关的文件是有用的，其余的代码文件什么的都不需要

2. packaging标签的值必须设置为pom

子工程直接创建到父maven的目录中。  

之后父maven的pom.xml中使用<modules>与<module>标签添加子工程的信息即可。  

module标签内部值为子工程的工程名。

* 同样子maven需要同第一种方法一样指向父maven

* 父工程管理依赖同第一种方法

当然，这种情况下也可以存在继承产生的下级父maven，规则同上。

    目录结构
    -father
        |-java-web(D)
        |-java-web(D)
        |-newFather(D)
        |   |-newSon(D)
        |   |-pom.xml(newFather的pom.xml)
        |-pom.xml(father的pom.xml)
        
    //父maven，项目名father
    
    <modules>
        <module>java-web</module>
        <module>java-app</module>
        <module>newFather</module>
    </modules>
    
    //父maven，项目名newFather
    <parent>
        ...
    </parent>
    <modules>
        <module>newSon</module>
    </modules>
    
## 注意上述两种方式可以混合使用
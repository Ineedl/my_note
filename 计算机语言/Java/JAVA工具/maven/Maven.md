# maven的核心概念
* POM  
* 约定的目录结构
* 坐标
* 依赖管理
* 仓库管理
* 生命周期
* 插件和目标
* 继承
* 聚合

### POM
所有用maven管理的项目中都有一个文件为pom.xml， maven将项目当作一个模型使用，并且使用该文件来管理项目中的各个设置以及jar依赖

##### POM常用字段解析
 
| 字段 | 	描述 |
| :------ | :------ |
| modelVersion | Maven模型的版本,对于Maven2与Maven3来说只能是4.0.0 |
| groupId | 组织id,一般为公司域名的倒写,也可以倒写后加上项目名 |
| artifactId | 项目名称.也可以是模块名称,对应groupId中项目中的子项目 |
| version | 项目版本号,version使用三位数字标识,通常在版本后带-SNAPSHOT |
| packaging | 项目编译打包后的文件扩展名，不写时默认为jar|
| dependencies | 项目的依赖相关属性，该字段和dependency组合一起描述了项目中所需要的jar包等依赖，一个dependencies包含多个dependency |
| dependency | 项目的依赖相关属性，一个dependency包含一个坐标 |
| properties | 该字段中定义了一些项目一般配置属性 |
| build | 该字段中设置了项目编译时所用的一些配置信息(jdk版本等)，包括插件配置 |
| parent | 该字段描述了项目的继承关系 |
| modules | 该字段描述了项目的聚合关系 |


* groupId与artifactId与version这三个字段被称作坐标,在maven中他们三个标识一个唯一的项目,项目pom文件中必须有,他们三个合起来标识的项目在互联网中唯一.而且项目在仓库中的位置由坐标来确定

* maven通过dependencies和dependency的依赖以及其中的坐标来从本地库或他人的库里面寻找依赖文件

例:

    <dependencies>
        <dependency>
            <groupId>公司域名倒写</groupId>
            <artifactId>自定义项目名称</artifactId>
            <version>自定版本号</version>
            <scope>test</scope>
        </dependency>
        
        <dependency>
            <groupId>公司域名倒写2</groupId>
            <artifactId>自定义项目名称2</artifactId>
            <version>自定版本号2</version>
        </dependency>
        
        <dependency>
            <groupId>公司域名倒写3</groupId>
            <artifactId>自定义项目名称3</artifactId>
            <version>自定版本号3</version>
            <scope>provided</scope>
        </dependency>
        
    </dependencies>


### pom.xml文件中依赖的范围
#### dependency字段中的依赖范围字段
* scope   

| 值 | 	描述 |
| :------ | :------ |
| compile | 该依赖在maven生命周期中都会使用到的 |
| test | 该依赖在测试代码阶段才会被使用 |
| provided | 表示为提供者，表示该依赖只会在编译，测试时才会使用 |

![](https://note.youdao.com/yws/api/personal/file/C78D3801BC6F447AA7DA70C376D7CAF6?method=download&shareKey=a53a8faf7285232eb02dfb04eb8c43bd)


### 约定的目录结构
maven项目的目录和文件位置都被规定了。

约定的目录结构:   

 项目名称  
 |---src  (源代码)  
 |---|---main  (放置你的主程序代码与配置文件)  
 |---|---|---java  (放置java主程序代码)  
 |---|---|---resources  (放置资源文件或配置文件)  
 |---|---test  (放置测试程序代码和文件(非必需))  
 |---|---|---java  (放置java主程序代码)  
 |---|---|---resources  (放置资源文件或配置文件)  
 |---pom.xml  (maven核心文件)  



### 坐标
坐标为一个唯一的字符串，每个坐标都标识一个项目
为pom文件中的一个组成部分

### 依赖管理
用来管理项目中可以使用的jar文件

### 仓库管理
maven可以配置pom.xml来使得本地形成一个仓库来自动从网上获取对应jar包并且维护他更新

maven每次自动更新或下载的jar包等文件都放在本地仓库中.

##### 默认仓库位置  
C:\Users\%username%\\.m2\repository

修改maven目录中的settings.xml可以修改仓库位置    
在文件中搜索localRepository并在注释下面加上  
<localRepository>你想要设置的仓库路径</localRepository>

##### 仓库分类
* 本地仓库(自己本地存放jar包的仓库)  
* 远程仓库( 在互联网上他人存放jar并且提供给他人获取jar包的仓库)  
    1.中央仓库:最权威,所有开发人员都能共享使用的一个集中仓库.
    2.中央仓库的镜像:中央仓库的备份,用来缓解中央仓库的压力.  
    3.私服:公司内网,局域网中对内使用的仓库,或是他人开放的某个仓库.

#### 使用需要的jar包时maven的仓库搜索顺序
    本地-->私服-->镜像-->中央仓库

### 生命周期
maven构建项目的一个过程，就是一个生命周期，(项目的构建包括 打包 安装和部署)

### 插件和目标
maven可以使用一些插件和工具来帮助构建项目，maven执行命令时，实际上时使用的插件来完成命令

### 继承
maven项目可以继承给一个新项目或现有项目

### 聚合
多个maven项目可以合并

### maven的生命周期
maven在进行项目的构建的过程  
清理，编译，测试，报告，打包，安装，部署

### maven常用命令  
* maven命令必须要在由pom.xml的目录中使用

| 字段 | 	描述 |
| :------ | :------ |
| mvn compile | 编译项目,并且在项目根目录创建一个target(结果)目录，最后编译后的class文件等都放置在里面 |
| mvn clean | 清理原来编译和测试的目录(target目录) |
| mvn test-compile | 编译工程目录下test目录中的程序 |
| mvn package | 打包主程序 |
| mvn install | 安装主程序(会将主程序按照坐标保存到maven本地仓库中) |
| mvn deploy | 部署主程序，除了安装主程序意外，还会按照工程的坐标部署到web容器中 |


### IDEA与maven配合使用
IDEA中使用maven创建工程时，会提示选择一个原型(或模板)来创建一个项目，其实是选择在java开发中不同方向上项目的不同目录结构(但是都会有pom.xml文件)。
  
* 常用的原型  
maven-archetype-quickstart : 一般java项目  
maven-archetype-webapp : web工程


### maven中常用技巧
* 在pom.xml中在properties标签中设置部分项目属性，也可以使用properties在pom.xml中定义自己的全局变量，并且使用${变量名}的方式调用变量(只限于本pom.xml文件)
    

    <properties>
        <变量名>变量值</变量名>
    </properties>

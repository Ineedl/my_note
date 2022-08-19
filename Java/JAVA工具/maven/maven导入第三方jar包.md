## 导入第三方jar包
    <dependency>
      <groupId>组织id</groupId>
      <artifactId>jar包项目名称</artifactId>
      <version>8.0.27</version>
      <scope>system</scope>
      <systemPath>第三方包的路径</systemPath>
    </dependency>
    
* version，artifactId，groupId不知道可以随便写写，一般最好是对应上，但是不强制要求。

* systemPath写第三方包在的目录。

* scope为system表示显示的提供jar依赖，该jar依赖不会再Repository中查找他。
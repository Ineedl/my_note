## SpringBoot标签分类
SpringBoot标签主要分为三大类  
1. 启动类标签
2. 配置类标签
3. 组件类标签

* 剩余的标签都是与这些标签配合使用，其他的标签实现了条件判断，类的导入等功能。


`启动标签`  
被启动标签标记的类相当于是SpringBoot应用，该标记的类为主程序类与主配置类，该类相当于是所有SpringBoot启动的入口。

比如@SpringBootApplication

`配置标签`  
被配置标签标记的类用于管理或组建Spring IOC容器中部分对象。

比如@Configuration

`组建类标签`  
组建标签标记的类表示该类将会生成一个对象并存于Spring IOC容器中。

比如@Server

## Logger
每个Logger对象都是一个保存并记录某一块日志信息的对象实体。

## ROOT Logger
在 log4cplus 中，所有 logger 都通过一个层次化的结构（其实内部是 hash 表）来组
织的，有一个 Root 级别的 Logger。

`获取Root级别的Logger对象`  
Logger Logger::getRoot()

`定义一个Logger并且取名的函数`  
Logger Logger::getInstance("test");

* 所有的子Logger如果不指定父类，则默认继承自root Logger。

* 每个Logger对象的配置都互相不通用

> 自定义一个Logger

用户定义的 logger 都有一个名字与之对应，比如：

    Logger test = Logger::getInstance("test");
可以定义该 logger 的子 logger:

    Logger subTest = Logger::getInstance("test.subtest"); 

注意 Root 级别的 logger 只有通过 getRoot方法获取  
    
    Logger root=Logger::getInstance("root");

获得的是它的子对象而已。有了这些具有父子关系的 logger 之后可分别设置其LogLevel。


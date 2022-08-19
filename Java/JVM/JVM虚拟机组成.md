## JVM组成

![](https://note.youdao.com/yws/api/personal/file/WEBb4752efc41307fa59a7acf8d421b802a?method=download&shareKey=fdd6fc31005737d62d559ccd719d653e)

* 程序计数器：记住下一条jvm指令的地址，程序计数器为每个线程私有，每个线程的程序计数器都指向该线程中下一条指令的地址，程序计数器中完全不会存在内存溢出情况。

* 虚拟机栈区：线程运行的基本单位为一个存放栈帧帧的空间，该空间相当于一个存放栈帧的栈，一个栈帧就是一个方法运行时所占用的栈内存。

 `虚拟机栈帧图`
 ![](https://note.youdao.com/yws/api/personal/file/WEB0ae854ce261200b0974cbe7699cf464f?method=download&shareKey=06b263a207f8afdbcdb1535a4c747be8)

* 虚拟机堆区：所有线程共享的动态内存区域，使用时需要注意线程安全，拥有垃圾回收机制。

* 方法区：用来存储已载入的所有类的结构相关信息(类的成员方法，成员变量，构造方法代码)，包括运行时常量池以及interface、注解的全部信息。该区域在JVM启动时被创建，起逻辑上是堆的组成部分。当动态加载的类过多时，方法区也会溢出。

`虚拟机方法区图`
![](https://note.youdao.com/yws/api/personal/file/WEB068f94c0d836a02e331265a3eb33ee83?method=download&shareKey=f75585398a54f4c203740079fde839b6)

* 本地方法栈：
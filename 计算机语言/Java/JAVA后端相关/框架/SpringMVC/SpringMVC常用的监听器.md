## ContextLoaderListener
ContextLoaderListener是一个监听器，其实现了ServletContextListener接口，其用来监听Servlet容器的初始化，当tomcat启动时会初始化一个Servlet容器，这样ContextLoaderListener会监听到Servlet容器的初始化。  

在Servlet容器初始化之后我们就可以在ContextLoaderListener中也进行一些初始化操作。  

在SpringMVC中ContextLoaderListener常用于在不使用org.springframework.web.servlet.DispatcherServlet的前提下载启动来加载Spring的配置文件  。

context-param 用来指定 Spring IOC 容器 Bean 定义的XML文件的路径

  
    //web.xml
    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>classpath:producer.xml</param-value>
    </context-param>
    
    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>
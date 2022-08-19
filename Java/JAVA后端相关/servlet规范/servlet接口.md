## servlet接口介绍
servlet接口为一个web开发规范，在部分的服务器应用上(比如tomcat)实现了servlet接口的类可以有权利被这些应用服务器软件在运行时调用并且处理相关数据。

servlet接口的方法

    init
    getServletConfig
    getServletInfo
    destory
    //上述四个方法对于我们在一般的web开发中没用
    
    //service方法定义了在服务器收到请求时，所做的操作
    //只有这个方法在web开发中一定会用到
    service




## servlet对象的生命周期
servlet对象一般在服务器启动时被创建，在服务器关闭时被销毁，一个servlet对象只会被服务器创建一次

* 一般在web.xml中声明要构建的servlet接口的类

## HttpServlet
这个类为servlet规范中的一个官方抽象类，该类实现了servlet中上述四个方法的默认实现。  

该类也给service方法提供了实现，使得service方法可以区分get与post请求，并且根据请求来调用  doPost和doGet方法。

继承该类的类，只需要实现doPost和doGet方法。

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException
    
`HttpServletResponse`  

该接口实现由http服务器提供，该接口代表响应的response对象，负责将doGet，doPost的方法写入http响应体中交给浏览器执行。

HttpServletResponse可以获得http服务器根据请求返回的响应体中的相关信息(传输的网页内容，响应头等)


`HttpServletRequest`  

该接口实现由http服务器提供，该接口代表请求的request对象，负责在doGet，doPost方法运行时读取请求协议包中的相关请求信息(URL信息，请求类型等)


* 请求对象和响应对象只在一次完整的http传输中存活。


## Servlet服务提供的本质
在获取到请求后，直接在响应体里面写入html或jsp数据，或是重定向与转发资源文件地址。
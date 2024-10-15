## 映射器
SpringMVC把实现了HandlerMapping接口的类叫做映射器

SpringMVC在中央调度器DispatcherServlet拿到请求后会将请求交给映射器，映射器会根据请求，从SPringMVC IOC容器中获取处理器对象，并且放入处理器执行链(HandlerExecutionChain)中。

最后DispatcherServlet再将会把找到的处理器对象交给处理器适配器对象

> HandlerExecutionChain

该类中保存着
1. 处理器对象
2. 项目中的所有的拦截器
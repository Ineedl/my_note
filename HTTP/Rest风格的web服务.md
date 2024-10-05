## REST风格的web

1. 在REST中的一切都被认为是一种资源，每个资源由url标识。

2. 对资源的操作包括获取、创建、修改和删除资源，这些操作正好对应http协议提供的get、post、put、和delete方法。，也就是说使用统一的接口，而不像soap风格的服务那样，每个服务的名称都是不同的。

3. 每个请求都是一个独立的请求，从客户端到服务器的每个请求都必须包含所有必要的信息，便于理解。

4. 资源表现形式则是JSON，xml、或者HTML，取决于读者是机器还是人，是消费web服务的客户软件合适web浏览器。当然也看可以是任何其他的格式。


常用的HTTP动词有五个,对应sql中命令。也就是说我们定义接口url中一般不会出现动词，都是使用名词,而动词使用HTTP请求方式来表示。

* HTTP1.1协议设计的一个原则就要实现Rest风格。所以毫无疑问HTTP的GET, POST, PUT,PATCH,DELETE就是最好的证明。

* 一般常用的方法只有POST与GET，至于其他的请求需要程序支持REST风格


    GET（SELECT）：从服务器取出资源（一项或多项）。
    
    POST（CREATE）：在服务器新建一个资源。
    
    PUT（UPDATE）：在服务器更新资源（客户端提供改变后的完整资源）。
    
    PATCH（UPDATE）：在服务器更新资源（客户端提供改变的属性）。
    
    DELETE（DELETE）：从服务器删除资源。
    


`例`

    //REST风格
    GET请求资源 /zoos：列出所有动物园
    POST请求资源 /zoos：新建一个动物园
    GET请求资源 /zoos/ID：获取某个指定动物园的信息
    PUT请求资源 /zoos/ID：更新某个指定动物园的信息（提供该动物园的全部信息）
    PATCH请求资源 /zoos/ID：更新某个指定动物园的信息（提供该动物园的部分信息）
    DELETE请求资源 /zoos/ID：删除某个动物园
    GET请求资源 /zoos/ID/animals：列出某个指定动物园的所有动物
    DELETE请求资源 /zoos/ID/animals/ID：删除某个指定动物园的指定动物
    
    //传统风格
    GET请求资源 /getZoos:列出全部动物园
    GET请求资源 /deleteZoos:删除全部动物园
    GET请求资源 /updateZoosID：更新某个指定动物园的信息（提供该动物园的全部信息
    GET请求资源 /saveZoos:保存全部动物园
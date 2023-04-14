## HTTP的支持

POCO包含一个现成的HTTP服务器框架，该框架在HTTP服务上具有以下支持

* 多线程的HTTP处理

  

* HTTP 1.0/1.1 版本的支持

* Http authentication 校验支持

* 支持cookie

* 使用Poco 的 NetSSl库时，支持HTTPS

## 常用类介绍

### Poco::Net::HTTPServerParams

`HTTPServerParams` 类用于传递 HTTP 服务器的各种参数，比如最大并发连接数、线程池大小、请求和响应的缓存大小等。它是在构建 `HTTPServer` 对象时传递的，如果不需要对这些参数进行定制，可以直接使用默认参数。

默认情况下，Poco 库为 `HTTPServerParams` 类中的大多数参数提供了合理的默认值，适用于绝大多数情况。

可以通过修改 `HTTPServerParams` 对象来实现定制。但是这些调整需要根据具体的应用场景和硬件配置情况进行调试和优化，否则可能会导致性能反而降低。

### Poco::Net::HTTPServer

HTTPServer 是TCPServer 的子类，用于实现一个多种特性的多线程HTTP Server，使用的时候必须提供一个HTTPRequestHandlerFactory ，并且 ServerSocket 必须提升到监听状态，为了配置server端，可以传递一个 HTTPServerParams 给构造函数。

* HTTPServer使用线程池来处理HTTP请求

####  常用方法

> 常用构造

```c++
HTTPServer(
  					Poco::Net::HTTPServerParams::Ptr pParams, 
           	unsigned short port, 
  					Poco::Net::HTTPRequestHandlerFactory::Ptr pFactory
);
HTTPServer(
  					Poco::Net::HTTPRequestHandlerFactory::Ptr pFactory, 
  					const Poco::Net::ServerSocket& socket, 
  					Poco::Net::HTTPServerParams::Ptr pParams
);
```

`参数`

* `pParams`：HTTP服务参数，一般new一个默认的传递进去即可
* `port`：HTTP服务端口
* `pFactory`：HTTP请求句柄工厂指针
* `socket`：一个服务套接字

> 服务开始

```c++
void HTTPServer::start();
```

> 服务结束

```c++
void HTTPServer::stop();
```

> 等待HTTP服务结束

```c++
void HTTPServer::waitForStop();
```

> 是否使用HTTP长连接

```c++
void HTTPServer::setKeepAlive(bool keepAlive);
```

> 设置HTTP服务超时时间

```c++
void HTTPServer::setTimeout(const Timespan& timeout);
```

> 设置HTTP处理最大线程数

```c++
void HTTPServer::setMaxThreads(int maxThreads);
```

> 设置线程空闲时间

```c++
void HTTPServer::setThreadIdleTime(int idleTime);
```

> 设置HTTP服务器名

```c++
void HTTPServer::setServerName(const std::string& name);
```

> 设置服务参数

```c++
void HTTPServer::setServerParams(HTTPServerParams::Ptr pParams);
```

### Poco::Net::HTTPRequestHandlerFactory

该类是一个创建HTTP请求句柄的工厂类，用户需要继承该类，并实现`createRequestHandler`方法来创建并传递用户自己的HTTPRequestHandler来处理HTTP请求。

```c++
virtual Poco::Net::HTTPRequestHandler* createRequestHandler(const Poco::Net::HTTPServerRequest &) = 0;
```

### Poco::Net::HTTPRequestHandler

HTTPRequestHandler 是由 HTTPServer 创建出来的抽象基类，派生类必须要重写 handleRequest() 方法。

```c++
virtual void handleRequest(Poco::Net::HTTPServerRequest & request,Poco::Net::HTTPServerResponse & response) = 0;
```

* handleRequest() 方法必须完整的处理HTTP 请求，一旦handleRequest() 方法执行完，请求处理的对象立即销毁。

### Poco::Net::HTTPServerRequest

该对象由服务器接受请求时创建传递给handleRequest

其包含：

* 请求的URI与方法

* Cookie

* authentication

*  表单等HTTP相关数据

#### 常用方法

> 获取HTTP请求方法

````c++
const std::string& Poco::Net::HTTPServerRequest::getMethod() const;
````

返回一个字符串类型的 HTTP 方法（如 GET、POST 等）。



> 获取HTTP请求的完整URL

```c++
const Poco::URI& Poco::Net::HTTPServerRequest::getURI() const;
```
获取 URI，返回一个 `URI` 类型的对象，表示客户端请求的 URI。



> 获取HTTP协议版本

```c++
const std::string& Poco::Net::HTTPServerRequest::getVersion() const;
```

获取 HTTP 协议版本，返回一个字符串类型的 HTTP 版本号（如 1.0、1.1 等）。



> 判断请求是否携带了身份验证信息

```c++
bool Poco::Net::HTTPServerRequest::hasCredentials() const;
```
判断请求是否携带了身份验证信息。



> 获取身份验证信息

```c++
const Poco::Net::HTTPBasicCredentials& Poco::Net::HTTPServerRequest::getCredentials() const;
```
获取身份验证信息，返回一个 `HTTPBasicCredentials` 类型的对象。



> 获取请求体的MIME类型

```c++
const std::string& Poco::Net::HTTPServerRequest::getContentType() const;
```
获取请求体类型，比如`application/json`



> 获取请求体长度

```c++
std::streamsize Poco::Net::HTTPServerRequest::getContentLength() const;
```



> 获取请求体消息的输入流

```c++
std::istream& Poco::Net::HTTPServerRequest::stream();
```

返回一个 `std::istream` 类型的输入流对象，可以通过该对象读取请求消息体中的数据。



> 判断cookie是否存在

```c++
bool Poco::Net::HTTPServerRequest::hasCookie(const std::string& name) const;
```

判断请求中是否包含了指定名称的 cookie。



> 获取指定cookie

```c++
const Poco::Net::HTTPCookie& Poco::Net::HTTPServerRequest::getCookie(const std::string& name) const;
```

获取指定名称的 cookie，返回一个 `HTTPCookie` 类型的对象。



> 获取所有cookie

```c++
const Poco::Net::NameValueCollection& Poco::Net::HTTPServerRequest::getCookies() const;
```

返回一个 `const CookieMap&` 类型的映射表，映射表的键为 cookie 名称，值为 `HTTPCookie` 类型的对象。

* `NameValueCollection` 类型实际上是 `std::vector<std::pair<std::string, std::string>>` 和 `std::map<std::string, std::string, Poco::CILess>`的组合。可以像一般容器那样遍历，也提供了同map一样的get方法。



> 获取所有的Header

```c++
const Poco::Net::NameValueCollection& getHeaders() const;
```



> 获取指定的Header

```c++
std::string Poco::Net::HTTPServerRequest::get(const std::string& name) const;
```

* `NameValueCollection` 类型实际上是 `std::vector<std::pair<std::string, std::string>>` 和 `std::map<std::string, std::string, Poco::CILess>`的组合。可以像一般容器那样遍历，也提供了同map一样的get方法。
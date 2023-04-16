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
void start();
```

> 服务结束

```c++
void stop();
```

> 等待HTTP服务结束

```c++
void waitForStop();
```

> 是否使用HTTP长连接

```c++
void setKeepAlive(bool keepAlive);
```

> 设置HTTP服务超时时间

```c++
void setTimeout(const Timespan& timeout);
```

> 设置HTTP处理最大线程数

```c++
void setMaxThreads(int maxThreads);
```

> 设置线程空闲时间

```c++
void setThreadIdleTime(int idleTime);
```

> 设置HTTP服务器名

```c++
void setServerName(const std::string& name);
```

> 设置服务参数

```c++
void setServerParams(HTTPServerParams::Ptr pParams);
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
const std::string& getMethod() const;
````

返回一个字符串类型的 HTTP 方法（如 GET、POST 等）。



> 获取HTTP请求的完整URL

```c++
const Poco::URI& getURI() const;
```
获取 URI，返回一个 `URI` 类型的对象，表示客户端请求的 URI。



> 获取HTTP协议版本

```c++
const std::string& getVersion() const;
```

获取 HTTP 协议版本，返回一个字符串类型的 HTTP 版本号（如 1.0、1.1 等）。



> 判断请求是否携带了身份验证信息

```c++
bool Poco::Net::HTTPServerRequest::hasCredentials() const;
```


> 获取身份验证信息

```c++
const Poco::Net::HTTPBasicCredentials& getCredentials() const;
```
获取身份验证信息，返回一个 `HTTPBasicCredentials` 类型的对象。



> 获取请求体的MIME类型

```c++
const std::string& getContentType() const;
```
获取请求体类型，比如`application/json`



> 获取请求体长度

```c++
std::streamsize getContentLength() const;
```



> 获取请求体消息的输入流

```c++
std::istream& stream();
```

返回一个 `std::istream` 类型的输入流对象，可以通过该对象读取请求消息体中的数据。



> 判断cookie是否存在

```c++
bool hasCookie(const std::string& name) const;
```

判断请求中是否包含了指定名称的 cookie。



> 获取指定cookie

```c++
const Poco::Net::HTTPCookie& getCookie(const std::string& name) const;
```

获取指定名称的 cookie，返回一个 `HTTPCookie` 类型的对象。



> 获取所有cookie

```c++
const Poco::Net::NameValueCollection& getCookies() const;
```

返回一个 `const CookieMap&` 类型的映射表，映射表的键为 cookie 名称，值为 `HTTPCookie` 类型的对象。

* `NameValueCollection` 类型实际上是 `std::vector<std::pair<std::string, std::string>>` 和 `std::map<std::string, std::string, Poco::CILess>`的组合。可以像一般容器那样遍历，也提供了同map一样的get方法。



> 获取所有的Header

```c++
const Poco::Net::NameValueCollection& getHeaders() const;
```



> 获取指定的Header

```c++
std::string get(const std::string& name) const;
```

* `NameValueCollection` 类型实际上是 `std::vector<std::pair<std::string, std::string>>` 和 `std::map<std::string, std::string, Poco::CILess>`的组合。可以像一般容器那样遍历，也提供了同map一样的get方法。



## Poco::Net::HTTPServerResponse

用于表示 HTTP 服务器的响应。它提供了许多用于设置和获取响应属性的方法，包括响应状态、响应头、响应体等。

### 常用方法

>  设置响应状态吗

```c++
void setStatus(HTTPStatus status);
```



> 设置响应类型

```c++
void setContentType(const std::string& mediaType);
```



> 设置响应内容长度

```c++
void setContentLength(std::streamsize length);
```



> 使用流发送响应

```c++
std::ostream& send();
```

* 向客户端发送响应头，并返回用于发送响应体的输出流。返回的流一直有效，直到响应对象被销毁。不能在sendFile()， sendBuffer()或redirect()被调用之后调用。
* 在写入完所有响应数据后，必须调用`ostr.flush()`来确保所有数据都已发送。
* 该流对象一直有效，直到response对象被摧毁。
* 该函数适合传递视频推流等这些持久的流数据，当然也可以短暂的发送一些字符数据。
* send也可以发送完整的HTTP响应，比如

```c++
std::ostringstream responseStream;
responseStream << "HTTP/1.1 200 OK\r\n"
               << "Content-Type: text/html\r\n"
               << "\r\n"
               << "<html><body><h1>Hello, world!</h1></body></html>";

response.send() << responseStream.str();
response.send().flush();
```



> 发送文件作为响应

```c++
void sendFile(const std::string& path, const std::string& mediaType = "");
```

* 该函数调用后，会立刻返回HTTP响应，之后不应该对响应体操作。



> 发送缓冲区作为响应。

```c++
void sendBuffer(const void* pBuffer, std::size_t length);
```

* sendBuffer也可以发送完整的HTTP响应类似于

```c++
std::ostringstream responseStream;
responseStream << "HTTP/1.1 200 OK\r\n"
               << "Content-Type: text/html\r\n"
               << "\r\n"
               << "<html><body><h1>Hello, world!</h1></body></html>";

std::string responseString = responseStream.str();
response.sendBuffer(responseString.c_str(), responseString.length());
```

* 该函数调用后，会立刻返回HTTP响应，之后不应该对响应体操作。



> 发送字符串作为响应

```c++
void sendString(const std::string& content);
```

* sendString也可以发送完整的HTTP响应，如下

```c++
std::ostringstream responseStream;
responseStream << "HTTP/1.1 200 OK\r\n"
               << "Content-Type: text/html\r\n"
               << "\r\n"
               << "<html><body><h1>Hello, world!</h1></body></html>";

response.sendString(responseStream.str());
```

* 该函数调用后，会立刻返回HTTP响应，之后不应该对响应体操作。



> 设置一个响应头信息

```c++
void setHeader(const std::string& name, const std::string& value);
```



> 设置响应 Cookie。

```c++
void setCookie(const HTTPCookie& cookie);
```



> 设置是否保持连接。

```c++
void setKeepAlive(bool keepAlive);
```



> 设置是否启用分块传输编码。

```c++
void setChunkedTransferEncoding(bool flag);
```



> 设置响应时间。

```c++
void setDate(const Timestamp& dateTime);
```



> 设置 HTTP 版本。

```c++
void setVersion(const std::string& version);
```



> 设置代理身份验证。

```c++
void setProxyAuthenticate(const std::string& value);
```



> 设置身份验证数据

```c++
void setAuthenticate(const std::string& value);
```



> 写入响应数据

```c++
void write(const void* buffer, std::streamsize length);
```



> 写入字符串响应。

```c++
void write(const std::string& content);
```



> 发送HTTP 错误响应。

```c++
void sendErrorResponse(HTTPStatus status, const std::string& message);
```



## HTTP服务代码实例

```c++
#include <Poco/Net/ServerSocket.h>
#include <Poco/Net/HTTPServer.h>
#include <Poco/Net/HTTPRequestHandler.h>
#include <Poco/Net/HTTPRequestHandlerFactory.h>
#include <Poco/Net/HTTPResponse.h>
#include <Poco/Net/HTTPServerResponse.h>
#include <Poco/Util/ServerApplication.h>

#include <iostream>
#include <time.h>
#include <vector>

class MyRequestHandler : public HTTPRequestHandler
{
public:
    LocalWebRequestHandler(){
      handlers_["/api/login"] = std::bind(&LocalWebRequestHandler::login, this, std::placeholders::_1);
  		handlers_["/api/logout"] = std::bind(&LocalWebRequestHandler::logout, this, std::placeholders::_1);
    }

    void handleRequest(HTTPServerRequest &request, HTTPServerResponse &response) override{
    	//进行http处理  
    }
    

private:
    LocalWebResponse login(HTTPServerRequest &request){
   		//此处省略处理
    }

    LocalWebResponse logout(HTTPServerRequest &request){
      //此处省略处理
		}
  
  	std::map<std::string, std::function<LocalWebResponse(HTTPServerRequest &request)>> handlers_;

}


class MyRequestHandlerFactory : public Poco::Net::HTTPRequestHandlerFactory
{
public:
    virtual Poco::Net::HTTPRequestHandler* createRequestHandler(const Poco::Net::HTTPServerRequest &)
    {
        return new MyRequestHandler;
    }
};


int main(int argc, char **argv)
{
    Poco::Net::HTTPServer s(new MyRequestHandlerFactory, Poco::Net::SocketAddress("127.0.0.1:8080"), new Poco::Net::HTTPServerParams);

    s.start();
    std::cout<< "Server started" << std::endl;

    while(1){
      sleep(10);
    }

    return 0;
}
```





## Poco::Net::HTTPClientSession

Poco::Net::HTTPClientSession 是 Poco C++ 库中用于发送 HTTP 请求的类，它提供了与 HTTP 服务器建立连接、发送请求、接收响应等功能。

### 常用方法

> 常用构造

```c++
HTTPClientSession(const std::string& host, Poco::UInt16 port = HTTPSession::HTTP_PORT);
HTTPClientSession(const URI& uri);
```



> 设置代理主机

```c++
void setProxy(const std::string& host, Poco::UInt16 port);
```



> 设置代理主机身份验证信息

```c++
void setProxyCredentials(const std::string& username, const std::string& password);
```



> 长连接启用

```c++
void setKeepAlive(bool keepAlive);
```



> 设置建立连接超时时间

```c++
void setConnectionTimeout(const Poco::Timespan& timeout);
```



> 设置等待响应超时时间

```c++
void setTimeout(const Poco::Timespan& timeout);
```



> 设置服务器host和port

```c++
void setHost(const std::string& host);
void setPort(Poco::UInt16 port);
```



> 设置协议名称

```c++
void setProtocol(const std::string& protocol);
```



> 设置cookie

```c++
void setCookies(const NameValueCollection& cookies);
```

* `NameValueCollection` 类型实际上是 `std::vector<std::pair<std::string, std::string>>` 和 `std::map<std::string, std::string, Poco::CILess>`的组合。可以像一般容器那样遍历，也提供了同map一样的get方法。



> 准备发送请求

```c++
std::ostream& sendRequest(HTTPRequest& request);
```

该函数返回一个流用来传递发送的body体数据

* 当调用 `sendRequest` 方法时，实际上并不会发送请求，而是会先将请求缓存到客户端会话对象的内部缓冲区中。



> 发送请求并等待响应

```c++
std::istream& receiveResponse(HTTPResponse& response);
```

该函数返回一个流用来获取接受的body体数据

* `sendRequest`不会实际发送http请求，而是在`receiveResponse`后才会实际将HTTP请求发出，并等待响应。



## Poco::Net::HTTPRequest 

`Poco::Net::HTTPRequest` 类是 Poco C++ 库中用于表示 HTTP 请求的类。它包含了 HTTP 请求的各种元素，如请求方法、URL、协议版本、头部、实体体等。

### 常用方法

> 设置请求头Content-Length字段

```c++
void setContentLength(std::streamsize length);
```



> 设置请求头Content-Type字段

```
void setContentType(const std::string& mediaType);
```

`application/json`这种



> 设置一个请求头字段

```c++
void set(const std::string& name, const std::string& value);
```



> 设置请求url

```c++
void setURI(const std::string& uri);
```



> 设置请求方法

```c++
void setMethod(const std::string& method);
```

GET、POST、PUT、DELETE等



> 设置请求头Host字段

```c++
void setContentType(const std::string& contentType);
```



> 设置长连接

```c++
void setKeepAlive(bool keepAlive);
```



> 判断是否包含某个请求头

```c++
bool has(const std::string& name) const;
```



> 返回某个请求头的值

```c++
const std::string& operator [] (const std::string& name) const;
```



> 将请求写入某个流

```c++
void write(std::ostream& ostr) const;
```



## Poco::Net::HTTPResponse

`Poco::Net::HTTPResponse` 是一个表示 HTTP 响应的类，用于在客户端应用程序中处理 HTTP 响应。

### 常用方法

> 获取状态码

```c++
int getStatus() const
```



> 获取原因短语

```c++
std::string getReason() const
```



> 获取HTTP响应的版本

```c++
std::string getVersion() const
```



> 查看是否有ContentLength响应头

```c++
bool hasContentLength() const
```



> 获取ContentLength

```c++
std::streamsize getContentLength() const
```



> 获取所有响应头

```c++
const Poco::Net::NameValueCollection& getHeader() const
```



> 获取输入流来读取响应

```c++
std::istream& stream()
```



> 写入请求体内容到输出流

```c++
void write(std::ostream& ostr) const
```



> 获取某个响应头

```c++
const std::string& get(const std::string& name) const;
```



## Poco::Net::HTMLForm

Poco::Net::HTMLForm 是一个用于构造 HTML 表单的类，可以方便地将表单数据序列化为 application/x-www-form-urlencoded 或 multipart/form-data 格式的 POST 请求，并且还支持上传文件。

### 常用方法

> 常用构造

```c++
默认构造
```



> 添加文本字段

```c++
void add(const std::string& name, const std::string& value);
```



> 添加表单一部分

```c++
void addPart(const std::string& name, PartSource* pSource);
```

* `PartSource` 是一个抽象类，它定义了通过表单上传的数据源类型。`addPart()` 方法中的 `PartSource*` 参数表示需要上传的数据源。具体来说，常用以下的 `PartSource` 类型：
  1. `StringPartSource`：表示一个字符串类型的数据源。
  2. `FilePartSource`：表示一个文件类型的数据源。

`filePart举例`

```c++
Poco::Net::HTMLForm form;
Poco::File file("file.txt");
Poco::Net::FilePartSource* pFile = new Poco::Net::FilePartSource(file.path(), "file.txt", "text/plain");
form.addPart("file", pFile);
```

`StringPartSource举例`

```c++
Poco::Net::HTMLForm form;
std::string data = "Hello, world!";
Poco::Net::StringPartSource* pStringSource = new Poco::Net::StringPartSource(data, "text/plain");
form.addPart("text", pStringSource);
```



> 设置编码格式

```c++
void setEncoding(const std::string& encoding);
```



> 序列化表单内容并写入请求

```c++
void prepareSubmit(HTTPRequest& request);
```



## HTTP发送请求实例

```c++
#include <iostream>
#include <Poco/Net/HTTPClientSession.h>
#include <Poco/Net/HTTPRequest.h>
#include <Poco/Net/HTTPResponse.h>
#include <Poco/JSON/Parser.h>
#include <Poco/JSON/PrintHandler.h>
#include <Poco/URI.h>
#include <sstream>

int main()
{
    // 创建HTTP客户端会话对象
    Poco::URI uri("http://example.com/api");
    Poco::Net::HTTPClientSession session(uri.getHost(), uri.getPort());

    // 创建HTTP请求对象
    Poco::Net::HTTPRequest request(Poco::Net::HTTPRequest::HTTP_POST, uri.getPath(), Poco::Net::HTTPMessage::HTTP_1_1);
    request.setContentType("application/json"); // 设置请求头的Content-Type为JSON

    // 设置请求体
    std::string jsonStr = R"({"name": "Alice", "age": 20})";
    request.setContentLength(jsonStr.length());
    std::ostream& requestStream = session.sendRequest(request);
    requestStream << jsonStr;

    // 接收HTTP响应
    Poco::Net::HTTPResponse response;
    std::istream& responseStream = session.receiveResponse(response);

    // 输出HTTP响应状态码
    std::cout << "Status code: " << response.getStatus() << " " << response.getReason() << std::endl;

    // 输出HTTP响应体
    std::stringstream ss;
    ss << responseStream.rdbuf();
    std::string responseStr = ss.str();
    std::cout << "Response body: " << responseStr << std::endl;

    // 解析HTTP响应体中的JSON数据
    Poco::JSON::Parser parser;
    Poco::Dynamic::Var result = parser.parse(responseStr);
    Poco::JSON::Object::Ptr pObj = result.extract<Poco::JSON::Object::Ptr>();
    std::cout << "Name: " << pObj->get("name").toString() << ", Age: " << pObj->get("age").toString() << std::endl;

    return 0;
}
```

`form文件上传实例`

```c++
#include <Poco/URI.h>
#include <Poco/Net/HTTPRequest.h>
#include <Poco/Net/HTTPClientSession.h>
#include <Poco/Net/HTMLForm.h>
#include <Poco/File.h>
#include <Poco/Net/FilePartSource.h>

int form(){
    Poco::URI uri("http://example.com/upload");
    Poco::Net::HTTPClientSession session(uri.getHost(), uri.getPort());

// 创建 HTML 表单对象
    Poco::Net::HTMLForm form;
    form.setEncoding(Poco::Net::HTMLForm::ENCODING_MULTIPART);

// 添加表单字段
    form.add("name", "Alice");
    form.add("age", "20");

// 添加文件上传
    Poco::File file("file.txt");
    Poco::Net::FilePartSource* pFile = new Poco::Net::FilePartSource(file.path(), "file.txt", "text/plain");
    form.addPart("file", pFile);

// 构建 HTTP 请求对象
    Poco::Net::HTTPRequest request(Poco::Net::HTTPRequest::HTTP_POST, uri.getPath(), Poco::Net::HTTPMessage::HTTP_1_1);
    form.prepareSubmit(request);

// 发送 HTTP 请求并接收响应
    session.sendRequest(request);
    Poco::Net::HTTPResponse response;
    std::istream& responseStream = session.receiveResponse(response);
}

```


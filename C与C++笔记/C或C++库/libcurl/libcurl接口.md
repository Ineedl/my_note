## 全局准备

> 全局初始化

```c++
CURLcode curl_global_init(long flags);
```

* `flags`:位模式参数，告诉 libcurl 要初始化什么。

常用位：

```c++
CURL_GLOBAL_ALL		//初始化所有已知的内部子模块，包括下面的选项(如果编译内容中含有下述模块的话)
    
CURL_GLOBAL_WIN32	//只在Windows上使用。libcurl将初始化win32套接字的东西。如果没有正确初始化，您的程序将无法正确使用套接字。您应该只为每个应用程序执行一次此操作，因此如果您的程序已经执行此操作或正在使用的另一个库执行此操作，则您不应该告诉 libcurl 也执行此操作。

CURL_GLOBAL_SSL		//启用 libcurl 的 SSL/TLS 支持

CURL_GLOBAL_DEFAULT //使用默认选项初始化 libcurl 库。

CURL_GLOBAL_NOTHING //不启用任何选项，一般很少使用
    
CURL_GLOBAL_SSL_SESSIONID_CACHE //启用 SSL 会话 ID 缓存。如果设置了该选项，libcurl 会在 SSL 握手时缓存 SSL 会话 ID，从而加速 SSL 连接建立过程。

CURL_GLOBAL_SSL_VERIFYHOST 和 CURL_GLOBAL_SSL_VERIFYPEER //设置 SSL 证书验证选项。如果设置了这两个选项，libcurl 会在 SSL 握手时验证服务器的证书和主机名。如果服务器证书或主机名验证失败，则连接失败。

CURL_GLOBAL_COOKIE //启用 Cookie 处理。如果设置了该选项，libcurl 会在 HTTP 请求中处理 Cookie，从而保持用户会话状态。

CURL_GLOBAL_DNS_CACHE //启用 DNS 缓存。如果设置了该选项，libcurl 会在 DNS 解析时缓存解析结果，从而加速 DNS 查询过程。
```

> 全局清理

```c++
void curl_global_cleanup(void);
```

释放libcurl占用的资源

* 在一个程序的生命内，应避免重复调用`curl_global_init`和`curl_global_cleanup`他们每个只能被调用一次。

* libcurl 有一个默认的保护机制，它检测`curl_global_init`是否在`curl_easy_perform`被调用时没有被调用，如果是这样，libcurl 会使用猜测的位模式运行函数本身。这经常会导致不好的结果。



## 线程安全相关

libcurl 是线程安全的，但没有内部线程同步。如果您遇到以下任何线程安全异常，您可能必须提供自己的锁定。

* 句柄：您绝不能在多个线程中共享同一个句柄。您可以在线程之间传递句柄，但在任何给定时间都不得使用来自多个线程的单个句柄。

* 共享对象：您可以使用共享接口在多个句柄之间共享某些数据，但您必须提供自己的锁定并设置`curl_share_setopt`的`CURLSHOPT_LOCKFUNC` 和 `CURLSHOPT_UNLOCKFUNC`。



## 两种接口

* 简单接口：libcurl 首先引入了所谓的简单接口。简易界面中的所有操作都以“curl_easy”为前缀。简单的界面让您可以通过同步和阻塞函数调用进行单次传输。
* 多接口：libcurl 还提供了另一个接口，允许在单个线程中同时进行多个传输，即所谓的多接口。有关该接口的更多信息将在后面的单独章节中详细介绍。您仍然需要先了解简单的界面，因此请继续阅读以更好地理解。

## libcurl简单流程函数

> 简单句柄的创建

```c++
CURL *curl_easy_init(void);
```

该函数将会返回一个简单的curl句柄



> (核心函数)句柄参数的设置

```c++
#define curl_easy_setopt(handle,opt,param) curl_easy_setopt(handle,opt,param)
```

该函数向libcurl句柄设置一个参数，比如通讯协议、地址、端口、发送数据等。

>  `常用句柄参数`

```c++
CURLOPT_URL //指定要访问的 URL。

CURLOPT_POSTFIELDS //设置请求体的内容。
    
CURLOPT_POSTFIELDSIZE //设置请求体内容长度。

CURLOPT_HEADER //设置是否返回响应头信息。

CURLOPT_HTTPHEADER //设置请求头信息，可以包含多个头部。
    
CURLOPT_COOKIE //设置请求中的 cookie 信息。

CURLOPT_USERAGENT //设置用户代理信息，用于标识请求来源。即HTTP中的UA
    
CURLOPT_HTTPGET //设置 HTTP GET 请求方法。
    
CURLOPT_POST //设置 HTTP POST 请求方法。
    
CURLOPT_PUT //设置 HTTP PUT 请求方法。
    
CURLOPT_CUSTOMREQUEST //自定义 HTTP 请求方法，如 DELETE、HEAD、OPTIONS 等。
    
CURLOPT_NOBODY //设置 HTTP 请求方法为 HEAD，只获取响应头部信息，不获取响应体。
    
CURLOPT_HTTP_VERSION //设置 HTTP 协议版本，如 CURL_HTTP_VERSION_NONE、CURL_HTTP_VERSION_1_0、CURL_HTTP_VERSION_2_0 等。

CURLOPT_FOLLOWLOCATION //设置是否跟随重定向。

CURLOPT_TIMEOUT //设置请求超时时间。

CURLOPT_CONNECTTIMEOUT //设置连接超时时间。

CURLOPT_SSL_VERIFYPEER //设置是否验证 SSL 证书。

CURLOPT_SSL_VERIFYHOST //设置是否验证 SSL 证书主机名。

CURLOPT_VERBOSE //设置是否输出调试信息。

CURLOPT_PROGRESSFUNCTION //设置进度回调函数，用于监控请求进度。

CURLOPT_WRITEDATA //设置写入数据的位置，如文件指针、缓冲区等。

CURLOPT_READDATA //设置读取数据的位置，如文件指针、缓冲区等，如果设置自定义返回数据处理回调函数，设置的位置将会被传递给回调函数中的ptr
    
CURLOPT_WRITEFUNCTION //设置自定义返回数据处理回调
    
CURLSHOPT_USERDATA		//设置传入回调函数的共享数据，所有回调通用
```

>  `自定义数据处理函数定义`

```c++
size_t write_callback(char *ptr, size_t size, size_t nmemb, void *userdata);
```

回调函数 `write_callback` 接收 4 个参数：

\- `ptr`：指向接收到的数据的指针；

\- `size`：每个数据块的大小；

\- `nmemb`：数据块的数量；
\- `userdata`：用户自定义的指针，用于在回调函数中传递额外的参数。

回调函数的返回值为 `size_t` 类型，表示接收到的数据的大小。如果返回的大小不等于 `size * nmemb`，则会被视为错误，导致请求失败。

* `libcurl` 提供自己的默认内部回调，如果您没有使用`CURLOPT_WRITEFUNCTION`设置回调，它将处理数据。然后它将简单地将接收到的数据输出到标准输出。您可以让默认回调将数据写入不同的文件句柄。
* 在某些平台上，`libcurl` 将无法对程序打开的文件进行操作。在这些平台上，当使用默认回调并使用`CURLOPT_WRITEDATA`传入打开的文件，程序将崩溃。因此，您应该避免这种情况，以使您的程序几乎在任何地方都能正常运行。

>  `例子`

```c++
int write_callback(char *data, size_t size, size_t nmemb, std::string *writer_data) {
    if (writer_data == nullptr) {
        return 0;
    }
    writer_data->append(data, size * nmemb);
    return size * nmemb;
}


// 设置 URL
curl_easy_setopt(curl, CURLOPT_URL, "http://127.0.0.1:8888/a");

// 设置接收响应数据的回调函数及缓冲区
curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);
curl_easy_setopt(curl, CURLOPT_WRITEDATA, &response_data);
```



> 开始进行传输

```c++
CURLcode curl_easy_perform(CURL *curl);
```

该函数开始使用句柄中设置的协议和参数来进行实际的数据传输

* `curl`：curl句柄



> 重置句柄

```c++
void curl_easy_reset(CURL *curl);
```

该函数将重置对应的curl句柄，并且清除其相关的状态信息等数据(比如cookie等)

* `curl`：curl句柄



> 清理句柄

```c++
void curl_easy_cleanup(CURL *curl);
```

清理libcurl中的句柄，但是请注意，libcurl句柄可以重复使用，并且保存与服务器通讯相关的状态信息(比如http的 cookie等)，并且句柄可以重置，不需要总是频繁的释放。

* `curl`：curl句柄



> 常见libcurl返回码(CURLcode)

```c++
CURLE_OK //操作成功完成。

CURLE_UNSUPPORTED_PROTOCOL //不支持的协议。

CURLE_URL_MALFORMAT //URL 格式不正确。

CURLE_COULDNT_RESOLVE_HOST //无法解析主机名。

CURLE_COULDNT_CONNECT //无法连接到服务器。

CURLE_SSL_CONNECT_ERROR //SSL 连接错误。

CURLE_OPERATION_TIMEDOUT //操作超时。

CURLE_HTTP_RETURNED_ERROR //HTTP 返回错误，例如 404、500 等。

CURLE_WRITE_ERROR //写入数据错误。

CURLE_READ_ERROR //读取数据错误。

CURLE_ABORTED_BY_CALLBACK //操作被回调函数取消。

CURLE_OUT_OF_MEMORY //内存不足。

CURLE_SSL_CERTPROBLEM //SSL 证书问题。

CURLE_SSL_CIPHER //SSL 密码问题。

CURLE_SSL_CACERT //SSL CA 证书问题。
```



## 多线程数据共享

> 初始化共享句柄

```c++
CURLSH *curl_share_init(void);
```

该函数返回一个初始化了的共享句柄



> 清理共享句柄

```c++
CURLSHcode curl_share_cleanup(CURLSH *share);
```

该函数清理初始化过的共享句柄



> 相关句柄参数

```c++
CURLSHOPT_LOCKFUNC //设置共享句柄的上锁回调函数，当 libcurl 内部需要访问共享数据时，会调用这个回调函数，以获取该数据的互斥锁，确保在同一时刻只有一个线程可以访问该共享数据。

CURLSHOPT_UNLOCKFUNC //设置共享句柄的解锁回调函数，当 libcurl 内部完成对共享数据的访问后，会调用这个回调函数，以释放该数据的互斥锁，让其他线程可以继续访问该共享数据。

CURLSHOPT_SHARE //设置该共享句柄允许共享的数据。比如在多个句柄之间共享 DNS 缓存、连接缓存、cookie 缓存、SSL 会话等。
    
    
CURLOPT_SHARE //给一般的句柄设置共享句柄，相同共享句柄的一般句柄即可在多线程中共享数据
```


> 锁回调函数介绍

```c++
typedef void (*curl_lock_function)(CURL *handle, curl_lock_data data, curl_lock_access access, void *userptr);
typedef void (*curl_unlock_function)(CURL *handle, curl_lock_data data, void *userptr);
```

* `handle` ：当前调用的 libcurl 句柄；
* `data` ：正在访问的共享资源的类型，比如 DNS 缓存、cookie 数据等；
* `access` ：当前请求的类型，读或写；
* `userptr` 是通过 CURLSHOPT_USERDATA 设置的用户数据指针；



> 设置共享数据实例

```c++
//创建共享句柄
CURLSH* share_handle = curl_share_init();
curl_share_setopt(share_handle, CURLSHOPT_SHARE, CURL_LOCK_DATA_COOKIE);		//设置允许共享cookie
curl_share_setopt(share_handle, CURLSHOPT_SHARE, CURL_LOCK_DATA_DNS);			//设置允许共享dns缓存

// 创建CURL会话句柄
CURL* curl_handle1 = curl_easy_init();
CURL* curl_handle2 = curl_easy_init();

// 将CURL会话句柄与共享会话句柄相关联
curl_easy_setopt(curl_handle1, CURLOPT_SHARE, share_handle);
curl_easy_setopt(curl_handle2, CURLOPT_SHARE, share_handle);

// 设置CURL会话句柄的其他参数
curl_easy_setopt(curl_handle1, CURLOPT_URL, "http://www.example.com");
curl_easy_setopt(curl_handle2, CURLOPT_URL, "http://www.example.com");

// 执行CURL请求
curl_easy_perform(curl_handle1);
curl_easy_perform(curl_handle2);

// 清理资源
curl_easy_cleanup(curl_handle1);
curl_easy_cleanup(curl_handle2);
curl_share_cleanup(share_handle);
curl_global_cleanup();
```



> 共享句柄常见返回码(CURLSHcode)

```c++
CURLSHE_OK //操作成功。

CURLSHE_BAD_OPTION //指定的共享句柄选项无效。

CURLSHE_IN_USE //共享句柄当前正在使用中，不能执行请求的操作。

CURLSHE_INVALID //无效的共享句柄。

CURLSHE_NOMEM //内存分配失败。

CURLSHE_NOT_BUILT_IN //共享句柄不支持请求的操作。

CURLSHE_LAST //表示错误码的范围。

在使用共享句柄相关函数时，可以根据返回的CURLSHcode值判断操作是否成功，以及错误原因。
```


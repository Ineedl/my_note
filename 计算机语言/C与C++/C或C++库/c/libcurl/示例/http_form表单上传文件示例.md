## 文件方式
```c++
#include <curl/curl.h>

int main() {
    CURL* curl = curl_easy_init();
    if (!curl) {
        // 初始化 curl 失败
        return 1;
    }

    // 设置上传的文件
    const char* filepath = "/path/to/file.png";

    // 设置 POST 请求
    curl_easy_setopt(curl, CURLOPT_POST, 1L);

    // 创建一个 curl_formdata_style 结构体，用于存储表单项
    struct curl_httppost* form = NULL;
    struct curl_httppost* last = NULL;

  	// 添加非文件数据项
    //如果使用 CURLFORM_PTRNAME 和 CURLFORM_PTRCONTENTS ，则用户需要保证数据在请求期间以及响应处理完前 数据不会被释放
    curl_formadd(&post, &last, CURLFORM_COPYNAME, "field1", CURLFORM_COPYCONTENTS, "value1", CURLFORM_END);
    curl_formadd(&post, &last, CURLFORM_COPYNAME, "field2", CURLFORM_COPYCONTENTS, "value2", CURLFORM_END);
  
  	//如果使用 CURLFORM_PTRNAME 和 CURLFORM_PTRCONTENTS ，则用户需要保证数据在请求期间以及响应处理完前 数据不会被释放
    // 添加一个文件项到表单中
    curl_formadd(&form, &last,
                 CURLFORM_COPYNAME, "file",
                 CURLFORM_FILE, filepath,			//传递文件不需要指定长度
                 CURLFORM_CONTENTTYPE, "image/png",
                 CURLFORM_END);

    // 设置请求 URL
    curl_easy_setopt(curl, CURLOPT_URL, "http://example.com/upload");

    // 将表单项添加到请求中
    curl_easy_setopt(curl, CURLOPT_HTTPPOST, form);

    // 发送请求
    CURLcode res = curl_easy_perform(curl);

    // 释放表单项内存
    curl_formfree(form);

    // 清理 curl
    curl_easy_cleanup(curl);

    if (res != CURLE_OK) {
        // 发送请求失败
        return 1;
    }

    return 0;
}

```

## buffer方式

```c++
#include <curl/curl.h>
#include <iostream>

int main() {
    CURL *curl;
    CURLcode res;
    struct curl_httppost* post = NULL;
    struct curl_httppost* last = NULL;
    char buf[] = "Hello, world!";

    curl_global_init(CURL_GLOBAL_ALL);
    curl = curl_easy_init();
    if(curl) {
      //如果使用 CURLFORM_PTRNAME 和 CURLFORM_PTRCONTENTS ，则用户需要保证数据在请求期间以及响应处理完前 数据不会被释放
        curl_formadd(&post, &last,
            CURLFORM_COPYNAME, "file",
            CURLFORM_BUFFER, "example.txt",
            CURLFORM_BUFFERPTR, buf,
            CURLFORM_BUFFERLENGTH, strlen(buf),		//传递buffer需要指定长度
            CURLFORM_END);
        curl_easy_setopt(curl, CURLOPT_URL, "http://localhost/upload.php");
        curl_easy_setopt(curl, CURLOPT_HTTPPOST, post);
        res = curl_easy_perform(curl);
        if(res != CURLE_OK)
            std::cerr << "curl_easy_perform() failed: " << curl_easy_strerror(res) << std::endl;
        curl_easy_cleanup(curl);
    }
    curl_formfree(post);
    curl_global_cleanup();
    return 0;
}

```


## curl_formadd

```c++
CURLFORMcode curl_formadd(struct curl_httppost** httppost, 
                          struct curl_httppost** last_post, ...);
```

`curl_formadd` 是 libcurl 中用来创建 multipart/form-data 格式数据的函数，可以用于创建 POST 请求中的表单数据。该函数的函数原型如下：

```
arduinoCopy code
CURLFORMcode curl_formadd(struct curl_httppost** httppost, 
                          struct curl_httppost** last_post, ...);
```

该函数有三个参数，分别是：

- `httppost`: 指向指针的指针，即存储新表单元素的指针数组，这里会填充新的表单元素。
- `last_post`: 指向指针的指针，即最后一个表单元素的指针数组，这里会在其后面添加新的表单元素。
- `...`: 该参数为可变参数，用于指定表单元素的属性，以 NULL 结束。当然也可以使用`CURLFORM_END`等同于null。



在使用 `curl_formadd()` 函数构建 POST 表单时，可以使用一个链表结构体 `struct curl_httppost` 来存储表单内容。每个节点代表一个表单元素，而 `last_post` 参数则用来指向链表的最后一个节点。当向表单中添加新元素时，使用 `curl_formadd()` 函数时会自动更新 `last`_post 指针，因此在最后只需要将 `httppost` 参数传递给 `CURLOPT_HTTPPOST` 选项即可。



`常用参数`

```c++
CURLFORM_COPYNAME		//指定表单数据名称，但是会自己开辟空间拷贝一份名称数据
CURLFORM_PTRNAME		//指定表单数据名称，但是使用用户传递字符的空间
  
CURLFORM_COPYCONTENTS //指定表单数据的值，但是会自己开辟空间拷贝一份值数据
CURLFORM_PTRCONTENTS //指定表单数据的值，但是使用用户传递字符的空间

CURLFORM_NAMELENGTH //表单元素名称的长度，类型为 long。
CURLFORM_CONTENTSLENGTH //表单元素内容的长度，类型为 long。	//一般不需要特别指定
CURLFORM_FILE //文件上传的路径，类型为 const char*。
CURLFORM_CONTENTTYPE //表单元素的 MIME 类型，类型为 const char*。
CURLFORM_FILENAME //文件上传时指定的文件名，类型为 const char*。
  
CURLFORM_END //用于表明这个表单元素是链表中的最后一个元素。
  
//以buffer传递文件时使用
CURLFORM_BUFFER //设置缓冲区的名称，等同于文件名
CURLFORM_BUFFERPTR //指向缓冲区的指针；
CURLFORM_BUFFERLENGTH //缓冲区的长度；
  
```

`使用file上传文件示例`

```c++
// 设置 POST 请求
curl_easy_setopt(curl, CURLOPT_POST, 1L);

// 创建一个 curl_formdata_style 结构体，用于存储表单项
struct curl_httppost* form = NULL;
struct curl_httppost* last = NULL;

// 添加非文件数据项
//如果使用 CURLFORM_PTRNAME 和 CURLFORM_PTRCONTENTS ，则用户需要保证数据在请求期间以及响应处理完前 数据不会被释放
curl_formadd(&post, &last, CURLFORM_COPYNAME, "field1", CURLFORM_COPYCONTENTS, "value1", CURLFORM_END);
curl_formadd(&post, &last, CURLFORM_COPYNAME, "field2", CURLFORM_COPYCONTENTS, "value2", CURLFORM_END);


// 添加一个文件项到表单中
curl_formadd(&form, &last,
             CURLFORM_COPYNAME, "file",
             CURLFORM_FILE, filepath,
             CURLFORM_CONTENTTYPE, "image/png",
             CURLFORM_END);

// 设置请求 URL
curl_easy_setopt(curl, CURLOPT_URL, "http://example.com/upload");

// 将表单项添加到请求中
curl_easy_setopt(curl, CURLOPT_HTTPPOST, form);
```

`使用buffer上传文件示例`

```c++
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
        CURLFORM_BUFFERLENGTH, strlen(buf),
        CURLFORM_END);
    curl_easy_setopt(curl, CURLOPT_URL, "http://localhost/upload.php");
    curl_easy_setopt(curl, CURLOPT_HTTPPOST, post);
    res = curl_easy_perform(curl);
    if(res != CURLE_OK)
        std::cerr << "curl_easy_perform() failed: " << curl_easy_strerror(res) << std::endl;
    curl_easy_cleanup(curl);
}
```


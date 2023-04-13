## NDC
NDC使得多个线程使用一个函数时，利用堆栈机制，来根据不同的线程来输出相关的日志

## 常用函数
* NDC log4cplus::getNDC()  

该函数用于获取一个NDC对象


* push(str)

该函数用于设置与当前线程相关的日志标识

* pop()

该函数用于去掉与当前线程相关的日志标识

* remove()

该函数用于清理当前线程使用的NDC资源


* NDCContextCreator:NDCContextCreator_first_ndc(str);

该函数相当于 getNDC push pop remove的整合。

## 一般使用方法
`使用实例`


    std::string pattern = "NDC:[%x] - %m %n";
    std::auto_ptr _layout(new PatternLayout(pattern));
    ... ...
    
    
    //进入线程
    NDC& ndc = log4cplus::getNDC();
    
    ndc.push("某个线程变量相关字符串，该字符串在线程不同时表现的字符串不同");
    
    //输出日志会输出push的信息，之后用户可以根据该信息来区分不同线程的日志
    //该信息会加上push中的信息
    LOG4CPLUS_WARN(_logger, "This is the SECOND log message...");
    
    //工作完成
    
    //注意一个线程只能一次push和一次pop
    ndc.pop();
    ndc.remove();
    //离开线程
    
## 另外一种方法
更简单的使用方法是在线程中直接用
    
    NDCContextCreator:NDCContextCreator_first_ndc("ur ndc string");

    LOG4CPLUS_DEBUG(logger, "this is a NDC test")
    
不必显式地调用 push/pop 了，而且当出现异常时，能够确保 push 与 pop 的调用是
匹配的。
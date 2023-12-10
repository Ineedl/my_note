## Loglog
LogLog 类实现了 debug, warn, error 函数用于 logcplus 运行时显示 log4cplus 自身的
调试、警告或错误信息，是对标准输出的简单封装，它也可以用来进行简单的日志输出。

 > LogLog 同时提供了两个方法来进一步控制所输出的信息
 
 `setInternalDebugging(bool)`

该用来控制是否屏蔽输出信息中的调试信息，当输入参数为 false 则屏蔽，缺省设置为 false。 

`setQuietMode(bool)`

该方法用来控制是否屏蔽所有输出信息，当输入参数为 true 则屏蔽，缺省设置为 false。


> Loglog使用实例

    #include <iostream>
    #include <log4cplus/helpers/loglog.h>
    
    using namespace log4cplus::helpers;
    void printMsgs(void)
    {
        std::cout << "Entering printMsgs()..." << std::endl;
        LogLog::getLogLog()->debug("This is a Debug statement...");
        LogLog::getLogLog()->warn("This is a Warning...");
        LogLog::getLogLog()->error("This is a Error...");
        std::cout << "Exiting printMsgs()..." << std::endl << std::endl;
    }
    int main()
    { 
        printMsgs();
        std::cout << "Turning on debug..." << std::endl;
        LogLog::getLogLog()->setInternalDebugging(true);
        printMsgs();
        std::cout << "Turning on quiet mode..." << std::endl;
        LogLog::getLogLog()->setQuietMode(true);
        printMsgs();
        return 0;
    }
    
* LogLog输出信息中总是包含"log4cplus:"前缀，这是因为 LogLog 在实现时候在构造函数中进行了硬编码，如果想要换成自己的或是去掉，请更改源码。
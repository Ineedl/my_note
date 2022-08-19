## 使用脚本文件语句

PropertyConfigurator::doConfigure("urconfig.properties");


* 使用了该语句读取脚本文件后，就可以在程序中使用对应的Logger来给宏输出。

例子

    /* urconfig.properties */
    log4cplus.rootLogger=TRACE, ALL_MSGS, TRACE_MSGS, DEBUG_INFO_MSGS, 
    FATAL_MSGS
    log4cplus.appender.ALL_MSGS=log4cplus::RollingFileAppender
    log4cplus.appender.ALL_MSGS.File=all_msgs.log
    log4cplus.appender.ALL_MSGS.layout=log4cplus::TTCCLayout
    log4cplus.appender.TRACE_MSGS=log4cplus::RollingFileAppender
    log4cplus.appender.TRACE_MSGS.File=trace_msgs.log
    log4cplus.appender.TRACE_MSGS.layout=log4cplus::TTCCLayout
    log4cplus.appender.TRACE_MSGS.filters.1=log4cplus::spi::LogLevelMatchFilter
    log4cplus.appender.TRACE_MSGS.filters.1.LogLevelToMatch=TRACE
    log4cplus.appender.TRACE_MSGS.filters.1.AcceptOnMatch=true
    log4cplus.appender.TRACE_MSGS.filters.2=log4cplus::spi::DenyAllFilter
    log4cplus.appender.DEBUG_INFO_MSGS=log4cplus::RollingFileAppender
    log4cplus.appender.DEBUG_INFO_MSGS.File=debug_info_msgs.log
    log4cplus.appender.DEBUG_INFO_MSGS.layout=log4cplus::TTCCLayout
    log4cplus.appender.DEBUG_INFO_MSGS.filters.1=log4cplus::spi::LogLevelRangeFilter
    log4cplus.appender.DEBUG_INFO_MSGS.filters.1.LogLevelMin=DEBUG
    log4cplus.appender.DEBUG_INFO_MSGS.filters.1.LogLevelMax=INFO
    log4cplus.appender.DEBUG_INFO_MSGS.filters.1.AcceptOnMatch=true
    log4cplus.appender.DEBUG_INFO_MSGS.filters.2=log4cplus::spi::DenyAllFilter
    log4cplus.appender.FATAL_MSGS=log4cplus::RollingFileAppender
    log4cplus.appender.FATAL_MSGS.File=fatal_msgs.log
    log4cplus.appender.FATAL_MSGS.layout=log4cplus::TTCCLayout
    log4cplus.appender.FATAL_MSGS.filters.1=log4cplus::spi::StringMatchFilter
    log4cplus.appender.FATAL_MSGS.filters.1.StringToMatch=FATAL
    log4cplus.appender.FATAL_MSGS.filters.1.AcceptOnMatch=true
    log4cplus.appender.FATAL_MSGS.filters.2=log4cplus::spi::DenyAllFilter
    
    //程序
    
    #include <log4cplus/logger.h>
    #include <log4cplus/configurator.h>
    #include <log4cplus/helpers/stringhelper.h>
    using namespace log4cplus;
    static Logger logger = Logger::getInstance("log");
    void printDebug()
    {
        LOG4CPLUS_TRACE_METHOD(logger, "::printDebug()");
        LOG4CPLUS_DEBUG(logger, "This is a DEBUG message");
        LOG4CPLUS_INFO(logger, "This is a INFO message");
        LOG4CPLUS_WARN(logger, "This is a WARN message");
        LOG4CPLUS_ERROR(logger, "This is a ERROR message");
        LOG4CPLUS_FATAL(logger, "This is a FATAL message");
    }
    int main()
    {
        Logger root = Logger::getRoot();
        PropertyConfigurator::doConfigure("urconfig.properties");
        printDebug();
        return 0;
    }
    
## 脚本文件的动态加载
多线程版本的 log4cplus 提供了实用类 ConfigureAndWatchThread，该类启动线程对配置脚本进行监控，一旦发现配置脚本被更新则立刻重新加载配置。

`构造函数`
ConfigureAndWatchThread(const log4cplus::tstring& propertyFile,unsigned int millis = 60 * 1000);

* propertyFile 配置脚本的路径
* millis 监控时两次更新检查相隔的时间，单位为耗秒 ms。
    

`例子`

    #include <log4cplus/logger.h>
    #include <log4cplus/configurator.h>
    #include <log4cplus/helpers/loglog.h>
    #include <log4cplus/helpers/stringhelper.h>
    using namespace std;
    using namespace log4cplus;
    using namespace log4cplus::helpers;
    Logger log_1 = Logger::getInstance("test.log_1");
    Logger log_2 = Logger::getInstance("test.log_2");
    Logger log_3 = Logger::getInstance("test.log_3");
    void printMsgs(Logger& logger)
    {
        LOG4CPLUS_TRACE_METHOD(logger, "printMsgs()");
        LOG4CPLUS_DEBUG(logger, "printMsgs()");
        LOG4CPLUS_INFO(logger, "printMsgs()");
        LOG4CPLUS_WARN(logger, "printMsgs()");
        LOG4CPLUS_ERROR(logger, "printMsgs()");
    }
    int main()
    {
        cout << "Entering main()..." << endl;
        LogLog::getLogLog()->setInternalDebugging(true);
        Logger root = Logger::getRoot();
        try {
            ConfigureAndWatchThread configureThread("log4cplus.properties", 5 * 1000);
            LOG4CPLUS_WARN(root, "Testing....")
        for(int i=0; i<100; ++i) {
        printMsgs(log_1);
        printMsgs(log_2);
        printMsgs(log_3);
        log4cplus::helpers::sleep(1);
    }
    
    }
    catch(...) {
        cout << "Exception..." << endl;
        LOG4CPLUS_FATAL(root, "Exception occured...")
    }
        cout << "Exiting main()..." << endl;
        return 0;
    }

## log4cplus脚本详解暂不做论述
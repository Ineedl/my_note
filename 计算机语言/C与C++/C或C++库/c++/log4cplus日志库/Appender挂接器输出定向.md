## Appender
Appender与Layout和Filter紧密配合，其决定了输出的位置(文件，控制台，远程服务器等)

* 一个Logger对象可以同时关联多个Appender对象。

* 一个Appender对象只能添加一个Layout对象

## 重定向到控制台
log4cplus 默认将输出到控制台，提供 ConsoleAppender 用于操作。该类使用方法很简单，示例也有，这里不做说明

## 重定向到文件
log4cplus 提供了三个类用于文件操作，  
FileAppender 类、  
RollingFileAppender类、  
DailyRollingFileAppender 类。

> FileAppender

该类实现了基本的文件操作功能

`构造函数`  
FileAppender ::FileAppender(  
const log4cplus::tstring& filename,  
LOG4CPLUS_OPEN_MODE_TYPE mode = LOG4CPLUS_FSTREAM_NAMESPACE::ios::trunc,  
bool immediateFlush = true);

* filename : 文件名
* mode : 文件类型，可选择的文件类型包括 app、ate、binary、in、out、trunc，
因为实际上只是对 stl 的一个简单包装，这里就不多讲了。缺省是 trunc，表示将先
前文件删除。
* immediateFlush : 缓冲刷新标志，如果为 true 表示每向文件写一条记录就刷新一次
缓存，否则直到 FileAppender 被关闭或文件缓存已满才更新文件，一般是要设置 true
的，比如你往文件写的过程中出现了错误（如程序非正常退出），即使文件没有正常
关闭也可以保证程序终止时刻之前的所有 记录都会被正常保存。


`使用实例`


    //下列代码演示在utf-8编码环境下
    //如果为Unicode，则需要给所有字符串加上LOG4CPLUS_TEXT()

    #include <log4cplus/logger.h>
    #include <log4cplus/fileappender.h>
    using namespace log4cplus;
    int main()
    {

        SharedAppenderPtr _append(new FileAppender("Test.log"));
        _append->setName("file log test");
        
        Logger _logger = Logger::getInstance("test.subtestof_filelog");
        Log4cplus 使用指南
        11
        
        _logger.addAppender(_append);
        
        int i;
        for( i = 0; i < 5; ++i )
        {
            LOG4CPLUS_DEBUG(_logger, "Entering loop #" << i << "End line #");
        }
        return 0;
    }
    
    输出结果（Test.log 文件）：
    DEBUG - Entering loop #0End line #
    DEBUG - Entering loop #1End line #
    DEBUG - Entering loop #2End line #
    DEBUG - Entering loop #3End line #
    DEBUG - Entering loop #4End line #
    
    
> RollingFileAppender

RollingFileAppender实现了可以滚动转储的文件操作功能

`构造函数`
RollingFileAppender::RollingFileAppender(  
const log4cplus::tstring& filename,  
long maxFileSize,  
int maxBackupIndex,  
bool immediateFlush  
)

* filename : 文件名
* maxFileSize : 文件的最大尺寸，单位为字节，默认最小为200K，少于200k则除了第一个转储文件外，其他都为200k
* maxBackupIndex : 最大记录文件数
* immediateFlush : 缓冲刷新标志

RollingFileAppender 类可以根据你预先设定的大小来决定是否转储，当超过该大小，
后续 log 信息会另存到新文件中。  

除了定义每个记录文件的大小之外，你还要确定在RollingFileAppender 类对象构造时最多需要多少个这样的记录文件(maxBackupIndex+1)，当存储的文件数目超过 maxBackupIndex+1 时，会删除最早生成的文件，保证整个文件数目等于 maxBackupIndex+1。然后继续记录。


`使用实例`  
    
    
    //下列代码演示在utf-8编码环境下
    //如果为Unicode，则需要给所有字符串加上LOG4CPLUS_TEXT()
    SharedAppenderPtr _append(new RollingFileAppender("Test.log", 5*1024, 5));
    
    _append->setName("file test");
    
    _append->setLayout( std::auto_ptr(new TTCCLayout()) );
    
    Logger::getRoot().addAppender(_append);
    
    Logger root = Logger::getRoot();
    
    Logger test = Logger::getInstance("test");
    
    Logger subTest = Logger::getInstance("test.subtest");
    
    for(int i=0;i<800*1024;i++) {
        LOG4CPLUS_DEBUG(subTest, "Entering loop #" << i);
    }
    //输出文件除了这里除了 Test.log 之外，每个文件的大小都是 200K
    
    //
    运行后会产生多个输出文件，Test.log、Test.log.1、Test.log.2、Test.log.3、Test.log.4、...
    
> DailyRollingFileAppender

DailyRollingFileAppender实现了根据频度来决定是否转储的文件转储功能

`构造函数`  
DailyRollingFileAppender::DailyRollingFileAppender(  
const log4cplus::tstring& filename,  
DailyRollingFileSchedule schedule,  
bool immediateFlush,  
int maxBackupIndex  
)

* filename : 文件名
* chedule : 存储频度
* immediateFlush : 缓冲刷新标志
* maxBackupIndex : 最大记录文件数  

DailyRollingFileAppender 类可以根据你预先设定的频度来决定是否转储，当超过该
频度，后续 log 信息会另存到新文件中。  
这里的频度包括：MONTHLY（每月）、WEEKLY（每周）、DAILY（每日）、TWICE_DAILY（每两天）、HOURLY（每时）、MINUTELY（每分）。


`实例`


    SharedAppenderPtr _append(new DailyRollingFileAppender("Test.log", MINUTELY, true, 5));
    
    _append->setName("file test");
    
    _append->setLayout( std::auto_ptr(new TTCCLayout()) );
    
    Logger::getRoot().addAppender(_append);
    
    Logger root = Logger::getRoot();
    
    Logger test = Logger::getInstance("test");
    
    Logger subTest = Logger::getInstance("test.subtest");
    
    for(int i=0;i<400*1024;i++){
        LOG4CPLUS_DEBUG(subTest, "Entering loop #" << i)
    }
    
    //
    运行后会以分钟为单位，分别生成名为Test.log.2004-10-17-03-03 、Test.log.2004-10-17-03-04 和 Test.log.2004-10-17-03-05 这样的文件。
    
## 重定向到远程服务器
了解SocketAppender类型，暂时用不到，不做赘述。
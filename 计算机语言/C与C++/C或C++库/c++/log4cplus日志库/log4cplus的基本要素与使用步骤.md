## [github地址](https://github.com/log4cplus/log4cplus)

## log4cplus基本要素
* Layouts：布局器，控制输出消息的格式。  

* Appenders：挂接器，与布局器紧密配合，将特定格式的消息输出到所挂接的设备终端（如屏幕，文件等等)。 

* Logger：记录器，保存并跟踪对象日志信息变更的实体，当你需要对一个对象进行记录时，就需要生成一个logger。

* Categories：分类器，层次化（hierarchy）的结构，用于对被记录信息的分类，层次中每一个节点维护一个logger的所有信息。

* Priorities：优先权，包括TRACE, DEBUG, INFO, WARNING, ERROR, FATAL。


## 使用log4cplus的六个基本步骤
1. 实例化一个appender对象  

2. 实例化一个layout对象  

3. 将layout对象绑定(attach)到appender对象  

4. 实例化一个logger对象,调用静态函数：log4cplus::Logger::getInstance("logger_name")

5. 将appender对象绑定(attach)到logger对象，如省略此步骤，标准输出（屏幕）appender对象会绑定到logger

6. 设置logger的优先级，如省略此步骤，各种有限级的消息都将被记录


`例：完整使用六个步骤`

    #include <log4cplus/logger.h>
    #include <log4cplus/consoleappender.h>
    #include <log4cplus/layout.h>
    #include <log4cplus/loggingmacros.h>
    
    using namespace log4cplus;
    using namespace log4cplus::helpers;
    
    int main()
    {
    	/* step 1: 设置一个输出对象，就是在哪里输出日志，屏幕就是console */
    	SharedObjectPtr<Appender> _append(new ConsoleAppender());
    	_append->setName(LOG4CPLUS_TEXT("append for test"));
    	
    	/* step 2: 设置一个日志输出格式的对象 ，这里格式为时间 工作目录文件，行以及换行 */
    	std::auto_ptr<Layout> _layout(new PatternLayout(LOG4CPLUS_TEXT("%d{%m/%d/%y %H:%M:%S}  - %m [%l]%n")));
    	
    	/* step 3: 绑定屏幕和格式对象 */
    	_append->setLayout(_layout);
    	
    	/* step 4: 设置一个日志对象，还有名字 */
    	Logger _logger = Logger::getInstance(LOG4CPLUS_TEXT("test"));
    	
    	/* step 5: 绑定日志对象和屏幕  */
    	_logger.addAppender(_append);
    	
    	/* step 6: Se设置日志优先级，应该是打印那些级别的日志  */
    	_logger.setLogLevel(ALL_LOG_LEVEL);
    	
    	/* 日志输出 */
    	LOG4CPLUS_DEBUG(_logger, "This is the FIRST log message...");
    	LOG4CPLUS_WARN(_logger, "This is the SECOND log message...");
    	getchar();
    	return 0;
    }
    
`例：只使用1 4 5步骤简洁实现`

    #include <log4cplus/logger.h>
    #include <log4cplus/consoleappender.h>
    #include <log4cplus/loggingmacros.h>
    using namespace log4cplus;
    using namespace log4cplus::helpers;
    int main()
    {
    	/* step 1: 设置一个输出对象，就是在哪里输出日志，屏幕就是console */
    	SharedAppenderPtr _append(new ConsoleAppender());
    	_append->setName(LOG4CPLUS_TEXT("append test"));
    	
    	/* step 4: 设置一个日志对象，还有名字  */
    	Logger _logger = Logger::getInstance(LOG4CPLUS_TEXT("test"));
    	
    	/* step 5: 绑定日志对象和屏幕 */
    	_logger.addAppender(_append);
    	
    	/* 日志输出 */
    	LOG4CPLUS_DEBUG(_logger, "This is the FIRST log message...");
    	LOG4CPLUS_WARN(_logger, "This is the SECOND log message...");
    	getchar();
    	return 0;
    }
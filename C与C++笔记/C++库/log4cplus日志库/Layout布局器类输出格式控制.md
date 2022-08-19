## Layouts介绍
log4cplus通过布局器(Layouts)来控制输出的格式，log4cplus提供了三种类型的Layouts。  
SimpleLayout，PatternLayout，TTCCLayout

## SimpleLayout
一个默认使用的简单格式布局器，在输出的原始信息之前加上LogLevel和一个"-"，若初始化时没有将布局器附加到挂载器(输出目标定位类)，则默认使用SimpleLayout

`使用例`


    //下列代码演示在utf-8编码环境下
    //如果为Unicode，则需要给所有字符串加上LOG4CPLUS_TEXT()
    
    SharedObjectPtr _append (new ConsoleAppender());
    _append->setName("append for test");

    std::auto_ptr<Layout> _layout(new log4cplus::SimpleLayout());

    _append->setLayout( _layout );

    Logger _logger = Logger::getInstance("test");

    _logger.addAppender(_append);

    LOG4CPLUS_DEBUG(_logger, LOG4CPLUS_TEXT("This is the simple formatted log message..."));
    
    输出结果：
    DEBUG - This is the simple formatted log message...
    
## PatternLayout
一种有词法分析功能的模式布局器，类似于 C 语言的 printf()函数，能够对预定义
的转换标识符（conversion specifiers）进行解析，转换成特定格式输出。


`使用实例`

    //下列代码演示在utf-8编码环境下
    //如果为Unicode，则需要给所有字符串加上LOG4CPLUS_TEXT()
    
    SharedObjectPtr _append (new ConsoleAppender());
    _append->setName("append for test");
    
    std::string pattern = "%d{%m/%d/%y %H:%M:%S} - %m [%l]%n";
    std::auto_ptr<Layout> _layout(new PatternLayout(pattern));
     
    _append->setLayout( _layout );

    Logger _logger = Logger::getInstance("test_logger.subtest");

    _logger.addAppender(_append);

    LOG4CPLUS_DEBUG(_logger, "teststr");

    输出结果
    10/16/04 18:51:25 - teststr [main.cpp:51]

> PatterLayout 支持的转换标识符

| 转移符号<div style="width: 60pt"> |意义|
|:--|:--|
|%%|输出%|
|%c|输出 logger 名称,比如 std::string pattern ="%c" 时输出: "test_logger.subtest",也可以控制 logger 名称的显示层次，比如"%c{1}"时输出"test_logger"，其中数字表示层次|
|%D|本地标准时间，默认格式"year-month-days hh:mm:ss"|
|%d|世界标准时间，默认格式"year-month-days hh:mm:ss"|
|%F|输出当前记录器所在的文件名称|
|%L|输出当前记录器所在的文件行号|
|%m|输出原始日志信息,例如上面的"teststr"|
|%n|换行符|
|%p|输出LogLevel|
|%t|输出记录器所在的线程的ID|
|%x|输出嵌套诊断上下文 NDC (nested diagnostic context) ，从堆栈中弹出上下文信息，NDC 可以用对不同源的 log 信息（同时地）交叉输出进行区分|
|%-<num>|可以配合其他转义符使用，比如 std::string pattern ="%-10m"时表示左对齐，限定当前转移符号对应字符串的宽度是10，不加负号默认右对齐 |


* 可以通过%d{...}或%D{...}定义更详细的显示格式，比如%d{%H:%M:%s}表示要显示小时:
分钟：秒。大括号中可显示的预定义标识符如下：

|转移符号|意义|
|:--|:--|
|%a| -- 表示礼拜几，英文缩写形式，比如"Fri"|
|%A| -- 表示礼拜几，比如"Friday"|
|%b| -- 表示几月份，英文缩写形式，比如"Oct"|
|%B| -- 表示几月份，"October"|
|%c| -- 标准的日期＋时间格式，如 "Sat Oct 16 18:56:19 2004"|
|%d|表示今天是这个月的几号(1-31)"16"|
|%H| -- 表示当前时刻是几时(0-23)，如 "18"|
|%I| -- 表示当前时刻是几时(1-12)，如 "6"|
|%j| -- 表示今天是哪一天(1-366)，如 "290"|
|%m| -- 表示本月是哪一月(1-12)，如 "10"|
|%M| -- 表示当前时刻是哪一分钟(0-59)，如 "59"|
|%p| -- 表示现在是上午还是下午， AM or PM|
|%q| -- 表示当前时刻中毫秒部分(0-999)，如 "237"|
|%Q|-- 表示当前时刻中带小数的毫秒部分(0-999.999)，如 "430.732"|
|%S|-- 表示当前时刻的多少秒(0-59)，如 "32"|
|%U|-- 表示本周是今年的第几个礼拜，以周日为第一天开始计算(0-53)，如 "41"|
|%w| -- 表示礼拜几，(0-6, 礼拜天为 0)，如 "6"|
|%W| -- 表示本周是今年的第几个礼拜，以周一为第一天开始计算(0-53)，如 "41"|
|%x| -- 标准的日期格式，如 "10/16/04"|
|%X| -- 标准的时间格式，如 "19:02:34"|
|%y| -- 两位数的年份(0-99)，如 "04"|
|%Y| -- 四位数的年份，如 "2004"|
|%Z| -- 时区名，比如 "GMT"|

## TTCCLayout
TTCCLayout是在 PatternLayout 基础上发展的一种缺省的带格式输出的布局器，其格式由时间，
线程 ID，Logger 和 NDC 组成，相当于是一个格式固定的PatternLayout

`使用实例`


    //下列代码演示在utf-8编码环境下
    //如果为Unicode，则需要给所有字符串加上LOG4CPLUS_TEXT()

    SharedObjectPtr _append (new ConsoleAppender());
    _append->setName("append for test");

    std::auto_ptr _layout(new TTCCLayout());

    _append->setLayout( _layout );

    Logger _logger = Logger::getInstance("test_logger");

    _logger.addAppender(_append);

    LOG4CPLUS_DEBUG(_logger, "teststr")

    输出结果：
    10-16-04 19:08:27,501 [1075298944] DEBUG test_logger <> - teststr
    
    
TTCCLayout 在构造时有机会选择显示本地时间或 GMT 时间，缺省是按照本地时
间显示：

    TTCCLayout::TTCCLayout(bool use_gmtime = false)

如果需要构造 TTCCLayout 对象时选择 GMT 时间格式，则使用方式如下代码片断
所示。

    std::auto_ptr _layout(new TTCCLayout(true));
 
    上述例子进行该修改后输出结果：
    10-16-04 11:12:47,678 [1075298944] DEBUG test_logger <> - teststr
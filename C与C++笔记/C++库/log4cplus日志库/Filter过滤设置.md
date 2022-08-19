## Logger类利用日志等级过滤

* 过滤等级详情见 日志级别与输出宏

`设置日志过滤等级`
Logger::setLogLevel(LogLevel level);

`获取设置的日志过滤等级`
LogLevel getLogLevel() const;


## Filter过滤设置
log4plus 提 供 的 过 滤 器 包 括 DenyAllFilter 、 LogLevelMatchFilter 、
LogLevelRangeFilter、和 StringMatchFilter。

Filter以链表的形式存在，给Appender配置规则时，以链为单位配置规则。

* Filter的过滤设置建议使用脚本


> LogLevelMatchFilter   

根据特定的日志级别进行过滤。

过滤条件包括 LogLevelToMatch 和 AcceptOnMatch（true|false）， 只有当日志的
LogLevel 值与 LogLevelToMatch 相同，且 AcceptOnMatch 为 true 时才会匹配。

> LogLevelRangeFilter

根据根据日志级别的范围进行过滤。

过滤条件包括 LogLevelMin、LogLevelMax 和 AcceptOnMatch，只有当日志的
LogLevel 在 LogLevelMin、LogLevelMax 之间同时 AcceptOnMatch 为 true 时才会匹配。

> StringMatchFilter 

根据日志内容是否包含特定字符串进行过滤。

过滤条件包括 StringToMatch 和 AcceptOnMatch，只有当日志包含 StringToMatch
字符串 且 AcceptOnMatch 为 true 时会匹配。

> DenyAllFilter 

过滤掉所有消息。

> 过滤条件处理机制

后写的条件会被先执行，但是所有条件都一定会被执行

`例子`

    log4cplus.appender.append_1.filters.1=log4cplus::spi::LogLevelMatchFilter
    log4cplus.appender.append_1.filters.1.LogLevelToMatch=TRACE
    log4cplus.appender.append_1.filters.1.AcceptOnMatch=true
    log4cplus.appender.append_1.filters.2=log4cplus::spi::DenyAllFilter
    
会首先执行 filters.2 的过滤条件，关闭所有过滤器，然后执行 filters.1，仅匹配 TRACE信息
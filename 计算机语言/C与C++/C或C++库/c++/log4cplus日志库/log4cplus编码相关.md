## 日志输出编码
对于想使用Unicode编码输出日志时，log4cplus中的函数如果默认跟随系统设置则几乎log4cplus中所有需要传入字符串的函数都需要传入wchar_t字符串，此时需要一个这样的宏来转换字符串类型适配Unicode编码

    LOG4CPLUS_TEXT(StringStr)
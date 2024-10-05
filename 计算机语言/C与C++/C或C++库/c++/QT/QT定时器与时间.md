## QTimer
QTimer为定时器,其构造后可以设置一个超时时间,超时时会发出一个信号  
QTimer计时时其必须存在。

> timeout  
```
[signal] void QTimer::timeout()  
```
该信号会在定时器超时时发出    

---

> start
```
[slot] void QTimer::start(int msec)    
```
启动或重启定时器，超时时间为msec毫秒。    
如果计时器已经在运行，它将被停止并重新启动。  
如果singleShot为true，计时器只会被激活一次。  
```
[slot] void QTimer::start()      
```

以interval指定的超时时间启动或重启计时器。  
如果计时器已经在运行，它将被停止并重新启动。  
如果singleShot为true，计时器只会被激活一次。

---

> stop  
```
[slot] void QTimer::stop()  
```
停止定时器  

---

> 构造函数  
```
QTimer::QTimer(QObject *parent = Q_NULLPTR)  
```
 
QTimer的构造函数只有这一个。  

---

> setSingleShot
```
void QTimer::setSingleShot(bool singleShot)  
```

该函数设置定时器是否只激活一次,默认为false(无限次激活) 。 

> setInterval
```
void QTimer::setInterval(int msec)  
```

该函数用来设置定时器的超时时间。定时器设定定时时间为0秒有特殊意义,一般使用时最好不要将定时时间设置为0  。

超时间隔为0的QTimer将在窗口系统事件队列中的所有事件被处理后立即超时。


---
  
> interval
```
int interval() const 
```
该函数用来获取该定时器设定的定时时间。


## QTime

更详细请参考QT助手

QTime对象包含一个时钟时间，它可以表示为自午夜以来的小时、分钟、秒和毫秒数。它提供了比较时间和通过添加若干毫秒来操作时间的函数。QTime对象应该通过值传递，而不是通过对const的引用传递。

QTime使用24小时时钟格式;它没有上午/下午的概念。与QDateTime不同，QTime对时区或夏令时(DST)一无所知。

### currentTime
[static] QTime QTime::currentTime()  

返回一个具有系统时间的QTime对象

### toString
QString QTime::toString(const QString &format) const  

返回当前对象中时间的字符串,字符串显示格式由format决定

一般常用如下:  
hh:mm:ss.zzz 显示格式为：14:13:09.042

h:m:s ap 显示格式为：2:13:9 pm

H:m:s   显示格式为：14:13:9

hh::mm::s 显示格式为：14:13:9

yyyy-MM-dd hh:mm:ss dddd 显示为:年-月-日 时:分:秒 星期几

h m s z不严格区分大小写,但是他们之间必须要有:间隔,两个相同的字母表示小于10时填充0
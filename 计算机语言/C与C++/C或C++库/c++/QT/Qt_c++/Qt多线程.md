[toc]

## QT多线程

每个`QObject`都有一个所谓的“主线程”（thread affinity）。这个主线程就是创建这个`QObject`的线程。你可以通过`QObject`的`thread()`方法来获取这个`QObject`的主线程。

`QObject`的主线程有两个主要的作用：

1. 决定了这个`QObject`的事件会在哪个线程中被处理。当一个`QObject`收到一个事件（例如，一个定时器事件或者一个自定义事件）时，这个事件会被发送到这个`QObject`的主线程的[事件循环](https://so.csdn.net/so/search?spm=a2c6h.13046898.publish-article.15.cb6b6ffaj0VvAl&q=事件循环)中，然后在这个线程中被处理。
2. 决定了这个`QObject`的信号会在哪个线程中被发射。当你在一个线程中发射一个`QObject`的信号时，这个信号会被发送到这个`QObject`的主线程的事件循环中，然后在这个线程中被发射。
3. 继承了QThread和QObject的类或者转移了方法的类，他的主线程仍然是创建他的那个线程。

### 事件循环

在Qt应用程序中，每个线程都可以有自己的事件循环。

继承自QThread后，如果不调用exec()，该线程则默认不开启事件循环，如果这个线程没有运行事件循环，则以该线程为主线程的对象的信号与槽以及事件的触发，均会没有效果。

## QThread

Qt多线程使用两种方法来创建线程

* 继承QThread的方法并且重写run函数，之后通过start来启动线程。

  ```c++
  #include <QThread>
  #include <QDebug>
  
  class MyThread : public QThread {
  public:
      void run() override {
          // 这里写线程执行的代码
          qDebug() << "Thread is running in a separate thread!";
      }
  };
  
  int main() {
      MyThread thread;
      thread.start();  // 启动线程
      thread.wait();   // 等待线程完成
      return 0;
  }
  ```

* 将一个类的事件处理全部交给一个线程去处理，而不是向上面那样简单的直接使用线程。

  ```cpp
  #include <QThread>
  #include <QDebug>
  #include <QObject>
  
  class Worker : public QObject {
      Q_OBJECT
  public slots:
      void doWork() {
          qDebug() << "Worker is working in a separate thread!";
      }
  };
  
  int main() {
      QThread thread;  // 创建一个线程
      Worker worker;   // 创建一个 Worker 对象
  
      worker.moveToThread(&thread);  // 将 worker 对象移到新的线程中
  																	
      // 在新的线程中执行 doWork() 函数
    	//不一定非要叫doWork
      QObject::connect(&thread, &QThread::started, &worker, &Worker::doWork);
  
      thread.start();  // 启动线程
      thread.wait();   // 等待线程结束
  
      return 0;
  }
  ```

### 槽函数触发后的归属问题

connect函数的第五参数是默认值的情况下

* 对于继承QThread的方法并且重写run函数的方式 ，哪个线程触发的槽函数，该槽函数就是哪个线程运行。  

* 对于使用了转移事件处理的方式，转移了事件处理循环给线程的对象，他的槽函数一定都在对应转移后的线程中进行。

### 返回线程句柄

```c++
[static] Qt::HANDLE QThread::currentThreadId()
```

返回当前执行线程的线程句柄(可以用来当作tid直接输出)。

Qt::HANDLE在所有平台上被定义为void*

### 线程结束时信号

```c++
[signal] void QThread::finished()
```

经常和  

```c++
[slot] void QObject::deleteLater()
```

配合一起删除线程

### 线程休眠  

```c++
[static] void QThread::sleep(unsigned long secs) //秒级休眠  
[static] void QThread::msleep(unsigned long msecs) //毫秒级休眠    
[static] void QThread::usleep(unsigned long usecs) //微秒级休眠
```

这三个函数都是通过Thread::调用时会使调用线程休眠。

### quit

```c++
[slot] void QThread::quit()  
```

不应该理解为quit会使当前线程从事件循环中退出，并继续运行事件循环。 

该函数应该是你使用现成的主类调用exec()完后再停止线程的。  
这表示你必须从exec()返回后再调用quit停止线程。

就是差不多是从当前窗口实例的事件循环中退出后，自动帮你退出线程。

### exit

```c++
void QThread::exit(int returnCode = 0)
```

同quit，quit相当于是exit(0)的槽函数版本。

* l注意使用转移事件处理创建线程的方法需要quit和exit来终止，不然exec()结束后，线程仍会等待事件过来。但是该方法中的线程可以使用exit与quit来终止线程中的事件循环和退出线程，但是不会中断最后一次运行的任务，那个任务必须运行完后再推出

### terminate

```c++
[slot] void QThread::terminate()
```

该函数可以立即或是等待一些系统调度时间后终止现在运行的线程(不管他是否在事件循环中)。  

该函数不安全，不稳定，建议调用过后使用wait函数。

不允许该函数在正常程序中使用，只有在某个线程不会影响其他线程且它无法正常终止但是的确是需要终止时调用。

### wait

```c++
bool QThread::wait(unsigned long time = ULONG_MAX)  
```

阻塞线程，直到满足以下任一条件:

* 与这个QThread对象相关联的线程已经完成执行(即当它从run()返回时)。如果线程已经完成，这个函数将返回true。如果线程还没有启动，它也会返回true。
* 时间已经过了毫秒。如果time是ULONG_MAX(默认值)，则等待永远不会超时(线程必须从run()返回)。
* 如果等待超时，这个函数将返回false。

### moveToThread

```c++
void QObject::moveToThread(QThread *targetThread)
```

该函数设置后，将会把一个类的所有的事件处理转移给另外一个线程处理。  
比如你在别的类中触发了该类的槽函数，则一定是在转移的那个线程中进行。

如果对象有父对象，则无法移动该对象。有父对象的类的事件处理必须在父对象的事件处理循环线程中进行。

### start

```c++
[slot] void QThread::start(Priority priority = InheritPriority)
```

enum QThread::Priority指定系统如何调度新进程。

默认是使用与创建线程相同的优先度。

对于重载了run的方法，start将会启动线程。

对于转移了事件处理循环的方法，start将会开启这个事件循环调度。  
如果仅仅创建且转移了事件处理循环但是没有调用start，则相当于没有创建线程。

### finished

```c++
[signal] void QThread::finished()
```

QT线程结束后会发送的信号。

对于转移了事件处理循环的方法，一次任务结束并不会发送该信号，只有对应线程调用了quit或exit等正常结束后才会发送该信号。


## QMutex

### 构造函数

```c++
QMutex::QMutex(RecursionMode mode = NonRecursive)
```

RecursionMode的值：

QReadWriteLock::Recursive == 1 允许多次上锁，并且多次unlock解锁

QReadWriteLock::NonRecursive == 0 不允许多次上锁

### lock

```c++
void QMutex::lock() 
```

上锁  

### unlock

```c++
void QMutex::unlock()
```

解锁

### tryLock

```c++
bool QMutex::tryLock(int timeout = 0)  
```

timeout => 0 一段时间内尝试上锁  
timeout < 0 永远等待直到可以上锁

### isRecursive

```c++
bool QMutex::isRecursive()
```

查看是否允许上锁


## QMutexLocker

该锁一般被用作临时锁，构造时传入锁对象，析构时自动释放锁，在许多场合很好用。

### 构造函数  

```c++
QMutexLocker::QMutexLocker(QMutex *mutex)
```

传入锁并上锁，并在该对象销毁时解锁。  

### 返回构造该对象时传入的锁对象

```c++
QMutex *QMutexLocker::mutex() const
```

### relock

```c++
void QMutexLocker::relock()
```

用锁构造了QMutexLocker对象后仍可以操作传入的锁。

该函数把传入的锁重新上锁

### unlock

```c++
void QMutexLocker::unlock()
```

该函数把传入的锁解锁，析构时会自动判断锁是否上锁了。

## QReadWriteLock

对于读写锁

* 如果有写上锁，则直到写完成，所有的读都会等待，写也会。

* 如果有读上锁，则读上锁操作可以继续，写上锁会排入等待序列。

* 写上锁操作在等待序列中的优先级是大于读上锁操作的，在序列中永远优先处理写操作。  

### 构造函数  

```c++
QReadWriteLock::QReadWriteLock(RecursionMode recursionMode = NonRecursive)
```

RecursionMode的值：

QReadWriteLock::Recursive == 1 允许多次上锁，并且多次unlock解锁

QReadWriteLock::NonRecursive == 0 不允许多次上锁

* 注意读锁之间的允许通过原理并不是重复上锁

### 读上锁

```c++
void QReadWriteLock::lockForRead() 
```

### 写上锁

```c++
void QReadWriteLock::lockForWrite()
```

### 尝试读上锁

```c++
bool QReadWriteLock::tryLockForRead(int timeout)
bool QReadWriteLock::tryLockForWrite()
```

会被写锁阻塞

### 尝试写上锁

```c++
bool QReadWriteLock::tryLockForWrite()
bool QReadWriteLock::tryLockForWrite(int timeout)
```

会被读和写锁阻塞

### 解锁  

```c++
void QReadWriteLock::unlock()
```


## QSemaphore

信号量就相当于是一个可以多次上锁的锁。

### 构造函数  

```c++
QSemaphore::QSemaphore(int n = 0)  
```

创建一个新的信号量，并初始化它保护的资源数量为n(默认为0)。

### acquire

```c++
void QSemaphore::acquire(int n = 1)  
```

试图获取由信号量保护的n个资源。如果n > available()，这个调用将阻塞，直到有足够的资源可用。

### available

```c++
int QSemaphore::available() const
```

返回信号量当前可用的资源数量。

### release

```c++
void QSemaphore::release(int n = 1)
```

释放由信号量保护的n个资源。

如果n>available()，则更新剩余信号量为n。

### tryAcquire

```c++
bool QSemaphore::tryAcquire(int n = 1)
bool QSemaphore::tryAcquire(int n, int timeout)
```

试图获得n个信号量。

## 线程池

```c++
#include <QRunnable>
#include <QDebug>
//继承QRunnable表示是一个任务类
class MyTask : public QRunnable {
public:
    void run() override {
        // 这里写线程要执行的任务
        qDebug() << "Task is running in thread:" << QThread::currentThreadId();
    }
};
```

```c++
#include <QCoreApplication>
#include <QThreadPool>
#include <QRunnable>
#include <QDebug>

int main(int argc, char *argv[]) {
    QCoreApplication a(argc, argv);
    // 获取全局线程池实例
    QThreadPool *threadPool = QThreadPool::globalInstance();
    // 创建任务对象
    MyTask *task = new MyTask();
    // 向线程池提交任务
    threadPool->start(task);
    // 等待任务完成
    threadPool->waitForDone();
    return a.exec();
}
```


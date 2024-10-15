## Java线程的状态与迁移

![](https://note.youdao.com/yws/api/personal/file/WEB4e867cfc619c5664b8d1a8da706e3714?method=download&shareKey=5ba0a6ba98b31a1475e8aa20c8bd5bd5)

* NEW状态：线程刚创建出来时的状态。

* Runnable状态：分为Ready与Running状态。Ready为就绪状态，表示该线程在CPU等待队列中等待运行。Running状态为运行状态，表示该线程正在被CPU调度运行。

* Teminated：线程的结束状态，此时再次调用start不会再让线程进如可调度状态，而且这是不允许行为。

* TimeWaiting：有时长的线程等待状态，等待结束后线程进入Runnable状态。

* Waiting：无时长的线程等待状态，等待结束后线程进入Runnable状态。
* Blocked：阻塞状态，表示该线程因为并发争夺机制而进行阻塞等待。
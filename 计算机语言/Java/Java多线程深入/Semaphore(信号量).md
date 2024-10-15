## 信号量

信号量即是可以重复上锁的锁，信号量初始化时会指定一个最大的上限数，作为信号量可以获取的最大上限。当获得信号量时，信号量中对应信号数量减1，释放信号量时，信号量中对应的信号数量加1。

## 使用

> 构造方法

```
Semaphore(int semaphoreNum)
```

semaphoreNum为最大信号数量。

```
Semaphore(int semaphoreNum,boolean fair)
```

fair为表示是否采取尽量保证先入等待队列先得的策略，默认为false不保证。

---

> 获取信号量(获取许可)

```
void acquire();
```

获取一个信号量

```
void acquire(int num);
```

获取num个信号量

在可以获取到足够多的许可前，线程将会一直被阻塞。

```
boolean tryAcquire();
```

如果许可立即可用则返回真，否则返回假，但 acquire() 获取许可并阻塞直到一个可用，该方法有设置超时与选择获取许可个数的重载。

```
int drainPermits()
```

获取剩余的所有可用所有许可，并且将可用许可置0，返回这些许可的数量。


---

> 释放信号量(释放许可)

```
void release();
```

释放一个信号量，注意没有拿到许可的线程不可以释放许可。

```
void release(int num);
```

释放num个信号量

> 许可剩余个数

```
int availablePermits();
```
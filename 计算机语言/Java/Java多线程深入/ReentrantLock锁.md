## ReentrantLock

ReentrantLock是一种可重入的锁，其相较于synchronized来说，它具有以下性质：

* 可中断：在线程等待的区间，可以手动中断等待。
* 可设置超时时间：可以设置等待该锁释放的最长时间。
* 可设置为公平锁：可以让锁释放后的争抢过程更为公平，先进先出，而不是随机争抢。
* 可支持多个条件变量

## 常用API

> 构造函数

```
默认构造函数
```

创建一个锁对象

```
ReentrantLock(boolean flag)
```

默认flag为false，为不公平竞争(先等也可能后面再得到锁)
flag为true，为公平竞争(尽量按照阻塞队列先等先得)

---

> 上锁与释放

```
void lock()
```

获取锁


```
void unlock()
```

释放锁


* 注意ReentrantLock不同于synchronized，其在抛出异常后不会释放锁，ReentrantLock常有以下写法

```
reentrantLock.lock()
try{
    
}catch(Exception e)
{
    
}finally{
    reentrantLock.unlock();
}
```

---

> 等待中断

```
void lockInterruptibly()
```

尝试获得锁。  
如果当前无竞争，就会获取锁。
如果有竞争，进入阻塞队列。
调用该方法介入阻塞队列后，如果有其他线程调用interruptibly()，调用lockInterruptibly()处会抛出一个InterruptedException异常。

* 抛出InterruptedException异常后说明该线程不应该继续正常的业务逻辑了。


```
void Thread类的interruptibly()
```

打断lockInterruptibly()等方法的阻塞。

* 打断很大程度上是为了预防死锁

---

> 超时上锁

```
boolean trylock(long timeOut);
```

尝试获取一个锁，有超时限制，获取到返回true。

不传入参数时，如果无法获取到锁，就立刻返回false。

传入参数时，以单位为秒进行等待。


---

> 条件变量的创建与使用

```
Condition newCondition()
```

创建一个新的条件变量。

```
Condition的await()方法
```

该方法需要已经获取该条件变量对应的锁，执行该方法后，会释放锁并且进入等待状态。

该方法有对应的超时版本重载

该等待状态可以被interruptibly()方法打断或是超时。

```
Condition的signal()方法
```

唤醒该条件变量上的一个等待线程

```
Condition的signalAll()方法
```

唤醒该条件变量上的所有等待线程
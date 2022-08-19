## CAS

CAS全称为Compare And Swap(比较与交换)，其是一种线程的无锁同步的实现。

CAS的思想基于乐观锁，其通过大量的对比重试来代替synchronized那种上锁的同步实现。

## CAS原理

CAS的原理是，当多个线程共享一个变量时，每个线程每次要修改该变量的值的时候，都会将该线程中，循环以下操作：将被业务操作后的变量与主内存的变量中进行一次比较(这个比较是一个原子操作)，业务操作或者读取后的变量的值如果与主存中的值对比后如果是满足预期的，则同步本次写操作并且终止该循环。

## CAS与volatile的关系

CAS的实现是使用了volatile的可见性来保证的。

## CAS的效率

使用CAS的效率高于synchronized，因为CAS是无锁操作，CAS并没有像synchronized那样强制CPU调用进行线程的停止与上下文切换。

* CAS一直都没有强制的改变各个线程的运行。上下文切换的代价远高于CAS的多次循环(保持线程的一直运行有时仍然会导致较多的上下文切换)。

* 如果竞争激烈，效率有时会不及使用synchronized。


## 最基本的使用示例

```
public AtomicInteger i;
public void fun()
{
    while(true){
        int prev = i.get();
        int next = prev * 10;
        //prev与主存中的内容一致，表示没有被其他线程操作，此时可以更新。
        if(i.compareAndSet(prev,next))
        {
            break;
        }
        
    }
}

```
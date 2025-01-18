## synchronized的设计思想

synchronized的设计基于悲观锁。


## 重入性

当synchronized对多个非static方法上锁时(或是某个类中的父子类均有synchronized标记的方法而且互相调用等这类同一个类中不同的synchronized方法互相调用的场景)，这些互相调用不会造成调用线程的死锁，类似于linux中的递归锁。

重入性就是拥有该锁的线程对该锁重复获得时，不会将自己上锁。

## 自动释放

当synchronized中抛出无法处理的异常时，抛出该异常的线程会自动释放当前这个锁。

## 底层实现
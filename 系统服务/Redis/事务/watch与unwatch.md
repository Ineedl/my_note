
## watch
watch命令用于监视一个数据，给该数据附加一个版本号以来完成乐观锁

    watch key [key2 key3 ...]

## unwatch
unwatch命令取消所有的监视

    watch

* DISCARD 命令在取消事务的同时也会取消所有对 key 的监视。
* EXEC 命令在执行事务的同时也会取消所有对 key 的监视。
=======
## watch
watch命令用于监视一个数据，给该数据附加一个版本号以来完成乐观锁

    watch key [key2 key3 ...]

## unwatch
unwatch命令取消所有的监视

    watch

* DISCARD 命令在取消事务的同时也会取消所有对 key 的监视。
* EXEC 命令在执行事务的同时也会取消所有对 key 的监视。

## watch使用场景

被watch的变量，如果在事物执行过程中被其他事物或者客户端修改，那么exec执行后，相当于没有进行事物。

## Set
Redis的Set为String类型的无序集合，其底层为一个hash表，其添加，删除，查找的复杂度都为O(1)。


## Set内部的数据结构
Set数据结构为dict字典，字典使用的哈希表实现。

Redis的Set内部中的Hash结构，所有的value都指向一个内部值。

* Set实际上只是一个key=value的HashMap，HashMap使用红黑树存储，所以Set只是一个不能存储重复值的Hash红黑树结构。
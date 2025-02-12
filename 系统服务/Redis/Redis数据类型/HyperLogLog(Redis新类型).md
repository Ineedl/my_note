## HyperLogLog
HyperLogLog是用来做基数(一组元素中不重复的元素叫做基数)统计的一种算法，其在输入元素的数量或体积非常大时，计算基数所需的空间总是固定而且很小的。

Redis中的HyperLogLog每个key只需要12KB的内存，就可以计算接近2^64个不同元素的基数(注意是基数个数，不是全部元素个数)。

Redis中的HyperLogLog只会根据输入元素来计算基数，而不会存储输入元素本身，Redis中的HyperLogLog不能像集合那样，返回输入的各个元素。

* HyperLogLog不存储元素本身，只存储基数元素的计数。
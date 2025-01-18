## List
Redis中的List为单键多值，相当于C中的struct。  

Redis是简单地字符串列表，按照插入顺序排序。可以插入一个元素到头部或尾部。

List底层为一个双向链表，对两端的操作性能很高，通过索引插入性能较差。


## List内部的数据结构
List底层数据结构为quickList。  

当数据较少时(小于1MB)，使用一块连续的内存存储，该结构被称作压缩列表，结构被称为ziplist。

当数据量较多时(超过1MB)，会将结构改为quicklist，再次之后，其quickList将每1MB的数据(一个ziplist单元)作为一个链表的基本单元来串起来。

当有quickList时，链表基本单元的组成为一个ziplist和两个额外的指针prev和next。


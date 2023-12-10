## 添加一个或多个值到集合key中

    sadd <key> <value1> <value2> ...
    
## 取出集合key中的所有值

    smembers <key>
    
## 判断集合<key>是否为含有该<value>值

    sismember <key> <value>
    
## 返回集合key中元素个数

    scard <key>
    
## 删除集合中的某些元素

    srem <key> <value1> <value2> ...
    
## 从集合中随机取出一个值

    spop <key>
    
* 该方式将值取出来后，将会从set中删除。    
    

## 从集合中随机取出n个值

    srandmember <key> <n>
    
* 该方式的取值不会将值从set中删除。


## 把一个集合中的值移动到另一个集合

    smove <sourceKey> <targetKey> <value>
    
## 返回两个集合中全部的元素(交集)

    sinter <key1> <key2>
    
## 返回两个集合中都有的元素(并集)

    sunion <key1> <key2>
    
## 返回两个集合中第一个集合有但是第二个集合没有的元素(差集)

    //返回key1中有但是key2中无的元素
    sdiff <key1> <key2>

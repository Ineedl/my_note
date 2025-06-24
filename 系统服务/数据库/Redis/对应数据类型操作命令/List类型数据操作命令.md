## 在左/右边插入一个值
一个List数据类型从一个空的开始构建起来。

    lpush/rpush <key> <value1>
                      <value2>
                      <value3>
                      ...

## 在左/右边取出一个值
键在值在，值无键亡，取出值后List中对应的数据将消失，当数据全部取完时，key将不再存在。

    lpop/rpop   <key>
    
## rpoplpush
取出一个list的一个右边的值加入到一个list的最左边

    rpoplpush <key1> <key2>
    
* 注意没有lpoprpush


## 按照索引下标获得元素
按照索引下标从左到右获取元素

    lrange <key> <startIndex> <stopIndex>

* 0表示左边第一个索引，-1表示右边第一个索引


    //获取全部元素值
    lrange <key> 0 -1


* 注意没有rrange


## 按照索引下标获取指定位置元素

    lindex <key> <index>
    
## 获取list长度

    llen <key>
    
## 在某个值后面插入新的值

    linsert <key> before <value> <newvalue>
    
## 从左边开始删除n个相同的元素

    lrem <key> <n> <value>
    
`例子`

    //myList： 1 abc 3 abc 4 5 abc
    
    lrem myList 2 abc
    
    //结果：1 3 4 5 abc

## 替换某个索引下标的值

    lset <key> <index> <newvalue>
    
## 添加一个或多个值以及他们的评分

    zadd <key> <score1> <value1>
               <score2> <value2>
               <score3> <value3>
               ...

* 注意评分必须是一个数值类型，否则报错

* 对于已经存在的值，再次插入只能改变原有值的评分

## 根据下标Index的范围取值

    zrange <key> <startIndex> <endIndex> [withscores]
    
* 取出的值会根据评分从小到大排序。

* -1表示最后一个的评分，-2表示倒数第二个评分以此类推。

* 默认情况下不会显示评分，加上withscores会显示评分，加上withscores后显示的评分会与值在同一列显示

    `例`
    
    ZSet 34:abc 35:def
    
    //加上withscores显示
    (1)abc
    (2)34
    (3)def
    (4)35
    
        
## 根据评分的范围取值

    //按评分从小到大排序
    zrangebyscore <key> <startIndex> <endIndex> [withscores] [limit <offset> <count>]
    
    //按评分从大到小排序
    zrevrangebyscore <key> <startIndex> <endIndex> [withscores] [limit offset count]
    
* 加上withscores后同上。
    
* 评分可以有负数，-1表示最后一个值的这种设定只有在用索引时才生效。

* limit字段同sql，表示只显示zrangebyscore查询结果中从第offset开始的count个数据。


## 给某个value的评分加上增量

    //给key中的某个value的评分增加num
    zincrby <key> <num> <value>
    
* 注意num可以为负数，为负数时表示评分的减少。

## 删除指定的值元素

    zrem <key> <value>
    
## 统计某个评分区间内元素的个数

    zcount <key> <min> <max>
    
## 返回某个值在该key集合中按评分排名的次序

    zrank <key> <value>
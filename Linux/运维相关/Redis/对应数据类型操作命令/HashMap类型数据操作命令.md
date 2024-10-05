## 向key中添加一个数据

    hset <key> <field> <value>
    
* 当对应的field存在时，将会用新的value替换旧的value
    

## 获得key中的一个值

    hget <key> <field>
    
* 不会从hash中删除这个数据。


## 获得key中的多个值

    hmget <key> <field> <value>
                <field2> <value2>
                <field3> <value3>
                ...

* 不会从hash中删除获得的数据。

## 批量添加多个数据

    hmset <key> <field> <value>
                <field2> <value2>
                <field3> <value3>
                ...

* 当对应的field存在时，将会用新的value替换旧的value
                
## 查看key中某个field是否存在

    hexists <key> <field>
    
## 列出key中的全部field

    hkeys <key>
    
## 列出某个key中的所有value

    hvals <key>
    
## 将key中某个field的value自增

    hincrby <key> <field> <num>
    
* 将key中某个field的value加上num(num<0时为自减)

## 给key添加一个不存在的field与field的value

    hsetnx <key> <filed> <newvalue>
    
* 当且仅当filed在key中不存在时，添加成功。
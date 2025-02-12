## 数据添加命令

    set <key> <value>

* 当设置的key值在当前数据库存在时，将会替换原本的值
  

    set <key> <value> nx ex <time_s>
    
* 该方式表示设置某个key的同时上锁，nx表示键不存在时才进行操作(相当于上锁)，ex表示设置过期时间，该命令等同于使用setnx的同时指定过期时间。

## 数据查询命令

    get <key>

## 数据追加命令

    append <key> <value>

* 将给定的value追加到原值得末尾。


## 获取值的长度

    strlen <key>

## 添加数据防覆盖命令
改名了在对应的key存在时，无法覆盖原有key的value。

    setnx <key> [second] <value>

## 让存储的数字数据的值-1/+1

    //让存储的数字的值+1
    incr <key>
    
    //让存储的数字的值-1
    decr <key>

* incr与decr的自增与自减为一个原子操作，因为Redis使用的是单线程处理内部数据。

* incrby与decrby可以自定义增减的大小
  

## 让存储的数字数据的值自增或自减部分

    //让存储的数字的值+num
    incrby <key> <num>
    
    //让存储的数字的值-num
    decrby <key> <num>

* 这两个命令也是原子操作的，原因同incr与decr。

    
## 同时设置多个key-value

    mset <key1> <value1>
         <key2> <value2>
         <key3> <value3>
         ...


    msetnx <key1> <value1>
           <key2> <value2>
           <key3> <value3>
           ...

* msetnx的多个数据的添加具有原子性，如果其中有一个添加失败，所有的数据添加都将失败。

## 同时取多个key的值

    mget <key1> <key2> ...

## 获取值中的部分连续值

    getrange <key> <起始位置> <结束位置>

`例子`

    key  value
     a    "123456"
     
    getrange key 1 4
    返回 "2345"

## 替换值中的部分连续值

    setrange <key> <起始位置> <覆盖的值>

`例子`

    key  value
     a    "123456"
     
    setrange key 0 456
    返回"456456"

## 设置值得时候同时设置过期时间

    setex <key> <过期时间(s)> <value>

## 设置新的值得同时获取旧的值

    getset <key> <value>
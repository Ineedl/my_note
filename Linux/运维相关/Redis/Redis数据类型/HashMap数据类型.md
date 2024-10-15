## Hash
Redis的Hash为一个键值对的集合。

Redis的Hash为一个String类型的field和value的映射表，相当于Java里面的Map<String,Object>

Redis中Hash的使用相当于mysql中一个只有一行数据的数据表，表名相当于key，字段相当于存放的field，存放的数据相当于value。

`存储方式举例`

    key  |  field | value
    ---------------------
         |  id    | 1
    user |  name  | zhangsan
         |  age   | 20
         
## 数据结构
Redis中的Hash实际上使用了两种类型。  

当field-value长度较短且个数较少时，使用ziplist(小于1MB)，否则使用Hashtable(之后Hashtable的基本单位就是一个1MB的ziplist)。
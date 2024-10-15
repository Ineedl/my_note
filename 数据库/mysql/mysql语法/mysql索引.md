## 索引
索引相当于目录，可以加快用某字段搜索数据时的搜索速度，索引只在存在于字段上。

* 索引底层数据结构常用B+Tree

## 索引常使用场景
* 数据量庞大
* 该字段很少进行DML操作。
* 该字段经常出现在where子句中。

## 常见的索引种类
* 单一索引：没有什么特别。
* 唯一索引：该索引作用同唯一约束，但是不为唯一约束，可单独存在，设置后查询对应列时，不会存在唯一约束。
* 主键索引：同唯一索引。
* 符合索引：多个字段联合起来添加一个索引。

## 添加索引
* 主键和unique约束都会自动添加索引。
*  主键的查询效率较高。尽量根据主键检索。


    create [unique] index <index_name> ont <table_name(字段1[(类型长度)],字段2[(类型长度)]...,字段n[(类型长度)])>
    
* create index只能添加唯一索引和一般索引(包括复合索引)

    
    alter table <table_name> add [primary/unique]index <index_name>(字段1[(类型长度)],字段2[(类型长度)]...,字段n[(类型长度)]);

* 修改表的方式添加索引可以添加唯一索引与主键索引和一般索引(包括复合索引)。

* 添加索引时指定类型长度有时可以提升索引效率。


## 索引的删除

    drop index <index_name> on <table_name>;
    
    alter table <table_name> drop index <index_name> ;
    
    注意如果对应的约束存在，将不能删除索引，但是删除对应约束，索引将不存在。
    
    alter table <table_name> drop <primary key>/<unique> ;
    
## 索引的实效
使用模糊查询时，如果第一个字符为%则索引实效
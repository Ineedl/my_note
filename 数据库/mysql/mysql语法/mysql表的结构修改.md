## alter表的结构修改

* 一般在开发中，修改表的结构多数是用工具来修改，故使用对应的语句修改表的结构用的地方也不多。


## 列的增加
### 单列的增加

    alter table <tableName> add [column] <create建表时包含列名的对应列语句> [first/(after 该表中的某列的列名)];
    
* first表示在表结构中第一列

* after表示该列增加在某列后面

* 加上column为mysql标准写法，不加为sql标准写法。

### 多列的增加

    alter table <tableName> 
    add [column] <create建表时包含列名的对应列语句> [first/(after 某列名)],
    add [column] <create建表时包含列名的对应列语句> [first/(after 某列名)],
    ...,
    add [column] <create建表时包含列名的对应列语句> [first/(after 某列名)],
    ;
    
或

    alter table <tableName> 
    add [column] 
    (
    <create建表时包含列名的对应列语句> [first/(after 某列名)],
    <create建表时包含列名的对应列语句> [first/(after 某列名)],
    ...,
    <create建表时包含列名的对应列语句> [first/(after 某列名)]
    );

* 注意，主键约束每个表只有一个

## 列的删除

    alter table <tableName> 
    drop [column] <columnName1>,
    drop [column] <columnName2>,
    ...,
    drop [column] <columnNameN>;

## 约束的添加

    //注意括号要加
    alter table <tableName> add constraint <对应约束> (<约束指定的单个列或多个列>);
    
* 外键约束的添加
    

    alter table <tableName> add constraint foreign key (<约束指定的单个列或多个列>) references <tableName2> (<约束指定的单个列或多个列>);
    
* 多个约束一起添加
    

    alter table <tableName> 
    add constraint <对应约束> (<约束指定的单个列或多个列>),
    add constraint <对应约束> (<约束指定的单个列或多个列>),
    add constraint foreign key (<约束指定的单个列或多个列>) references <tableName2> (<约束指定的单个列或多个列>),
    ...,
    add constraint <对应约束> (<约束指定的单个列或多个列>);
    

## 约束的删除
### 主键的删除
    
    alter table <tableName> drop primary key;
    
### 唯一约束的删除

    alter table <tableName> drop index <索引名>
    
或

    alter table <tableName> drop key <columnName>
    
* 一般建表时如果没有指定索引名的情况下,索引名为列名。




### 外键约束的删除

    alter table <tableName> drop foreign key <外键名称>;
    
* 使用下面语句可以查询外键名

    show  create table <tableName>;
    
## 添加列的默认值

    alter table <tableName> 
    alter <columnName1> set default <default_value>,
    alter <columnName2> set default <default_value>,
    ...,
    alter <columnNameN> set default <default_value>;
    
## 删除列的默认值

    alter table <tableName>
    alter <columnName1> drop default,
    alter <columnName2> drop default,
    ...,
    alter <columnNameN> drop default;

## 列定义的修改

* 注意修改列定义时，如果修改了数据类型，修改后数据类型要兼容。

### 不修改列名

    alter table <tableName> 
    modify column <create建表时包含列名的对应列语句> [first/(after 某列名)],
    modify column <create建表时包含列名的对应列语句> [first/(after 某列名)],
    ...,
    modify column <create建表时包含列名的对应列语句> [first/(after 某列名)];
    
### 修改列名

    alter table <tableName>
    change column <oldName> <newName> <create建表时不包含列名的对应列语句> [first/(after 某列名)],
    change column <oldName2> <newName2> <create建表时不包含列名的对应列语句> [first/(after 某列名)],
    ...,
    change column <oldNameN> <newNameN> <create建表时不包含列名的对应列语句> [first/(after 某列名)];
     
## 数据表的更名
### 更改一个

    alter table <tableName> rename [to/as] <NewTableName>;
     
* 加上to/as为sql标准语句

### 更改多个

    rename table 
    <tableName1> to <NewTableName1>,
    <tableName2> to <NewTableName2>,
    ...,
    <tableNameN> to <NewTableNameN>;
    

    
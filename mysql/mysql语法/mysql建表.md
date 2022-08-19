## 表的创建

* 表建立时默认使用utf-8编码

### 字段约束

#### 主键约束
建表时使用 primary key 来使用主键约束。  

每一个表只能有一个主键约束。  

主键值必须唯一标识表中的每一行，且不能为 NULL。  

主键可以加快使用对应列寻找数据时的搜索速度。  

主键可以使用多个列一起成为联合主键，联合主键的唯一判断是所有标记列都不相同就为唯一。

* 主键类型分类  


按照字段数量划分：  
复合主键(不建议使用，因为违背了三范式)  
单一主键  

按功能划分：  
业务主键：标记的字段与系统业务相关(拿身份证账号等作为主键)  
自然主键：标记的字段只是为了标记记录的编号，对应字段与系统业务无关

#### 唯一约束  
建立表时使用 unique 来使用唯一。  
该约束使得该列中的数据不允许重复，每行记录该列对应的数据必须各不相同。

#### 非空约束  
建立表时使用 not null 来使用非空约束。  
该约束使得该列中的数据不能为null，每行记录该列对应数据必须有效不为null。

#### 外键约束  
建立表时使用 foreign key 来使用外键约束。

#### 检查约束(mysql不支持)
建立表时使用 check 来使用检查约束。

* 注意字段约束不一定非要有哪个，每个表都可以完全无字段约束。


### 简单创建

    create table [if not exists] <tableName>(
        字段名1 数据类型 [default <默认值>]，
        字段名2 数据类型 [default <默认值>]，
        .....
        字段名n 数据类型 [default <默认值>]
    );
    
if not exists表示在表不存在时才创建表。    

### 复杂创建

    create table [if not exists] <tableName>(
        字段名1 数据类型 [约束] [default <默认值>] [auto_increment]，
        字段名2 数据类型 [约束] [default <默认值>] [auto_increment]，
        .....
        字段名n 数据类型 [约束] [default <默认值>] [auto_increment],
        [primary key(字段1,字段2,...,字段n)]
        [unique(字段1,字段2,...,字段n)]
        
        //使用多个字段为主键或是唯一约束时，写在下面，单列指定时最好写在列后
        //注意无法用not null约束指定多个字段
        
        
    ) [engine=<指定的引擎>] [DEFAULT CHARSET=<表格编码>];

#### auto_increment
auto_increment表示该列在插入值时如果为null或是不指定对应的值，该列对应值会根据之前插入的值自动增加。  

* auto_increment一般在主键中使用的多。  

* auto_increment约束字段的最大值受该字段的数据类型约束，如果达到上限，AUTO_INCREMENT 就会失效。 

* 一个表中只能有一个字段使用 auto_increment 约束，且该字段必须有唯一索引，以避免序号重复（即为主键或主键的一部分）。  

* auto_increment约束的字段必须具备 NOT NULL 属性。  

* auto_increment约束的字段只能是整数类型（TINYINT、SMALLINT、INT、BIGINT 等）。



### 表的复制 
## 通过select结果创建表

    create table <tableName> as <select语句>

## 将查询结果插入表
注意查询结果的列的数据必须和插入的表的类型对应。

    insert into <tableName> <select语句>

## 表的删除

    drop table [if exists] <tableName>;
    
if exists表示表存在时才删除。

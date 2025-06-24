## 查看增删改查等语句执行次数

```
    //like模糊查询中必须后面跟7个下划线
    show global/session status like 'Com_______';
```

```
//执行结果:从上次mysql服务开始时到现在为止
//(使用session表示为连接mysql开始时到现在为止的当前会话的统计)，
//对于mysql所有数据库中表的增删改查等操作的所有次数。

//例

> show global status like 'Com_______';

+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| Com_binlog    | 0     |
| Com_commit    | 0     |
| Com_delete    | 0     |
| Com_import    | 0     |
| Com_insert    | 3     |
| Com_repair    | 0     |
| Com_revoke    | 0     |
| Com_select    | 48    |
| Com_signal    | 0     |
| Com_update    | 5     |
| Com_xa_end    | 0     |
+---------------+-------+


```

## 语句耗时详情

profilling语句可以用来查询语句耗时的详细情况。

`查询mysql是否支持profile操作`
```

select @@have_profiling;

```

`开启profiling`
```
默认情况下没有开启profiling

//查看是否开启profiling开关
select @@profiling;

//开启profiling操作
//可以选择是全局开启还是当前会话开启
set [session/global] profiling = 1;

```

`查询当前会话中所有sql语句的耗时情况`
```

> show profiles;

//结果
+----------+------------+-------------------------------+
| Query_ID | Duration   | Query                         |
+----------+------------+-------------------------------+
|        1 | 0.00044100 | select @@profiling            |
|        2 | 0.00007500 | show profiling                |
|        3 | 0.00015700 | SELECT DATABASE()             |
|        4 | 0.00164400 | show databases                |
|        5 | 0.00348600 | show tables                   |
|        6 | 0.00006600 | show profiling                |
|        7 | 0.00037600 | select * from students        |
|        8 | 0.00180100 | select count(*) from students |
+----------+------------+-------------------------------+

```

`某个语句的耗时情况详情`
```
show profile for query <query_id>

//以上面查询到的所有语句执行情况为例子
//查询query_id = 7语句的耗时情况
> show profile for query 6;

+---------------+----------+
| Status        | Duration |
+---------------+----------+
| starting      | 0.000044 |
| freeing items | 0.000016 |
| cleaning up   | 0.000006 |
+---------------+----------+

//cpu耗费情况

> show profile cpu for query 6;

+---------------+----------+----------+------------+
| Status        | Duration | CPU_user | CPU_system |
+---------------+----------+----------+------------+
| starting      | 0.000044 | 0.000034 |   0.000010 |
| freeing items | 0.000016 | 0.000009 |   0.000006 |
| cleaning up   | 0.000006 | 0.000005 |   0.000002 |
+---------------+----------+----------+------------+

```

## 查看索引的使用过程与表的查询过程

explain/desc命令可以获取一条查询sql语句执行时的索引使用情况与表的连接情况。

```
explain/desc select查询语句

//例子
explain select * from students;


//效果同上
desc select * from students;

```

`使用例子`
```

> desc/explain select a.name,a.class,a.course,a.score from students as a join (select max(score) as score,course from students group by course) as b
on a.course = b.course and a.score = b.score;

//结果

+----+-------------+------------+------------+------+---------------+-------------+---------+----------------------------+------+----------+-----------------+
| id | select_type | table      | partitions | type | possible_keys | key         | key_len | ref                        | rows | filtered | Extra           |
+----+-------------+------------+------------+------+---------------+-------------+---------+----------------------------+------+----------+-----------------+
|  1 | PRIMARY     | a          | NULL       | ALL  | NULL          | NULL        | NULL    | NULL                       |   12 |   100.00 | Using where     |
|  1 | PRIMARY     | <derived2> | NULL       | ref  | <auto_key0>   | <auto_key0> | 208     | test.a.score,test.a.course |    2 |   100.00 | Using index     |
|  2 | DERIVED     | students   | NULL       | ALL  | NULL          | NULL        | NULL    | NULL                       |   12 |   100.00 | Using temporary |
+----+-------------+------------+------------+------+---------------+-------------+---------+----------------------------+------+----------+-----------------+


```

> explain结果字段解释

|字段<div style="width: 70pt">|解释|
|:-:|:-|
|id|select查询的序列号，表示查询中执行的select字句或是操作表的顺序(id相同，执行顺序从上到下。id不同，越大的越先执行)|
|select_type|表示select类型，常见的有SIMPLE(简单表，不包含子查询与表连接)、PRIMARY(主查询，即最外层查询)、UNION(UNION中第二个或是之后的查询)、SUBQUERY(select/以及where之后的查询，不包括from之后的子查询)、DERIVED(from语句中出现的子查询，也被称为派生表)|
|table|显示的查询表名，如果查询使用了别名，那么这里显示的是别名，如果不涉及对数据表的操作，那么这显示为null，如果显示为尖括号括起来的就表示这个是临时表。|
|partitions|如果查询是基于分区表的话，会显示查询将访问的分区。|
|type|表示连接类型，性能依次从好到差：null, system（查询sql中的系统表），const（查询索引字段，并且表中最多只有一行匹配），eq_ref(使用唯一或是主键索引)，ref(非唯一性索引等)，fulltext(全文索引检索，全文索引的优先级很高，若全文索引和普通索引同时存在时，mysql不管代价，优先选择使用全文索引)，ref_or_null(与ref方法类似，增加了null值的比较)，unique_subquery(用于where中的in形式子查询，子查询返回不重复值唯一值)，index_subquery(用于in形式子查询使用到了辅助索引或者in常数列表，子查询可能返回重复值)，range(索引范围扫描，常见于使用>)，index_merge(表示查询使用了两个以上的索引，最后取交集或者并集，常见and，or的条件使用了不同的索引，官方排序这个在ref_or_null之后，但是实际上由于要读取所个索引，性能可能大部分时间都不如range)，index(索引全表扫描，把索引从头到尾扫一遍)，all(全表扫描).一般业务sql基本不可能出现null，几乎只有像select 1;这种type才会为null|
|possible_keys|查询可能使用到的索引都会在这里列出来|
|key|查询真正使用到的索引，select_type为index_merge时，这里可能出现两个以上的索引，其他的select_type这里只会出现一个。|
|key_len|用于处理查询的索引长度，如果是单列索引，那就整个索引长度算进去，如果是多列索引，那么查询不一定都能使用到所有的列，具体使用到了多少个列的索引，这里就会计算进去，没有使用到的列，这里不会计算进去。留意下这个列的值，算一下你的多列索引总长度就知道有没有使用到所有的列了。要注意，mysql的ICP特性使用到的索引不会计入其中。另外，key_len只计算where条件用到的索引长度，而排序和分组就算用到了索引，也不会计算到key_len中。|
|ref|这一列显示了在key列记录的索引中，表查找值所用到的列或常量，常见的有：const（常量），字段名（例：film.id）|
|rows|这里是执行计划中估算的扫描行数，不是精确值|
|filtered|返回行数占查询过的行数的百分比|
|extra|额外信息，这个列可以显示的信息非常多，有几十种，常用的有

A：distinct：在select部分使用了distinc关键字

B：no tables used：不带from字句的查询或者From dual查询

C：使用not in()形式子查询或not exists运算符的连接查询，这种叫做反连接。即，一般连接查询是先查询内表，再查询外表，反连接就是先查询外表，再查询内表。

D：using filesort：排序时无法使用到索引时，就会出现这个。常见于order by和group by语句中

E：using index：查询时不需要回表查询，直接通过索引就可以获取查询的数据。

F：using join buffer(block nested loop)，using join buffer(batched key accss)：5.6.x之后的版本优化关联查询的BNL，BKA特性。主要是减少内表的循环数量以及比较顺序地扫描查询。

G：using sort_union，using_union，using intersect，using sort_intersection：

using intersect：表示使用and的各个索引的条件时，该信息表示是从处理结果获取交集

using union：表示使用or连接各个使用索引的条件时，该信息表示从处理结果获取并集

using sort_union和using sort_intersection：与前面两个对应的类似，只是他们是出现在用and和or查询信息量大时，先查询主键，然后进行排序合并后，才能读取记录并返回。

H：using temporary：表示使用了临时表存储中间结果。临时表可以是内存临时表和磁盘临时表，执行计划中看不出来，需要查看status变量，used_tmp_table，used_tmp_disk_table才能看出来。

I：using where：表示存储引擎返回的记录并不是所有的都满足查询条件，需要在server层进行过滤。查询条件中分为限制条件和检查条件，5.6之前，存储引擎只能根据限制条件扫描数据并返回，然后server层根据检查条件进行过滤再返回真正符合查询的数据。5.6.x之后支持ICP特性，可以把检查条件也下推到存储引擎层，不符合检查条件和限制条件的数据，直接不读取，这样就大大减少了存储引擎扫描的记录数量。extra列显示using index condition

J：firstmatch(tb_name)：5.6.x开始引入的优化子查询的新特性之一，常见于where字句含有in()类型的子查询。如果内表的数据量比较大，就可能出现这个

K：loosescan(m..n)：5.6.x之后引入的优化子查询的新特性之一，在in()类型的子查询中，子查询返回的可能有重复记录时，就可能出现这个

除了这些之外，还有很多查询数据字典库，执行计划过程中就发现不可能存在结果的一些提示信息|
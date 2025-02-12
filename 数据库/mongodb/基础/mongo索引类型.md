[toc]

# 使用事项

1. 创建合适的复合索引，不要依赖于交叉索引(查询条件中每个对应字段都有独自的索引，查询时使用的是这些字段所有的单独索引，而不是组合索引)
2. 复合索引查询时，匹配条件在前，范围条件在后
3. 尽可能使用覆盖索引(同mysql)
4. 索引的创建会阻塞，最好后台执行。

# 常用索引

## 单键索引

在某一个特定的字段上建立索引

* mongodb在id字段上建立了唯一的单键索引。
* 在该字段上进行精准匹配、排序、范围查找都会使用此索引
* 数据结构为B Tree

```bash
db.<collection>.createIndex({title:1})
```

## 复合索引

在多个字段上建立索引，同mysql

* 数据结构为B Tree
* 使用时字段的顺序，字段的升降序会导致性能的不同

```bash
db.<collection>.createIndex({title:1,favCount:2})
```

## 多键索引

在数组的属性上建立的索引，针对该数组中任意值的查询都会定位到对应的文档，多个索引入口或者键值引用同一个文档。

## 全文索引

可以通过某字段中的部分字符来搜索进行生效

```bash
db.<collection>.createIndex({ title: "text" })
# 上述text表示创建全文索引,而不是表示我只对text搜索生效
```

* 不如用es

## hash索引

不同传统的B-Tree索引，hash索引使用hash函数创建索引

* 该索引只支持精确匹配

```bash
db.<collection>.createIndex({username:'hashed'})
```

# 索引约束

## 唯一索引

```
db.<collection>.createIndex({title:1},{unique:true})
```

* 唯一索引对于文档中缺失的字段，会使用null代替，因此不允许存在多个文档缺失对应唯一索引字段的情况。

## 部分索引

部分索引为在一个集合中为文档的一个子集建立索引。即进队满足指定过滤器表达式的文档进行索引创建。

* 部分索引具有耕地的存储需求和更低的维护性能成本

```bash
db.<collection>.createIndex({cuisine:1,name:1},{partialFilterExpression:{rating:{ $gt: 5 }}})
# 创建cuisine和name的复合索引，并且对其中rating大于5的所有文档建立索引
```

## 稀疏索引

稀疏属性确保索引只包含具有所以字段的文档的条目，索引将跳过没有索引字段的文档

```bash
db.<collection>.createIndex({name:1},{sparse:true})
#对name建立普通索引，并指定稀疏属性
```

* 如果稀疏索引会导致查询和排序操作的结果集不完整(稀疏被忽略了)，mongoDB将不会使用该索引，除非hint()明确指定一定使用稀疏索引。
* 部分索引优先于稀疏索引，因为部分索引提供了稀疏索引的超集

## TTL索引

超时限制

```bash
db.<collection>.createIndex({name:1},{expireAfterSeconds:3600})
#对name建立普通索引，并指定稀疏属性
```


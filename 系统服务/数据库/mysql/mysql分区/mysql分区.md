[toc]

## mysql分区

MySQL在5.1时添加了对水平分区的支持。分区是将一个表或索引分解成多个更小，更可管理的部分。每个区都是独立的，可以独立处理，也可以作为一个更大对象的一部分进行处理。这个是MySQL支持的功能，业务代码无需改动。

* 一个分区中既存了数据，又放了索引。也就是说，每个区的聚集索引和非聚集索引都放在各自区的（不同的物理文件）。目前MySQL数据库还不支持全局分区。

### 全局分区(mysql不支持)

**全局分区（Global Partitioning）** 指的是 **所有分区共享一套索引结构**，而不是每个分区各自维护一套索引。

在 **全局分区模型** 中：

- **索引可以跨多个分区**，不会局限于某个单独分区。
- **辅助索引可以不包含分区键**，查询时仍然能够有效定位数据，而无需扫描多个分区。
- **通常出现在 Oracle、PostgreSQL 和一些分布式数据库（如 TiDB）中**。

## 分区类型

* 定义分区时，可以在定义中对分区字段使用部分函数。

### RANGE分区

行数据基于属于一个给定的连续区间的列值被放入分区。但是记住，当插入的数据不在一个分区中定义的值的时候，会抛异常。

```mysql
CREATE TABLE `m_test_db`.`Order` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `partition_key` INT NOT NULL,
    `amt` DECIMAL(5) NULL,
    PRIMARY KEY (`id` , `partition_key`)
) PARTITION BY RANGE (partition_key) PARTITIONS 5 (
PARTITION part0 VALUES LESS THAN (201901) , -- partition_key < 201901
PARTITION part1 VALUES LESS THAN (201902) , -- 201901 < partition_key < 201902
PARTITION part2 VALUES LESS THAN (201903) , -- 201902 < partition_key < 201903
PARTITION part3 VALUES LESS THAN (201904) , -- 201903 < partition_key < 201904
PARTITION part4 VALUES LESS THAN (201905)); -- 201904 < partition_key < 201905
```

## LIST分区

LIST分区和RANGE分区很相似，但分区列的值是离散的，不是连续的。LIST分区使用VALUES IN，因为每个分区的值是离散的，因此只能定义值。

```mysql
CREATE TABLE users (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(50),
    age INT,
    region_id INT NOT NULL,  -- 用于分区的字段
    PRIMARY KEY (id, region_id)  -- 分区键必须包含在主键中
) ENGINE=InnoDB
PARTITION BY LIST(region_id) (  -- 按 region_id 进行 LIST 分区
    PARTITION p_north VALUES IN (1, 2, 3),   -- 北部地区 (1, 2, 3)
    PARTITION p_south VALUES IN (4, 5, 6),   -- 南部地区 (4, 5, 6)
    PARTITION p_west VALUES IN (7, 8, 9),    -- 西部地区 (7, 8, 9)
    PARTITION p_other VALUES IN (10, 11, 12) -- 其他地区
);
```

## HASH分区

**HASH 分区** 直接使用 `partition_key % 分区数` 计算分区。

```mysql
CREATE TABLE orders (
    id INT NOT NULL AUTO_INCREMENT,
    customer_id INT NOT NULL,  -- 作为分区键
    amount DECIMAL(10,2) NOT NULL,
    order_date DATE NOT NULL,
    PRIMARY KEY (id, customer_id)  -- 分区键必须包含在主键中
) ENGINE=InnoDB
PARTITION BY HASH(customer_id) PARTITIONS 4;  -- 4个分区 对4取模

CREATE TABLE tblinhash (
    id INT NOT NULL,
    hired DATE NOT NULL DEFAULT '1970-01-01'
)
PARTITION BY LINEAR HASH( YEAR(hired) )
PARTITIONS 6;

```

## KEY分区

**KEY 分区** 使用 **MySQL 内部的哈希函数** 计算分区，不直接使用 `%` 取模，因此分区规则**不可预测**。

```mysql
CREATE TABLE users (
    id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    PRIMARY KEY (id, user_id)  -- 主键必须包含分区键
) ENGINE=InnoDB
PARTITION BY KEY(user_id) PARTITIONS 4;

```

## 使用注意

错误的使用分区，会造成格外开销

比如一张表1000w数据量，如果一句select语句走辅助索引，但是没有走分区键。那么结果会很尴尬。如果1000w的B+树的高度是3，现在有10个分区。错误使用分区，最多会造成(3+3)*10次的逻辑IO。（使用聚集索引3次IO读取，使用聚集索引后，回表查询3次IO读取，10个分区，每个分区都进行一次）。

##  分区时机

可以使用ALTER TABLE来进行更改表为分区表，这个操作会创建一个分区表，然后自动进行数据copy然后删除原表。

* 如果想要给一个已有表添加分区，最好 **重建表并迁移数据**。

* 对原先的表直接进行分区会比较复杂（如果还涉及到外键等），建议数据库设计时，提前使用分区。
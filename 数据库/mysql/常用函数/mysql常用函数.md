## mysql常用函数
### 分组函数
分组函数输入多行，但是输出结果只有一行。

分组函数都会自动忽视null。

分组函数经常和group by联用，故其被称作分组函数。

* 数据库规定，只要有null参与计算的结果都将是null。

* count 计数  

count将会记录传入字段有效的记录的数目。只能输入一个字段。但是其可以输入*来进行计数。

count(*)统计总记录数，而count(字段)统计改记录中有效记录数。

例：
    
    //输出user中id不为null有效记录数
    select count(id) from user

* sum 求和
输出某一字段中所有有效记录的总和，该字段类型必须为数值类型。而且只能输入一个字段。

* avg 平均值
输出某一字段中所有有效记录的平均值，该字段类型必须为数值类型。而且只能输入一个字段。

* max 最大值
输出某一字段中所有有效记录的最大值，该字段类型必须为数值类型。而且只能输入一个字段。

* min 最小值
输出某一字段中所有有效记录的最小值，该字段类型必须为数值类型。而且只能输入一个字段。
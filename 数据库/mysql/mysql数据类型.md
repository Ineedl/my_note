## 整形
| 类型 | 说明 |
|:---|:---|
| tinyint | 1字节整形 |
| smallint | 2字节整形 |
| mediumint | 3字节整形 |
| int | 4字节整形 |
| bigint | 8字节整形 |

在mysql中使用整形时，可以对应类型最多的十进制位数

    create table myTable
    (
        columnName1 int(6)      //该int最多6个十进制位
    );

在mysql中的数值类型都可以使用unsigned来指定无符号数值类型

    create table myTable
    (
        columnName1 int(6) unsigned
    );

## 浮点型
| 类型 | 说明 |
|:---|:---|
| float | 4字节浮点，float最多允许保留小数点后约7位 |
| double | 8字节浮点，double最多允许保留小数点后约16位 |
| decimal | 16字节，以二进制存储，不存在精度损失 |

在mysql中使用浮点型时，可以选择该数的总位数和小数点后位数。

格式：decimal/double/float(M,D)

M表示总位数，D表示小数点的位数，M>=D

    create table myTable
    (
        columnName1 float(6,2)      //该float一共6位，小数点有2位
    );
    
在mysql中的数值类型都可以使用unsigned来指定无符号数值类型

    create table myTable
    (
        columnName1 float(6,2) unsigned   
    );

* float范围  
-3.402823466E+38 ~ -1.175494351E-38  
1.175494351E-38 ~ 3.402823466E+38

* double范围  
-1.7976931348623157E+308 ~ -2.2250738585072014E-308  
2.2250738585072014E-308 ~ 1.7976931348623157E+308

* decimal范围  
decimal(M,D)中，M范围为1～65，M的默认值是10，D范围是0～30，但不得超过M。

## 日期型
| 类型 | 说明 |
|:---|:---|
| year | 1字节，仅能表示年份 |
| time | 3字节，仅能用24小时制表示未来或过去某个时间 |
| date | 3字节，仅能表示年月日 |
| datetime | 8字节，用来表示年月日+24小时制的时间 |
| timestamp | 4字节，用来表示年月日+24小时制的时 |

* year范围  
1970~ 2069

* time范围  
-838:59:59 ~ 838:59:59  
超过24小时可以用来表示未来或过去的某个时间

* date范围  
1000/1/1 ~ 9999/12/31

* datetime范围  
1000/1/1,00:00:00 ~ 9999/12/31,23:59:59

* timestamp范围  
1970/1/1,00:00:00 ~ 2038


## 字符型
| 类型 | 说明 |
|:---|:---|
| char | 最多255字节，变长字符串 |
| varchar | 最多65536字节，变长字符串 |
| tinytext | 255字节，短文本数据 |
| text | 65535字节，一般本字数据 |
| mediumtext | 16777215字节，中等文本数据 |
| longtext | 4294967295字节，长文本数据 |

在mysql中存储字符串可以指定其长度

    create table myTable
    (
        columnName1 text(16) //最长16个字符
    );
    
除了char与varchar的存储大小是指定的字符串位数字节外，剩余的文本类型的存储大小都有如下规律 
| 类型 | 大小 |
|:---|:---|
| tinytext | 指定位数+1个字节 |
| text | 指定位数+2个字节 |
| mediumtext | 指定位数+3个字节 |
| longtext | 指定位数+4个字节 |

## 枚举类型(enum)
mysql在建立数据表时可以指定枚举类型，用自己定义的形式来表示某个字段的意义。

    create table myTable
    (
        columnName1 enum('value1','value2',....)
    );

enum属于字符串类型，enum类型中每定义一个成员一个字节，如果某个enum类型定义了n个成员，那么该字段数值类型大小有n字节，同时enum一个成员一字节限定了enum中单个成员的字符串长度。

    create table myTable
    (
        sex enum('man','woman','unknow')
    );

enum最大为65535个字节

## 结构体类型(set)
mysql在建立数据表时可以指定set类型，用自己定义的形式来表示某个字段的意义。但是与enum不同的是，set允许使用定义中的多个值，来做排列(不算组合)。

    create table myTable
    (
        columnName1 set('value1','value2',....)
    );

同时，在设置对应set类型列的值时也可以设定数字来表示其中的value值，set在定义时下标的增长是按照1,2,4,6,8,10,....来的，3表示1+2即第一个与第二个值得排列，2表示单个第二个值。
    
例:

    create table myTable
    (
        job set('teacher','student','son')
    );
    
    //前7行数据采用数值插入法
    insert into myTable(job) values
    (1),                        //表示'teacher'
    (2),                        //表示'student'
    (3),                        //表示('teacher','student')
    (4),                        //表示('son')
    (5),                        //表示('teacher','son')
    (6),                        //表示('student','son')
    (7),                        //表示('teacher','student','son')
    ('teacher'),
    ('student'),
    ('teacher','student'),
    ('son'),
    ('teacher','son'),
    ('student','son'),
    ('teacher','student','son');
    


## [其他更多数据类型](https://www.runoob.com/mysql/mysql-data-types.html)

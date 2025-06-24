## select简单查询

    select <字段1,字段2...字段n> from <tableName>;

## select复杂查询字段位置

                                //执行顺序
    select                      //5
        <字段1,字段2...字段n> 
    frome                       //1
        <tablename>
    where                       //2
        <条件>
    group by                    //3
        <字段>
    having                      //4
        <字段>
    order by                    //6
        <字段>;
    limit
        <number1,number>;        //7

## where条件查询
where中无法使用聚合(分组)函数

    select <字段1,字段2...字段n> from <tableName>  
    where  
        条件;
        
条件查询支持如下运算符：

| 运算符 | 说明 |
|:---|:---|
| = | 等于 |
| <> 或 != | 不等于 |
| <=> | 同上，但是为闭区间 |
| < | 小于 |
| <= | 小于等于 |
| > | 大于 |
| >= | 大于等于 |
| between...and... | 两个值之间(相当于 >=&&<=，也可以用于字符串比较) |
| is null | 为空(is not null为不为空) |
| and | 让多个条件相与 |
| or | 让多个条件相或 |
| in | 包含(相当于多个or) |
| not | 否定(常用于is与is null，也可用于in) |
| like | 模糊查询 |

* 在没有括号的情况下and优先级高于or


    select gameId from user where gameId > 10 and gameId < 20 or gameId > 60;

* like模糊查询使用了两个通配符来进行匹配  
%代表任意多个字符_代表一个字符。如果要把%或_当字符，则在其前面使用\来防转移。

    
    select * from user where username like 'huxia_';
    
    select * from user where username like '%huxiao';
    
    select * from user where username like '\%huxiao%';


* 一些条件查询


    select name,ID from myTable where name between 'A' and 'E';
    
    select gameId,name from user where gameId is not null;
    
    //找出gameId在10到20之前或者大于60的列
    
    
## order by排序

    select <字段1,字段2...字段n> from     <tableName>  
    order by <字段1,字段2,字段3> desc/asc;
    
asc表示升序排列

desc表示降序排列

* 在不使用order by时，默认位升序排序

* 如果指定多个字段排序，那么后一个字段将会在前一个字段相同时进行对应顺序排序。

例：
        
    select id from user 
    order by id,vip desc
        //当id相同时，讲这些序列以vip等级降序排列

## group by分组

group by将会把对应字段中重复字段放在一起即相同的在一组，然后返回查询结果。  
当指定多个字段分组时，其讲多个字段的混合看成一个类别

    select <字段1,字段2...字段n> frome tablename 
    group by
        <字段1，字段2，字段3>;
        
    id name number
    1  aa   22
    2  bb   22
    3  cc   33
    4  dd   33
    5  dd   44
    6  ee   44
    7  ee   55
    8  ff   55
    9  ff   66
    
    //根据name分组，然后找出每组中最大的id
    select max(id) group by name;
    
    //根据name与number分组，然后找出每组中最大的id(name与number全相同时为同一组)
    select max(id) group by name,number;
    
    //查看根据name分组时可以分为多少组
    select count(*) group by name;

## having再过滤
having用于对分组之后的数据再进行过滤。

having中可以使用聚合(分组)函数。

having一般与group配合使用，单独使用having并不规范。

如果单独使用having，mysql中将会单独修正一个GROUP BY NULL，该语句等同于LIMIT 1。所以为了不混乱，不要单独使用having。

例：

    //表t
    a  id
    1  1
    1  3
    
    select * from t having id = min(id);
    //有输出
    a   id
    1   1
    
    select * from t having id = max(id);
    //无输出
    //因为该语句等同于select * from t group by null having id=3;
    //用group by null分组后只有id=1这一分组与唯一记录，此时id=3不在该分组中
    //(max函数看的是全局数据)故没有返回。

* [上述例子详情网址](https://blog.csdn.net/majianxin1/article/details/102602492)
  
## limit行限定
limit为mysql特有，不属于sql标准

    select                      //5
        <字段1,字段2...字段n> 
    limit
        <number1,number>        //7

limit的最小行数下标为0。

limit用来限定最后输出记录的行数。  

limit可以接受两个数字，第一个表示开始的下标，第二个表示从该下标开始要多少行数据。  

limit只接受一个数字时，表示只要该行数之前的所有记录。

limit接受的第二个数字为一个限定为无穷大的数时表示到最后一行。(以前可以用-1但是现在不行了)

    //从第1行开始，获取2行数据
    select id from user limit 0,2;

    //只要前8行
    select id from user limit 8;
    
    //从第9行开始，要所有数据
    select id from user limit 9,(>columnNumber);

## distinct去重
distinct只能出现在select后面所有字段的最前面，表示去除重复项。

distinct用于多个字段时，这些字段对应数据全都一致才算重复。

    //正确，当多个记录id,name全都一致时去重
    select distinct id,name from user
    
    //错误
    //select id,distinct name from user

## 连接

### 笛卡尔积的现象

### 内连接
内连接就是组合两个表中的记录，返回两个表指定条件相关联字段相符的记录，也就是返回两个表都满足该条件的交集部分。

![内连接图](https://note.youdao.com/yws/api/personal/file/WEBfc9f48376eae343408615bd10452bd4f?method=download&shareKey=2253be0e6efab8fec0690a8fef353893)



    ....
        A
    [inner/cross] join
        B
    on
        连接条件
    where
        .......

* 等值连接  
等值连接是指内连接中两表交集部分是以两表部分字段记录的值以相等的形式来决定的。

例:

    select 
        emp.name,dept.name
    from
        emp
    join
        dept
    on
        emp.deptno=d.deptno

* 非等值连接
类似于等值连接但是其连接条件是以两表部分字段记录的值以不相等的形式来决定的。

例:
    
    //将emp中sal字段符合salgrade的losal与hisal字段区间的对应的salgrade.grade和emp.ename显示出来
    select 
        emp.ename,e.sal,salgrade.grade
    from
        emp
    join
        salgrade
    on
        emp.sal between s.losal and s.hisal

    //salgrade
    grade   losal   hisal
    1       700     1200
    2       1201    1400
    3       1401    2000
    4       2001    3000
    5       3001    9999
    
    //emp
    ename   sal
    smith   800
    allen   1600
    ward    1250
    jones   2975
    martin  1250
    blake   2850
    clark   2450
    scott   3000
    king    5000
    turner  1500
    adams   1100
    james   950
    ford    3000
    miller  1300
    
    //output
    ename   sal     grade
    smith   800     1
    allen   1600    3
    ward    1250    2
    jones   2975    4
    martin  1250    2
    blake   2850    4
    clark   2450    4
    scott   3000    4
    king    5000    5
    turner  1500    3
    adams   1100    1
    james   950     1
    ford    3000    4
    miller  1300    2


* 自连接
自连接就是在内连接中一张表当两张，自己连接自己。

### 外连接
外连接中连接的两个表分为主表与副表，主要是需要查询主表中的数据，捎带着查询副表，如果副表中的数据没有跟主表中的匹配到，则以null与之匹配。

一般而言外连接中的左连接与右连接本质上一致，只是主表和副表的位置不同。

* 左连接

语法:

    ........
    from
        tableA
    left [outer] join
        tableB
    on
        连接条件

此时主表在语句左边，取主表中的全部，与副表中满足条件的记录，若右表中的记录不满足条件，则显示null

例：找到所有员工的领导

    //员工表tableA
    ename   mgr
    SMITH   7902
    ALLEN   7698
    WARD    7698
    JONES   7839
    MARTIN  7698
    BLAKE   7839
    CLARK   7839
    SCOTT   7566
    KING    null
    TURNER  7698
    ADAMS   7788
    JAMES   7698
    FORD    7566
    MILLER  7782
    
    //领导表tableB
    empno   ename
    7566    JONES
    7698    BLAKE
    7782    CLARK
    7788    SCOTT
    7839    KING
    7902    FORD
    
    select
        tableA.ename,tableB.ename
    from
        tableA
    left outer join
        tableB
    on
        tableA.mgr=tableB.empno
    

* 右连接  

语法：

    ........
    from
        tableA
    right [outer] join
        tableB
    on
        连接条件


此时主表在语句右边，取主表中的全部，与副表中满足条件的记录，若右表中的记录不满足条件，则显示null。

例：

    //tableA
    DEPTNO
    20
    30
    30
    20
    30
    30
    10
    20
    10
    30
    20
    30
    20
    10
    
    
    //tableB
    DEPTNO  DNAME           LOC
    10      ACCOUNTING      NEW YOUR
    20      RESEARCH        DALLAS
    30      SALES           CHICAGO
    40      OPERATIONS      BOSTON
    
    select
        tableA.*,tableB*
    from
        tableA
    right outer join
        tableB
    on
        tableB.deptno=tableA.deptno
    
* 全连接(用的非常少，这里不做介绍)

### 表的多连接
连接可以在同一个查询语句中多次使用。  
一般来说有n个表一起连接查询，对应在查询语句中使用了n-1次连接(前面连接完成后再拿之前的表来连接不算)


例:
   
   //找出每一个员工的部门名称，工资等级，上级领导  
   //e为员工表,其中包括领导，mgr表示该员工领导的编号  
   //d为部门情况表，该表中deptno为部门编号  
   //s为工资等级表，该表中losal为最低划分标准，hisal为最高划分标准  
   
    select
        e.ename,d.dname,s.grade,e1.name
    from
        e
    join
        d
    on
        e.deptno = d.deptno         //此处找出部门
    join
        s
    on
        s.sal between s.losal and s.hisal       //此处划分出工资标准
    left join
        e as e1        //重命名了
    on
        e.mgr = e1.empno                        //此处找出领导

## select子查询
每个select语句都可以作为一个新的表嵌套在其他的语句中。

    select                      
        (子查询)
    frome                     
        (子查询)
    where                       
        (子查询)
    group by                   
        (子查询)
    having                     
        (子查询)
    order by                    
        (子查询)
    limit
        (子查询);      



### where中的select子查询
例:
    
* 部分查询之后只会返回一行一列的数据表，此时使用该表相当于一个数据。

    select * from emp where sal > (select avg(sal) from emp);

### from后的select子查询
from后的select子查询比较简单，其将子查询结果当做了一个普通的表。  

例:
    
    //将子查询(select deptno,avg(sal) as avgsal from emp group by deptno)当做了一个新的表来用
    //表salgrade为工资水平定级表，grade为等级，losal为某等级最低水平，hisal为某等级最高水平
    //表emp为员工表，sal为员工工资，deptno为部门编号
    //下述案例，查询每个部门的平均工资水平
    
    select 
        t.*,s.grade
    from
        (select deptno,avg(sal) as avgsal from emp group by deptno) as t
    join
        salgrade as s
    on 
        t.avgsal between s.losal and s.hisal

### select后的select子查询

例:

    //emp为员工表，ename为员工名字，deptno为部门编号
    //dept为部门表，deptno为部门编号
    //下属查询每个员工所在部门名称并且和员工名一起显示
    
    select
        e.ename,
        (select d.dname from dept as d where e.deptno = d.deptno) as dname
    from
        emp as e; 
        
    //不使用子查询
    select
        e.ename,d.dname
    from
        emp as e
    join
        dept as d
    on
        e.deptno = d.deptno;

上述select子查询本质上是查询了某一列，然后该列从另外一个表中使用条件查询

select子查询部分时候可以避免使用连接

上述的(select d.dname from dept as d where e.deptno = d.deptno) as dname如果不用as显示的将会是(select d.dname from dept as d where e.deptno = d.deptno)，但是其本质上仍然为列deptno。

## union的使用
union能将查询结果集相加  

union表示去重相加  
union all表示不去重相加  

例：

    select * from tableA where id=6 or id=5;
    
    //等同于
    select * from tableA where id=6
    union all
    select * from tableA where id=5;
    
    //去重相加
    select * from tableA where id=6
    union all
    select * from tableA where id=5;
    
使用union时请保证连接的表列数相同，不然结果无意义。
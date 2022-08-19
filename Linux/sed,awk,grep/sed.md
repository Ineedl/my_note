# sed

## sed中注意事项

* sed中的()默认没有特殊意义，需要用\来附加特殊意义，比如sed中\^(123)匹配"(123)"开头，\^\\(123\\)匹配"123"开头。

* sed中的{}默认没有特殊意义，需要用\来附加特殊意义，比如sed中p{6}匹配"p{6}"这个字符串，p\\{6\\}匹配"pppppp"。

* sed中的[]默认拥有特殊意义，当需要使用[]两个字符时，需要用\来取消特殊意义。

* sed中默认是每次对每一行进行处理，而且会默认会忽视每行的换行符。(非常不建议在sed中进行带\n的多行操作，因为sed是行处理命令，虽然这可以实现)

* sed中默认匹配多次就操作多次，而不是只会在第一次匹配时操作。

* 在MacOS下的许多sed命令必须要使用\换行后才能输入代替，替换，添加等的内容(很操蛋)


## sed规则

    sed '<行匹配>
         <行操作>
         [(替换操作有)/匹配内容/]
         [(修改与添加操作有)\添加或替换内容\]
         [正则表达式匹配修饰符与打印输出控制]'

>  常用选项

-i 将改动对应修改文件
-n 取消打印效果


## 行寻址 找到想要替换的那行  

> 数字方式

数字方式直接用数字,数字放到sed命令行最前就行。

```
    >sed '2s/dog/cat/' test.txt
    
    只在第二行里寻找并替换，如果第二行中无该字符，相当于没用  
    
    >sed '1,99s/dog/cat/' test.txt
    
    只在1-99行里替换 
    
    >sed '10,$/dog/cat/' test.txt
    
    在10行之后的所有行里替换
```   
    
> 文本过滤器
该方式相当于grep,可以使用正则表达式，文本过滤用//围起来放到sed命令行最前面。

```
    >sed '/myName/s/he/she/' test.txt
    
    找到全部有myName的那一行，并且把里面的he替换成she
```
    
> 两个寻址方式一起使用 

`格式`  

/文本/ 或 数字,/文本/ 或 数字 

```
    #test.txt
    1 2 3 4 5 num
    3 3 4 6 7 test
    003000000 test
    ----------
    1111111111
    
    >sed -n '/1/,/3/s/test/number/p' test.txt
    3 3 4 6 7 number
    
    从第一个含有字符1开始的行开始,到最后一个含有字符3的行结束
    把这些行里面的test替换成number
    
    >sed '2,/3/s/5/number/' test.txt
    1 2 3 4 5 num
    3 3 4 6 7 test
    003000000 test
    ----------
    1111111111                                      //无变化
    
    从第二行开始到最后一个含有字符3的行结束
    把这里面的字符5替换成number
    如果后面的行没有字符3，则会从开始行的所有行
```

> 多行命令

```
    $ sed '行寻址{
    > s/for/while/
    > s/dog/cat/
    > }' test.txt
```

sed如果输入一个'后按回车，就会开启多行模式，多个命令需要用{}括起来



## s行操作

行操作中字符为s时为替换

```
    #test.txt
    A test,Some number test;
    Are you ok? Do you want select what number?
    ok let's go test.

    >echo test test test | sed 's/test/number/2'
    test number test

```

## d行操作

行操作中字符为d时为删除

```
    sed '3d' test.txt
    
    sed '2,3d' test.txt
    
    sed '/1/,/3/d' test.txt
```

## a/i 

行操作中字符为a/i时为行后/前插入

```
    set '<行匹配>i<添加的东西>' 文件
```

* i与a选项支持文本匹配

* 一般为了美观可以把添加的东西用\围起来，或是用\换行后最后用'结尾来插入多行
    

> 插入一行

```
    $ echo Test Line 2 | sed 'i\Test Line 1'
    Test Line 1
    Test Line 2
    
    $ echo Test Line 2 | sed 'i\
    > Test Line 1'
    Test Line 1
    Test Line 2
```   
    
> 插入多行
    
```    
    $ echo Test Line 2 | sed 'i\
    > Test Line 1\nTest Line 3'
    Test Line 1
    Test Line 3
    Test Line 2
    
    在该命令中\n转义为换行
    
    $ echo Test Line 2 | sed 'i\
    > Test Line 1\
    > Test Line 3'
    Test Line 1
    Test Line 3
    Test Line 2
```   
    
## c

行操作中字符为c时为修改

重新编辑某一行的内容，可以使用行寻址，寻址方式同上面命令。

```
    #test.txt
    This is number 1;
    This is number 2;
    This is number 3;

    $ sed '/number 1/c\
    > This is mine;' test.txt
    This is mine;
    This is number 2;
    This is number 3;
    
    $ sed '/number1/c This is mine;' test.txt
```   
    

## r

行操作中字符为r时表现为在匹配行的后面加入读入文本的内容。

读取的数据默认会插入到指定操作文件的末尾显示，可以和行寻址一起使用。

使用行寻址后表示插入到某行后面或某行范围后面。

    # test.txt
    --------
    ++++++++
    ////////
    
    > echo test | sed 'r test.txt'
    test
    --------
    ++++++++
    ////////

一般 r 和 d操作符一起配合使用  

```
    #notice.std
    Would the following people:
    List
    please report to the ship's captain.
    
    #data.txt
    Blum, R Browncoat
    Harken, C Browncoat
    ??????, D !!!!!!!!!
    
    $ sed '/List/{
    > r  data.txt
    > d
    > }' notice.std
    Would the following people:
    Blum, R Browncoat
    Harken, C Browncoat
    ??????, D !!!!!!!!!
    please report to the ship's captain.
```
    
## l 列出assic码符号，而不是他们的转意

## y

行操作中字符为c时为映射修改
    
## 正则表达式匹配修饰符标记与打印输出控制处选项

`例子文本` 

```
    #test.txt
    A test,Some number test;
    Are you ok? Do you want select what number?
    ok let's go test.
```

* 数字：有替换字符的那行只替换第n次出现改行的地方其他的都不匹配  
``` 
    >echo test test test | sed 's/test/number/2'
    test number test
```
    
* g：替换所有匹配的文本(默认自动添加)

```
    >sed 's/test/number/g' test.txt
    A number,Some number number;
    Are you ok? Do you want select what number?
    ok let's go number.
```

* i：不区分大小写	将匹配设置为不区分大小写，搜索时不区分大小写: A 和 a 没有区别。


* p： 与-n一起使用，-n为取消所有打印结果，p为显示出替换过的行，sed默认会打印出所有行

```
    >sed -n 's/test/number/p' test.txt
    A number,Some number number;
    ok let's go number.
```

* w file 将替换结果写入到文件  

```
    >sed 's/test/number/w test2.txt' test.txt
    A number,Some number number;
    Are you ok? Do you want select what number?
    ok let's go number.
```

* 上述替换标记一起使用  

```
    >sed 's/test/number/2 g p w test2.txt' test.txt
    A number,Some number number;
```   
    
这样会造成效果叠加,并不是后一个效果让前一个失效，不建议这样使用。
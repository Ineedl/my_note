## rand函数

> 原型

```C
<stdlib.h>
int rand(void);
```

> 作用

rand()函数用来产生随机数，但是，rand()的内部实现是用线性同余法实现的，是伪随机数，由于周期较长，因此在一定范围内可以看成是随机的。

rand()会返回一个范围在0到RAND_MAX（至少是32767）之间的伪随机数（整数）。

在调用rand()函数之前，可以使用srand()函数设置随机数种子，如果没有设置随机数种子，rand()函数在调用时，自动设计随机数种子为1。随机种子相同，每次产生的随机数也会相同。

使用rand()函数产生1-100以内的随机整数：int number1 = rand() % 100+1;

## srand函数

> 原型

```c
<stdlib.h>
void srand (usigned int seed);
```

> 作用

srand()用来设置rand()产生随机数时的随机数种子。参数seed是整数，通常可以利用time(0)或getpid(0)的返回值作为seed。

使用rand()和srand()产生1-100以内的防真随机整数:

    srand(time(0));
    int number1 = rand() % 100+1;
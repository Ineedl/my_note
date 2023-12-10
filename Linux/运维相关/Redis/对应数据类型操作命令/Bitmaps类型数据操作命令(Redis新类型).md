## 添加数据

    setbit <key> <offset> <value>
    
* offset为偏移量，相当于一般数组中的索引

* 一开始初始化的时候可以直接从某一个位开始进行初始化，之后默认其他位的值都是0，大于该索引位置的值也为0。

`例`

    //之后0-8的索引位置的值都是0，大于9的索引位置也为0(如果你之前没有设置过更大的位置)
    setbit abc 9 1

* 对于已设置了的位，后续的设置会替换之前的设置

* 每次只能设置一位。

## 获得数据

    gitbit <key> <offset>
    
* 一般来讲，Bitmaps在初始化后没有上限(严格来讲到你设置过的最大位置)，只是除了你设置的位置外，其他位置默认都为0。


## 统计Bitmaps数组中设置为1的个数

    bitcount <key> [startOffset endOffset]
    
* 注意范围不能只有start，必须start与end同时都有
    
## Bitmaps的与/或/非/异或操作

    //与/或/异或
    bitop <and/or/xor> <outKey> <key1> <key2>
    
    //非
    bitop <not> <outKey> <key>
    
* 一般建议操作后只取自己需要的偏移位置来使用，对于超过自己设定的最大位置的偏移的索引，请不要使用。


## 获得Bitmaps中第一个值为targetBit的偏移量

    bitpos key <targetBit(0/1)> [start] [end]

* 可以只指定起始位置
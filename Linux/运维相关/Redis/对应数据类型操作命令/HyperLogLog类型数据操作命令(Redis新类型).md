## 元素的添加

    pfadd <key> <element1> [<element2>...]
    
* 如果插入重复元素，操作结果将返回0

## 统计基数数量

    pfcount <key> [<key2>...]

## 合并多个HyperLogLog到另外一个HyperLogLog中

    pfmerge <outKey> <sourcekey> [<sourcekey2>]
    
* 合并后会继承之前key的已存入的基数，当对新的key来pfadd之前key中已有的基数时，将返回0。
## 集群的Jedis操作

Jedis连接集群中的任何一个主机都可以进行读/写操作，在读/写操作的值不属于当前集群节点管辖范围或是在从机操作时，都会对应转换到相应的主机，而不需要手动切换。


* Jedis在集群中不允许一般的多键操作。
* Jedis在集群中的事务中的多键位操作不被允许。
* Jedis不支持lua脚本。
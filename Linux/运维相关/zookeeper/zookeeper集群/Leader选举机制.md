## 投票机制

至少有三票才能选举出一个Leader，这也意味着最少有三个主机才能启动一个zookeeper集群。

每个主机有且只有一票能够来投票。

主机不够时，该主机将会处于Looking模式，仍然启动着，但是并不是一个集群节点，直到有Leader产生，集群才诞生。


## 集群中一开始没有Leader时选举机制。

> 选举机制

1.每启动一个主机时，默认会先给自己投一票。

2.当之前已存在的主机进入新的一轮投票后，如果新主机的myid值大于自己，将会把自己的票投给新主机

3.如果一轮投票后过后没有Leader产生，所有主机都将会进入Looking状态，该状态下，每次投票该主机都会参加，直到该主机成为Leader或是Follower。

4.当一轮投票后产生Leader后，除了Leader主机，投票过的主机都会成为Follower，Follower与Leader主机在后续新进入主机再次发生投票时，不会更改自己的投票。


## 集群中有Leader时的选举机制

> 有Leader，新主机加入时的选举

当集群中有Leader主机时，新加入的主机会被告知Leader的信息，并且会与Leader建立连接同步。

> 有Leader，但是Leader已经挂掉。

集群中会按照 Epoch>ZXID>SID 来规则来选举Leader

Epoch值最大的主机自动成为Leader

Epoch值相同时，ZXID最大的主机自动成为Leader

Epoch值相同时，ZXID值相同时，SID最大的主机成为Leader
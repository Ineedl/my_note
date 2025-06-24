# MongoDB ObjectId

------

ObjectId 是一个12字节 BSON 类型数据，有以下格式：

- 前4个字节表示时间戳
- 接下来的3个字节是机器标识码
- 紧接的两个字节由进程id组成（PID）
- 最后三个字节是随机数。

MongoDB中存储的文档必须有一个"_id"键。这个键的值可以是任何类型的，默认是个ObjectId对象。

在一个集合里面，每个文档都有唯一的"_id"值，来确保集合里面每个文档都能被唯一标识。

MongoDB采用ObjectId，而不是其他比较常规的做法（比如自动增加的主键）的主要原因，因为在多个 服务器上同步自动增加主键值既费力还费时。

------

## 创建新的ObjectId

使用以下代码生成新的ObjectId：

```bash
newObjectId = ObjectId()
```

上面的语句返回以下唯一生成的id：

```bash
ObjectId("5349b4ddd2781d08c09890f3")
```

也可以使用自己的id来取代MongoDB自动生成的ObjectId：

```bash
myObjectId = ObjectId("5349b4ddd2781d08c09890f4")
```

------

## 创建文档的时间戳

由于 ObjectId 中存储了 4 个字节的时间戳，所以你不需要为你的文档保存时间戳字段，你可以通过 getTimestamp 函数来获取文档的创建时间:

```bash
ObjectId("5349b4ddd2781d08c09890f4").getTimestamp()

#结果
ISODate("2014-04-12T21:49:17Z")
```
## 序列化
序列化是指将Java的某个对象(不是某个类)的状态保存下来并且存储到硬盘中，让出内存空间，在后续需要的时候再反序列化到内存。


## 反序列化
反序列化将硬盘存储中的某个序列化的对象，重新以原状态加载到内存中执行。

## 序列化标志
### Serializable接口
所需包：java.io.Serializable

* 需要被序列化的对象，其类型必须实现Serializable接口。

* 该接口内部没有任何功能，仅为一个标志类，序列化的识别操作是由反射来完成的。

* 实例化不实现该接口的类会抛出NotSerializableException异常

## 序列化的操作
### ObjectOutputStream类
ObjectOutputStream类用于将对象序列化并且存储。并且保存存储时状态。

#### 常用构造函数
##### ObjectOutputStream(OutputStream out

* 该构造方法传入的流为序列化对象写入的流

#### 写入对象方法
##### public final void writeObject(Object obj) throws IOException

* 该方法将指定的obj对象写入构造时指定的流中

* 会抛出的异常：  
InvalidClassException - 序列化使用的类错误。  
NotSerializableException - 要序列化的某些对象不实现java.io.Serializable接口。  
IOException - 底层OutputStream抛出的任何异常


#### 序列化写入一个文件的实例

    try{
    
        Test t=new Test();
        ObjectOutputStream oos= new ObjectOutputStream(new FileOutputStream("Test"));

        oos.writeObject(t);
        oos.flush();
        oos.close();
        
    }catch(IOException e)
    {
        
    }

## 反序列化的操作
ObjectInputStream的包：java.io.ObjectInputStream  
ObjectOutputStream的包：java.io.ObjectOutputStream  
### ObjectInputStream类
ObjectInputStream用于把已序列化的对象反序列化到程序中，并还原序列化时的状态。

#### 常用构造函数
##### ObjectInputStream(OutputStream out)

* 该构造方法传入的流为将要读出已序列化对象的流。

#### 常用方法
public final Object readObject() throws IOException,ClassNotFoundException

* 该方法从构造时指定的流中读取一个对象。

* 会抛出的异常：
ClassNotFoundException - 无法找到序列化对象的类。  
InvalidClassException - 序列化使用的类错误。  
StreamCorruptedException - 流中的控制信息不一致。  
OptionalDataException - 在流中找到原始数据，而不是对象。  
IOException - 任何常见的输入/输出相关异常。

#### 反序列化实例
    try{
    
        ObjectInputStream oos= new ObjectInputStream(new FileInputStream("Test"));

        Object obj =oos.writeObject(t);
        
        oos.close();
        
    }catch(IOException e)
    {
        
    }

## 多个对象序列化
* 序列化使用writeObject写入对象时，如果继续写入，则将会继续追加写入。反序列化读取同理。  

* 由于每次写入是以Object为对象，而且都好像写入了对应类信息，使用对应writeObject与readObject写入与读取时不用考虑对象会被部分读取并与其他对象组合，但是仍然要考虑顺序问题

* 一般多个序列化推荐装入容器然后再对容器序列化，对于多个不同类型的对象，可使用Object容器。

* 容器一般实现了Serializable接口，一般只需要放入容器的对象其类型实现了Serializable接口就可以使用容器序列化。

## transient关键字
该关键字用于标识类的变量。  
被该关键字标识的变量不参与序列化。

transient标识的变量在序列化与反序列化之后，值会归0，对象引用会变为null。

例:

    Class User
    {
        public int id;
        private int password;
        public transient NowGameState state;
    }
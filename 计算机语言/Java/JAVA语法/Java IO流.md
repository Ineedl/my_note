## Java中IO流分类
### 按方向
Output：输出流  
Input：输入流

### 按照读取方式
字节流：以字节为单位读取  

字符流：以字符为单位来读取数据  
(读取正常英文字符，一次读取1字节，如果是读取非英文的字节编码字符，则一次读取多个字节)。

## IO流四大抽象大类
| 类全名 | 解释 |
|:--|:--|
| java.io.InputStream | 字节输入流超类 |
| java.io.OutputStream | 字节输出流超类 |
| java.io.Reader | 字符输入流超类 |
| java.io.Writer | 字符输出流超类 |

* 上述四大抽象类都是对于流的最基础的抽象。

* Java标准包中以Stream结尾的都是操作字节流的类。以Reader/Writer结尾的都是操作字符流的流。

* 所有的流都实现了java.io.Closeable接口，都可以使用close()方法关闭流。

* 输出流实现了java.io.Flushable接口，可以使用flush()方法来将已缓存的数据写入底层来刷新此流。(数据缓存部分不完整也会被写入底层刷新)


## 需要掌握的IO
| 类全名 | 解释 |
| :-- | :-- |
| java.io.FileInputStream | 文件字节输入流 |
| java.io.FileOutputStream | 文件字节输出流 |
| java.io.FileReader | 文件字符输入流 |
| java.io.FileWriter | 文件字符输出流  |
| java.io.InputStreamReader | 字节流转字符流输入流 |
| java.io.OutputStreamWriter | 字节流转字符流输出流 |
| java.io.BufferdInputStream | 缓冲字节输入流 |
| java.io.BufferdOutputStream | 缓冲字节输出流 |
| java.io.BufferedReader | 数缓冲字符输入流 |
| java.io.BufferdWriter | 缓冲字符输出流 |
| java.io.DataInputStream  | 数据输入流 |
| java.io.DataOutputStream | 数据输出流 |
| java.io.PrintStream | 标准流 |
| java.io.PrintWriter | 标准入出流 |
| java.io.ObjectInputStream | 对象输入流 |
| java.io.ObjectOutputStream | 对象输出流 |

## 文件IO
### FileInputStream
#### 常用构造方法 
##### FileInputStream(String fileName)  
fileName：要打开的文件名(可以使用绝对路径，也可以使用相对路径)

##### FileInputStream(File file)  
file:要打开的File类对象

#### 字节读取方法
##### public int read() throws IOException  

* 功能：该方法从输入流中读取一个字节  

* 返回值：返回读到字节的对应的int类型的值，如果到达流的末尾返回-1。

* 发生IO错误时，抛出IOException 异常。


##### public int read(byte[] b) throws IOException

* 功能：该方法从输入流中读取b.size()个字节到byte数组中

* 返回值：读入缓冲区的总字节数，如果没有数组大小那么多字节的数据，或是已经到达流的末尾，返回-1 。

* 发生IO错误时，抛出IOException 异常。

##### public long skip(long n) throws IOException

* 注意n为负数时没意义，也不会往前跳。

* 功能：该方法跳过输出流中的n个字节

* 返回值：实际跳过的字节数。

* 发生IO错误时，抛出IOException 异常。

##### public int available() throws IOException

* 功能：估计剩余可从流中读取的字节数。

* 返回值：返回剩余可读取的字节数。

* 发生IO错误时，抛出IOException 异常。

##### 关于位置重定位和详细的规定读取数量与剩余字节的检测请查询API文档


### FileOutputStream
#### 常用构造方法 
##### FileOutputStream(String fileName)  
fileName：要打开的文件名(可以使用绝对路径，也可以使用相对路径)

##### FileOutputStream(File file)  
file:要打开的File类对象

#### 字节的写入方法
##### public void write(byte b) throws IOException  

* 功能：该方法写入一个字节到流中。  

* 发生IO错误时，抛出IOException 异常。


##### public void write(byte[] b) throws IOException

* 功能：该方法将byte数组中的内容写入流中。

* 发生IO错误时，抛出IOException 异常。

##### public void write(byte[] b,int off,int len) throws IOException

* 功能：从指定的byte阵列写入len字节，从偏移量off开始输出到此输出流。

* 发生IO错误时，抛出IOException 异常。

### FileReader与FileWriter
这两个类的用法几乎跟FileInputStream与FileOutputStream一致，但是其每次读取写入的单位都为字符。

##### 关于位置重定位和详细的规定读取数量与剩余字节的检测请查询API文档

### BufferedReader与BufferedWriter
这两个类用于包装其他Reader类与其他Writer类，其内部拥有一个缓冲数组用来存放读取到或是将要写入的数据，这两个类相当于给其他Reader类与其他Writer类增加了一个缓冲区。
#### 详细使用方法请查询API文档

### BufferedInputStream与BufferedOutputStream
这两个类用于包装其他InputStream类与其他OutputStream类，其内部拥有一个缓冲数组用来存放读取到或是将要写入的数据。  
这两个类相当于给其他InputStream类与其他OutputStream增加了一个缓冲区。

#### 详细使用方法请查询API文档

### DataInputStream与DataOutputStream
这两个类写入或读取数据时，可以将对类型带着数据一起写入文件或从文件中读取。  
用DataInputStream写入的数据只能用DataOutputStream类来读取。

DataInputStream与DataOutputStream类有对于数据类型来进行不同I/O的方法。

#### 详细使用方法请查询API文档

### PrintStream与PrintWriter 
这两个类配后使用后类似于c中的scanf，用来提供字符的格式化输入。同时，他们也能对标准输入流进行一些操作。

* 标注输入流不需要手动关闭，因为每个程序运行时都是默认打开直到程序关闭。

#### 详细使用方法请查询API文档

## 文件的抽象File类
File类只是文件的一个抽象存在(包括目录等各种文件都可以)，其不拥有读写的方法，其只是表示一个文件.  
File类包含被抽象文件的所有属性，与信息。  
File类只是将文件本身的抽象与文件内容分离。
File类可以用来创建一个新的文件。

File类的常用方法请查询对应API文档。
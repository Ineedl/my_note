## Properties
包：java.util.Properties

Properties继承于 Hashtable。表示一个持久的属性集.属性列表中每个键及其对应值都是一个字符串。

* Properties常用于读取属性配置文件。

### 属性配置文件
Properties常用于从属性配置文件中读取数据，属性配置文件中存放数据满足以下条件。

* 每行一组数据。

* 每组数据由键=值组成。

* 建议以.properties结尾，但是不必须

* key重复会发生value的覆盖，不建议使用重复key。

* 属性文件中#为注释

格式：
    
    key=value
    key2=value
    ...
    keyn=value

Properties和FileReader配合使用从配置文件中读取数据。

#### 构造函数
Properties常用的构造函数为一个空的构造函数。

#### 加载读取的字节流
##### public void load(InputStream inStream)throws IOException

* 该方法指定Properties类要读出数据的输入流，并且把该流中的数据全部加载。

* 抛出异常:
IOException - 从输入流读取时是否发生错误。  
IllegalArgumentException - 如果输入流包含格式不正确的Unicode转义序列。

##### public String getProperty(String key)

* 该方法用来获取读入数据中指定的key的值。

#### 使用实例

    FileReader reader = new FileReader("./test");
    
    Properties pro = new Properties();
    
    pro.load(reader);
    
    String username = pro.getProperty("username");
    
    String password =
    pro.getProperty("password");
    
    //test文件
    username=root
    password=12345678
    
* 注意Properties只能读取英文字符数字等单字节数据，对于国际化编码并不支持。
    


## ResourceBundle
Properties的国际化版本，Properties基本只能读取标准编码的属性集(英文，单字节数字字符与符号字符等)，但是ResourceBundle可以进行多语言的属性集读取和转换。
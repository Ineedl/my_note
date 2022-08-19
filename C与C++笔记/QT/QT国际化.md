## QT国际化

> 原理

利用QTranslator加载Qt语言家中生成的ts文件，来对程序中使用tr圈起来的字符进行翻译  

> QT国际化顺序  

0.使用qt语言家创建一个tr文件

1.初始化一个QTranslator对象  

2.使这个QTranslator对象用load加载语言文件      

3.使用实例化对象installTranslator该QTranslator对象   

4.再次对使用了tr包裹的文本再用tr包裹设置一次  
//很重要，而且在这之前QTranslator对象都必须存在


* 被tr包裹的字符串设置在加载新的语言文件后，必须重新再被重新设置一次。

---

> tr

```
[static] QString QObject::tr(  
const char *sourceText,  
const char *disambiguation = Q_NULLPTR,  
int n = -1  
)
```

sourceText：  你需要包裹的字符串  

disambiguation：  该字符串会在Qt语言家中的开发者注解中出现，这是为了防止有许多的sourceText相同

n： 根据sourceText中的单词来填写出现的数量，翻译会根据n的值来将英语中该单词翻译成复数形式


请注意不要使用tr包裹中文。


> load

```
bool QTranslator::load(  
const QString &filename,  
const QString &directory = QString(),  
const QString &search_delimiters = QString(),  
const QString &suffix = QString()  
)
```

filename： 文件名，可以使用绝对路径，使用时剩下三个参数可以不写。

directory： 目录名

search_delimiters： 目录分隔符

suffix： 文件后缀

---

> installTranslator

```
[static] bool QCoreApplication::installTranslator(QTranslator *translationFile)  
```
该函数用来将加载了语言文件后的语言类生效。


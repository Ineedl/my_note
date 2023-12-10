# QT常用类以及方法  &ensp;  &emsp; &nbsp;

* [QT中字符转换注意](#qt中字符转换注意)  

* [字符串类&emsp;&emsp;QString ](#qstring)  

* [字符串的list容器类&emsp;&emsp;QStringList ](#qstringlist)  

* [静态图片显示类&emsp;&emsp;QPixmap ](#qpixmap)  

* [动态图片显示类&emsp;&emsp;QMoive](#qmovie)  

* [QT窗体常用函数&emsp;&emsp;](#qt窗体常用函数)  

* [弹窗类&emsp;&emsp;QDialog](#qdialog)

* [表格类&emsp;&emsp;QTableView](#qtableview)  

* [表格数据项类&emsp;&emsp;QStandardItem](#qstandarditem)  

* [表格数据整体类&emsp;&emsp;QStandardItemModel](#qstandarditemmodel)  

* [窗口的鼠标事件函数](#窗口的鼠标事件函数)

* [设置控件或部件的属性](#设置控件或部件的属性)

* [带滚动条的QWidget&emsp;&emsp;QScrollArea//未完成](#qscrollarea)  

* [文件类&emsp;&emsp;QFile](#qfile)  

* [单字节数据类&emsp;&emsp;QByteArray](#qbytearray)    

* [界面切换类(界面栈)&emsp;&emsp;QStackedWidget](#qstackedwidget)  

* [滚动条类&emsp;&emsp;QProgressBar](#qprogressbar)

* [QT布局相关](#qt布局相关)

* [QT容器相关](#qt容器相关)

* [QT多进程&emsp;&emsp;QProcess](#qprocess)

* [QT绘图事件相关](#qt绘图事件)

* [QT进程内存共享&emsp;&emsp;QSharedMemory](#qsharedmemory)

* [QT文件目录相关&emsp;&emsp;QDir](#qdir)

* [QT文件信息相关&emsp;&emsp;QFileInfo](#qfileinfo)

* [自定义MVC](#自定义mvc)

## 关于QtCreator中原来类的提升  
[返回开头](#qt常用类以及方法)

类提升就是将原本QtCreator中控件，升级成自己在项目中自定义的 继承该控件并增加新功能后的类。

## QT中字符转换注意
[返回开头](#qt常用类以及方法)
微软VC编译器源代码使用GB2312编码进行保存。linux环境下则是UTF-8。源码中的汉字字符串在生成可执行文件的过程中被转换成了本地编码。

Qt内部是使用Unicode编码，即QString保存的是Unicode编码的字符串。

Qt内部需要使用Unicode编码的字符串才能正确处理。使用QString的函数默认QString内部是Unicode字符串。  

### QString::fromLocal8Bit
[static] QString QString::fromLocal8Bit(const char *str, int size = -1)

该函数可以将是该系统中的字符编码集的字符串转换为Unicode 

linux下为UTF-8，windows下为GBK等，如果windows下使UTF-8编码使用该函数会产生乱码

如果size为-1(默认值)，则将其视为strlen(str)。

## QString  
[返回开头](#qt常用类以及方法)  
### 构造函数(QByteArray转QString)  
QString::QString(const QByteArray &ba)    

将QByteArray对象转换成QString对象

### length
int QString::length() const  

返回字符串个数(不包括 \0)


### mid    
QString QString::mid(int position, int n = -1) const  

截取从某一下标到某一下标的字符串,默认-1是表示直到结尾


### indexOf
int QString::indexOf(  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;const QString &str,  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;int from = 0,  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Qt::CaseSensitivity cs = Qt::CaseSensitive  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&ensp;) const 

可以从选择的位置开始查找,也可以选择忽略大小写(默认不忽略)  

### toUtf8
QByteArray QString::toUtf8() const  

将QString中的内容转换成用Utf-8编码的QByteArray对象  

### fromUtf8
[static] QString QString::fromUtf8(const char *str, int size = -1)  

将用UTF-8编码的str转换成使用Unicode编码的QString对象  
(str可以传入QByteArray对象,QByteArray有对应的转换函数)

### chop
void QString::chop(int n)

去除末尾n个字符。

### left
QString QString::left(int n) const
截取QString前n个字符。

### left
QString QString::right(int n) const
截取QString后n个字符。

### number
[static] QString QString::number(double n, char format = 'g', int precision = 6)

该函数将,double转换成对应的QString字符串。  

format：表示方法(科学计数法或是详细表示法)  

e   format as [-]9.9e[+|-]999
    
E   format as [-]9.9E[+|-]999
    
f   不使用科学计数法
    
g   从e和f中选择比较简洁的
    
G    从E和f中选择比较简介的

   

precision：保留的小数点

### replace
QString &QString::replace(  
QChar before,  
QChar after,  
Qt::CaseSensitivity cs = Qt::CaseSensitive  
)

将其中的某个字符全部替换成另外一个字符

Qt::CaseSensitive为是否大小写敏感

Qt::CaseInsensitive == 0    区分大小写  
Qt::CaseSensitive == 1  不区分


## QStringList  
QStringList继承于QList,可能就是QList<QString>然后加了一些常用方法  
[返回开头](#qt常用类以及方法)

### operator<<
QStringList &QStringList::operator<<(const QString &str)  

添加字符串到容器中,相当于容器内增加了一个元素  

### append
void QList::append(const T &value)

该方法是QList的方法  
QStringList继承了QList,T为QString类型

### insert
void QList::insert(int i, const T &value)

同append函数,T为QString类型  
可以选择插入位置(下标从0开始)

### replace
void QList::replace(int i, const T &value)

同append函数,T为QString类型  
替换第i个位置的元素(下标从0开始)

### join  
QString QStringList::join(QChar separator) const  
QString QStringList::join(const QString &separator) const 

把容器中的每个元素用一个字符或字符串拼接起来然后组成一个QString  
例:  
&emsp;&emsp;QString str = fonts.join(",");    
&emsp;&emsp;// fonts == ["Android","Qt Creator","Java","C++"]  
&emsp;&emsp;//str == "Android,Qt Creator,Java,C++"

### split方法(QString,非QStringList方法但是与之相关)  
QStringList QString::split(  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;const QRegExp &rx,   
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;SplitBehavior behavior = KeepEmptyParts  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;) const  

根据输入的字符拆分QString类并做成QStringList的元素,  
第二个此参数用QString::SkipEmptyParts表示忽略为空的元素  
例:  
&emsp;&emsp;String str = "Android,Qt Creator, ,Java,C++";  
&emsp;&emsp;QStringList list1 = str.split(",");  
&emsp;&emsp;// list1: [ "Android", "Qt Creator"," ", "Java", "C++" ]  
&emsp;&emsp;QStringList list2 = str.split(",", QString::SkipEmptyParts);  
&emsp;&emsp;// list2:[ "Android", "Qt Creator", "Java", "C++" ]

### replaceInStrings
QStringList &QStringList::replaceInStrings(const QRegExp &rx, const QString &after)  

替换所有元素中字符中存在的rx为after(若某个元素中不含该内容则会跳过该元素)  
例:  
&emsp;&emsp;QStringList list;  
&emsp;&emsp;list << "alpha" << "beta" << "gamma" << "epsilon";  
&emsp;&emsp;list.replaceInStrings("a", "o");  
&emsp;&emsp;// list == ["olpho", "beto", "gommo", "epsilon"]

### filter
QStringList QStringList::filter(  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;const QString &str,   
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Qt::CaseSensitivity cs = Qt::CaseSensitive  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;) const  

剔除容器中不存在str字串的元素  
例:  
&emsp;&emsp;QStringList list;  
&emsp;&emsp;list << "Bill Murray" << "John Doe" << "Bill Clinton";  
&emsp;&emsp;QStringList result;  
&emsp;&emsp;result = list.filter("Bill");  
&emsp;&emsp;// result: ["Bill Murray", "Bill Clinton"]


## QPixmap
常和QLabel一起使用来显示静态图片
### 一个完整显示图片的QPixmap和QLabel配合使用的例子  
    //构造一个QPixmap对象，使用图片路径
    QPixmap pix("D:/Qt_pro/Qt_day04/3.png");
            
    //调整QPixmap大小和lab一致
    pix = pix.scaled(ui->label->size());
        
    //使用lab显示图片
    ui->label->setPixmap(pix);  
[返回开头](#qt常用类以及方法)

### 构造函数
QPixmap::QPixmap(  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;const QString &fileName,   
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;const char *format = Q_NULLPTR,   
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Qt::ImageConversionFlags flags = Qt::AutoColor  
)  

一般只传入第一个参数,即图片路劲即可,剩下的一般默认即可

### scaled
QPixmap QPixmap::scaled(  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;const QSize &size,   
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Qt::AspectRatioMode aspectRatioMode = Qt::IgnoreAspectRatio,   
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;Qt::TransformationMode transformMode = Qt::FastTransformation  
) const  

一般传入label的大小来让其填满label  
例:    
`pix = pix.scaled(ui->label->size());`  
//让该图片显示大小同label尺寸

### setScaledContents
void QLabel::setScaledContents(bool)  

该函数用来选择是使用label的全部内容来填充图片


### loadFromData
bool QPixmap::loadFromData(  
const uchar *data,   
uint len, const char *format = Q_NULLPTR,   
Qt::ImageConversionFlags flags = Qt::AutoColor  
)

该函数使用字节数据加载图片

* data：原始数据

* format：图片格式

* flags：颜色偏好（一般默认即可）



## QMovie
常和QLabel一起使用来显示动态图片
### 一个完整显示动态图片的QMovie和QLabel配合使用的例子  
    QLabel label;  
    
    //设置Gif图片
    QMovie *movie = new QMovie("animations/fire.gif"); 
    
    //在label上设置动图
    label.setMovie(movie);  
    
    //开始显示动图
    movie->start();
[返回开头](#qt常用类以及方法)
### 构造函数  
QMovie::QMovie(const QString &fileName,  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;const QByteArray &format = QByteArray(),  
&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;QObject *parent = Q_NULLPTR   
)  

同QPixmap,一般只传入第一个参数,即图片路劲即可,剩下的一般默认即可  

### start
void QMovie::start()  

使动图开始播放,如果图片已经是播放状态,则该函数调用无效  
请注意,图片播放时QMovie对象必须必须存在  
播放一个停止的动图会从头开始重新播放

### stop
void QMovie::stop()  

使图片停下来,如果图片已经停止,则调用无效.

### setScaledSize
void QMovie::setScaledSize(const QSize &size)  

该函数使用QSize设置动图的大小

## QLabel  
### setScaledContents  
void setScaledContents(bool)  

该函数允许label控件放置图片时让图片填充整个label控件  
默认情况下调用时为false

## QT窗体常用函数  
[返回开头](#qt常用类以及方法)

### 去除任务栏  
this->setWindowFlags(windowFlags() | Qt::FramelessWindowHint);


### showMaximized()
void QWindow::showMaximized()  

只有顶级窗口可以使用,该函数使用后窗体最大化  
这种窗口对象一般是一开始就有的那个窗口的对象this

### showMinimized()  
void QWindow::showMinimized()  

只有顶级窗口可以使用,该函数使用后窗体最小化,并且在最下方工具栏中显示  
这种窗口对象一般是一开始就有的那个窗口的对象this

### showNormal()
void QWindow::showNormal()  

只有顶级窗口可以使用,还原窗口的默认尺寸  
这种窗口对象一般是一开始就有的那个窗口的对象this

## QDialog    
void QDialog::setModal(bool modal)  

设置窗口是否为模态

## QTableView  
[返回开头](#qt常用类以及方法)

### QHeaderView::sectionClicked  
[signal]void QHeaderView::sectionClicked(int logicalIndex)  

该函数是表头被点击时会触发的信号,并且参数是被点击的那行行数(从0开始)  
注意使用表格对象捕捉该信号时,请先用horizontalHeader来获得表头.

### setVerticalScrollBarPolicy  
void QAbstractScrollArea::setVerticalScrollBarPolicy(Qt::ScrollBarPolicy)  

该函数用来设置是否隐藏纵向滚动条,注意是隐藏而不是移除(QTableView默认情况下不隐藏)  
Qt::ScrollBarPolicy == Qt::ScrollBarAlwaysOn&emsp;&emsp;开启滚动条  
Qt::ScrollBarPolicy == Qt::ScrollBarAlwaysOff&emsp;&emsp;关闭滚动条  

### setHorizontalScrollBarPolicy  
void QAbstractScrollArea::setHorizontalScrollBarPolicy(Qt::ScrollBarPolicy)  

该函数用来设置是否隐藏横向滚动条,注意是隐藏而不是移除(QTableView默认情况下不隐藏)  
Qt::ScrollBarPolicy == Qt::ScrollBarAlwaysOn&emsp;&emsp;开启滚动条  
Qt::ScrollBarPolicy == Qt::ScrollBarAlwaysOff&emsp;&emsp;关闭滚动条 

### horizontalHeader  
QHeaderView *QTableView::horizontalHeader() const  

返回QTableViewz中的表头对象(即最上面的那一行)


### QHeaderView::setSectionResizeMode  
void QHeaderView::setSectionResizeMode(ResizeMode mode)  

设置表头约束布局    

mode == QHeaderView::Interactive == 0  
用户可以调整QHeaderView区域的大小。即表格一开始的默认情况,表格内容过少时放大整个表格会在窗体左上角靠紧,QHeaderView也可以用resizeSection函这样的编程的形式改变该大小

mode == QHeaderView::Stretch == 1   
QHeaderView将自动调整区域大小以填充可用空间。大小可以由用户更改。  
(该方式最常用,会默认将列表铺平Table所在区域)    

mode == QHeaderView::Fixed == 2   
用户无法调整QHeaderView区域的大小。除此之外同QHeaderView::Interactive  

mode == QHeaderView::ResizeToContents == 3  
QHeaderView将根据整个列或行的内容自动调整section的大小为其最佳大小。大小不能由用户或以编程方式更改。(该值在QT4.2中引入)。但是同QHeaderView::Interactive和QHeaderView::Fixed,表格内容过少时整个表格会在窗体左上角靠紧  

### setSortingEnabled  
void QTableView::setSortingEnabled(bool enable)  

该函数用来选择是否允许点击表头排序
true表示启用,false表示关闭  
奇数次点击默认是字典序降序排序  
偶数次点击默认是字典序升序排序    

### sortByColumn  
void QTableView::sortByColumn(int column, Qt::SortOrder order)  

该函数用来将某列进行排序(下标从0开始)  
order == Qt::AscendingOrder == 0   字典序降序  
order == Qt::DescendingOrder == 1  字典序升序  

### setModel  
使用model对象来设置显示的数据  
[virtual] void QTableView::setModel(QAbstractItemModel *model)   

该函数重新实现了QAbstractItemView的函数  
通常使用QStandardItemModel对象来设置要显示的数据  
注意model对象要是中途销毁了,table中之前通过model显示的数据将都会消失  
建议每次设置完数据后重新show()一下

### setEditTriggers  

void QAbstractItemView::setEditTriggers(EditTriggers triggers)

该函数用来设置是否允许编辑表中和内容

triggers == QAbstractItemView::NoEditTriggers == 0  
不允许用户编辑表中内容。 

triggers == QAbstractItemView::CurrentChanged == 1  
当前项发生改变时，就开始编辑。

triggers == QAbstractItemView::DoubleClicked == 2  
双击某项时开始编辑。

triggers == QAbstractItemView::SelectedClicked == 4  (默认)  
单击某项时开始编辑。

triggers == QAbstractItemView::EditKeyPressed == 8  
当在项目上按下平台编辑键时，编辑开始。  

triggers == QAbstractItemView::AnyKeyPressed == 16  
当在项目上按下任何键时，编辑开始。  

triggers == QAbstractItemView::AllEditTriggers == 31  
触发上面任何操作时,开始编辑  

### setSelectionBehavior  
void QAbstractItemView::setSelectionBehavior(  
&emsp;&emsp;&emsp;QAbstractItemView::SelectionBehavior behavior  
)  

该函数用来选择当每次选择是是选择一个格子还是一行还是一列  

behavior == QAbstractItemView::SelectItems == 0  (默认)
每次只选择某个格子

behavior == QAbstractItemView::SelectRows == 1  
每次选择也会全部选中该格子所在行

behavior == QAbstractItemView::SelectColumns == 2
每次选择也会全部选中该格子所在列  

### setShowGrid
void QTableView::setShowGrid(bool show)  

该函数用来设置表格中是否显示划分行与列的线(默认为true为显示)

## QStandardItemModel  
该类是项数据类,通常用于存储QTableView中显示的数据    

[返回开头](#qt常用类以及方法) 
### 构造函数  
QStandardItemModel::QStandardItemModel(QObject *parent = Q_NULLPTR)

通常将显示该对象中数据的表格作为其parent  

### setHorizontalHeaderLabels  
void QStandardItemModel::setHorizontalHeaderLabels(const QStringList &labels) 

该函式用来设置表头显示数据  
该表头数据用QStringList容器来存放,并且每列显示的数据下标对应QStringList中数据下标  


### setItem
void QStandardItemModel::setItem(int row, int column, QStandardItem *item)    

该函数通过QStandardItem对象来给对应行列的位置设置显示的数据  
该函数传入QStandardItem对象后,QStandardItemModel对象保证了其销毁时会销毁他存储的对象  
row为对应行数,columns为对应列数

### currentIndex
QModelIndex QAbstractItemView::currentIndex() const  

返回表格中被选中的那格的数据模型  
QModelIndex.row()                   //返回行  
QModelIndex.column()                //返回列

## QStandardItem  
该类和QStandardItemModel一起使用,用来存放表格中对应位置的数据，  
当然也适用于其他模型
[返回开头](#qt常用类以及方法)   

### 构造函数

QStandardItem::QStandardItem(const QString &text)  
该构造函数只用来构造一个存放要显示的字符QStandardItem  

### setHeaderData
[virtual] bool QAbstractItemModel::setHeaderData(  
int section,   
Qt::Orientation orientation,   
const QVariant &value,   
int role = Qt::EditRole  
)

该函数设置在QTableView中的行首和列首的字段名    

section：行号或列号

Qt::Orientation：  
Qt::Horizontal == 0x1   //设置列首
Qt::Vertical == 0x2     //设置行首

QVariant  
QVariant类用来充当最常见Qt数据类型的联合。  
这里可以直接使用字符串来来进行行首或列首文本的编辑。
例：

    /*设置列字段名*/
    model->setColumnCount(3);
    model->setHeaderData(0,Qt::Horizontal, "姓名");
    model->setHeaderData(1,Qt::Horizontal, "年龄");
    model->setHeaderData(2,Qt::Horizontal, "性别");
    
    /*设置行字段名*/
    model->setRowCount(3);
    model->setHeaderData(0,Qt::Vertical, "记录一");
    model->setHeaderData(1,Qt::Vertical, "记录二");
    model->setHeaderData(2,Qt::Vertical, "记录三"); 


在该类中使用 role一般默认即可,role为项数据角色,  
Qt::EditRole表示编辑角色


### removeRow
bool QAbstractItemModel::removeRow(  
int row,  
const QModelIndex &parent = QModelIndex()  
)  

该函数用来删除某一行数据(包括行首)。  
此处QModelIndex默认即可，此处不需要该对象。  
删除后返回true,否则返回false。

### removeRows
[virtual] bool QStringListModel::removeRows(  
int row,   
int count,   
const QModelIndex &parent = QModelIndex()  
)  

该函数用来删除从某一行开始的几行(包括行首) 。 
此处QModelIndex默认即可，此处不需要该对象。
删除后返回true,否则返回false。


### removeColumn
bool QAbstractItemModel::removeColumn(  
int column,   
const QModelIndex &parent = QModelIndex()  
)

该函数用来删除某列数据(包括行首)。  
此处QModelIndex默认即可，此处不需要该对象。
删除后返回true,否则返回false。


### removeColumns
[virtual] bool QAbstractItemModel::removeColumns(  
int column,  
int count,  
const QModelIndex &parent = QModelIndex()  
)

该函数用来删除从某一列开始的几列(包括行首) 。 
此处QModelIndex默认即可，此处不需要该对象。  
删除后返回true,否则返回false。




## 窗口的鼠标事件函数  
	void mouseMoveEvent(QMouseEvent *event);					//不可修改名字的的槽函数接口,鼠标移动事件(点击后拖动才算移动)
	void mouseReleaseEvent(QMouseEvent *event);				//不可修改名字的槽函数接口,鼠标松开事件
	void mousePressEvent(QMouseEvent *event);					//不可修改名字的槽函数接口,鼠标点击事件
	void mouseDoubleClickEvent(QMouseEvent* event);			//不可修改名字的槽函数接口,鼠标双击事件

### 鼠标移动到该器件上时变成其他形状
void setCursor(const QCursor &);  

    ui.Abutton->setCursor(QCursor(Qt::PointingHandCursor));   
    //到按钮上变为手形状

QCyrsor为鼠标形状对象。  

QCursor(Qt::PointingHandCursor)为手形。 

其余的形状详情请见enum Qt::CursorShape的值

## 设置控件或部件的属性
void QWidget::setAttribute(Qt::WidgetAttribute, bool on = true);  

该函数用来设置控件的某些只能为true或false的属性

详情属性请查看Qt::WidgetAttribute枚举变量

* Qt::WA_TransparentForMouseEvents == 51   

当设置为true时，此属性将禁止向小部件及其子部件传递鼠标事件。鼠标事件被传递给其他小部件，就好像小部件及其子部件不在小部件层次结构中一样;鼠标点击和其他事件有效地“穿过”它们(即该部件的鼠标消息将传送给其上层控件)。该属性在默认情况下是false的。

* Qt::WA_TranslucentBackground == 120

当设置为true时，整个控件除了其子空间外，都变为透明，而且该属性还会导致  
Qt::WA_NoSystemBackground被设置。  
该属性和setWindowFlags(Qt::FramelessWindowHint);一起使用时会导致窗体透明。  
setWindowFlags(Qt::FramelessWindowHint)表示生成一个无边界窗口。  
他们一起使用会使

setWindowFlags(Qt::FramelessWindowHint)+Qt::WA_NoSystemBackground  
相当于用户在(Windows下为全黑)(QT中的)透明背景下用自己重载的paintEvent绘制自己的背景

setWindowFlags(Qt::FramelessWindowHint)+Qt::WA_TranslucentBackground 
相当于用户在透明背景下用自己重载的paintEvent绘制自己的背景。  
该背景等同于windows系统上的桌面，你甚至可以在里面右键到桌面菜单。

#### 快捷复制 
setWindowFlags(Qt::FramelessWindowHint)
setAttribute(Qt::WA_TranslucentBackground)

* Qt::WA_NoSystemBackground == 9  

指示小部件没有背景，即当小部件接收到绘制事件时，背景不会自动重新绘制，而是需要用户自己重载的paintEvent函数，否则背景将自动设置为QT中的透明(Windows中为全黑)

## QScrollArea
[返回开头](#qt常用类以及方法)

## QFile  
[返回开头](#qt常用类以及方法)
### 构造函数
QFile::QFile(const QString &name)

该构造函数使用一个文件名来构造一个QT中的file对象  

###  QFileDevice::close
[override virtual] void QFileDevice::close()

重新实现从QIODevice: close()，用来关闭打开的文件。  

### open  
[override virtual] bool QFile::open(QIODevice::OpenMode mode)  

重新实现了QIODevice::open()。  
使用OpenMode模式打开文件，如果成功返回true;否则错误。  
在仅写或读写模式下，如果相关文件不存在，此函数将尝试在打开它之前创建一个新文件。    

该函数返回值由mode来相关确定  
true为打开成功，false为打开失败  

OpenMode的值:  

QIODevice::NotOpen == 0x0000  
文件未打开,可能该模式只是用来查看而不是拿来打开的  

QIODevice::ReadOnly == 0x0001  
只读打开  

QIODevice::WriteOnly == 0x0002  
只写打开，对于文件系统子类（例如QFile），此模式意味着QIODevice::Truncate，除非与ReadOnly，Append或NewOnly结合使用。

QIODevice::ReadWrite == QIODevice::ReadOnly | QIODevice::WriteOnly  
读写打开  

QIODevice::Append == 0x0004  
以追加模式打开，这样所有的数据都被写到文件的末尾。  

QIODevice::Truncate == 0x0008  
以重写的模式打开，之前的内容都将丢失。  

QIODevice::Text == 0x0010  
读取时，行结束符被翻译成'\n'。写入时，行尾结束符被转换为本地编码。  
例如Win32的'\r\n'。  

QIODevice::Unbuffered == 0x0020  
跳过缓冲区存放数据  

QIODevice::NewOnly == 0x0040  
如果要打开的文件已存在，则返回false。仅当文件不存在时才创建并打开该文件。操作系统保证您是唯一创建和打开文件的人。请注意，此模式打开文件后为WriteOnly，并允许将其与ReadWrite组合。此标志目前仅影响QFile。其他类可能在将来使用此标志，但在此之前将此标志与QFile以外的任何类一起使用可能会导致未定义的行为。（自Qt 5.11起）  

QIODevice::ExistingOnly == 0x0080  (暂时不用，一般也不会像他说的那样加)  
如果要打开的文件不存在则返回false。必须在ReadOnly，WriteOnly或ReadWrite旁边指定此标志。请注意，单独使用此标志与ReadOnly是多余的，因为当文件不存在时，ReadOnly已经失败。此标志目前仅影响QFile。其他类可能在将来使用此标志，但在此之前将此标志与QFile以外的任何类一起使用可能会导致未定义的行为。（自Qt 5.11起）

### setFileName
void QFile::setFileName(const QString &name)

空构造构造QFile对象时，设置将要打开的文件名。

### read
QByteArray QIODevice::read(qint64 maxSize)  

该函数用来读取数据.读取maxSize个字节，内部位置指针后移maxSize，  
并返回一个QByteArray对象存储这些数据。  

不会返回错误,返回空的QByteArray时表示没有数据可读。

### readAll
QByteArray QIODevice::readAll()  

读取file对象中的全部数据。

不会返回错误,返回空的QByteArray时表示没有数据可读。

### readLine  
QByteArray QIODevice::readLine(qint64 maxSize = 0)  

读取一行，但不超过maxSize字符，并以字节数组的形式返回结果。  

不会返回错误,返回空的QByteArray时表示没有数据可读。

### write
qint64 QIODevice::write(const QByteArray &byteArray)  

将byteArray的内容写入设备。返回实际写入的字节数，如果发生错误则返回-1。

qint64 QIODevice::write(const char *data)  

将以0结束的8位字符串的数据写入设备。返回实际写入的字节数，如果发生错误则返回-1。

### seek()  
[virtual] bool QFileDevice::seek(qint64 pos)  

重新实现了QIODevice:seek()  
对于随机访问设备，此函数将当前位置设置为pos，成功时返回true，发生错误时返回false。对于顺序设备，默认行为是什么都不做并返回false。
超出文件末尾查找:如果位置超出了文件末尾，则seek()不会立即扩展文件。如果在这个位置执行写操作，那么文件将被扩展。文件的前一个末尾和新写入的数据之间的文件内容是未定义的，并且在不同的平台和文件系统之间会有所不同。

### size
[virtual] qint64 QFile::size() const  

重新实现了QIODevice:size()   

对于开放的随机访问设备，这个函数返回设备的大小。对于打开的顺序设备，返回bytesAvailable()。  
如果设备是关闭的，返回的大小将不能反映设备的实际大小。  

### pos
[virtual] qint64 QIODevice::pos() const

对于随机访问设备，这个函数返回数据写入或读取的位置。对于顺序设备或闭合设备，如果没有“当前位置”的概念，则返回0。

### flush
bool QFileDevice::flush()  

将任何缓冲数据刷新到文件中。如果成功返回true;否则返回false。


---


## QByteArray  
[返回开头](#qt常用类以及方法)  
提供一个字节数组,QByteArray可用于存储原始字节（包括“\ 0” ）和传统的8位 “\ 0” 端接字符串 . 使用QByteArray比使用const char *更方便. 

### 构造函数
QByteArray::QByteArray(const char *data, int size = -1)  

构造一个字节数组，其中包含数组数据的第一个大小字节。  
如果data为0，则构造一个空字节数组。  
如果size为负数，则假定data指向一个以null结尾的字符串，其长度是动态确定的。  
束null字符不被认为是字节数组的一部分。  
QByteArray对字符串数据进行深度拷贝。

### at  
char QByteArray::at(int i) const  

返回位于字节数组下标i位置的字符。  
该方法比operator[]更快。它不会导致深层拷贝发生。  

### operator[]
QByteRef QByteArray::operator[](int i)  

同at  

## QStackedWidget
[返回开头](#qt常用类以及方法)   
QStackWidget中切换的界面的设计建议是在QtCreator中添加页面后并且提升该页面类然后用QtCreator编辑。 

QStackedWidget相当于只是一个用来存放QWidget的控件，其并不含基本QWidget功能。  
如果其内部不含有QWidget，他将无法放置控件。

###  widgetRemoved
[signal] void QStackedWidget::widgetRemoved(int index)  
每次移出部件时将发出该信号，该int为移出的widget在原来QStackedWidget中的索引。

### setCurrentWidget
[slot] void QStackedWidget::setCurrentWidget(QWidget *widget)  
在QStackedWidget页面中显示widget。该widget必须已经添加到了QStackedWidget。

### addWidget
int QStackedWidget::addWidget(QWidget *widget)  

该函数添加一个widget到QStackedWidget中，并且返回插入后在界面栈中的索引。  

### setCurrentIndex  
void QStackedWidget::setCurrentIndex(int index)  
该函数设置对应索引在QStackedWidget中的界面。  

### removeWidget
void QStackedWidget::removeWidget(QWidget *widget)  
该函数将对应widget从QStackedWidget中移出，但是并没有销毁widget对象。 


## QProgressBar
[返回开头](#qt常用类以及方法)  
该类用来展示一个进度条  

### setInvertedAppearance  
该函数设置进度条是否反方向加载  

### setMinimum  
该函数设置进度条的最小值(这个最好为0，max可以随便设置) 

### setMaximum  
该函数设置进度条的最大值
假设:  
setMaximum(50)  
setMinimum(0)
则  
setValue(5)时进度条加载10%;  

### Max和Min都最小  
进度条会变成繁忙进度条。

### setValue  
设置进度条当前百分比值(1-100)。

### setOrientation
该函数设置进度条水平还是竖直。  


## QT布局相关  
[返回开头](#qt常用类以及方法)  

QT布局使某个主控件中的子空间，按布局类型，根据自身的最大尺寸和最小尺寸自动调整自己在布局中的位置。  

QT的布局类类型是QLayout，由他衍生出了以下几个布局类型  

使用水平布局类QHBoxLayout；

使用垂直布局类QVBoxLayout；

使用网格布局类QGridLayout；

使用表格布局类QFormLayout。  


### 构造函数 

注意Layout本身并不能存放空间，如果其构造函数中传入某个窗口控件，则相当于是给该窗口设置布局。

    例：
    //给主窗口设置水平布局
    QHBoxLayout *qlayout = QHBoxLayout(myMainWindow);
    qlayout->addWidget(mylabel);
    qlayout->addWidget(myButton);


如果想要Layout只适用主窗口中某几个控件而并非只是给主窗口添加控件的话，你必须制定一个空的QWidget对象作为其子控件
    
    例：
    //只将几个控件绑定布局而不影响主窗口
    QWidget *LittleControlWidget=QWidget(MainWindow)
    QHBoxLayout *qlayout = QHBoxLayout(QWidget);
    qlayout->addWidget(mylabel);
    qlayout->addWidget(myButton);

如果用空的构造函数实例化他，则该布局A一定是用来添加到其他的布局B中的，此时该布局A不需要空的QWidget对象(相当于会使用布局B的QWidget内容)，这种情况请注意将给布局B指定QWidget对象。  
如果布局A和布局B的父窗口一致，添加后也会生成想要效果，否则该布局不会显示。

    例：
    //添加布局到一个布局
    QHBoxLayout *qlayoutMain = QHBoxLayout(myMainWindow);
    QHBoxLayout *qlayout = QHBoxLayout(); 
    //QHBoxLayout *qlayout = QHBoxLayout(myMainWindow); 也可以，但是其他窗口不可以
    qlayout->addWidget(mylabel);
    qlayout->addWidget(myButton);
    qlayoutMain->setLayout(qlayout);


如果两个布局指定了同一个窗口而且并不互相添加，则只会最后设置的布局生效。如果两个布局指定了同一个窗口，那么他们应该一个成为另外一个的子部件。  
当然，大部分时候都会引起混乱，一般也并不会这么做。

    例：
    QHBoxLayout* p2 = new QHBoxLayout(ui.centralWidget);
    QVBoxLayout* p3 = new QVBoxLayout(ui.centralWidget);
    p3->addWidget(ui.label,1);
    p3->addWidget(ui.pushButton,0);
    p3->addWidget(ui.label_2,0);
    p2->addWidget(ui.pushButton_2, 0);
    p2->addWidget(ui.pushButton_3, 1);
    //最后只有p2这个布局生效了，原有的p3被打破了。

#### 水平布局构造
QHBoxLayout::QHBoxLayout()  

QHBoxLayout::QHBoxLayout(QWidget *parent)


#### 垂直布局构造
QVBoxLayout::QVBoxLayout()

QVBoxLayout::QVBoxLayout(QWidget *parent)


#### 栅格化布局构造
QGridLayout::QGridLayout(QWidget *parent)

QGridLayout::QGridLayout()  

#### 表格布局构造  
QFormLayout::QFormLayout(QWidget *parent = nullptr)

表格布局没有空构造函数。

空构造相当于传入nullptr。
用法和上面几个相同。


### addWidget
添加一个控件到布局中，默认是添加到末尾  
水平方向为

#### QHBoxLayout和QVBoxLayout的addWidget函数  
void QBoxLayout::addWidget(QWidget *,   
 int stretch = 0,   
 Qt::Alignment alignment = Qt::Alignment()  
);

stretch为拉伸因子，即添加后在布局中所占的比例：  

    例：
        QHBoxLayout *qlayout = QHBoxLayout(); 
        qlayout->addWidget(mylabel,1);
        qlayout->addWidget(myButton,0);
        qlayout->addWidget(mylabel_2,0);
        //该布局中3个控件所占空间比例为 mylabel:myButton:mylabel_2=1:0:0
        //myButton和mylabel_2的水平大小将会被拉伸到最小值

alignment为对齐方式，默认是填充满自己负责的空间

QHBoxLayout添加顺序为从左到右

QVBoxLayout添加顺序为从上到下

#### QGridLayout和QFormLayout的addWidget函数

##### QGridLayout  
inline void QGridLayout::addWidget(QWidget *w) {  
QLayout::addWidget(w);  
}
调用QLayout的addWidget,默认是垂直布局从上到下。


void QGridLayout::addWidget(QWidget *,  
int row,  
int column,  
Qt::Alignment = Qt::Alignment() 
);

row  空间在栅格中的行数(设置大于1时行号从1开始，设置0时行号从0开始)
column 空间在栅格中的列数(设置大于1时列号从1开始，设置0时列号从0开始)

上面两个值的开始标号和另外一个不相干。可能一个从0开始，一个从1开始。
QtCreator中添加的两个标号默认都是从0开始。  
建议为了统一，都从0开始。

默认时，是从上往下的垂直布局，如果设置了列数，则下次默认添加控件时，除了固定设置的那个，其余的都从设置过列的最后位置，且都按设置过的最大列数的标准来从左到右，从上到下来设置。
    
    例：
    p->addWidget(ui.label,0,1);
    p->addWidget(ui.label_2);
    p->addWidget(ui.label_3);
    p->addWidget(ui.label_4);
    
    则排版为:
    空      label
    label_2 label_3
    label_4 空

设置的原本的行数或列数超过栅格布局原本的行数和列数时，只在原本行数或列数的最大值+1处设置。如果第一个子控件是这样设置，则从1，1开始。

    例：
    p->addWidget(ui.label,0,0);
    p->addWidget(ui.label_2，8，8);
    
    则排版为:
    label 空
    空    label_2

void QGridLayout::addWidget(QWidget *,  
int row,   
int column,  
int rowSpan,   
int columnSpan,  
Qt::Alignment = Qt::Alignment()  
);

rowSpan 设置在设置行之后所要占用的行数。为0时表示占用设置改行后面的所有行。  

columnSpan 设置在设置列之后所占据的列数。为0时表示占用设置改行后面的所有列。

如果要设置上面两个值应该默认为1。  

Alignment的意义同上。


#### QFormLayou //暂时没用到，可用QGridLayout代替

### 设置布局边距(所有布局都有该函数)  
void QLayout::setContentsMargins(int left, int top, int right, int bottom)  
设置布局周围使用的左、上、右和下边距。
默认情况下，QLayout使用样式提供的值。在大多数平台上，所有方向的边缘都是11像素。  

### 设置布局比例
#### QGridLayout和QFormLayout的setStretch函数
void QBoxLayout::setStretch(int index, int stretch)  
设置某一行，或某一列所占比例  
默认情况下，从上到下，从左到右，都是0:0:0:0:........

#### QGridLayout和QFormLayout的setRowStretch和setRowStretch
void QGridLayout::setRowStretch(int row, int stretch)  

设置某行比例(某行或某列在不设置时比例为0)  
从0行开始计数


void QGridLayout::setRowStretch(int row, int stretch)  

设置某列比例(某行或某列在不设置时比例为0)  
从0列开始计数


### 设置布局中，每个控件间的距离  
#### QGridLayout和QFormLayout的setSpacing
void QBoxLayout::setSpacing(int spacing)

设置布局中每个控件之间的距离，单位px；


### 设置布局边距  
所有布局都可以设置  
void QLayout::setContentsMargins(int left, int top, int right, int bottom)  
设置布局的上下左右边距。(单位px)  
某个值设置为-1时为系统默认设置。


## QT容器相关
[返回开头](#qt常用类以及方法)  
QT容器几乎相当于是在QT中的STL容器，相当于是把STL中的一些常用容器升级了，每种QT容器都支持将对应的STL容器中的数据转移过来(有对应构造函数)

### 所有容器通用部分

#### 迭代器

容器::Iterator 返回一般迭代器  
容器::ConstIterator //const迭代器，只能用来查找值，不能用来改变容器中的值

#### begin,end
同STL   容器都是左闭右开的  
begin函数 都是返回指向容器中第一个值的迭代器。  
end函数 都是返回返回指向容器中最后一个值的下一个的迭代器。

cbegin函数 都是返回指向容器中第一个值的const版的迭代器。  
cend函数 都是返回返回指向容器中最后一个值下一个的const版的迭代器。

#### 清理函数
void clear()

该函数清理容器中所有的值，注意每个容器再使用前请都使用下这个函数。

#### size函数
int size();

都返回容器中剩余元素的个数。

#### isEmpty函数
bool QLinkedList::isEmpty() const

判断容器是否为空



### 部分容器通用

所有的顺序容器以及set都支持<<重载(使用同QString)。  

除了QLinkedList，其他容器的迭代器都支持++和--重载。


QT容器有：  
### QList<T>	
这是目前使用最频繁的容器类，它存储了指定类型(T)的一串值，可以通过索引来获得。本质上QList是用数组实现的，从而保证基于索引的访问非常快。但是QList不能保证插入和删除的时间，他不适合用于一些大量插入和删除的场景。但是非常适合索引查找的场合。  

#### 添加元素

##### 向容器的末尾添加一个元素
void QList::append(const T &value)

##### 再容器头部添加一个元素
void QList::prepend(const T &value)

##### operator<<重载(同QString)
###### 将其他QList中的内容添加到末尾
QList<T> &QList::operator<<(const QList<T> &other)

###### 将元素添加到容器末尾
QList<T> &QList::operator<<(const T &value)

##### 在索引位置插入元素
void QList::insert(int i, const T &value)

#### 删除  

##### 删除容器从前往后的第一个指定的元素
bool QList::removeOne(const T &value)

##### 删除指定索引处元素  
void QList::removeAt(int i)


#### 替换

##### 将原来的某位置元素移动到指定位置
void QList::move(int from, int to)

##### 将某个索引处的值替换  
void QList::replace(int i, const T &value)

##### 返回一个子集，从pos索引位置开始连续的length(-1表示pos后全要)个元素
QList<T> QList::mid(int pos, int length = -1) const

##### 交换两个索引项的值
void QList::swap(int i, int j)

#### 查找元素

##### 查找是否含有某个元素
bool QList::contains(const T &value) const

##### 查找某个元素出现了几次  
int QList::count(const T &value) const  

##### 返回元素从前(初始位置可指定)向后的第一个索引  
int QList::indexOf(const T &value, int from = 0) const

##### operator[]重载  
T &QList::operator[](int i)

##### 获取容器中第一个元素的引用  
T &QList::first()

##### 获取容器中最后一个元素的引用
T &QList::back()

##### 返回容器中某个元素的const引用
const T &QList::at(int i) const


### QLinkedList<T>	
类似于QList，但它使用迭代器而不是整数索引来获得项。当在一个很大的list中间插入项时，它提供了更好的性能，并且它有更好的迭代器机制。取而代之的就是他不像QList那样，只适合一些数据插入和删除比较多的场景。  

### QVector<T>	
在内存中相邻的位置存储一组值，在开头或中间插入会非常慢，因为它会导致内存中很多项移动一个位置。但是其是一个动态扩容的数组，它保证了每次插入后都不会访问越界，QVector其具备了QList和QLinkedList的优点但是也只是具备了一部分。

#### 注意每次更新QVector后请重新获取迭代器

#### 添加元素

##### 向容器的末尾添加一个元素
void QVector::append(const T &value)

##### 再容器头部添加一个元素
void QVector::prepend(const T &value)

##### operator<<重载(同QString)
###### 将其他QList中的内容添加到末尾
QVector<T> &QVector::operator<<(const QVector<T> &other)

###### 将元素添加到容器末尾
QVector<T> &QVector::operator<<(const T &value)

##### 在索引位置插入元素
void QVector::insert(int i, const T &value)

#### 删除  

##### 删除容器从前往后的第一个指定的元素
bool QVector::removeOne(const T &value)

##### 删除指定索引处元素  
void QVector::removeAt(int i)


#### 替换

##### 将原来的某位置元素移动到指定位置
void QVector::move(int from, int to)

##### 将某个索引处的值替换  
void QVector::replace(int i, const T &value)

##### 返回一个子集，从pos索引位置开始连续的length(-1表示pos后全要)个元素
QVector<T> QVector::mid(int pos, int length = -1) const

##### 交换两个索引的值  
void QVector::swap(int i, int j)

#### 查找元素

##### 查找是否含有某个元素
bool QVector::contains(const T &value) const

##### 查找某个元素出现了几次  
int QVector::count(const T &value) const  

##### 返回元素从前(初始位置可指定)向后的第一个索引  
int QVector::indexOf(const T &value, int from = 0) const

##### operator[]重载  
T& QVector::operator[](int i)

##### 获取容器中第一个元素的引用  
T& QVector::first()

##### 获取容器中最后一个元素的引用
T& QVector::back()

##### 返回容器中某个元素的const引用
const T& QVector::at(int i) const

##### 容器返回底部指针(指向头)
T* QVector::data()

### QStack<T>	
QVector的一个子类，提供后进先出的机制，即栈。在当前的QVector中增加了几个方法：push()、pos()、top()。

### QQueue<T>	
QList的一个子类，提供了先进先出的机制，即队列。在当前的QList中增加了几个方法：enqueue()、dequeue()、head()。  

### QSet<T>	
单值的数学集合，能够快速查找，本质是一颗红黑树。非常适合需要大量查找的场合，但是其并不适合索引查找的场合，其只适合需要大量查找和少量修改的场合。  

### QMap<Key, T>	
提供了字典（关联数组）将类型Key的键对应类型T的值。通常一个键对应一个值，QMap以Key的顺序存储数据，如果顺序不重要，QHash是一个更快的选择，二叉树的升级版，按key来在红黑树中排列。  

QMap默认会对插入元素进行从小到大的排序。

#### 添加元素

##### 插入某个元素  
iterator QMap::insert(const Key &key, const T &value) 

如果已经有一个具有键key的项，则该项的值将被替换为value。  
如果有多个项具有键key，则最近插入的项的值将被替换为value。

##### operator[]重载
T &QMap::operator[](const Key &key)

    /*QMap<char,int>*/ map['s']=6;
    插入一个('s',6)到QMap中

#### 删除  

##### 删除键值为key的全部元素并且返回删除个数
int QMap::remove(const Key &key)


#### 替换


#### 查找元素

##### 查找容器中是否含有该key值  
bool QMap::contains(const Key &key) const

##### 返回容器中存在的对应key值的元素数
int QMap::count(const Key &key) const

##### 返回容器中第一个元素
T &QMap::first()

##### 查找某个元素并且返回他的迭代器
iterator QMap::find(const Key &key)

返回一个迭代器，该迭代器指向映射中键为key的项。  
如果映射中不包含键为key的项，则函数返回end()。  
如果map包含多个键key项，则该函数返回指向最近插入值的迭代器。

##### 返回value指定的key
const Key QMap::key(const T &value, const Key &defaultKey = Key()) const

返回第一个带有值value的键，如果映射不包含带有值value的项，则返回defaultKey。  
如果没有提供defaultKey，该函数将返回一个默认构造的key。

##### 返回QMap中最后一个元素的value
T &QMap::last()

##### 返回与value相关的所有key(升序列表)  
QList<Key> QMap::keys(const T &value) const

##### 返回与某个key相关的所有value(升序列表)
QList<T> QMap::values(const Key &key) const

##### 返回全部key的列表(升序)
QList<Key> QMap::keys() const

##### 返回全部value的列表(升序)  
QList<T> QMap::values() const


### QMultiMap<Key, T>	
QMap的子类，提供了多值的接口，一个键对应多个值。 ，允许存放多个一样的值 

### QHash<Key, T>
和QMap几乎有着相同的接口，但查找起来更快。QHash存储数据没有什么顺序。  

### QMultiHash<Key, T>	
QHash的子类，提供了多值的接口，允许存放相同而值。

## QProcess
[返回开头](#qt常用类以及方法)
### started
[signal] void QProcess::started()

进程成功启动时返回的信号 


### finished
[signal] void QProcess::finished(int exitCode, QProcess::ExitStatus exitStatus)

[signal] void QProcess::finished(int exitCode)

进程退出后发送的信号

* exitCode为退出码  

* QProcess::ExitStatus exitStatus为退出状态：  

QProcess::NormalExit == 0 正常退出
QProcess::CrashExit == 1 崩溃退出

在进程完成后，QProcess中的缓冲区仍然是完整的。您仍然可以读取进程在完成之前可能已经写入的任何数据。


### stateChanged
[signal] void QProcess::stateChanged(QProcess::ProcessState newState)

进程状态改变时发出的信号

* QProcess::ProcessState
QProcess::NotRunning == 0 进程未启动  

QProcess::Starting == 1 进程正在启动但是还未被调用  
QProcess::Running == 2 进程正在启动


### errorOccurred
[signal] void QProcess::errorOccurred(QProcess::ProcessError error)

进程发生错误时发送的信号

* QProcess::ProcessError  

QProcess: FailedToStart == 0  (常用)  
进程启动失败。处理步骤被调用的程序缺失，或者您没有足够的权限来调用该程序。  

QProcess:Crashed == 1 
进程在成功启动后崩溃了一段时间。

QProcess: Timedout == 2 
函数的最后一个waitFor…()超时。QProcess的状态没有改变，您可以再次尝试调用waitFor…()。  

QProcess: WriteError == 4  
试图写入进程时发生错误。例如，进程可能没有运行，或者它可能已经关闭了它的输入通道。  

QProcess: ReadError == 3  
试图从进程中读取时发生错误。例如，进程可能未运行。  

QProcess: UnknownError == 5  
发生了未知的错误。这是error()的默认返回值。


### 进程间交互相关信号  

[signal] void QProcess::readyReadStandardError()  
[signal] void QProcess::readyReadStandardOutput()


### kill()
[slot] void QProcess::kill()

不计后果的杀死进程。

### terminate
[slot] void QProcess::terminate()

试图终止进程，进程会保存之前的数据后正常退出。


### start
void QProcess::start(const QString &program, const QStringList &arguments, OpenMode mode = ReadWrite)

用来启动一个进程  

* program 进程的路径以及程序名

* arguments 命令行藏书  

* mode打开模式(详情见QIODevice)

注意,start只是用program启动进程的时候不可以使用快捷方式，和文件连接.

尽量使文件名中不能有中文以及空格。   
带有中文时需要转换成本地中文使用编码格式才能正常打开(QString为Unicode)。

带有空格的解决办法 路劲字符串使用" "括起来

    例:
    使用空格  
    m_Process.start("\"D:/notepad ++/notepad++.exe\"");
    
    使用中文  
    m_Process.start("D:/"+QString::fromLocal8Bit("中文目录")+"/notepad++.exe");


start启动后的进程与QProcess对象几乎绑定，QProcess对象销毁时，进程随之结束。
    
### 分步启动进程

* 设置进程要启动的程序

void QProcess::setProgram(const QString &program)

* 设置程序的启动参数

void QProcess::setArguments(const QStringList &arguments)

* 利用之前设置的参数启动进程  

void QProcess::start(OpenMode mode = ReadWrite)

### workingDirectory
QString QProcess::workingDirectory() const

返回进程工作目录

### setWorkingDirectory
void QProcess::setWorkingDirectory(const QString &dir)

设置要启动进程的工作目录

### startDetached
[static] bool QProcess::startDetached(  
const QString &program,  
const QStringList &arguments,  
const QString &workingDirectory = QString(),  
qint64 *pid = Q_NULLPTR  
)

在一个新进程中使用参数启动程序程序，并从它分离。成功回报真;否则返回false。  
如果调用进程退出，被分离的进程将继续不受影响地运行。  

参数处理与相应的start()重载相同。  

分离后的进程相当于是与QProcess对象以及父进程无关了，相当于你是不通过父进程重新启动了一个软件。


### error
QProcess::ProcessError QProcess::error() const

返回上次发生错误的类型  

详情见前面的[errorOccurred](#erroroccurred)

### state
QProcess::ProcessState QProcess::state() const

返回进程状态

详情见[stateChanged](#statechanged)


### waitForFinished
bool QProcess::waitForFinished(int msecs = 30000)

阻塞直到进程结束(发送了finished信号)，或超过毫秒数。



### waitForStarted
bool QProcess::waitForStarted(int msecs = 30000)

阻塞 直到进程成功启动(发送了started信号)，或超过毫秒数。

启动进程后请让父进程调用该函数来保证子进程初始化完毕。


## QT绘图事件
[返回开头](#qt常用类以及方法)


paintEvent(QPaintEvent*)函数是QWidget类中的虚函数，用于ui的绘制，会在多种情况下被其他函数自动调用，比如update()时。

### 运行时机：

一个重绘事件用来重绘一个部件的全部或者部分区域，下面几个原因的任意一个都会发生重绘事件：

（1）repaint()函数或者update()函数被调用；

（2）被隐藏的部件现在被重新显示；

（3）其他一些原因。


### QT绘图主要有三个对象来完成：

* 1.QPainter类

这个类主要提供在窗体或者其他绘图设备上进行绘图的功能，

在paintEvent(QPaintEvent*)中使用如下：QPainter painter(this);

此类中常用的函数有：

drawXXX()函数，用于绘制图形、文字和路径等；

fillXXX()函数，用于填充，可在指定区域内进行填充；

brush()和pen() 笔刷和钢笔的相关操作

* 2.QPainterPath类

这个类为绘图提供容器，主要还是用于描述绘制路径。

可以通过函数setFillRule(Qt::WindingFill);

来设置填充规则，通过addRect()函数来添加绘制区域。

该类主要是用来添加绘制范围。

* 3.QColor类

此类提供颜色支持，这里的颜色可以定义四个属性：
QColor ( int r, int g, int b, int a = 255 )，  
即红、绿、蓝和透明度。  
除此之外，也可以单个设置这四个值，通过类似setAlpha()的函数即可设置，这对设计渐进效果很有帮助。


## QPainterPath
该类主要用来提供绘图的路径供QPainter来绘制。  

当QPainterPath添加多个路径时，在下次用该QPainterPath绘图时，只会对最后一个路径生效。  


使用固定坐标就是固定绘图，但是如果使这些坐标和窗口大小来相加和减少或除法运算，等同于百分比尺寸绘图。


### setFillRule
void QPainterPath::setFillRule(Qt::FillRule fillRule)
设置填充时的规则

Qt::OddEvenFill (default)  
Qt::WindingFill //可以填充满


## 多边形路径  QPolygonf

* QPolygonF+QPoint+QPainterPath::closeSubpath

QPolygonf即是一个多边形类，同时也可以把他当作一个含有许多个坐标点的类。  
当QPolygonf被添加到QPainterPath后，并且QPainterPath::closeSubpath被调用后，将会根据添加的节点顺序来进行多边形的绘制。

### 构造函数
QPolygonF::QPolygonF(const QVector<QPointF> &points)

### QPainterPath::closeSubpath
void QPainterPath::closeSubpath()

该函数使被加入的QPolygonf路径的头坐标和尾坐标用线相连。  
虽然不调用时，只是缺少一条线条，并不影响多边形的绘制

### QPainterPath::addPolygon
void QPainterPath::addPolygon(const QPolygonF &polygon)

将多边形路径添加到QPainterPath中。


## 矩形路径

## QRectF

### 构造函数
QRectF::QRectF(qreal x, qreal y, qreal width, qreal height)

在坐标x,y构造一个大小为width*height的矩形路径。

### QPainterPath::addRect
void QPainterPath::addRect(const QRectF &rectangle)

添加矩形路径


## 椭圆路径

椭圆路径使用QRectF即可，椭圆的四个方向都会和矩形的边相切。

### QPainterPath::addEllipse
void QPainterPath::addEllipse(const QRectF &boundingRectangle)


## 文本路径

### QPainterPath::addText
void QPainterPath::addText(  
const QPointF & point,  
const QFont & font,   
const QString & text  
)

在QPointF的坐标处(视作文本框左下角处)，以QFont的设置显示text内容

# 更多图形请百度。

## 笔刷 QBrush
QBrush定义了QPainter的填充模式，具有样式、颜色、渐变以及纹理等属性。  

### setStyle
void QBrush::setStyle(Qt::BrushStyle style)

该函数设置了填充样式。具体的枚举效果参考如下：

[枚举值参考](https://www.cnblogs.com/Jace-Lee/p/5946342.html)


Qt::BrushStyle QBrush::style() const  
返回笔刷的填充样式。

### setColor
void QBrush::setColor(const QColor &color)

该函数设置笔刷的填充颜色。

*QColor的最常用构造 QColor::QColor(int r, int g, int b, int a = ...)

const QColor &QBrush::color() const  
返回笔刷的颜色。



## 画笔 QPen

画笔常用来画一些曲线或是直线，或是给绘制的图形加线条颜色。

### setWidth
void QPen::setWidth(int width)

用来设置画笔的宽度，当width=-1时，不显示画笔


### setStyle
void QPen::setStyle(Qt::PenStyle style)

用来设置画笔的样式

style=Qt::NoPen时，画笔隐形。

详情更多枚举值请看QT助手


## 绘图者 QPainter

### 设置笔刷
void QPainter::setBrush(const QBrush &brush)

### 设置画笔
void QPainter::setPen(const QPen &pen)

### drawPath
void QPainter::drawPath(const QPainterPath &path)

绘制区域图。

### 绘制线条
void QPainter::drawLine(int x1, int y1, int x2, int y2)

从(x1,x2)到(x2,y2)的线条

# 更多绘制请参考QT助手

## QSharedMemory
[返回开头](#qt常用类以及方法)

该类是QT中进程间通信的共享内存类。


### 构造函数  
QSharedMemory(const QString &key, QObject *parent = Q_NULLPTR)

QSharedMemory(QObject *parent = Q_NULLPTR)

* key：QT中共享内存的标识符，其他进程可以通过这个标识符来加入这块共享内存


### setKey
void QSharedMemory::(const QString &key)

设置共享内存标识

### key
QString QSharedMemory::key() const

返回该QSharedMemory对象设置的key。

### attach
bool QSharedMemory::attach(AccessMode mode = ReadWrite)

将调用进程添加进共享内存允许中。

* mode：  

QSharedMemory::ReadOnly == 0

QSharedMemory::ReadWrite == 1

### create
bool QSharedMemory::create(int size, AccessMode mode = ReadWrite)

创建一个size字节大小的共享内存并与设置的内存标识相关联。  
create必须在制定了内存标识后调用，否则读写共享内存指针会异常。


### data/constData
void *QSharedMemory::data()

返回指向共享内存的指针(该函数也有const重载)

const void *QSharedMemory::constData() const

返回const类型的指向共享内存的指针

### lock/unlock
bool QSharedMemory::lock()

某个进程对共享区域上锁，如果已经上锁将一直阻塞

bool QSharedMemory::unlock()

某个进程对共享区域解锁


### detach
bool QSharedMemory::detach()

使调用进程脱离共享内存，如果这是附加在共享内存段上的最后一个进程，那么这个共享内存段就会被系统释放，也就是说，里面的内容会被销毁。

如果返回false，并不是说该进程没有添加该共享内存，可能该共享内存此时被lock中。

### isAttached
bool QSharedMemory::isAttached() const

返回调用进程是否添加了该共享内存。

### size
int QSharedMemory::size() const

返回共享内存段大小。




## QDir
[返回开头](#qt常用类以及方法)

### dirName
QString QDir::dirName() const

获取QDir对象对应目录的目录名，改名字不带层层父目录。


### home
[static] QDir QDir::home()

获取当前用户的家目录下的目录对象

### entryInfoList
QFileInfoList QDir::entryInfoList(  
const QStringList &nameFilters,   
QDir::Filters filters = NoFilter,   
QDir::SortFlags sort = NoSort  
) const

返回一个QFileInfo List  
(存放QFileInfo的List容器，类名为QFileInfoList，拥有迭代器一般操作)

* nameFileters：通配文件列表，\*.cpp,\*.c等

* filters：筛选枚举

* sort：排序枚举


### setFilter
void QDir::setFilter(QDir::Filters filters)

设置筛选枚举。

### drives
[static] QFileInfoList QDir::drives()

获取系统的全部盘符路径。

如果是Linux等系统则只会返回一个'/'目录。

## QFileInfo
[返回开头](#qt常用类以及方法)

QFileInfo提供某个文件的非系统相关信息

### fileName
QString QFileInfo::fileName() const

获取文件名。


### path
QString QFileInfo::path() const

获取文件所在目录的绝对路径。

### isDir
bool QFileInfo::isDir() const

判断是否为目录

### isFile
bool QFileInfo::isFile() const

判断是否为普通文件 

### isSymLink
bool QFileInfo::isSymLink() const

判断是否为链接文件

# 更多的is判断文件类型或属性请查看QT手册


## 自定义MVC
MVC即是一种模型。

介绍如下：  
[Qt Model/View（模型/视图）结构](http://c.biancheng.net/view/1864.html)  
[Qt中的MVC （模型/视图结构）](https://blog.csdn.net/rl529014/article/details/52072380)

[model选择模式](https://blog.csdn.net/weixin_30677073/article/details/98154494)

## QModelIndex
改类定义了一个在模型中的索引  

### 空构造函数
QModelIndex::QModelIndex()

创建一个新的空模型索引。这种类型的模型索引用于表明该位置在模型中是无效的。

### internalPointer
void *QModelIndex::internalPointer() const

返回一个void *指针，该指针指向内部数据项关联起来。


### parent
QModelIndex QModelIndex::parent() const

返回模型索引的父对象，如果没有父对象，则返回空的QModelIndex。

### data
QVariant QModelIndex::data(int role = Qt::DisplayRole) const  

根据索引引用的项返回给定数据项的数据。

role：数据项的显示类型。  Qt::displayRole表示为以文本形式

(更多请见枚举类型 enum Qt::ItemDataRole)

每一个数据项都会存储非常多的不同类型数据，文字，还有文字的颜色、单元格的背景色、图标等等(QStandardItem里面就是如此)，默认情况下这戏类型由Qt::DisplayRole标记。  

这也表示了View通过代理向model索要数据时，不止一次，也导致了data会被调用不止一次。(就通过测试来讲，调用了28次(qt5.6.3_64))

### flags
Qt::ItemFlags QModelIndex::flags() const

返回索引所引用的项的标志。

### model
const QAbstractItemModel *QModelIndex::model() const

返回一个指向模型的指针，该模型包含该索引所引用的项。  
返回指向模型的const指针是因为对模型的非const函数的调用可能会使模型索引无效，并可能导致应用程序崩溃。

## 自定义model(重载QAbstractItemModel)

## QAbstractItemModel

### createIndex
[protected] QModelIndex QAbstractItemModel::createIndex(int row, int column, void *ptr = nullptr) const

根据所在的row和column和该节点对应的数据项来创建其在模型中的索引对象


*model结构特点  
[模型结构特点](http://c.biancheng.net/view/1864.html)

不管数据模型的表现形式是怎么样的，数据模型中存储数据的基本单元都是项（item）。  

每个项有一个行号、一个列号，还有一个父项。  

在列表和表格模式下，所有的项都有一个相同的顶层项。  

在树状结构中，行号、列号、父项稍微复杂一点，但是由这 3个参数完全可以定义一个项的位置，从而存取项的数据。



* 自定义model一般也就意味着要自定义数据项类型（当然你也可以使用QT自带的）。  


## 自定义model需要继承QAbstractItemModel,你必须重写一些函数：  

必须函数(这些函数在基类中为纯虚函数)：

### data
QVariant QAbstractItemModel::data(const QModelIndex& index, int role) const;
    
返回对应索引的Data，默认情况下返回QStandardItem中设置的text。
    
### index
QModelIndex QAbstractItemModel::index(
int row,   
int column,  
const QModelIndex& parent = QModelIndex()  
) const;	

//返回模型中对应行和列的索引
    
### parent   
QModelIndex QAbstractItemModel::parent(
const QModelIndex& index  
) const;

//返回某个索引的父节点
    
### rowCount
int QAbstractItemModel::rowCount(
const QModelIndex& parent = QModelIndex()  
) const;

返回该父节点下面的行数
    
### columnCount
int QAbstractItemModel::columnCount(
const QModelIndex& parent = QModelIndex()
) const;

返回给父节点的子节点的数据的列数。

* 这几个函数不仅保证了你的model正常功能，还保证了你的model加载到QT自带的View中可以随便使用，以及你的model放入QT的自带数据项也可以正常运作。但是这也只能保证你的数据可以显示在视图上而不能通过视图修改他们。

## 可选函数：

### flags
Qt::ItemFlags QAbstractItemModel::flags(const QModelIndex &index) const

用于获取对应索引关于模型提供的信息标志(行头，列头还是数据项)。
在许多模型中，标志的组合应该包括Qt::ItemIsEnabled和Qt::ItemIsSelectable，该值决定了模型中显示的空间(文本框，复选框还是)

实现该函数可以使模型被编辑

### headerData
QVariant QAbstractItemModel::headerData(  
int section, Qt::Orientation orientation,   
int role = Qt::DisplayRole  
) const

提供视图的标题中显示的信息。信息仅由能够显示头信息的视图检索。
    
### setData
bool QAbstractItemModel::setData(  
const QModelIndex &index,  
const QVariant &value, int role = Qt::EditRole  
)

将索引处项的角色数据设置为value。
如果成功返回true;否则返回false。
如果成功设置了数据，则应该发出datachanged()信号。
基类实现返回false。对于可编辑的模型，必须重新实现此函数和data()。


### setHeaderData
bool QAbstractItemModel::setHeaderData(int section, Qt::Orientation orientation, const QVariant &value, int role = Qt::EditRole)

用于修改水平和垂直标题信息。更改数据项之后，模型必须发出headerDataChanged()信号，以通知更改的其他组件。

### insertRows
bool QAbstractItemModel::insertRows(int row, int count, const QModelIndex &parent = QModelIndex())
    
注意:这个函数的基类实现什么也不做，返回false。  

在支持这一点的模型上，在给定行之前将count行插入到模型中。新行中的项将是父模型索引所表示项的子项。  

如果row为0，则将行添加到父节点中任何现有行的前面。 

如果row为rowCount()，则将行附加到父节点中任何现有行。 

如果父节点没有子节点，则插入一个包含计数行的单列。  

如果成功插入行，则返回true;否则返回false。  

如果您实现了自己的模型，那么如果您想支持插入，可以重新实现这个函数。或者，您可以提供自己的API来更改数据。在任何一种情况下，您都需要调用beginInsertRows()和endInsertRows()来通知其他组件模型已经更改。  

实现必须在将新行插入任何底层数据结构之前调用beginInsertRows()，然后立即调用endInsertRows()。


### removeColumns

注意:这个函数的基类实现什么也不做，返回false。

bool QAbstractItemModel::removeColumns(int column, int count, const QModelIndex &parent = QModelIndex())

用于从所有类型的模型中删除行及其包含的数据项。 

实现必须在从任何底层数据结构中删除行之前调用beginRemoveRows()，然后立即调用endRemoveRows()。

### insertColumns

注意:这个函数的基类实现什么也不做，返回false。

bool QAbstractItemModel::insertColumns(int column, int count, const QModelIndex &parent = QModelIndex())

用于向表模型和层次模型添加新的列和数据项。  

实现必须在将新列插入任何底层数据结构之前调用beginInsertColumns()，然后立即调用endInsertColumns()。
    
### removeColumns

注意:这个函数的基类实现什么也不做，返回false。

bool QAbstractItemModel::removeColumns(int column, int count, const QModelIndex &parent = QModelIndex())

用于从表模型和层次模型中删除列及其包含的数据项。

实现必须在从任何底层数据结构中删除列之前调用beginRemoveColumns()，然后立即调用endRemoveColumns()。

* 这几个函数虽然不是必须的，但是没有他们你不能对数据模型中的底层数据进行增删改查，同时你也无法使用QT自带View中一些基本的操作，可以说必须重写的函数是保证用户可以读模型中的数据，这些函数保证了用户可以通过视图写模型中的数据。

# 剩下的请查阅QT手册中QAbstractItemModel或百度

## 自定义代理
QAbstractItemDelegate 是所有代理类的抽象基类。  
而它的子类有QStyledItemDelegate 和 QItemDelegate。  
区别在于前者用的是当前的样式表来绘制组件。

* [例子1](https://www.cnblogs.com/lifexy/p/9186565.html)
* [例子2](https://blog.csdn.net/qq_42235172/article/details/98171777)

## 数据项编辑过程

* 1.视图首先会调用createEditor()函数生成编辑器。  

* 2.调用updateEditorGeometry()函数设置编辑器组件大小。  

* 3.调用setEditorData()函数,将模型里的数据提取到编辑器中。  

等待用户编辑... ...

* 4.当用户编辑完成后, 系统将会发送commitData信号函数。

* 5.然后调用setModelData()函数,设置模型数据,以及setEditorData()函数,更新编辑器。

* 6.视图最后发送closeEditor()信号函数,表示已关闭编辑器


## 相关信号函数
[signal] void QAbstractItemDelegate::closeEditor (   
QWidget * editor,     
QAbstractItemDelegate::EndEditHint hint = NoHint  
);

当用户关闭编辑器后，就会发出这个信号。


[signal] void QAbstractItemDelegate::commitData ( QWidget * editor ) ;

当完成编辑数据后,发送该信号,表示有新数据提交到模型中

## 需要重写的函数  
(从QAbstractItemDelegate两个子类继承，非纯虚函数)

### createEditor
[virtual] QWidget *QAbstractItemDelegate::createEditor(  
QWidget *parent,  
const QStyleOptionViewItem &option,  
const QModelIndex &index  
) const

返回用于编辑具有给定索引的数据项的编辑器。该控件会在视图中编辑数据项时显示出来。

返回的编辑器小部件应该有Qt::StrongFocus;  
否则，小部件接收到的QMouseEvents将传播到视图。  
除非编辑器绘制自己的背景(例如，使用setAutoFillBackground())，否则视图的背景将会亮起。

* parent：该编辑器控件应该选择的的父控件。

* option：用于控制item的显示使用的，包含了该数据项的具体信息。(比如:数据项窗口大小,字体格式,对齐方式,图标位于字体的哪个位置等)。

* index：被点击的Item项的索引。

### setEditorData
[virtual] void QAbstractItemDelegate::setEditorData(  
QWidget *editor,  
const QModelIndex &index  
) const  

通过索引值,将模型中对应数据点的数据对应设置到编辑器显示


### setModelData
[virtual] void QAbstractItemDelegate::setModelData(  
QWidget *editor,  
QAbstractItemModel *model,  
const QModelIndex &index  
) const

通过索引值, 将editor 的数据更新到model中。

### updateEditorGeometry
[virtual] void QAbstractItemDelegate::updateEditorGeometry(  
QWidget *editor,  
const QStyleOptionViewItem &option,  
const QModelIndex &index  
) const

* editor：显示的数据项控件

* option：包含了对应数据项的具体信息，用于将该editor设置为适应Item的大小或布局或设置等。

* index：对应位置的索引

该函数保证了editor显示的位置及大小。

根据在选项中指定的矩形，使用给定的索引更新项的编辑器的几何形状。  
如果条目有内部布局，编辑器将相应地布局。  
请注意，索引包含关于正在使用的模型的信息。  
基本实现什么也不做。如果需要自定义编辑，则必须重新实现此函数。

## 从QAbstractItemDelegate直接继承必须重写的函数
当然，你可以继承他的两个子类来重新实现来达到你想要的效果。

### paint
[pure virtual] void QAbstractItemDelegate::paint(  
QPainter *painter,  
const QStyleOptionViewItem &option,  
const QModelIndex &index  
) const

* painter：视图提供的painter绘制类。

* option：包含了对应的Item的具体信息(比如:数据项窗口大小,字体格式,对齐方式,图标位于字体的哪个位置等)。

* index：对应数据项的索引。


paint函数的作用是绘制要在view中数据的UI显示。

paint不同于data函数，paint只会每次针对于一个数据项，调用一次。

而data函数会针对于数据项中的每个选项调用一次。

### sizeHint
[pure virtual] QSize QAbstractItemDelegate::sizeHint(  
const QStyleOptionViewItem &option,  
const QModelIndex &index  
) const

* option：包含了对应的Item的具体信息(比如:数据项窗口大小,字体格式,对齐方式,图标位于字体的哪个位置等)。

* index：对应数据项的索引。

该函数用于设置Item的窗口大小。


## QSharedPointer

QSharedPointer等同于C++中的shared_ptr


## QScopedPointer

QScopedPointer等同于C++中的unique_ptr


## QWeakPointer

QWeakPointer等同于C++中的weak_ptr，用于处理互相指向时QSharedPointer会出现的问题

## QPointer

QPointer是QT中父对象销毁会导致子对象销毁的原理基础，其指向的对象被销毁时，其会自己设置为nullptr



## QT事件机制

[非常好的QT事件机制介绍](https://www.jianshu.com/p/48f007c2de09)

### event函数
[virtual] bool QObject::event(QEvent *e)

* e：被包装成QEvent的发生的事件

event函数可以用来过滤和处理对应的事件(把事件分类分发给各种????Event函数)，该函数会接受所有的事件并集中处理。

但是过滤完和处理完对应事件后，一定要调用父类的event函数来让父类进行对应处理。否则从某些本来有的事件功能不能触发。  
因为这样的机制，也导致了QT子类触发了某个事件后，如果子类不处理，会发送给父类处理。  

返回true表示事件已处理或已转发给其他的????Event函数，false表示分发事件或处理事件异常，对于不知道的事件，转发给父类event函数处理。


### ????Event函数

这些函数都是经过event函数后分配了对应事件的函数(专门处理鼠标事件，专门处理键盘事件等)


### 事件过滤机制

### eventFilter
virtual bool QObject::eventFilter ( QObject * watched, QEvent * event );

该函数可以过滤自己不感兴趣的事件。  
对于不感兴趣的事件，可以返回true。  
对于感兴趣的事件，可以返回false。
对于不知道如何处理的事件，转交给父类的该函数处理。


* watched：触发该事件的控件。

* event：触发的事件

经过测试是先调用eventFilter再调用event的。也就是说event和eventFilter的使用是互相影响的，eventFilter也可以屏蔽传给event函数的事件。

### installEventFilter
void QObject::installEventFilter(QObject *filterObj)

启动指定对象的事件过滤器(即启动使用eventFilter函数过滤)


### *QApplication或者QCoreApplication对象添加事件过滤器。这种全局的事件过滤器将会在所有其它特性对象的事件过滤器之前调用。这种行为会严重降低整个应用程序的事件分发效率，要看具体情况使用。详情请搜索一下两个函数。

* CoreApplication::instance()函数 
* QCoreApplication::notify()函数



## QEvent
QEvent是所有事件类的基类，其也提供了自定义类型


QEvent类可以说只包含一个事件类型的成员和一个"accept"标志。

### 构造函数
QEvent::QEvent(Type type)

*type：为一个枚举类型，每个都代表一系列事件(比如鼠标系列，键盘系列)，或是每个都代表一个具体事件(包括registerEventType返回的自定义事件)

### type
Type QEvent::type() const

返回该事件的对应系列名枚举或是某种事件对应的枚举

### registerEventType
[static] int QEvent::registerEventType(int hint = -1)

使用默认参数时获取一个未使用的事件中的Type类型的枚举值。  
值在 QEvent::User and QEvent::MaxUser之间。  
一般使用默认的-1即可，虽然可以使用hint指定自己想要的枚举值。

如果已获取所有可用值或程序正在关闭，则返回-1。

自定义事件实例：[实例地址](https://blog.csdn.net/Amnes1a/article/details/64906910)
    
    
    const QEvent::Type MyType = (QEvent::Type)QEvent::registerEventType();
    class MyEvent : public QEvent
    {
    public:
        MyEvent(QEvent::Type type, QString param) : QEvent(type)
        {
            this->param = param;
        }
        QString param;
    };


​        
​    void Widget::on_pushButton_clicked()    //按钮按下发送事件
​    {
​        MyEvent e(MyType, "自定义事件");
​        QApplication::sendEvent(this, &e);
​    }
​    
    bool Widget::event(QEvent *event)
    {
        if(event->type() == MyType)
        {
            MyEvent *e = static_cast<MyEvent*>(event);
            QMessageBox::information(this, "MyEvent", e->param);
            return true;
        }
        return QWidget::event(event);
    }

### spontaneous
bool QEvent::spontaneous() const

该函数用来判断发生的事件是否为系统事件(系统定时器软中断等)。  

此函数不支判断绘制事件。


### 事件发送函数  
### sendEvent
[static] bool QCoreApplication::sendEvent(QObject *receiver, QEvent *event)

* receiver：接受对象。

* event：发送的事件。


该函数为静态函数，支持堆上对象和栈上对象的传递。  

sendEvent发送后会立刻调用event函数(不需要在事件队列中排序)。

new分配的事件对象被处理后,会由Qt内部自动摧毁。

该函数为阻塞式，返回值为该事件的处理结果(保险起见，可以判断后再手动delete一下)。

### postEvent
[static] void QCoreApplication::postEvent(  
QObject *receiver,  
QEvent *event,  
int priority = Qt::NormalEventPriority  
)

* receiver：接受对象。

* event：发送的事件。

* priority：事件优先级，默认为正常优先级。

该函数只把事件通过优先级放入事件队列。

该函数是非阻塞的，而且event必须在堆上分配才行，不同于sendEvent。

### accept
void QEvent::accept()

设置QEvent类的accpet标志为已被接受处理。

设置表明该事件已被接受，再传递给父控件的event等事件处理函数时，该事件不会被处理。

### ignore
void QEvent::ignore()

设置QEvent类的accpet标志为已被未被接受处理。

设置表明该事件已被接受，再传递给父控件的event等事件处理函数时，该事件不会被处理。


### isAccepted
bool QEvent::isAccepted() const

该函数根据QEvent对象的accept标志返回该事件是否想被处理。

返回true表示该事件想要被接受处理，而不会在被传递后被忽视。

返回false表示事件不想被处理，就算传递到父控件也会被忽视。

### setAccepted
void QEvent::setAccepted(bool accepted)

该函数设置该事件的accept标志来表示该事件是否想被处理。

设置true表示该事件想要被接受处理，而不会在被传递后被忽视。

设置false表示事件不想被处理，就算传递到父控件也会被忽视。



## QFontMetrics
该类可以根据label中的字体类型与大小用来测量改字体在显示时所占用的像素的宽高。(当然，不一定局限于label中字体，QT中所有能显示字体的地方都可以)，然后根据像素大小调整文本位置。
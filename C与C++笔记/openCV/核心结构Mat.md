## cv::Mat

Mat结构为cv中的一个class(虽然我觉得他更适合作为struct)，它是作为图像矩阵载体的数据结构。

* 该类型结构仅适用于Mat中，相当于一个枚举值

## opcnCV中定义的矩阵中数值的类型

![](./图片/Mat矩阵类型值对应图.jpeg)

CN表示通道数，比如rgb32的数据类型需要使用C4(rgba四个通道)

U表unsigned整形

S表signed整形

F表float

* 图中右下角表示枚举(参数)值

## Mat中常用成员变量与函数

#### 成员变量

| 成员名 | <span style="display:inline-block;width: 160px">类型(或返回类型)</span> | 介绍                       |
| ------ | ------------------------------------------------------------ | -------------------------- |
| data   | uchar*                                                       | 存放矩阵数据的指针，为一维 |
| dims   | int                                                          | 矩阵的维度                 |
| rows   | int                                                          | 矩阵的行数                 |
| cols   | int                                                          | 矩阵的列数                 |

#### 成员函数

> 简单函数

| <span style="display:inline-block;width: 160px">成员名</span> | <span style="display:inline-block;width: 70px">返回类型</span> | 介绍                                                         |
| ------------------------------------------------------------ | :----------------------------------------------------------: | ------------------------------------------------------------ |
| total()                                                      |                            size_t                            | 矩阵中元素个数                                               |
| channels()                                                   |                             int                              | 图片每个像素数据的通道数                                     |
| depth()                                                      |                             int                              | 用来度量每一个像素中每一个通道的精度，但它本身与图像的通道数无关Mat.depth()得到的是一个0~6的数字，分别代表不同的位数enum{CV_8U=0,CV_8S=1,CV_16U=2,CV_16S=3,CV_32S=4,CV_32F=5,CV_64F=6} |
| elemSize()                                                   |                            size_t                            | 矩阵中一个像素的大小(以8bit为单位)，比如rgb24的矩阵导入后该函数返回3 |
| elemSize1()                                                  |                            size_t                            | 矩阵中一个像素每个通道的大小，相当于返回 elemSize/channels   |
| step=step[0]                                                 |                            size_t                            | 矩阵第一行元素的总字节数                                     |
| step[1]                                                      |                            size_t                            | 矩阵中一个元素的字节数                                       |
| step1()=step1(0)                                             |                            size_t                            | 矩阵中一行有几个通道数                                       |
| step1(1)                                                     |                            size_t                            | 一个元素有几个通道数(channel())                              |
| type()                                                       |                             int                              | mat的类型对应值如下表                                        |
| at<typename T>(i,j)                                          |                              T&                              | 返回第i行第j列的数据的引用，并将该引用类型转换成T            |
| (static) eye(row,col,type)                                   |                             Mat                              | 返回一个单位矩阵，如果row!=col 则将会在(1,1) (2,2) ... (n,n) 位置数据置为1 |
| (static) ones(row,col,type)                                  |                             Mat                              | 全1矩阵                                                      |
| (static) zeros(row,col,type)                                 |                             Mat                              | 全0矩阵                                                      |
| (static) diag(const cv::Mat&)                                |                             Mat                              | 构建对角矩阵 输入的矩阵必须是一纬的，其一维中的数据用来创建对角阵 |

* type()返回值对应的类型见上面矩阵中数值的数据类型

> 复杂函数

`内部数据类型转换`

```c++
void convertTo( OutputArray m, int rtype, double alpha=1, double beta=0 ) const;
```

* m：输出的数据
* type：目标类型
* alpha：转换过程中的缩放因子
* beta：转换过程中的偏置因子

```c++
设缩放因子为 a
设偏置因子为 b

转换公式：
					m(x,y) = static_cast<type>(a * origin(x,y) + b )
```

## Mat常用构造函数

> 空构造

```C++
Mat::Mat()
```

> 创建行数为 rows，列数为 col，每个成员类型为 type 的矩阵。

```c++
Mat::Mat(int rows, int cols, int type)
```

* type为上述CV_8UC1或CV_8U(1)这种
* 该函数不对Mat中的值进行初始化

`实例`

```C++
cv::Mat imageData(1920,1080,CV_8UC3)
```

> 创建行数为 rows，列数为 col，每个成员类型为 type 的矩阵。并且给予初始化

```c++
Mat::Mat(int rows,int cols,int type,const Scalar& s)
```

* s为一个像素值变量。
* Scalar为一个模板类型，其可以蕴含用户创建矩阵所需的所有数值类型。

`实例`

```c++
cv::Mat imageData(1920,1080,CV_8UC3,cv::Scalar(255,0,0));			//创建一个每个点位数值都是三通道且为值为255、0、0的矩阵
cv::Mat imageData2(1920,1080,CV_8UC2,cv::Scalar(255,0));			//创建一个每个点位数值都是二通道且值为255、0的矩阵
cv::Mat imageData3(1920,1090,CV_32FC3,cv::Scalar(1.1,1.2,1.3)); //创建一个每个点位数值都是三通道且值为1.1、1.2、1.3的矩阵
```

> 截取数据创建

```c++
Mat::Mat(const Mat& m, const Range& rowRange, const Range& colRange=Range::all());
```

* colRange参数可以不填，表示使用所有列
* Range为一个简单的表示一维数据中范围的类

`实例`

```c++
cv::Mat a(1920,1080,CV_8UC3);
cv::Mat b = cv::Mat(a,cv::Range(100,200),cv::Range(100,200));			//截取3纬矩阵第100行-200行中第100列-第200列的数据
```


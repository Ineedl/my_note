[toc]

## 渲染过程

### 图形管线 

在OpenGL中，任何事物都在3D空间中，但屏幕和窗口却是2D像素数组，这导致OpenGL的大部分工作都是关于把3D坐标转变为适应你屏幕的2D像素。

3D坐标转为2D坐标的处理过程是由OpenGL的图形**渲染管线（Graphics Pipeline，大多译为管线，实际上指的是一堆原始图形数据途经一个输送管道，期间经过各种变化处理最终出现在屏幕的过程）**管理的。

图形渲染管线可以被划分为两个主要部分：

​	1：把你的3D坐标转换为2D坐标

​	2：把2D坐标转变为实际的有颜色的像素。

### 渲染过程

图形渲染管线接受一组3D坐标，然后把它们转变为你屏幕上的有色2D像素输出。

图形渲染管线可以被划分为几个阶段，每个阶段将会把前一个阶段的输出作为输入。所有这些阶段都是高度专门化的（它们都有一个特定的函数），并且很容易并行执行。

由于具有并行执行的特性，当今大多数显卡都有成千上万的小处理核心，它们在GPU上为每一个（渲染管线）阶段运行各自的小程序，从而在图形渲染管线中快速处理你的数据。这些小程序叫做着色器(Shader)。

有些着色器可以由开发者配置，因为允许用自己写的着色器来代替默认的，所以能够更细致地控制图形渲染管线中的特定部分了。因为它们运行在GPU上，所以节省了宝贵的CPU时间。

* OpenGL着色器是用OpenGL着色器语言(OpenGL Shading Language, GLSL)写成的。


* 在现代OpenGL中，如果想要渲染一个简单图像，必须定义至少一个顶点着色器和一个片段着色器（因为GPU中没有默认的顶点/片段着色器）。

`渲染各个阶段的抽象展示`

![](https://note.youdao.com/yws/api/personal/file/WEB3fb2aae0e4710964575187b3384d2a0a?method=download&shareKey=094176f244b3c85c6dec5741b2fc796d)

#### 顶点着色器

换算输入顶点的坐标到二维坐标系中

#### 图元装配

将所有的点装配成用户指定图元的形状

#### 几何着色器

把图元形式的一系列顶点的集合作为输入，它可以通过产生新顶点构造出新的（或是其它的）图元来生成其他形状。例子中，它生成了另一个三角形。

#### 光栅化

几何着色器的输出会被传入光栅化阶段(Rasterization Stage)，这里它会把图元映射为最终屏幕上相应的像素，生成供片段着色器(Fragment Shader)使用的片段(Fragment)。在片段着色器运行之前会执行裁切(Clipping)。裁切会丢弃超出你的视图以外的所有像素，用来提升执行效率。

* OpenGL中的一个片段是OpenGL渲染一个像素所需的所有数据

#### 片段着色器

计算一个像素的最终颜色，这也是所有OpenGL高级效果产生的地方。通常，片段着色器包含3D场景的数据（比如光照、阴影、光的颜色等等），这些数据可以被用来计算最终像素的颜色。

#### 测试与混合

Alpha测试和混合(Blending)阶段。这个阶段检测片段的对应的深度（和模板(Stencil)）值，用它们来判断这个像素是其它物体的前面还是后面，决定是否应该丢弃。这个阶段也会检查alpha值（alpha值定义了一个物体的透明度）并对物体进行混合(Blend)。


## openGL的坐标系
openGL在其应用中的坐标系为[-1,-1] 到 [1,1]的矩形，可以说其中点的坐标都是百分比值。

## VBO
顶点缓冲对象：Vertex Buffer Object，VBO

定义顶点数据以后，将会把它作为输入发送给图形渲染管线的第一个处理阶段：顶点着色器。

它会在GPU上创建内存用于储存我们的顶点数据，还要配置OpenGL如何解释这些内存，并且指定其如何发送给显卡。
顶点着色器接着会处理我们在内存中指定数量的顶点。
可以通过VBO来管理这个内存，它会在GPU内存（通常被称为显存）中储存大量顶点。

使用这些缓冲对象的好处是我们可以一次性的发送一大批数据到显卡上，而不是每个顶点发送一次。

从CPU把数据发送到显卡相对较慢，所以只要可能我们都要尝试尽量一次性发送尽可能多的数据。
当数据发送至显卡的内存中后，顶点着色器几乎能立即访问顶点，这是个非常快的过程。

* 指定版本后 使用VBO绘图会导致失效 这可能和glfw默认选择的版本和vbo的遗留问题有关

```c
glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
```

* OpenGL的核心模式**要求**我们使用VAO，所以它知道该如何处理我们的顶点输入。如果我们绑定VAO失败，OpenGL会拒绝绘制任何东西。

## VAO

顶点数组对象：Vertex Array Object，VAO

VAO可以存储一个顶点数组对象以及对他们的操作过程。

当配置顶点属性指针时，只需要先绑定一个VAO，然后再将那些调用执行一次，绑定一个VAO之后的刚刚设置的所有状态将会存储在该VAO中，直到下一个VAO被绑定，之后再绘制物体的时候只需要绑定相应的VAO就行了。这使在不同顶点数据和属性配置之间切换变得非常简单，只需要绑定不同的VAO就行了。

一个顶点数组对象会储存以下这些内容：

- glEnableVertexAttribArray和glDisableVertexAttribArray的调用。
- 通过glVertexAttribPointer设置的顶点属性配置。
- 通过`glVertexAttribPointer`调用进行的顶点缓冲对象与顶点属性链接。

## EBO
元素缓冲对象：Element Buffer Object，EBO 或 索引缓冲对象 Index Buffer Object，
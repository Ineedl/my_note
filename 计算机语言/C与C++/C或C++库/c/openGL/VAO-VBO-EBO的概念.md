[toc]

## openGL的坐标系

openGL在其应用中的坐标系为[-1,-1] 到 [1,1]的矩形，可以说其中点的坐标都是百分比值。

## GLAD

此处使用接口都属于GLAD

## VBO(顶点缓冲对象：Vertex Buffer Object)

可以通过VBO用来管理GPU中的内存，使用它可以GPU内存（通常被称为显存）中储存大量顶点。

* 使用这些缓冲对象的好处是我们可以一次性的发送一大批数据到显卡上，而不是每个顶点发送一次。

* 从CPU把数据发送到显卡相对较慢，所以只要可能我们都要尝试尽量一次性发送尽可能多的数据。
  当数据发送至显卡的内存中后，顶点着色器几乎能立即访问顶点，这是个非常快的过程。

* 指定版本后 使用VBO绘图会导致失效 这可能和glfw默认选择的版本和vbo的遗留问题有关

```c
glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
```

* OpenGL的核心模式**要求**我们使用VAO，所以它知道该如何处理我们的顶点输入。如果我们绑定VAO失败，OpenGL会拒绝绘制任何东西。

### API

#### 分配VBO

```c
void glGenBuffers(GLsizei n, GLuint *buffers);

//示例
GLuint vbo;
glGenBuffers(1, &vbo);
```

* n：生成多少个VBO
* buffers：存储VBO索引的对象

#### 绑定显存缓冲区对象到VBO

```c
void glBindBuffer(GLenum target, GLuint *buffer);

//示例
glBindBuffer(GL_ARRAY_BUFFER, vbo);

//设置为0 或者下一个VBO的索引，可以解绑当前VBO或者切换至下一个VBO来进行设置
glBindBuffer(GL_ARRAY_BUFFER, 0);
```

* target：GL_ARRAY_BUFFER表示显存缓冲区对象为VBO
* buffer：vbo索引对象，为0时解绑当前VBO

#### 分配显存并通过VBO传递数据

```c 
void glBufferData(GLenum target, GLsizeiptr size, const void *data, GLenum usage);

//示例
glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
```

* target：分配的缓存缓冲区对象类型，GL_ARRAY_BUFFER表示显存缓冲区对象为VBO

* size：分配的显存大小

* data：传入的数据，并不检查类型，**它只按字节大小 `size` 把内存复制到 GPU 显存**。

* usage：

  | 取值              | 意义                                                         |
  | ----------------- | ------------------------------------------------------------ |
  | `GL_STATIC_DRAW`  | 数据只设置一次，之后多次绘制使用。适合不经常修改的数据。     |
  | `GL_DYNAMIC_DRAW` | 数据会被频繁修改，多次绘制。适合频繁更新的顶点数据。         |
  | `GL_STREAM_DRAW`  | 数据每帧几乎都会更新，只用一次绘制。适合极高频率更新的数据。 |

#### 解释当前绑定VBO中的顶点数据

```c
void glVertexAttribPointer(
    GLuint index,         
    GLint size,           
    GLenum type,          
    GLboolean normalized, 
    GLsizei stride,       
    const void *pointer 
);

//示例
glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 4 * sizeof(float), (void*)(2 * sizeof(float)));
```

* index：对应顶点着色器location

  ```
  layout(location = <index>) in 
  ```

  中的index

* size：坐标的空间数，二维坐标为2

* type：传入坐标数据的数据类型

  * GL_FLOAT表示每个坐标的数据类型都为float

* normalized：是否将传入数据强转为float类型

* stride：每个顶点数据的总大小，比如一个float的二维坐标，大小为sizeof(float)*2

* pointer：当前属性在每个顶点数据块中的偏移。

  * 指定type和size后，会把VBO的数据按照stride划分，而pointer指定的就是，每个stride块中的偏移量。

    ```c
    比如stride为
    sizeof(float)*4
    如果指定pointer为 (void*)(2 * sizeof(float))
    那么只会把每块 四个坐标数据中的后两个传递给对应顶点着色器中的位置
    ```

#### 启用顶点数据传递

开启到顶点着色器数据的传递

```c
void glEnableVertexAttribArray(GLuint index);
```

* index：和 `glVertexAttribPointer` 第一个参数相同，通常对应 `layout(location = N)`。

#### 关闭顶点数据传递

关闭到顶点着色器数据的传递

```c
void glDisableVertexAttribArray(GLuint index);
```

* index：和 `glVertexAttribPointer` 第一个参数相同，通常对应 `layout(location = N)`。

#### 释放VBO

```c
void glDeleteBuffers(GLsizei n, const GLuint *buffers);
```

* n：要删除的缓冲对象数量（如 VBO）

* buffers：指向要删除的缓冲对象名称（ID）数组的指针

## VAO(顶点数组对象：Vertex Array Object)

VAO记录了与顶点属性相关的配置信息，从而简化顶点数据的设置流程

当配置顶点属性指针时，只需要先绑定一个VAO，然后再将那些调用执行一次，刚刚设置的所有状态将会存储在该VAO中，直到下一个VAO被绑定，之后再绘制物体的时候只需要绑定相应的VAO就行了。

* 这使在不同顶点数据和属性配置之间切换变得非常简单，只需要绑定不同的VAO就行了。

一个VAO会储存以下这些内容：

- glEnableVertexAttribArray和glDisableVertexAttribArray的调用。
- 通过`glVertexAttribPointer`调用进行的顶点缓冲对象与顶点属性链接。

### API

#### 分配VAO

```c
void glGenVertexArrays(GLsizei n, GLuint *arrays);

//示例
GLuint vao;
glGenVertexArrays(1, &vao);
```

* n：生成多少个VAO
* buffers：存储VAO索引的对象

#### 绑定VAO对象

```c
void glBindVertexArray(GLuint array);

//示例
GLuint lightVAO;
glGenVertexArrays(1, &lightVAO);
glBindVertexArray(lightVAO);

//设置为0 可以解绑当前VAO或者切换至下一个VBO来进行设置
glBindBuffer(GL_ARRAY_BUFFER, 0);
```

* array：VAO索引
  * 切换VAO必须先用0解绑上一个VAO。

#### 释放VAO

```c
void glDeleteVertexArrays(GLsizei n, const GLuint *arrays);
```

- `n`：要删除的 VAO 数量
- `arrays`：指向要删除的 VAO 名称（ID）数组的指针

## EBO

元素缓冲对象：Element Buffer Object，EBO 或 索引缓冲对象 Index Buffer Object，
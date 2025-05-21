[toc]

## GLAD

此处的函数都是来源于GLAD

## uniform的概念

指的是在着色器程序（Shader）运行期间保持不变的全局变量。这些变量由 CPU 端（应用程序）传递给 GPU（着色器程序），用于配置渲染效果，如变换矩阵、颜色、光照参数等。

- **全局性**：在着色器程序内，uniform 是全局可见的，所有函数均可访问。
- **常量性**：在一次绘制调用（Draw Call）中，uniform 的值不可修改（但不同绘制调用之间可以改变）。
- **GPU 传递**：由 CPU 设置，通过图形 API（如 `glUniform*`）传递给着色器。
- **支持多种数据类型**：标量（`float/int`）、向量（`vec2/vec3/vec4`）、矩阵（`mat4`）、纹理采样器（`sampler2D`）等。

### UBO和独立uniform

UBO：UBO（Uniform Buffer Object）是 OpenGL/WebGL 等图形 API 中用于高效传递 **大量 Uniform 数据** 的机制。它通过将多个 Uniform 变量打包到一个 **显存缓冲区** 中，减少 CPU 到 GPU 的数据传输开销，并支持跨着色器程序共享数据。

```c
//着色器中声明UBO
layout(std140) uniform Camera {		//std140为内存布局
    mat4 view;
    mat4 projection;
};

//外部定义并使用UBO
struct Camera {
    mat4 view;
    mat4 proj;
};
glBindBuffer(GL_UNIFORM_BUFFER, ubo);
glBufferData(GL_UNIFORM_BUFFER, sizeof(Camera), &cameraData, GL_DYNAMIC_DRAW);
```



### 数量限制

每个着色器允许的**Uniform**数量均不相同，并且都有上限。

* 每个着色器（Shader）允许的 **Uniform 数量** 并不是绝对固定的，但它受到硬件和图形 API 的限制。

OpenGL 通常以 **基本组件**（如 `float`/`int` = 1 component）为单位限制。查询时使用的 `GL_MAX_*_UNIFORM_COMPONENTS` 即为此类限制。
例如：

- 一个 `vec3` = 3 components

- 一个 `mat4` = 16 components

### 内存限制

Uniform 数据最终会占用 GPU 的常量内存池，因此存在隐式的大小限制。如果总内存超出硬件支持，着色器会编译失败。

可通过 `GL_MAX_UNIFORM_BLOCK_SIZE` 查询  UBO 的最大字节数（现代 OpenGL 中通常为 64KB~16MB）。

* 非 Uniform对象 的独立 Uniform 总大小无显式查询 API，但通常由 `GL_MAX_*_UNIFORM_COMPONENTS` 间接限制（假设每个 component 占 4 字节）。

### 典型限制示例

| 限制类型               | 查询枚举                             | 典型值（桌面 OpenGL）          |
| :--------------------- | :----------------------------------- | :----------------------------- |
| 顶点着色器组件数量     | `GL_MAX_VERTEX_UNIFORM_COMPONENTS`   | 1024~4096                      |
| 片段着色器组件数量     | `GL_MAX_FRAGMENT_UNIFORM_COMPONENTS` | 1024~4096                      |
| Uniform Block 最大大小 | `GL_MAX_UNIFORM_BLOCK_SIZE`          | 65536 (64KB) ~ 16777216 (16MB) |
| 纹理采样器数量         | `GL_MAX_TEXTURE_IMAGE_UNITS`         | 8~32                           |

### 常用类型

#### 标量类型

| GLSL 类型 | 对应 C/C++ | 用途示例                   |
| --------- | ---------- | -------------------------- |
| `int`     | `GLint`    | 控制开关、选择、索引等     |
| `float`   | `GLfloat`  | 比例、位置、权重、时间等   |
| `bool`    | `GLint`    | 控制条件逻辑（true/false） |
| `uint`    | `GLuint`   | 无符号整数控制值           |

#### 向量类型

| GLSL 类型 | 分量数 | 对应 Uniform 函数 | 用途示例                   |
| --------- | ------ | ----------------- | -------------------------- |
| `vec2`    | 2      | `glUniform2f`     | 位置、方向、分辨率         |
| `vec3`    | 3      | `glUniform3f`     | 颜色、位置、法线向量等     |
| `vec4`    | 4      | `glUniform4f`     | RGBA 颜色、变换后位置      |
| `ivec2`   | 2      | `glUniform2i`     | 屏幕尺寸、整数位置         |
| `ivec3`   | 3      | `glUniform3i`     | 整数三元组，如离散三维坐标 |

#### 矩阵类型

| GLSL 类型 | 维度 | 对应 Uniform 函数    | 用途示例                                     |
| --------- | ---- | -------------------- | -------------------------------------------- |
| `mat2`    | 2×2  | `glUniformMatrix2fv` | 2D旋转、缩放矩阵                             |
| `mat3`    | 3×3  | `glUniformMatrix3fv` | 法线矩阵、旋转                               |
| `mat4`    | 4×4  | `glUniformMatrix4fv` | 投影/视图/模型变换矩阵                       |
| `matMxN`  | M×N  |                      | 非方阵矩阵（较少见），并且对M和N的取值有限制 |

#### 采样器类型（数据引用类型）

| GLSL 类型         | 对应 Uniform 设置方式         | 用途                             |
| ----------------- | ----------------------------- | -------------------------------- |
| `sampler2D`       | `glUniform1i(location, unit)` | 2D 纹理                          |
| `sampler3D`       | `glUniform1i(location, unit)` | 3D 纹理                          |
| `samplerCube`     | `glUniform1i(location, unit)` | 立方体贴图（如环境贴图，天气盒） |
| `sampler2DShadow` | `glUniform1i(location, unit)` | 阴影贴图                         |

这些采样器其实是用整数告诉 GPU 使用哪一个纹理单元（绑定的是 `GL_TEXTUREX`）。

## glGetIntegerv

读取一个或多个整数类型的 OpenGL 状态值或参数，并存储到你提供的内存地址中。

是 OpenGL 用来查询当前上下文状态或硬件限制的函数之一。

```c
void glGetIntegerv(GLenum pname, GLint *data);
```

* `pname`：指定你要查询的状态或参数的枚举值，比如纹理单元数量、视口大小、当前绑定的缓冲区ID等。

* `data`：指向存储查询结果的内存地址（至少要能容纳一个 `GLint`）。

### 查询取值

| pname                                 | 说明                                                      |
| ------------------------------------- | --------------------------------------------------------- |
| `GL_MAX_TEXTURE_SIZE`                 | 支持的最大纹理宽度/高度（单边）                           |
| `GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS` | 着色器阶段合计的最大纹理单元数量                          |
| `GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS`   | 顶点着色器支持的最大纹理单元数量                          |
| `GL_MAX_TEXTURE_IMAGE_UNITS`          | 片段着色器支持的最大纹理单元数量                          |
| `GL_MAX_VERTEX_ATTRIBS`               | 顶点着色器允许的最大顶点属性数量                          |
| `GL_MAX_UNIFORM_BLOCK_SIZE`           | 着色器中单个 Uniform Block 支持的最大字节数（限制块大小） |
| `GL_MAX_DRAW_BUFFERS`                 | 最大绘制缓冲区数量                                        |
| `GL_STENCIL_BITS`                     | 模板缓冲区的位数                                          |
| `GL_DEPTH_BITS`                       | 深度缓冲区的位数                                          |
| `GL_RED_BITS`                         | 红色通道的位数                                            |
| `GL_GREEN_BITS`                       | 绿色通道的位数                                            |
| `GL_BLUE_BITS`                        | 蓝色通道的位数                                            |
| `GL_ALPHA_BITS`                       | Alpha 通道的位数                                          |
| `GL_SAMPLE_BUFFERS`                   | 多重采样缓冲区数量                                        |
| `GL_SAMPLES`                          | 每个采样缓冲区的样本数                                    |
| `GL_MAX_ELEMENTS_INDICES`             | 最大元素索引数量                                          |
| `GL_MAX_ELEMENTS_VERTICES`            | 最大元素顶点数量                                          |

## glGetUniformLocation

```c
GLint glGetUniformLocation(GLuint program, const char *name);
```

**作用**：查询一个着色器程序（program）中，指定 uniform 变量名（`name`）的“位置”（location）。

**返回值**：如果找到对应 uniform 变量，返回它的整型位置索引；找不到返回 -1。

**注意**：

- 这个 location 是给后续 `glUniform*` 函数用的，告诉它具体操作哪个 uniform。
- 调用这个函数代价相对较高，最好在程序初始化时调用一次，缓存结果，不要在渲染循环里频繁调用。
- uniform 变量名必须与着色器里声明的完全匹配。

## glUniform系列

glUniform系列用于给着色器中的uniform变量设置值

### glUniform1i

传递一个 `int` 类型的值给着色器中的一个 `int` uniform 变量。

* 类似的还有2i、3i、4i，不过他们对应的变量目标类型是ivec2，ivec3，ivec4

```c
void glUniform1i(GLint location, GLint v0);
```

### glUniform1f

传递一个 `float` 类型的值给着色器中的一个 `float` uniform 变量。

* 类似的还有2f、3f、4f，不过他们对应的变量目标类型是vec2，vec3，vec4

```c
void glUniform1f(GLint location, GLfloat v0);
```

### glUniformMatrix4fv

传递 `count` 个 4x4 浮点矩阵给着色器中的 `mat4` uniform 变量。

```c
void glUniformMatrix4fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
```

`location`：uniform 位置

`count`：矩阵数量，通常是 1

transpose`：是否转置矩阵。OpenGL 默认列主序列存储，一般传 `GL_FALSE

value`：指向浮点数组指针，长度至少是 `count * 16

### glUniform1iv

传递整数数组给着色器中 `int[]` uniform 变量。

对应的还有 `glUniform2iv`, `glUniform3iv`, `glUniform4iv`，类似整型数组传递，但少用。

对于浮点数组，有 `glUniform1fv`, `glUniform2fv`, `glUniform3fv`, `glUniform4fv`，用法类似。

```c
void glUniform1iv(GLint location, GLsizei count, const GLint *value);
```


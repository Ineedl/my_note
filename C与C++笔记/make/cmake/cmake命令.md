## cmake_minimum_required
要求最低的cmake版本号
```cmake
cmake_minimum_required (VERSION 2.8)
```

## project
指定项目名，项目信息

`原型`
```cmake
roject(<PROJECT-NAME> [LANGUAGES] [<language-name>...])
```

`例子`
```cmake
project (projectName)
```

## message
cmake中的打印
(STATUS "SRC_FILE: " ${ALL_SRC_FILE})

## set
设置变量或环境变量

```cmake
#设置变量，<variable>在当前函数或目录范围内设置给定的值。
set(<variable> <value>... [PARENT_SCOPE])

#设置环境，环境变量整个cmake工程都可以使用
set(ENV{<variable>} [<value>])
```

PARENT_SCOPE: 如果给出选项，则变量将设置在当前范围之上的范围内。每个新目录或函数都会创建一个新范围。此命令会将变量的值设置到父目录或调用函数（以适用于手头的情况为准）。变量值的先前状态在当前范围内保持不变（例如，如果它之前未定义，它仍然是未定义的，如果它有一个值，它仍然是那个值）。

环境变量: 如果在之后没有给出参数ENV{<variable>}或者<value>是一个空字符串，那么这个命令将清除环境变量的任何现有值。当variable为空时，后面的参数<value>被忽略。如果发现额外的参数，则会发出作者警告。

## add_executable
指定生成目标(添加可执行文件目标)

`原型`
```cmake
add_executable(<name> [WIN32] [MACOSX_BUNDLE] [EXCLUDE_FROM_ALL] source1 [source2 ...])
```

WIN32: 用于windows系统下创建一个以WinMain为入口的可执行目标文件（通常入口函数为main），它不是一个控制台应用程序，而是一个GUI应用程序。当WIN32选项使用的时候，可执行目标的 WIN32_EXECUTABLE会被置位ON。windows下不加WIN32时，运行程序后会弹出一个cmd框

MACOSX_BUNDLE: 用于mac系统或者IOS系统下创建一个GUI可执行应用程序，当MACOSX_BUNDLE选项使用的时候，可执行目标的MACOSX_BUNDLE会被置位ON。

作者：Domibaba
链接：https://www.jianshu.com/p/19765d4932a4
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

`例子`
```cmake
add_executable(Demo main.cc)
```

## add_library
添加静态或动态库目标

`原型`
```cmake
add_library(<name> [STATIC | SHARED | MODULE]
            [EXCLUDE_FROM_ALL]
            [<source>...])
```

如果没有明确给出库类型，是否为STATIC或SHARED基于变量BUILD_SHARED_LIBS的当前值是否为ON

STATIC: 生成静态库
SHARED: 生成动态库
MODULE: 类似于动态库，模块库是没有链接到其他目标的插件，但在运行时可以使用类似 dlopen 的功能动态加载。在使用 dyld 的系统有效,如果不支持 dyld,则被当作 SHARED 对待。

EXCLUDE_FROM_ALL: 设置EXCLUDE_FROM_ALL，可使这个library排除在all之外，即必须明确点击生成才会生成。


`例子`
```cmake

```


## aux_source_directory

> * 特别注意
CMake官方不推荐使用aux_source_directory及其类似命令(file(GLOB_RECURSE …))来搜索源文件，
如果我再在被搜索的路径下添加源文件，我不需要修改CMakeLists脚本，  
也就是说，源文件多了，而CMakeLists并不需要(没有)变化，也就使得构建系统不能察觉到新加的文件，  
除非手动重新运行cmake，否则新添加的文件就不会被编译到项目结果中。

指定目录下所有的源文件

`原型`
```cmake
aux_source_directory(<dir> <variable>)
```

`例子`
```cmake
# 查找当前目录下的所有源文件
# 并将名称保存到 DIR_SRCS 变量
aux_source_directory(. DIR_SRCS)
```

## file(其1 glob)
读取一些目录中满足条件的所有文件名，并将他们放到一个变量中

> * 特别注意
CMake官方不推荐使用aux_source_directory及其类似命令(file(GLOB_RECURSE …))来搜索源文件，
如果我再在被搜索的路径下添加源文件，我不需要修改CMakeLists脚本，
也就是说，源文件多了，而CMakeLists并不需要(没有)变化，也就使得构建系统不能察觉到新加的文件，  
除非手动重新运行cmake，否则新添加的文件就不会被编译到项目结果中。

`原型`
```cmake
file(GLOB <variable>
[LIST_DIRECTORIES true|false] 
[RELATIVE <path>] 
[CONFIGURE_DEPENDS]
[<globbing-expressions>...])

#GLOB_RECURSE模式将遍历匹配目录的所有子目录并匹配文件
file(GLOB_RECURSE <variable>
[FOLLOW_SYMLINKS]
[LIST_DIRECTORIES true|false] 
[RELATIVE <path>] 
[CONFIGURE_DEPENDS]
[<globbing-expressions>...])

```

生成与匹配的文件列表<globbing-expressions并将其存储到<variable>.通配表达式类似于正则表达式。

<globbing-expressions>中可以使用与当前项目目录相关的相对路径

FOLLOW_SYMLINKS: 指定后也会遍历符号链接目录。

RELATIVE : 忽略返回的文件绝对路径中与该处路径匹配的项。
```cmake
假如项目当前工作目录是sources，

用file命令匹配文件列表 /usr/file/sources/*.c放到变量SOURCES_FILE变量中

假设/usr/file/sources中有a.c b.c c.c三个文件

如果设置 RELATIVE /usr/file/

则SOURCES_FILE中匹配的文件为 
sources/a.c sources/b.c sources/c.c
否则为
/usr/file/sources/a.c /usr/file/sources/b.c /usr/file/sources/c.c
```

LIST_DIRECTORIES : 默认情况显示全路径，LIST_DIRECTORIES设置为 false，则在结果中省略目录只显示文件名。(貌似没有效果，但是个人觉得全路径比较好)

CONFIGURE_DEPENDS : 如果 CONFIGURE_DEPENDS 标志位被指定，CMake 将在编译时给主构建系统添加逻辑来检查目标，以重新运行 GLOB 标志的命令。如果任何输出被改变，CMake都将重新生成这个构建系统。

 `实例`
 ```cmake
 #获取./src/head/下的所有.h文件放入ALL_HEAD_FILE中
 file(GLOB ALL_HEAD_FILE ./src/head/*.h)
 
 #获取./src/head/下所有的.h文件以及其递归子目录中的所有.h文件，即获取./src/head/中所能找到的所有.h文件
 file(GLOB_RECURSE ALL_HEAD_FILE ./src/head/*.h)
 
 ```

## add_subdirectory
添加其他目录到当前的cmake工程中被添加的目录下CMakeLists.txt文件和源代码也会被处理

`原型`
```cmake
add_subdirectory(source_dir [binary_dir] [EXCLUDE_FROM_ALL])
```

binary_dir: 当无这个参数时，指定目录必须是cmake主工作的子目录，指定后将没有这个限制，之后会在生成的构建目录下的 binary_dir 目录下存放制定子目录中工程编译生成的相关文件。

EXCLUDE_FROM_ALL: 设置该参数后，该子目录不会加入到主工程中，相当于忽略，该参数常用于测试代码

`实例`
```cmake
add_subdirectory(math)

#构建后 hello_binary_dir 的目录就在 projectName/build/ 目录下，里面存放子目录根据其目录下的cmakeList.txt生成的文件。
add_subdirectory(${TOP_DIR}/hello hello_binary_dir)
```

## include_directories
添加头文件目录

`原型`
```cmake
include_directories([AFTER|BEFORE] [SYSTEM] dir1 [dir2 ...])
```

AFTER或BEFORE: 来指定是添加到头文件目录列表的前面或者后面，不写时默认在最前(感觉一般没啥用)。

SYSTEM: 指定该参数表示这些目录是系统头文件目录，比如安装了openssl后，include <openssl/md5.h>中，openssl目录为一个系统头文件目录此时可以
```cmake
include_directories(openssl SYSTEM)
```
。


`实例`
```cmake
include_directories(${PROJECT_SOURCE_DIR}/include)
```

## target_link_libraries
链接需要链接的库

`原型`
```cmake
target_link_libraries(<target> ... <item>... ...)
```

target: <target>必须是由命令创建的，例如 add_executable()或者add_library()

item: 可能是库目标名称、库文件的完整路径、一个普通的库名称、以 开头-但不是-l开头的链接标志,-framework被视为链接器标志.

`实例`
```cmake
target_link_libraries(${PROJECT_NAME} util)

target_link_libraries(myclion 
        curl
        ssl
        crypto
        dl
        Threads::Threads
        )
```

## link_directories
指定链接库目录
`原型`
```cmake
link_directories([AFTER|BEFORE] directory1 [directory2 ...])
```

AFTER与BEFORE: 同导入头文件额

相当于gcc/g++ -L

`实例`
```cmake
link_directories(${CMAKE_CURRENT_LIST_DIR}/lib)
```

## link_libraries
添加链接的库，添加需要链接的库文件路径
`原型`
```cmake
link_libraries([item1 [item2 [...]]]
               [[debug|optimized|general] <item>] ...)
```

`实例`
```cmake
LINK_LIBRARIES("/opt/MATLAB/R2012a/bin/glnxa64/libeng.so")

LINK_LIBRARIES("/opt/MATLAB/R2012a/bin/glnxa64/libmx.so")
```

## add_custom_command

用来在CMake构建过程中来执行命令

```cmake
add_custom_command(
[TARGET target]
[OUTPUT fileName]
POST_BUILD|PRE_BUILD|PRE_LINK
COMMAND command1 [ARGS] [args1...]
[COMMAND command2 [ARGS] [args2...] ...]
[WORKING_DIRECTORY dir]
[COMMENT comment]
[VERBATIM] [ADDEND]
)
```

* `TARGET`：构建的目标

* `POST_BUILD|PRE_BUILD|PRE_LINK`：在该目标构建后、构建前、链接前执行命令

* `COMMAND`：要执行的命令，可以是任何可执行程序、脚本或命令行命令。

* `ARGS`：传递给命令的参数。

* `WORKING_DIRECTORY`：命令工作的目录，不写默认在CMakeLists.txt所在目录下。

* `COMMENT`：提供一个描述性注释。

* `VERBATIM`：添加该符号后将保证：保留命令行参数的字面值，并且不进行转义，比如命令行参数中'\n'、'\t'不会转义。

* `APPEND`：添加该符号后将新的自定义命令附加到已存在的某个带有`OUTPUT`的`add_custom_command`的`COMMAND`之后，保证顺序。

  `APPEND`必须和`OUTPUT一起存在`

* `OUTPUT`：表示该add_custom_command预期生成文件(该文件不可见，为一种虚拟的东西，用来给`add_executable`来使用生成目标)，`OUTPUT`无法和`TARGET`一起存在。

`实例`

```cmake
#编译后复制库到程序目录下
foreach (QT_LIB Core Gui Widgets Network WebSockets Charts)     #自动找Qt依赖库 放到编译目录
        add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy
                "${QT_INSTALL_PATH}/bin/Qt5${QT_LIB}${DEBUG_SUFFIX}.dll"
                "$<TARGET_FILE_DIR:${PROJECT_NAME}>"
                )
endforeach (QT_LIB)
```

`OUTPUT参数和APPEND参数的实例`

```cmake
cmake_minimum_required(VERSION 3.0)

project(MyProject)

# 添加一个自定义命令，用于生成 output.txt 文件
add_custom_command(OUTPUT output.txt
                   COMMAND echo "Hello, World!" >> output3.txt
                   COMMENT "Generating output file"
                   VERBATIM)

# 添加一个自定义命令，用于在 output.txt 文件末尾追加一行
add_custom_command(OUTPUT output2.txt
                   COMMAND echo "This is an appended line." >> output3.txt
                   COMMENT "Appending to output file"
                   VERBATIM
                   )

##This is an appended line2222.和 Hello，World打印的顺序不确定。
add_custom_command(OUTPUT output4.txt
                   COMMAND echo "This is an appended line2222." >> output3.txt
                   COMMENT "Appending to output file"
                   VERBATIM
                   )


# 将 output.txt 文件添加到构建目标中
# output.txt和output2.txt和output4.txt并不会实际生成，只是一个虚拟目标
add_executable(MyTarget main.c output.txt output2.txt output4.txt)

# 将 output.txt和output2.txt 文件添加到构建目标中

add_executable(MyTarget main.c output.txt output2.txt)

```



```cmake
cmake_minimum_required(VERSION 3.0)

project(MyProject)

# 添加一个自定义命令，用于生成 output.txt 文件
add_custom_command(OUTPUT output.txt
                   COMMAND echo "Hello, World!" >> output3.txt
                   COMMENT "Generating output file"
                   VERBATIM)

# 添加一个自定义命令，用于在 output.txt 文件末尾追加一行
add_custom_command(OUTPUT output2.txt
                   COMMAND echo "This is an appended line." >> output3.txt
                   COMMENT "Appending to output file"
                   VERBATIM
                   )

#This is an appended line2222.必定跟在 Hello，World打印后面!
add_custom_command(OUTPUT output.txt
                   COMMAND echo "This is an appended line2222." >> output3.txt
                   COMMENT "Appending to output file"
                   VERBATIM
                   APPEND
                   )


# 将 output.txt 文件添加到构建目标中
add_executable(MyTarget main.c output.txt output2.txt)

# 将 output.txt和output2.txt 文件添加到构建目标中

add_executable(MyTarget main.c output.txt output2.txt)
```


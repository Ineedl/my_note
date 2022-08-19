### CMAKE_ARCHIVE_OUTPUT_DIRECTORY

默认存放静态库的文件夹位置


### CMAKE_LIBRARY_OUTPUT_DIRECTORY

默认存放动态库的文件夹位置


### LIBRARY_OUTPUT_PATH

默认存放库文件的位置，如果产生的是静态库并且没有指定 CMAKE_ARCHIVE_OUTPUT_DIRECTORY 则存放在该目录下，动态库也类似

### CMAKE_RUNTIME_OUTPUT_DIRECTORY

存放编译后可执行文件的目录

### CMAKE_CURRENT_SOURCE_DIR

当前处理的CMakeList.txt文件所在目录

### CMAKE_INSTALL_RPATH

编译后运行时寻找动态库的位置

### CMAKE_PREFIX_PATH
是以分号分隔的列表，供

find_package(), //查找包装好可以供cmake使用的依赖包
find_program(), //查找程序路径
find_library(), //查找库文件路径
find_file(),    //查找指定文件全路径
find_path()     //查找指定文件的路径

使用，初始为空，由用户设定，一般只使用第一个分号前的路径

`例子`
```
set(CMAKE_PREFIX_PATH "D:/Qt/Qt5.9.9/5.9.9/mingw53_32")

//注意分号间隔中的目录一定要加/
set(CMAKE_PREFIX_PATH "/Qt/Qt5.9.9/5.9.9/mingw53_32/;D:/Qt/;/bin1/;/bin2/;/bin3/;/bin4/")
```


CMAKE_CURRENT_SOURCE_DIR：CMakeList.txt所在的目录
CMAKE_CURRENT_LIST_DIR：CMakeList.txt的完整路径
CMAKE_CURRENT_LIST_LINE：当前所在的行
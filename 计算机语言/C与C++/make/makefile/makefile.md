[toc]

## 规则

`Makefile`由若干条规则（Rule）构成，每一条规则指出一个目标文件（Target），若干依赖文件（prerequisites），以及生成目标文件的命令。

* makfile不止应用于c项目，其可以应用于多种文件生成项目
* `make`默认执行第一条规则
* make 的规则中，如果一个规则依赖于另一个规则，在执行这个规则之前，Make 会先尝试执行它依赖的规则
* 一条规则可以有多条命了，但`make`针对每条命令，都会创建一个独立的Shell环境，类似`cd ..`这样的命令，并不会影响当前目录。

```makefile
target: file1 file2
	cmd
	
	
#例
x.txt: m.txt c.txt
	cat m.txt c.txt > x.txt

m.txt: a.txt b.txt
	cat a.txt b.txt > m.txt
	echo m.txt

```

## 常用自动变量

### $@

目标文件

### $^

所有的依赖文件

### $<

第一个依赖文件。 

### $?

构造所需文件列表中更新过的文件

## 隐式规则

`make`最初就是为了编译C程序而设计的，为了免去重复创建编译`.o`文件的规则，`make`内置了隐式规则（Implicit Rule），即遇到一个`xyz.o`时，如果没有找到对应的规则，就自动应用一个隐式规则

```makefile
xyz.o: xyz.c
	cc -c -o xyz.o xyz.c
	
  #实际上是
  $(CC) $(CFLAGS) -c -o $@ $<
```

隐式规则有一个潜在问题，那就是无法跟踪`.h`文件的修改。如果我们修改了`hello.h`的定义，由于隐式规则`main.o: main.c`并不会跟踪`hello.h`的修改，导致`main.c`不会被重新编译。

## 变量

### 定义

```makefile
变量名 = 值
变量名 := 值
```

`=`：**递延展开（lazy evaluation）**，**用到时**才赋值。

`:=`：**立即展开（immediate evaluation）**，**定义时**就赋值

### 使用

```
$(变量名)
```

## 模式规则

我们可以自定义模式规则（Pattern Rules），它允许`make`匹配模式规则，如果匹配上了，就自动创建一条模式规则。

* 相当于正则表达式中用字符串去匹配能匹配的上的正则表达式。
* 顺序为从makefile自上到下

```makefile
OBJS = $(patsubst %.c,%.o,$(wildcard *.c))
TARGET = world.out

$(TARGET): $(OBJS)
	cc -o $(TARGET) $(OBJS)

# 模式匹配规则：当make需要目标 xyz.o 时，会匹配到这里
%.o: %.c
	@echo 'compiling $<...'
	cc -c -o $@ $<

clean:
	rm -f *.o $(TARGET)
```

## 头文件更新判断

* gcc -MM的作用：生成文件依赖关系，包括头文件的

```makefile
# 列出所有 .c 文件:
SRCS = $(wildcard *.c)

# 根据SRCS生成 .o 文件列表:
OBJS = $(SRCS:.c=.o)

# 根据SRCS生成 .d 文件列表:
DEPS = $(SRCS:.c=.d)

TARGET = world.out

# 默认目标:
$(TARGET): $(OBJS)
	$(CC) -o $@ $^

# 生成.d文件 一个.d文件就是一个包含某个.o的目标，这个目标依赖其.h和.c
%.d: %.c
	rm -f $@; \
	$(CC) -MM $< >$@.tmp; \
	sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.tmp > $@; \
	rm -f $@.tmp

# 模式规则:
%.o: %.c
	$(CC) -c -o $@ $<

clean:
	rm -rf *.o *.d $(TARGET)

# 引入所有 .d 文件， 当.d不存在时 触发上述 %.d: %.c 规则
# 首次运行会创建出.d，.d文件第二次才会生效，但是因为第一次本来就会编译所有，所以这个过程没有问题
include $(DEPS)
```

## 常用指令

### 伪目标

可以使用.PHONY定义一个伪目标，伪目标没有依赖文件和目标文件，其只是用于供makefile来执行命令

```makefile
# 声明all与clean为make命令 而不是文件名
# 而不会在make clean时去寻找clean作为makefile

.PHONY:all clean

x.txt: m.txt c.txt
	cat m.txt c.txt > x.txt

m.txt: a.txt b.txt
	cat a.txt b.txt > m.txt
	echo m.txt


all: x.txt


clean:
	rm x.txt m.txt
```

### include

`include` 命令用于**将其他文件的内容包含进当前 Makefile 中**，相当于文本级别的“粘贴”。这条命令在管理大型项目、自动化依赖追踪、复用构建规则时非常常用。

```makefile
include config.mk
include file1 file2
```

## 常用函数

### wildcard

匹配文件所有满足条件的文件

```makefile
SRCS = $(wildcard *.c)	#匹配当前目录下所有.c文件
OBJS = $(wildcard *.o)  #匹配当前目录下所有.o文件
```

### patsubst

模式替换字符串

```makefile
SRCS = $(wildcard *.c)
OBJS = $(patsubst %.c,%.o,$(SRCS)) #替换所有.c为.o 并赋值给OBJS
```

### 字符串替换

```makefile
STR := hello_world
NEW := $(subst _,-,$(STR)) #替换_为-
```


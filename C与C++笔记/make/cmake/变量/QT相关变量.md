## CMAKE_AUTOMOC

是否为Qt目标自动处理 moc

```
set(CMAKE_AUTOMOC ON)
```

## CMAKE_AUTORCC

是否为Qt目标自动处理rcc(比如qrc)资源文件

set(CMAKE_AUTORCC ON)

## CMAKE_AUTOUIC

是否为Qt目标自动处理ui文件

```
set(CMAKE_AUTOUIC ON)
```

## CMAKE_AUTOUIC_SEARCH_PATHS

设置自动uic时的搜索目录

```
set(CMAKE_AUTOUIC_SEARCH_PATHS /a /b /c)
```

## 自动处理

使用add_executable添加对应自动处理的qt文件后，cmake将会自动处理这些文件。
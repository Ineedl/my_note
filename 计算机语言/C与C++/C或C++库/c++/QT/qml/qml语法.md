[toc]

## QML

QML是一种描述用户界面的声明式语言。它将用户界面分解成一些更小的元素，这些元素能够结合成一个组件。QML语言描述了用户界面元素的形状和行为。用户界面能够使用JavaScript来提供修饰，或者增加更加复杂的逻辑。从这个角度来看它遵循HTML-JavaScript模式，但QML是被设计用来描述用户界面的，而不是文本文档。

## 例子

```
// rectangle.qml

//导入一个指定的模块 以及其版本
import QtQuick 2.0

// 根元素 每个QML文件都需要一个根元素
Rectangle {
    id: root

    width: 120; height: 240

    color: "#D8D8D8"

    Image {
        id: rocket

        x: (parent.width - width)/2; y: 40

        source: 'assets/rocket.png'
    }

    Text {

        // 通过id引用
        y: rocket.y + rocket.height + 20

        // 通过id引用
        width: root.width

        horizontalAlignment: Text.AlignHCenter
        text: 'Rocket'
    }
}
```

## ID属性

在每个QML元素中，id是一个非常特殊的属性值，它在一个QML文件中被用来引用元素。id不是一个字符串，而是一个标识符和QML语法的一部分。一个id在单个QML文件中是唯一的，并且不能被设置为其它值，也无法被查询（它的行为更像C++世界里的指针）。

## 其他属性

一个属性能够设置一个值，这个值依赖于它的类型。如果没有对一个属性赋值，那么它将会被初始化为一个默认值。可以查看特定的元素的文档来获得这些初始值的信息。

一个属性能够依赖一个或多个其它的属性，这种操作称作属性绑定。**当它依赖的属性改变时，它的值也会更新**。这并不同于JS，JS只会生效一次。
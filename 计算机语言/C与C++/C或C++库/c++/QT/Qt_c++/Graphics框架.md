[toc]

## Graphics View Framework

Graphics View Framework是Qt 提供的一个用于二维图形可视化、编辑、变换和交互的完整框架。

## 结构介绍

### QGraphicsScene

场景，管理图元项的容器，所有的图像内容的载体，所有的图像内容都在场景中

### QGraphicsView

视图，用于显示QGraphicsScene的图像内容

### QGraphicsItem

图元，图像本身，存在于场景中

* 用户可以自定义图元，不一定非要使用QGraphicsItem。

### 三者的关系

QGraphicsScene相当于景色，QGraphicsItem相当于景色中的事物，而QGraphicsView相当于门窗，QGraphicsView用于限制或者控制我们如何查看 QGraphicsScene 中的 QGraphicsItem。

#### 更严格的说法

Graphics View Framework 实际是一个 MVC（Model-View-Controller）架构的实现：

- **Model** → `QGraphicsScene`
- **View** → `QGraphicsView`
- **Controller / Item** → `QGraphicsItem`（直接负责事件响应和绘制）

## QGraphicsScene

### 坐标系

QGraphicsScene拥有一个自定义坐标系，并且由用户来指定坐标系的范围

```c++
QGraphicsScene *scene = new QGraphicsScene();
scene->setSceneRect(-200, -200, 400, 400);  // 场景坐标从 -200,-200 到 200,200
											// 场景原点 (0, 0) 正好在场景中心
QGraphicsView *view = new QGraphicsView(scene);
view->show();
```

## 添加图元

`QGraphicsScene::addItem()` 是 `QGraphicsScene` 中最核心的接口之一，作用是向场景中添加一个图元（`QGraphicsItem`）**，让它参与绘制、事件响应、碰撞检测等。

```c++
QGraphicsScene *scene = new QGraphicsScene();
scene->setSceneRect(-200, -200, 400, 400);

//定义该图源自己的坐标系，从-50,-25开始 宽100 高50
QGraphicsEllipseItem *ellipse = new QGraphicsEllipseItem(-50, -25, 100, 50);
ellipse->setBrush(Qt::blue);
ellipse->setPos(0, 0);  // 场景中心
scene->addItem(ellipse);
```

## QGraphicsView

QGraphicsView用于决定我们能在QGraphicsScene看到什么

### 指定场景

`QGraphicsView::setScene(QGraphicsScene *scene)` 是 QGraphicsView 用来关联或切换显示的场景（QGraphicsScene）的核心方法。

* 在一个景色中，场景永远只有一个，而视图可以拥有多个，所以常常是view绑定scene，而不是反过来

```c++
QGraphicsScene *scene = new QGraphicsScene();
scene->addItem(new QGraphicsEllipseItem(-50, -25, 100, 50));

QGraphicsView *view = new QGraphicsView();
view->setScene(scene);
view->show();
```

## 视图常用操作

```c++
// 缩放视图（坐标系放大2倍）
view->scale(2.0, 2.0);

// 平移视图
view->translate(100, 50);

// 设置视图大小
view->resize(800, 600);

// 获取视图大小
QSize sz = view->size();

// 映射坐标转换
// 把视图窗口（viewport）中心点的“视口坐标”转换为对应的场景中的坐标
QPointF scenePos = view->mapToScene(view->viewport()->rect().center());

// 开启抗锯齿
view->setRenderHint(QPainter::Antialiasing, true);
```

## QGraphicsItem

### 坐标系

QGraphicsItem也拥有一个自定义坐标系

### setPos

该函数用于定义QGraphicsItem在场景中的左上角位置在哪。

```c++
void QGraphicsItem::setPos(qreal ax, qreal ay)
```

### 自定义图元

自定义图元一般继承自QGraphicsItem，然后必须实现boundingRect，paint

### paint

```c++
void paint(QPainter *painter,const QStyleOptionGraphicsItem* option,QWidget* widget);
```

paint告诉 Qt 如何绘制这个图元。

### boundingRect

```c++
QRectF boundingRect() const;
```

boundingRect返回图元在局部坐标系下的边界矩形（即图元占用的矩形区域）。

它返回的是该图元**本身的局部坐标系（item coordinate system）中的边界矩形**，也就是说：

- 这个矩形定义了图元自己的坐标系。
- 这个矩形对QGraphicsScene意义只有他的大小。

### shape（可选）

用于定义更精确的碰撞检测形状，默认用 `boundingRect()` 的矩形。




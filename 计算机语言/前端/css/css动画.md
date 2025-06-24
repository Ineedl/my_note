[toc]

## 过度动画

让一个元素从一个状态平滑过渡到另外一个状态。它通常作用于指定的属性，比如width，background color。

定义前后的状态后，当某种条件触发时，动画就会自动播放。

### 用法

```css
transition: <元素名称> <持续时间> <使用的过渡函数>


transition: width 0.3s ease,height 0.3s ease;
transition: all 0.3s ease;
```

### 实例

```css
/*button样式 触摸button按钮会变大*/
.box{
  width: 100px;
  height: 40px;
	transition: width 05.s linear,height 0.5s linear;
}


.box:hober{
  width: 120px;
  height: 50px;
}
```

## 帧动画

器可以定义多个节点，让动画按照顺序一个个变化

### 用法

```css
/*定义关键帧*/
@keyframes 动画名 {
时间点1 { CSS属性1: 值; CSS属性2: 值; ... }		/*节点1的时css的状态*/	
时间点2 { ... }															/*节点2的时css的状态*/
...																					
}

/*使用关键帧*/
.cool-button:hover{
  animation: <动画名> <持续时间> <使用函数> [infinite];
}
```

* 时间点支持以下形式：

  - 百分比（如 `0%`, `50%`, `100%`）

  - 也可以用关键词：`from` 相当于 `0%`，`to` 相当于 `100%`

* infinite表示循环播放。

### 实例

```css
/*定义关键帧*/
@keyframes bounce{
  0%{
    transform: scale(1);
  }
  50%{
    transform: scale(1.15);
  }
  100%{
    transform: scale(1.1);
  }
}

/*使用关键帧*/
.box2{
  animation: bounce 1s infinite;
}
```

## 动画函数效果

* linear：线性匀速
* ease：开始和结束慢，中间快（默认）
* ease-in：缓入之后逐渐加速
* ease-out：开始比较快，后面逐渐变慢
* ease-in-out：缓入缓出
## 介绍

**QML 是支持 WebSocket 的**，Qt 提供了专门的 `QtWebSockets` 模块，可以在 QML 中方便地使用 WebSocket。

## 基本用法

```
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebSockets 1.0 

ApplicationWindow {
    visible: true
    width: 400
    height: 300

    WebSocket {
        id: socket
        url: "ws://echo.websocket.org"
        onStatusChanged: {
            if (status === WebSocket.Open) {
                console.log("连接已打开")
                socket.sendTextMessage("Hello WebSocket")
            }
            else if (status === WebSocket.Closed) {
                console.log("连接已关闭")
            }
        }
        onTextMessageReceived: {
            console.log("收到消息:", message)
        }
        onError: {
            console.log("错误:", errorString())
        }
    }

    Button {
        text: "打开连接"
        anchors.centerIn: parent
        onClicked: socket.open()
    }
}
```

## 重要信号和方法

- **信号**
  - `onStatusChanged`: 连接状态变化
  - `onTextMessageReceived`: 收到文本消息
  - `onBinaryMessageReceived`: 收到二进制消息
  - `onError`: 发生错误
- **方法**
  - `open()`: 打开连接
  - `close()`: 关闭连接
  - `sendTextMessage(msg)`: 发送文本消息
  - `sendBinaryMessage(array)`: 发送二进制消息
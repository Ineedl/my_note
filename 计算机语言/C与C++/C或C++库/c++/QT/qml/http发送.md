## XmlHttpRequest

`XmlHttpRequest`（XHR）是 Web 前端和 QML 中调用 HTTP 接口的**经典且通用方案**，它是基于浏览器环境的标准接口，QML 也内置支持它，用起来非常方便。

* qml与js可以混用，qml支持嵌入js

## 基本用法

* XmlHttpRequest不需要导入任何包就可以使用

```
var xhr = new XMLHttpRequest();
xhr.open("GET", "https://example.com/api/data");
xhr.onreadystatechange = function() {
    if (xhr.readyState === XMLHttpRequest.DONE) {
        if (xhr.status === 200) {
            var data = JSON.parse(xhr.responseText);
            console.log(data);
        } else {
            console.log("Error:", xhr.status);
        }
    }
}
xhr.send();
```

`json数据解析与发送`

```
//解析
var xhr = new XMLHttpRequest();
xhr.open("GET", "https://example.com/api/data");
xhr.onreadystatechange = function() {
    if (xhr.readyState === XMLHttpRequest.DONE) {
        if (xhr.status === 200) {
            var responseObj = JSON.parse(xhr.responseText);
            console.log("Parsed JSON:", responseObj);
            // 访问字段： responseObj.key
        } else {
            console.log("Request failed with status", xhr.status);
        }
    }
};
xhr.send();

//发送
var xhr = new XMLHttpRequest();
xhr.open("POST", "https://example.com/api/post");
xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");

var dataObj = {
    name: "Alice",
    age: 25
};
var jsonStr = JSON.stringify(dataObj);

xhr.onreadystatechange = function() {
    if (xhr.readyState === XMLHttpRequest.DONE) {
        if (xhr.status === 200 || xhr.status === 201) {
            console.log("响应:", xhr.responseText);
        } else {
            console.log("错误:", xhr.status);
        }
    }
};
xhr.send(jsonStr);
```

`form的发送`

```
var xhr = new XMLHttpRequest();
xhr.open("POST", "https://example.com/api/post");
xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");

// key1=value1&key2=value2 格式
var formBody = "username=alice&password=123456";

xhr.onreadystatechange = function() {
    if (xhr.readyState === XMLHttpRequest.DONE) {
        if (xhr.status === 200) {
            console.log("响应:", xhr.responseText);
        } else {
            console.log("错误:", xhr.status);
        }
    }
};
xhr.send(formBody);
```

`完整示例`

```
import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 400
    height: 200
    title: "XHR 简单示例"

    Button {
        text: "点击获取数据"
        anchors.centerIn: parent

        onClicked: {
            var xhr = new XMLHttpRequest();
            xhr.open("GET", "https://jsonplaceholder.typicode.com/todos/1");
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status === 200) {
                        var data = JSON.parse(xhr.responseText);
                        console.log("返回数据:", data);
                        // 你也可以把数据显示到界面上
                    } else {
                        console.log("请求失败，状态码:", xhr.status);
                    }
                }
            }
            xhr.send();
        }
    }
}
```

## Qt.labs.network 

Qt.labs.network 是 Qt 5.14 之后引入的一个实验性网络模块，旨在为 QML 提供更现代、更简洁的网络请求接口。它基于 Qt C++ 核心网络库（QNetworkAccessManager）封装，但以 QML 友好的形式呈现，方便直接在 QML 中进行 HTTP 请求。

`json发送与接收 以及 form发送的例子`

```
import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.network 1.0

ApplicationWindow {
    visible: true
    width: 400
    height: 300
    title: "Qt.labs.network HTTP示例"

    Column {
        spacing: 20
        anchors.centerIn: parent

        // 发送 GET 请求，接受 JSON
        Button {
            text: "GET JSON"
            onClicked: {
                getRequest.url = "https://jsonplaceholder.typicode.com/todos/1"
                getRequest.method = "GET"
                getRequest.send()
            }
        }

        HttpRequest {
            id: getRequest
            onFinished: {
                if (statusCode === 200) {
                    var obj = JSON.parse(response)
                    console.log("GET 响应:", obj)
                } else {
                    console.log("GET 错误，状态码:", statusCode)
                }
            }
        }

        // 发送 POST JSON
        Button {
            text: "POST JSON"
            onClicked: {
                var jsonData = JSON.stringify({ name: "Alice", age: 25 })
                postJsonRequest.url = "https://jsonplaceholder.typicode.com/posts"
                postJsonRequest.method = "POST"
                postJsonRequest.headers = ["Content-Type: application/json;charset=UTF-8"]
                postJsonRequest.body = jsonData
                postJsonRequest.send()
            }
        }

        HttpRequest {
            id: postJsonRequest
            onFinished: {
                if (statusCode >= 200 && statusCode < 300) {
                    console.log("POST JSON 响应:", response)
                } else {
                    console.log("POST JSON 错误，状态码:", statusCode)
                }
            }
        }

        // 发送 POST 表单
        Button {
            text: "POST Form"
            onClicked: {
                var formData = "username=alice&password=123456"
                postFormRequest.url = "https://httpbin.org/post"
                postFormRequest.method = "POST"
                postFormRequest.headers = ["Content-Type: application/x-www-form-urlencoded;charset=UTF-8"]
                postFormRequest.body = formData
                postFormRequest.send()
            }
        }

        HttpRequest {
            id: postFormRequest
            onFinished: {
                if (statusCode >= 200 && statusCode < 300) {
                    console.log("POST Form 响应:", response)
                } else {
                    console.log("POST Form 错误，状态码:", statusCode)
                }
            }
        }
    }
}
```


## Settings

在 QML 中，`Settings` 通过 `Qt.labs.settings` 模块来进行配置和存储。它可以保存应用程序的配置、用户偏好设置、状态等信息，使这些数据在应用程序退出后依然保持。

* `QSettings` 类实际上是一个 **键值对存储** 系统，它允许你将简单的数据（如字符串、数字、布尔值）存储在 **平台特定的位置**（例如，Windows 注册表、macOS 的配置文件、Linux 的 `.config` 文件夹等）中。

### 示例

```
import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.0

ApplicationWindow {
    visible: true
    width: 400
    height: 400
    title: "Settings Example"

    Rectangle {
        width: 400
        height: 400
        color: "lightgray"

        // 创建 Settings 对象，用于存储配置
        Settings {
            id: settings
            organization: "MyCompany"
            application: "MyApp"
        }

        Text {
            id: label
            anchors.centerIn: parent
            text: "Username: " + settings.value("user/username", "Guest")
        }

        Button {
            text: "Change Username"
            anchors.centerIn: parent
            anchors.topMargin: 50

            onClicked: {
                // 更新用户名并保存到 Settings
                settings.setValue("user/username", "Alice")
                label.text = "Username: " + settings.value("user/username", "Guest")
            }
        }
    }
}
```

### 常用属性与函数介绍

```
// 设置 QSettings 对象
Settings {
    id: settings
    // 设置组织和应用程序的名称
    // 这两个配置用于不同的qml程序存储数据的分离 比如win上他可能决定了配置存放的目录名
    organization: "MyCompany"
    application: "MyApp"

    // 自定义存储路径
    fileName: "~/.config/MyCompany/MyAppConfig.ini"

    // 设置存储格式（INI 格式）
    format: QSettings.IniFormat

    // 设置作用范围：全局或用户级
    scope: QSettings.UserScope

    // 设置为只读模式，禁止修改设置
    readOnly: false

		//下列是常用函数
    Component.onCompleted: {
        // 检查设置是否成功加载
        if (settings.status === QSettings.NoError) {
            console.log("Settings loaded successfully.")
        } else {
            console.log("Error loading settings.")
        }

        // 检查某个设置项是否存在
        if (settings.contains("user/username")) {
            console.log("Username exists!")
        } else {
            console.log("Username not found!")
        }

        // 获取值，提供默认值
        var username = settings.value("user/username", "Guest")
        console.log("Username: " + username)

        // 设置新值
        settings.setValue("user/username", "Alice")

        // 删除某个配置项
        settings.remove("user/username")

        // 清除所有设置
        // settings.clear()
    }
}
```

## Local Storage-SQL

Qt Quick支持一个与浏览器由区别的本地存储编程接口。需要使用"import QtQuick.LocalStorage 2.0"语句来导入后才能使用这个编程接口。

通常使用基于给定的数据库名称和版本号使用系统特定位置的唯一文件ID号来存储数据到一个SQLITE数据库中。无法列出或者删除已有的数据库。你可以使用QQmlEngine::offlineStoragePate()来寻找本地存储。

使用这个编程接口你首选需要创建一个数据库对象，然后在这个数据库上创建数据库事务。每个事务可以包含一个或多个SQL查询。当一个SQL查询在事务中失败后，事务会回滚。

`示例数据库组件`

```
import QtQuick 2.2
import QtQuick.LocalStorage 2.0

Item {
    // reference to the database object
    property var db;

		//数据库初始化
    function initDatabase() {
        print('initDatabase()')
        db = LocalStorage.openDatabaseSync("CrazyBox", "1.0", "A box who remembers its position", 100000);
        db.transaction( function(tx) {
            print('... create table')
            tx.executeSql('CREATE TABLE IF NOT EXISTS data(name TEXT, value TEXT)');
        });
    }

		//数据库写入
    function storeData() {
        print('storeData()')
        if(!db) { return; }
        db.transaction( function(tx) {
            print('... check if a crazy object exists')
            var result = tx.executeSql('SELECT * from data where name = "crazy"');
            // prepare object to be stored as JSON
            var obj = { x: crazy.x, y: crazy.y };
            if(result.rows.length === 1) {// use update
                print('... crazy exists, update it')
                result = tx.executeSql('UPDATE data set value=? where name="crazy"', [JSON.stringify(obj)]);
            } else { // use insert
                print('... crazy does not exists, create it')
                result = tx.executeSql('INSERT INTO data VALUES (?,?)', ['crazy', JSON.stringify(obj)]);
            }
        });
    }

		//数据库读取
    function readData() {
        print('readData()')
        if(!db) { return; }
        db.transaction( function(tx) {
            print('... read crazy object')
            var result = tx.executeSql('select * from data where name="crazy"');
            if(result.rows.length === 1) {
                print('... update crazy geometry')
                // get the value column
                var value = result.rows[0].value;
                // convert to JS object
                var obj = JSON.parse(value)
                // apply to object
                crazy.x = obj.x;
                crazy.y = obj.y;
            }
        });
    }

    Component.onCompleted: {
        initDatabase();
        readData();
    }

    Component.onDestruction: {
        storeData();
    }
}
```


import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

ApplicationWindow{
    id: root
    width: 1280
    height:800
    visible: true
    title: "login UI"
    flags: Qt.FramelessWindowHint
    color: "#00000000"

    property int dragX: 0
    property int dragY: 0
    property bool dragging: false
    Rectangle{
        width: parent.width
        height: parent.height
        radius: 10


        MouseArea{
            width:parent.width
            height: 100
            onPressed: {
                root.dragX = mouseX
                root.dragY = mouseY
                root.dragging = true
            }
            onReleased: {
                root.dragging = false
            }
            onPositionChanged:{
                if(root.dragging){
                    root.x += mouseX - root.dragX
                    root.y += mouseY - root.dragY
                }
            }
        }


        //渐变色
        gradient: Gradient{
            //结束颜色
            GradientStop{
                position:0
                color: "#4158d0"
            }
            GradientStop{
                position:1
                color: "#c850c0"
            }
            orientation: Gradient.Horizontal
        }
        Rectangle{
            width: 800
            height: 500
            anchors.centerIn: parent
            radius: 10
            Image{
                id: img
                x: 37
                y: 100
                width: 400
                height: 300
                source: "file:///Users/jiahui/project/Qt/first_qml/resource/1.jpg"
                states:[        //定义动画状态
                    State{
                        name: "rotated"
                        PropertyChanges{
                            target: img
                            rotation: 180
                        }
                    }
                ]

                transitions:Transition{ //定义动画效果
                    RotationAnimation{
                        duration: 1000
                        direction: RotationAnimation.Counterclockwise //旋转
                    }
                }

                MouseArea{
                    anchors.fill:parent
                    onClicked:{
                        if(img.state=="rotated"){
                            img.state=""            //清空状态以还原动画
                        }else{
                            img.state="rotated" //改变状态以触发旋转动画
                        }


                    }
                }
            }
            Text{
                x: 530
                y: 130
                width:120
                height:30
                font.pixelSize: 24
                text: qsTr("登录系统")
                color: "#333333"
            }
            TextField{
                id:username
                x: 440
                y: 200
                width: 300
                height: 50
                font.pixelSize: 30
                placeholderText: qsTr("用户名或邮箱")
                placeholderTextColor: "#999999"
                color: "#666666"
                leftPadding: 60
                background: Rectangle{
                    radius: 25
                    border.color: "#e6e6e6"
                    color: "#e6e6e6"
                }

                Image{
                    width:20
                    height:20
                    x:30
                    y:15
                    source: username.activeFocus ? "file:///Users/jiahui/project/Qt/first_qml/resource/2.png":"file:///Users/jiahui/project/Qt/first_qml/resource/3.png"
                }
                NumberAnimation on y{
                    from: username.y - 100
                    to: username.y
                    duration: 300
                }
                NumberAnimation on x{
                    from: username.x- 100
                    to: username.x
                    duration: 300
                }
            }
            TextField{
                id:password
                x: username.x
                y: username.y + username.height+10
                width: username.width
                height: username.height
                font.pixelSize: username.font.pixelSize
                echoMode: TextInput.Password
                placeholderText: qsTr("登录密码")
                placeholderTextColor: username.placeholderTextColor
                color: username.color
                leftPadding: username.leftPadding
                background: Rectangle{
                    radius: 25
                    border.color: "#e6e6e6"
                    color: "#e6e6e6"
                }
                Image{
                    width:20
                    height:20
                    x:30
                    y:15
                    source: password.activeFocus ? "file:///Users/jiahui/project/Qt/first_qml/resource/2.png":"file:///Users/jiahui/project/Qt/first_qml/resource/3.png"
                }
            }

            Button{
                id: sub
                x: password.x
                y: password.y + password.height+10
                width: password.width
                height: password.height
                text: qsTr("登录")
                font.pixelSize: password.font.pixelSize

                onClicked:{
                    print("登录："+username.text)
                }

                background: Rectangle{
                    radius: 25
                    color: {
                        if(sub.down)
                            return "#00b846"
                        if(sub.hovered)
                            return "#333333"
                        return "#57b846"
                    }
                }
            }    
        }
        Rectangle{
            x: root.width-35
            y: 5
            width:30
            height:30
            color: "#00000000"
            Text{
                text:"x"
                font.pixelSize: 28
                anchors.centerIn: parent

            }
            MouseArea{
                anchors.fill:parent
                hoverEnabled: true
                onEntered: {
                    parent.color="#1BFFFFFF"
                }
                onExited: {
                    parent.color="#00000000"
                }
                onPressed: {
                    parent.color="#3BFFFFFF"
                }
                onReleased: {
                    parent.color="#1BFFFFFF"
                }
                onClicked: {
                    root.close()
                }
            }
        }

    }
}


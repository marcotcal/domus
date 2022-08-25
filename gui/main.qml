import QtQuick 2.12
import QtQuick.Controls 2.12

ApplicationWindow {
    id: window
    width: 1920
    height: 1080
    color: "#000000"
    visible: true
    title: qsTr("Stack")
    // flags:  Qt.FramelessWindowHint

    property string currTime: "00:00:00"

    /*
    header: ToolBar {
        contentHeight: toolButton.implicitHeight

        ToolButton {
            id: toolButton
            text: stackView.depth > 1 ? "\u25C0" : "\u2630"
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: {
                if (stackView.depth > 1) {
                    stackView.pop()
                } else {
                    drawer.open()
                }
            }
        }

        Label {
            text: stackView.currentItem.title + " " + currTime
            anchors.centerIn: parent
        }
    }
    */

    Drawer {
        id: drawer
        width: window.width * 0.66
        height: window.height

        Column {
            anchors.fill: parent

            ItemDelegate {
                text: qsTr("Page 1")
                width: parent.width
                onClicked: {
                    stackView.push("pass_code_page.qml")
                    drawer.close()
                }
            }
            ItemDelegate {
                text: qsTr("Page 2")
                width: parent.width
                onClicked: {
                    stackView.push("pass_code_page.qml")
                    drawer.close()
                }
            }
        }
    }

    StackView {
        id: stackView
        initialItem: "home.qml"
        anchors.fill: parent

        pushEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to:1
                    duration: 500
                }
            }
            pushExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to:0
                    duration: 500
                }
            }
            popEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to:1
                    duration: 500
                }
            }
            popExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to:0
                    duration: 500
                }
            }
    }
}

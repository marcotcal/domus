import QtQuick 2.12
import QtQuick.Controls 2.12

Page {
    width: 1920
    height: 1080
    font.pointSize: 13
    wheelEnabled: false
    hoverEnabled: false

    title: qsTr("Home")

    FontLoader { id: domus; source: "assets/domus.ttf" }

    Image {
        id: image
        antialiasing: true
        anchors.fill: parent
        source: "images/home.svg"
        fillMode: Image.PreserveAspectFit

        Text {
            id: title
            x: 180
            y: 58
            width: 437
            height: 48
            color: "#6fa538"
            text: qsTr("HOME CONTROL")
            styleColor: "#ff6600"
            font.weight: Font.ExtraLight
            font.family: domus.name
            font.pixelSize: 38
        }

        MouseArea {
            id: mouse_area
            anchors.fill: parent

            Text {
                id: element1
                x: 0
                y: 930
                width: 1920
                height: 48
                color: "#6fa538"
                text: qsTr("TOUCH TO ACCESS")
                horizontalAlignment: Text.AlignHCenter
                font.family: domus.name
                font.weight: Font.ExtraLight
                styleColor: "#ff6600"
                font.pixelSize: 48
            }

            Image {
                id: image1
                x: 515
                y: 258
                width: 800
                height: 800
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.top: parent.top
                opacity: 0.05
                fillMode: Image.PreserveAspectFit
                source: "images/circle.svg"
            }
        }
    }

    Connections {
        target: mouse_area
        function onClicked() {
            stackView.push("pass_code_page.qml")
            drawer.close()
        }
    }
}


/*##^##
Designer {
    D{i:6;anchors_height:600;anchors_width:600;anchors_x:515;anchors_y:258}
}
##^##*/

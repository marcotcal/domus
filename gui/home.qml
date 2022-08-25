import QtQuick 2.12
import QtQuick.Controls 2.12

Page {
    width: 1920
    height: 1080
    font.pointSize: 13
    wheelEnabled: false
    hoverEnabled: false

    title: qsTr("Home")

    FontLoader { id: swiss2; source: "assets/swiss2.ttf" }
    FontLoader { id: swiss911; source: "assets/swiss911.ttf" }

    Image {
        id: image
        antialiasing: true
        anchors.fill: parent
        source: "images/background.svg"
        fillMode: Image.PreserveAspectFit

        Text {
            id: element
            x: 157
            y: 76
            width: 189
            height: 48
            color: "#288c98"
            text: qsTr("HOME CONTROL")
            styleColor: "#ff6600"
            font.weight: Font.ExtraLight
            font.family: swiss2.name
            font.pixelSize: 50
        }

        MouseArea {
            id: mouse_area
            anchors.fill: parent

            Text {
                id: element1
                x: 662
                y: 775
                width: 597
                height: 48
                color: "#288c98"
                text: qsTr("SECURITY CODE REQUIRED TO ACCESS THE SYSTEM PLESE TOUCH THE SCREEN")
                horizontalAlignment: Text.AlignHCenter
                font.family: swiss2.name
                font.weight: Font.ExtraLight
                styleColor: "#ff6600"
                font.pixelSize: 48
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


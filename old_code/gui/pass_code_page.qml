import QtQuick 2.12
import QtQuick.Controls 2.12

Page {
    width: 1920
    height: 1080

    Image {
        id: background_pg
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        layer.format: ShaderEffectSource.RGBA
        layer.smooth: false
        layer.mipmap: false
        clip: false
        visible: true
        anchors.fill: parent
        source: "images/access.svg"
        enabled: false
        fillMode: Image.PreserveAspectFit

        FontLoader {id: domus; source: "assets/domus.ttf" }

        Text {
            id: typed_code
            x: 565
            y: 175
            width: 170
            height: 17
            text: security.code
            color: "#2d412d" /* same background color */
            font.pixelSize: 12
        }
    }

    Button {
        id: bt_01
        x: 156
        y: 247
        width: 100
        height: 45
        text: qsTr("01")
        font.family: domus.name
        font.pixelSize: 25

        contentItem: Text {
            text: bt_01.text
            font: bt_01.font
            opacity: enabled ? 1.0 : 0.3
            color: bt_01.down ? "#ddff55" : "#aad400"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            implicitWidth: 100
            implicitHeight: 40
            opacity: enabled ? 1 : 0.3
            border.color: "#288c98"
            border.width: 1
            radius: 20
            color: bt_01.down ? "#6b9800" : "#668000"
        }
        onClicked: {
            security.code += "1"
        }
    }

    Button {
        id: bt_02
        x: 287
        y: 247
        width: 100
        height: 45
        text: qsTr("02")
        font.pixelSize: 25
        font.family: domus.name
        contentItem: Text {
            color: bt_02.down ? "#ddff55" : "#aad400"
            text: bt_02.text
            opacity: enabled ? 1.0 : 0.3
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            font: bt_02.font
            horizontalAlignment: Text.AlignHCenter
        }
        background: Rectangle {
            color: bt_02.down ? "#6b9800" : "#668000"
            radius: 20
            opacity: enabled ? 1 : 0.3
            border.width: 1
            border.color: "#288c98"
            implicitHeight: 40
            implicitWidth: 100
        }
        onClicked: {
            security.code += "2"
        }
    }

    Button {
        id: bt_03
        x: 415
        y: 247
        width: 100
        height: 45
        text: qsTr("03")
        font.pixelSize: 25
        font.family: domus.name
        contentItem: Text {
            color: bt_03.down ? "#ddff55" : "#aad400"
            text: bt_03.text
            opacity: enabled ? 1.0 : 0.3
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            font: bt_03.font
            horizontalAlignment: Text.AlignHCenter
        }
        background: Rectangle {
            color: bt_03.down ? "#6b9800" : "#668000"
            radius: 20
            opacity: enabled ? 1 : 0.3
            border.width: 1
            border.color: "#288c98"
            implicitHeight: 40
            implicitWidth: 100
        }
        onClicked: {
            security.code += "3"
        }
    }

    /* second line */
    Button {
        id: bt_04
        x: 156
        y: 297
        width: 100
        height: 45
        text: qsTr("04")
        font.family: domus.name
        font.pixelSize: 25

        contentItem: Text {
            text: bt_04.text
            font: bt_04.font
            opacity: enabled ? 1.0 : 0.3
            color: bt_04.down ? "#ddff55" : "#aad400"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            implicitWidth: 100
            implicitHeight: 40
            opacity: enabled ? 1 : 0.3
            border.color: "#288c98"
            border.width: 1
            radius: 20
            color: bt_04.down ? "#6b9800" : "#668000"
        }
        onClicked: {
            security.code += "4"
        }
    }

    Button {
        id: bt_05
        x: 287
        y: 297
        width: 100
        height: 45
        text: qsTr("05")
        font.pixelSize: 25
        font.family: domus.name
        contentItem: Text {
            color: bt_05.down ? "#ddff55" : "#aad400"
            text: bt_05.text
            opacity: enabled ? 1.0 : 0.3
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            font: bt_05.font
            horizontalAlignment: Text.AlignHCenter
        }
        background: Rectangle {
            color: bt_05.down ? "#6b9800" : "#668000"
            radius: 20
            opacity: enabled ? 1 : 0.3
            border.width: 1
            border.color: "#288c98"
            implicitHeight: 40
            implicitWidth: 100
        }
        onClicked: {
            security.code += "5"
        }
    }

    Button {
        id: bt_06
        x: 415
        y: 297
        width: 100
        height: 45
        text: qsTr("06")
        font.pixelSize: 25
        font.family: domus.name
        contentItem: Text {
            color: bt_06.down ? "#ddff55" : "#aad400"
            text: bt_06.text
            opacity: enabled ? 1.0 : 0.3
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            font: bt_06.font
            horizontalAlignment: Text.AlignHCenter
        }
        background: Rectangle {
            color: bt_06.down ? "#6b9800" : "#668000"
            radius: 20
            opacity: enabled ? 1 : 0.3
            border.width: 1
            border.color: "#288c98"
            implicitHeight: 40
            implicitWidth: 100
        }
        onClicked: {
            security.code += "6"
        }
    }

    /* third line */
    Button {
        id: bt_07
        x: 156
        y: 347
        width: 100
        height: 45
        text: qsTr("07")
        font.family: domus.name
        font.pixelSize: 25

        contentItem: Text {
            text: bt_07.text
            font: bt_07.font
            opacity: enabled ? 1.0 : 0.3
            color: bt_07.down ? "#ddff55" : "#aad400"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            implicitWidth: 100
            implicitHeight: 40
            opacity: enabled ? 1 : 0.3
            border.color: "#288c98"
            border.width: 1
            radius: 20
            color: bt_07.down ? "#6b9800" : "#668000"
        }
        onClicked: {
            security.code += "7"
        }
    }

    Button {
        id: bt_08
        x: 287
        y: 347
        width: 100
        height: 45
        text: qsTr("08")
        font.pixelSize: 25
        font.family: domus.name
        contentItem: Text {
            color: bt_08.down ? "#ddff55" : "#aad400"
            text: bt_08.text
            opacity: enabled ? 1.0 : 0.3
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            font: bt_08.font
            horizontalAlignment: Text.AlignHCenter
        }
        background: Rectangle {
            color: bt_08.down ? "#6b9800" : "#668000"
            radius: 20
            opacity: enabled ? 1 : 0.3
            border.width: 1
            border.color: "#288c98"
            implicitHeight: 40
            implicitWidth: 100
        }
        onClicked: {
            security.code += "8"
        }
    }

    Button {
        id: bt_09
        x: 415
        y: 347
        width: 100
        height: 45
        text: qsTr("09")
        font.pixelSize: 25
        font.family: domus.name
        contentItem: Text {
            color: bt_09.down ? "#ddff55" : "#aad400"
            text: bt_09.text
            opacity: enabled ? 1.0 : 0.3
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            font: bt_09.font
            horizontalAlignment: Text.AlignHCenter
        }
        background: Rectangle {
            color: bt_09.down ? "#6b9800" : "#668000"
            radius: 20
            opacity: enabled ? 1 : 0.3
            border.width: 1
            border.color: "#288c98"
            implicitHeight: 40
            implicitWidth: 100
        }
        onClicked: {
            security.code += "9"
        }
    }

    /* forth line */
    Button {
        id: bt_00
        x: 287
        y: 397
        width: 100
        height: 45
        text: qsTr("00")
        font.family: domus.name
        font.pixelSize: 25
        contentItem: Text {
            text: bt_00.text
            font: bt_00.font
            opacity: enabled ? 1.0 : 0.3
            color: bt_00.down ? "#ddff55" : "#aad400"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
        background: Rectangle {
            implicitWidth: 100
            implicitHeight: 40
            opacity: enabled ? 1 : 0.3
            border.color: "#288c98"
            border.width: 1
            radius: 20
            color: bt_00.down ? "#6b9800" : "#668000"
        }
        onClicked: {
            security.code += "0"
        }
    }

    Button {
        id: bt_enter
        x: 156
        y: 397
        width: 100
        height: 45
        text: qsTr("ENT")
        font.pixelSize: 25
        font.family: domus.name
        contentItem: Text {
            color: bt_enter.down ? "#eaeaea" : "#ddff55"
            text: bt_enter.text
            opacity: enabled ? 1.0 : 0.3
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            font: bt_enter.font
            horizontalAlignment: Text.AlignHCenter
        }
        background: Rectangle {
            color: bt_enter.down ? "#00e68a" : "#00cc7a"
            radius: 20
            opacity: enabled ? 1 : 0.3
            border.width: 1
            border.color: "#00cc7a"
            implicitHeight: 40
            implicitWidth: 100
        }
        onClicked: {
            if (security.verify_code) {
                security.code = ""
                stackView.push("management.qml")
            } else {
                if (security.verify_terminate_code) {
                    ApplicationWindow.window.close()
                } else {
                    security.code = ""
                    stackView.push("home.qml")
                }
            }
            drawer.close()
        }
    }

    Button {
        id: bt_cancel
        x: 415
        y: 397
        width: 100
        height: 45
        text: qsTr("CAN")
        font.pixelSize: 25
        font.family: domus.name
        contentItem: Text {
            color: bt_cancel.down ? "#eaeaea" : "#ddff55"
            text: bt_cancel.text
            opacity: enabled ? 1.0 : 0.3
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            font: bt_cancel.font
            horizontalAlignment: Text.AlignHCenter
        }
        background: Rectangle {
            color: bt_cancel.down ? "#afaf22" : "#aaaa40"
            radius: 20
            opacity: enabled ? 1 : 0.3
            border.width: 1
            border.color: "#909090"
            implicitHeight: 40
            implicitWidth: 100
        }
        onClicked: {
            security.code = ""
        }
    }

    Text {
        id: title
        x: 180
        y: 58
        width: 457
        height: 48
        color: "#6fa538"
        text: qsTr("HOME CONTROL")
        font.pixelSize: 38
        font.family: domus.name
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
    }
}

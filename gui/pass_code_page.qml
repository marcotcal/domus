import QtQuick 2.12
import QtQuick.Controls 2.12

Page {
    width: 1920
    height: 1080

    Image {
        id: background_pg
        layer.format: ShaderEffectSource.RGBA
        layer.smooth: false
        layer.mipmap: false
        clip: false
        visible: true
        anchors.fill: parent
        source: "images/background.svg"
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
        x: 400
        y: 350
        width: 130
        height: 45
        text: qsTr("01")
        font.family: domus.name
        font.pixelSize: 25

        contentItem: Text {
            text: bt_01.text
            font: bt_01.font
            opacity: enabled ? 1.0 : 0.3
            color: bt_01.down ? "#ffffff" : "#fafafa"
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
            color: bt_01.down ? "#A6A6D9" : "#288c98"
        }
    }

    Button {
        id: bt_02
        x: 550
        y: 350
        width: 130
        height: 45
        text: qsTr("02")
        font.pixelSize: 25
        font.family: domus.name
        contentItem: Text {
            color: bt_02.down ? "#ffffff" : "#fafafa"
            text: bt_02.text
            opacity: enabled ? 1.0 : 0.3
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            font: bt_02.font
            horizontalAlignment: Text.AlignHCenter
        }
        background: Rectangle {
            color: bt_02.down ? "#A6A6D9" : "#288c98"
            radius: 20
            opacity: enabled ? 1 : 0.3
            border.width: 1
            border.color: "#288c98"
            implicitHeight: 40
            implicitWidth: 100
        }
    }

    Button {
        id: bt_03
        x: 700
        y: 350
        width: 130
        height: 45
        text: qsTr("03")
        font.pixelSize: 25
        font.family: domus.name
        contentItem: Text {
            color: bt_03.down ? "#ffffff" : "#fafafa"
            text: bt_03.text
            opacity: enabled ? 1.0 : 0.3
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            font: bt_03.font
            horizontalAlignment: Text.AlignHCenter
        }
        background: Rectangle {
            color: bt_03.down ? "#A6A6D9" : "#288c98"
            radius: 20
            opacity: enabled ? 1 : 0.3
            border.width: 1
            border.color: "#288c98"
            implicitHeight: 40
            implicitWidth: 100
        }
    }

    /* second line */
    Button {
        id: bt_04
        x: 400
        y: 400
        width: 130
        height: 45
        text: qsTr("04")
        font.family: domus.name
        font.pixelSize: 25

        contentItem: Text {
            text: bt_04.text
            font: bt_04.font
            opacity: enabled ? 1.0 : 0.3
            color: bt_04.down ? "#ffffff" : "#fafafa"
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
            color: bt_04.down ? "#A6A6D9" : "#288c98"
        }
    }

    Button {
        id: bt_05
        x: 550
        y: 400
        width: 130
        height: 45
        text: qsTr("05")
        font.pixelSize: 25
        font.family: domus.name
        contentItem: Text {
            color: bt_05.down ? "#ffffff" : "#fafafa"
            text: bt_05.text
            opacity: enabled ? 1.0 : 0.3
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            font: bt_05.font
            horizontalAlignment: Text.AlignHCenter
        }
        background: Rectangle {
            color: bt_05.down ? "#A6A6D9" : "#288c98"
            radius: 20
            opacity: enabled ? 1 : 0.3
            border.width: 1
            border.color: "#288c98"
            implicitHeight: 40
            implicitWidth: 100
        }
    }

    Button {
        id: bt_06
        x: 700
        y: 400
        width: 130
        height: 45
        text: qsTr("06")
        font.pixelSize: 25
        font.family: domus.name
        contentItem: Text {
            color: bt_06.down ? "#ffffff" : "#fafafa"
            text: bt_06.text
            opacity: enabled ? 1.0 : 0.3
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            font: bt_06.font
            horizontalAlignment: Text.AlignHCenter
        }
        background: Rectangle {
            color: bt_06.down ? "#A6A6D9" : "#288c98"
            radius: 20
            opacity: enabled ? 1 : 0.3
            border.width: 1
            border.color: "#288c98"
            implicitHeight: 40
            implicitWidth: 100
        }
    }

    /* third line */
    Button {
        id: bt_07
        x: 400
        y: 450
        width: 130
        height: 45
        text: qsTr("07")
        font.family: domus.name
        font.pixelSize: 25

        contentItem: Text {
            text: bt_07.text
            font: bt_07.font
            opacity: enabled ? 1.0 : 0.3
            color: bt_07.down ? "#ffffff" : "#fafafa"
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
            color: bt_07.down ? "#A6A6D9" : "#288c98"
        }
    }

    Button {
        id: bt_08
        x: 550
        y: 450
        width: 130
        height: 45
        text: qsTr("08")
        font.pixelSize: 25
        font.family: domus.name
        contentItem: Text {
            color: bt_08.down ? "#ffffff" : "#fafafa"
            text: bt_08.text
            opacity: enabled ? 1.0 : 0.3
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            font: bt_08.font
            horizontalAlignment: Text.AlignHCenter
        }
        background: Rectangle {
            color: bt_08.down ? "#A6A6D9" : "#288c98"
            radius: 20
            opacity: enabled ? 1 : 0.3
            border.width: 1
            border.color: "#288c98"
            implicitHeight: 40
            implicitWidth: 100
        }
    }

    Button {
        id: bt_09
        x: 700
        y: 450
        width: 130
        height: 45
        text: qsTr("09")
        font.pixelSize: 25
        font.family: domus.name
        contentItem: Text {
            color: bt_09.down ? "#ffffff" : "#fafafa"
            text: bt_09.text
            opacity: enabled ? 1.0 : 0.3
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            font: bt_09.font
            horizontalAlignment: Text.AlignHCenter
        }
        background: Rectangle {
            color: bt_09.down ? "#A6A6D9" : "#288c98"
            radius: 20
            opacity: enabled ? 1 : 0.3
            border.width: 1
            border.color: "#288c98"
            implicitHeight: 40
            implicitWidth: 100
        }
    }

    /* forth line */
    Button {
        id: bt_00
        x: 550
        y: 500
        width: 130
        height: 45
        text: qsTr("00")
        font.family: domus.name
        font.pixelSize: 25

        contentItem: Text {
            text: bt_00.text
            font: bt_00.font
            opacity: enabled ? 1.0 : 0.3
            color: bt_00.down ? "#ffffff" : "#fafafa"
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
            color: bt_00.down ? "#A6A6D9" : "#288c98"
        }
    }

    Button {
        id: bt_enter
        x: 400
        y: 500
        width: 130
        height: 45
        text: qsTr("ENT")
        font.pixelSize: 25
        font.family: domus.name
        contentItem: Text {
            color: bt_enter.down ? "#ffffff" : "#fafafa"
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
    }

    Button {
        id: bt_cancel
        x: 700
        y: 500
        width: 130
        height: 45
        text: qsTr("CAN")
        font.pixelSize: 25
        font.family: domus.name
        contentItem: Text {
            color: bt_cancel.down ? "#ffffff" : "#fafafa"
            text: bt_cancel.text
            opacity: enabled ? 1.0 : 0.3
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            font: bt_cancel.font
            horizontalAlignment: Text.AlignHCenter
        }
        background: Rectangle {
            color: bt_cancel.down ? "#ffb3ff" : "#ff66ff"
            radius: 20
            opacity: enabled ? 1 : 0.3
            border.width: 1
            border.color: "#ff9900"
            implicitHeight: 40
            implicitWidth: 100
        }
    }

    Connections {
        target: bt_enter
        function onClicked() {
            if (security.verify_code) {
                stackView.push("management.qml")
            } else {
                security.code = ""
                stackView.push("home.qml")
            }
            drawer.close()
        }
    }

    Connections {
        target: bt_01
        function onClicked() {
            security.code += "1"
        }
    }

    Connections {
        target: bt_02
        function onClicked() {
            security.code += "2"
        }
    }

    Connections {
        target: bt_03
        function onClicked() {
            security.code += "3"
        }
    }

    Connections {
        target: bt_04
        function onClicked() {
            security.code += "4"
        }
    }

    Connections {
        target: bt_05
        function onClicked() {
            security.code += "5"
        }
    }

    Connections {
        target: bt_06
        function onClicked() {
            security.code += "6"
        }
    }

    Connections {
        target: bt_07
        function onClicked() {
            security.code += "7"
        }
    }

    Connections {
        target: bt_08
        function onClicked() {
            security.code += "8"
        }
    }

    Connections {
        target: bt_09
        function onClicked() {
            security.code += "9"
        }
    }

    Connections {
        target: bt_00
        function onClicked() {
            security.code += "0"
        }
    }

    Connections {
        target: bt_cancel
        function onClicked() {
            security.code = ""
        }
    }

    Text {
        id: title
        x: 50
        y: 50
        width: 189
        height: 48
        color: "#6fa538"
        text: qsTr("HOME CONTROL")
        font.pixelSize: 38
        font.family: domus.name
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
    }
}

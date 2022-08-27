import QtQuick 2.12
import QtQuick.Controls 2.12

Page {
    id: page
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

        FontLoader { id: domus; source: "assets/domus.ttf" }

        Image {
            id: image
            x: 598
            y: 276
            width: 600
            height: 600
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            opacity: 0.4
            fillMode: Image.PreserveAspectFit
            source: "images/circle.svg"
        }
    }

    Text {
        id: title
        x: 50
        y: 50
        width: 437
        height: 48
        color: "#6fa538"
        text: qsTr("HOME CONTROL")
        font.pixelSize: 38
        font.family: domus.name
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
    }

    Button {
        id: bt_sensors
        x: 299
        y: 230
        width: 200
        height: 200
        text: qsTr("SENSORS")
        font.pixelSize: 25
        font.family: domus.name
        contentItem: Text {
            color: bt_sensors.down ? "#ffffff" : "#ffff00"
            text: bt_sensors.text
            opacity: enabled ? 1.0 : 0.3
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            font: bt_sensors.font
            horizontalAlignment: Text.AlignHCenter
        }
        background: Rectangle {
            color: bt_sensors.down ? "#007F05" : "#007b05"
            radius: 100
            opacity: enabled ? 1 : 0.3
            border.width: 10
            border.color: "#004f05"
            implicitHeight: 40
            implicitWidth: 100
        }
    }

    Button {
        id: bt_security
        x: 426
        y: 771
        width: 230
        height: 230
        text: qsTr("SECURITY")
        font.pixelSize: 25
        font.family: domus.name
        contentItem: Text {
            color: bt_security.down ? "#ffffff" : "#ffff00"
            text: bt_security.text
            opacity: enabled ? 1.0 : 0.3
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            font: bt_security.font
            horizontalAlignment: Text.AlignHCenter
        }
        background: Rectangle {
            color: bt_security.down ? "#007F05" : "#007b05"
            radius: 115
            opacity: enabled ? 1 : 0.3
            border.width: 10
            border.color: "#004f05"
            implicitHeight: 40
            implicitWidth: 100
        }
    }

    Button {
        id: bt_lights
        x: 96
        y: 464
        width: 180
        height: 180
        text: qsTr("LIGHTS")
        font.pixelSize: 25
        font.family: domus.name
        contentItem: Text {
            color: bt_lights.down ? "#ffffff" : "#ffff00"
            text: bt_lights.text
            opacity: enabled ? 1.0 : 0.3
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            font: bt_security.font
            horizontalAlignment: Text.AlignHCenter
        }
        background: Rectangle {
            color: bt_lights.down ? "#007F05" : "#007b05"
            radius: 90
            opacity: enabled ? 1 : 0.3
            border.width: 10
            border.color: "#004f05"
            implicitHeight: 40
            implicitWidth: 100
        }
    }

    Button {
        id: bt_heat_system
        x: 1321
        y: 96
        width: 310
        height: 310
        text: qsTr("SECURITY")
        contentItem: Text {
            width: 214
            height: 218
            color: bt_heat_system.down ? "#ffffff" : "#ffff00"
            text: "HEAT SYSTEM"
            verticalAlignment: Text.AlignVCenter
            opacity: enabled ? 1.0 : 0.3
            horizontalAlignment: Text.AlignHCenter
            font: bt_heat_system.font
            elide: Text.ElideRight
        }
        font.family: domus.name
        background: Rectangle {
            color: bt_heat_system.down ? "#007F05" : "#007b05"
            radius: 155

            implicitWidth: 100
            opacity: enabled ? 1 : 0.3
            border.color: "#004f05"
            border.width: 10
            implicitHeight: 40
        }
        font.pixelSize: 25
    }

    Text {
        id: avg_temperature
        x: 1487
        y: 435
        width: 350
        height: 20
        color: "#6fa538"
        text: qsTr("AVG TEMPERATURE: 30ª")
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
    }

    Text {
        id: heat_system_status
        x: 1487
        y: 461
        width: 350
        height: 20
        color: "#6fa538"
        text: qsTr("HEAT SYSTEM STATUS: ON")
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
    }

    Text {
        id: security_system_status
        x: 155
        y: 672
        width: 375
        height: 19
        color: "#6fa538"
        text: qsTr("SECURITY SYSTEM: DISARMED")
        horizontalAlignment: Text.AlignRight
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
    }

    Text {
        id: gas_alarm_status
        x: 1487
        y: 487
        width: 350
        height: 20
        color: "#6fa538"
        text: qsTr("GAS ALARM: NORMAL LEVEL")
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
    }

    Text {
        id: central_control_status
        x: 971
        y: 894
        width: 382
        height: 20
        color: "#6fa538"
        text: qsTr("CENTRAL CONTROL: CONNECTED")
        horizontalAlignment: Text.AlignLeft
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
    }

    Text {
        id: ip_addresses
        x: 971
        y: 920
        width: 382
        height: 20
        color: "#6fa538"
        text: qsTr("192.68.1.20 - 85.234.200.34")
        horizontalAlignment: Text.AlignLeft
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
    }

    Text {
        id: ping_control
        x: 971
        y: 946
        width: 382
        height: 20
        color: "#6fa538"
        text: qsTr("PING: 23455")
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
        horizontalAlignment: Text.AlignLeft
    }

    Text {
        id: central_control_status_01
        x: 971
        y: 96
        width: 105
        height: 14
        color: "#6fa538"
        text: qsTr("343944")
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
        horizontalAlignment: Text.AlignLeft
    }

    Text {
        id: central_control_status_02
        x: 971
        y: 116
        width: 105
        height: 14
        color: "#6fa538"
        text: qsTr("12933")
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
        horizontalAlignment: Text.AlignLeft
    }

    Text {
        id: central_control_status_04
        x: 971
        y: 158
        width: 105
        height: 14
        color: "#6fa538"
        text: qsTr("1234")
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
        horizontalAlignment: Text.AlignLeft
    }

    Text {
        id: central_control_status_03
        x: 971
        y: 136
        width: 105
        height: 16
        color: "#6fa538"
        text: qsTr("124456")
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
        horizontalAlignment: Text.AlignLeft
    }

    Text {
        id: central_control_status_05
        x: 1082
        y: 96
        width: 105
        height: 14
        color: "#6fa538"
        text: qsTr("21")
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
        horizontalAlignment: Text.AlignLeft
    }

    Text {
        id: central_control_status_06
        x: 1082
        y: 116
        width: 105
        height: 14
        color: "#6fa538"
        text: qsTr("23664")
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
        horizontalAlignment: Text.AlignLeft
    }

    Text {
        id: central_control_status_08
        x: 1082
        y: 158
        width: 105
        height: 14
        color: "#6fa538"
        text: qsTr("43666")
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
        horizontalAlignment: Text.AlignLeft
    }

    Text {
        id: central_control_status_07
        x: 1082
        y: 136
        width: 105
        height: 16
        color: "#6fa538"
        text: qsTr("254334")
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
        horizontalAlignment: Text.AlignLeft
    }

    Text {
        id: central_control_status_09
        x: 1193
        y: 96
        width: 105
        height: 14
        color: "#6fa538"
        text: qsTr("102")
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
        horizontalAlignment: Text.AlignLeft
    }

    Text {
        id: central_control_status_10
        x: 1193
        y: 116
        width: 105
        height: 14
        color: "#6fa538"
        text: qsTr("2O32")
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
        horizontalAlignment: Text.AlignLeft
    }

    Text {
        id: central_control_status_12
        x: 1193
        y: 158
        width: 105
        height: 14
        color: "#6fa538"
        text: qsTr("23O9")
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
        horizontalAlignment: Text.AlignLeft
    }

    Text {
        id: central_control_status_11
        x: 1193
        y: 136
        width: 105
        height: 16
        color: "#6fa538"
        text: qsTr("1000")
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
        horizontalAlignment: Text.AlignLeft
    }

    Rectangle {
        id: bar_01
        x: 955
        y: 84
        width: 10
        height: 899
        color: "#ffff44"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle {
        id: bar_02
        x: 1471
        y: 406
        width: 10
        height: 99
        color: "#ffff44"
    }

    Rectangle {
        id: bar_03
        x: 956
        y: 90
        width: 10
        height: 899
        color: "#ffff44"
        rotation: 90
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle {
        id: bar_04
        x: 536
        y: 665
        width: 10
        height: 106
        color: "#ffff44"
    }

    Text {
        id: front_door
        x: 155
        y: 697
        width: 375
        height: 19
        color: "#6fa538"
        text: qsTr("FRONT DOOR: CLOSED")
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
        horizontalAlignment: Text.AlignRight
    }

    Text {
        id: garage_gate
        x: 155
        y: 722
        width: 375
        height: 19
        color: "#6fa538"
        text: qsTr("GARAGE GATE: CLOSED")
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
        horizontalAlignment: Text.AlignRight
    }

}

import QtQuick 2.12
import QtQuick.Controls 2.12

Page {
    id: page
    width: 1920
    height: 1080

    Image {
        id: background_pg
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent
        opacity: 0.8
        layer.format: ShaderEffectSource.RGBA
        layer.smooth: false
        layer.mipmap: false
        clip: false
        visible: true
        source: "images/management.svg"
        enabled: false
        fillMode: Image.PreserveAspectFit

        Image {
            id: rotor2
            x: 630
            y: 170
            width: 1017
            height: 971
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "images/rotor2.svg"
            fillMode: Image.PreserveAspectFit
            RotationAnimation on rotation {
                loops: Animation.Infinite
                from: 0
                to: 360
                target: rotor2
                duration: 40000
            }
        }

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

        Image {
            id: rotor1
            x: 582
            y: 277
            width: 684
            height: 684
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            source: "images/rotor.svg"
            fillMode: Image.PreserveAspectFit
            RotationAnimation on rotation {
                loops: Animation.Infinite
                from: 360
                to: 0
                duration: 8000
                target: rotor1
            }

            Image {
                id: center_disc
                x: 142
                y: 132
                width: 500
                height: 500
                opacity: 1
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                source: "images/center_disc.svg"
                fillMode: Image.PreserveAspectFit
            }
        }

    }

    Text {
        id: title
        x: 180
        y: 58
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
        x: 189
        y: 240
        width: 300
        height: 50
        text: qsTr("SENSORS")
        font.pixelSize: 25
        font.family: domus.name
        contentItem: Text {
            color: bt_sensors.down ? "#ddff55" : "#aad400"
            text: bt_sensors.text
            opacity: enabled ? 1.0 : 0.3
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            font: bt_sensors.font
            horizontalAlignment: Text.AlignHCenter
        }
        background: Rectangle {
            color: bt_sensors.down ? "#6b9800" : "#668000"
            radius: 100
            opacity: enabled ? 1 : 0.3
            border.width: 1
            border.color: "#288c98"
            implicitHeight: 40
            implicitWidth: 100
        }
    }

    Button {
        id: bt_security
        x: 189
        y: 402
        width: 300
        height: 50
        text: qsTr("SECURITY")
        font.pixelSize: 25
        font.family: domus.name
        contentItem: Text {
            color: bt_security.down ? "#ddff55" : "#aad400"
            text: bt_security.text
            opacity: enabled ? 1.0 : 0.3
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            font: bt_security.font
            horizontalAlignment: Text.AlignHCenter
        }
        background: Rectangle {
            color: bt_security.down ? "#6b9800" : "#668000"
            radius: 115
            opacity: enabled ? 1 : 0.3
            border.width: 1
            border.color: "#004f05"
            implicitHeight: 40
            implicitWidth: 100
        }
    }

    Button {
        id: bt_lights
        x: 189
        y: 294
        width: 300
        height: 50
        text: qsTr("LIGHTS")
        font.pixelSize: 25
        font.family: domus.name
        contentItem: Text {
            height: 164
            color: bt_lights.down ? "#ddff55" : "#aad400"
            text: bt_lights.text
            opacity: enabled ? 1.0 : 0.3
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            font: bt_security.font
            horizontalAlignment: Text.AlignHCenter
        }
        background: Rectangle {
            color: bt_lights.down ? "#6b9800" : "#668000"
            radius: 90
            opacity: enabled ? 1 : 0.3
            border.width: 1
            border.color: "#004f05"
            implicitHeight: 40
            implicitWidth: 100
        }
    }

    Button {
        id: bt_heat_system
        x: 156
        y: 564
        width: 120
        height: 120
        text: qsTr("HEAT SYSTEM")
        Image {
            x: 0
            y: 0
            width:120
            height:120
            id: icon
            source: "images/button_bg.svg"
        }
        contentItem: Text {
            width: 214
            height: 218
            color: bt_heat_system.down ? "#ddff55" : "#aad400"
            text: "HEAT SYSTEM"
            wrapMode: Text.WordWrap
            verticalAlignment: Text.AlignVCenter
            opacity: enabled ? 1.0 : 0.3
            horizontalAlignment: Text.AlignHCenter
            font: bt_heat_system.font
            elide: Text.ElideRight
        }
        font.family: domus.name
        background: Rectangle {
            color: bt_heat_system.down ? "#6b9800" : "#668000"
            radius: 155
            implicitWidth: 100
            opacity: enabled ? 1 : 0.3
            border.color: "#004f05"
            border.width: 1
            implicitHeight: 40
        }
        font.pixelSize: 15
    }

    Button {
        id: bt_energy
        x: 189
        y: 456
        width: 300
        height: 50
        text: qsTr("ENERGY")
        background: Rectangle {
            color: bt_energy.down ? "#6b9800" : "#668000"
            radius: 155
            implicitHeight: 40
            border.width: 1
            implicitWidth: 100
            opacity: enabled ? 1 : 0.3
            border.color: "#004f05"
        }
        font.family: domus.name
        font.pixelSize: 25
        contentItem: Text {
            width: 230
            height: 230
            color: bt_energy.down ? "#ddff55" : "#aad400"
            text: "ENERGY"
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            opacity: enabled ? 1.0 : 0.3
            verticalAlignment: Text.AlignVCenter
            font: bt_energy.font
        }
    }

    Button {
        id: bt_outlets
        x: 189
        y: 347
        width: 300
        height: 50
        text: qsTr("OUTLETS")
        background: Rectangle {
            color: bt_outlets.down ? "#6b9800" : "#668000"
            radius: 155
            implicitHeight: 40
            border.width: 1
            implicitWidth: 100
            opacity: enabled ? 1 : 0.3
            border.color: "#004f05"

        }
        font.family: domus.name
        font.pixelSize: 25
        contentItem: Text {
            width: 230
            height: 230
            color: bt_outlets.down ? "#ddff55" : "#aad400"
            text: "OUTLETS"
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            opacity: enabled ? 1.0 : 0.3
            verticalAlignment: Text.AlignVCenter
            font: bt_outlets.font
        }
    }

    Button {
        id: bt_back
        x: 157
        y: 923
        width: 100
        height: 100
        text: qsTr("CODE")
        Image {
            x: 0
            y: 0
            width:100
            height:100
            id: icon_heat_system
            source: "images/button_bg.svg"
        }
        font.family: domus.name
        contentItem: Text {
            color: bt_back.down ? "#ddff55" : "#aad400"
            text: "ENT"
            elide: Text.ElideRight
            opacity: enabled ? 1.0 : 0.3
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font: bt_back.font
        }
        background: Rectangle {
            color: bt_back.down ? "#6b9800" : "#668000"
            radius: 100
            border.color: "#288c98"
            border.width: 1
            implicitHeight: 40
            opacity: enabled ? 1 : 0.3
            implicitWidth: 100
        }
        font.pixelSize: 25
        onClicked: {
            stackView.push("pass_code_page.qml")
            drawer.close()
        }
    }

    Text {
        id: avg_temperature
        x: 1413
        y: 609
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
        x: 1413
        y: 635
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
        x: 1413
        y: 452
        width: 375
        height: 19
        color: "#6fa538"
        text: qsTr("SECURITY SYSTEM: DISARMED")
        horizontalAlignment: Text.AlignLeft
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
    }

    Text {
        id: gas_alarm_status
        x: 1413
        y: 583
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
        x: 769
        y: 512
        width: 382
        height: 20
        color: "#646464"
        text: qsTr("CENTRAL CONTROL: CONNECTED")
        horizontalAlignment: Text.AlignLeft
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
    }

    Text {
        id: ip_addresses
        x: 769
        y: 538
        width: 382
        height: 20
        color: "#646464"
        text: qsTr("192.68.1.20 - 85.234.200.34")
        horizontalAlignment: Text.AlignLeft
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
    }

    Text {
        id: ping_control
        x: 769
        y: 564
        width: 382
        height: 20
        color: "#646464"
        text: qsTr("PING: 23455")
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
        horizontalAlignment: Text.AlignLeft
    }

    Text {
        id: central_control_status_01
        x: 856
        y: 917
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
        x: 856
        y: 937
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
        x: 856
        y: 979
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
        x: 856
        y: 957
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
        x: 967
        y: 917
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
        x: 967
        y: 937
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
        x: 967
        y: 979
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
        x: 967
        y: 957
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
        x: 1078
        y: 917
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
        x: 1078
        y: 937
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
        x: 1078
        y: 979
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
        x: 1078
        y: 957
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

    Text {
        id: front_door
        x: 1413
        y: 477
        width: 375
        height: 19
        color: "#6fa538"
        text: qsTr("FRONT DOOR: CLOSED")
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
        horizontalAlignment: Text.AlignLeft
    }

    Text {
        id: garage_gate
        x: 1413
        y: 502
        width: 375
        height: 19
        color: "#6fa538"
        text: qsTr("GARAGE GATE: CLOSED")
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
        font.family: domus.name
        font.pixelSize: 15
        horizontalAlignment: Text.AlignLeft
    }

}

import QtQuick 2.12
import QtQuick.Controls 2.12

Page {
    id: page
    width: 1920
    height: 1080

    Image {
        id: background_pg
        opacity: 0.8
        layer.format: ShaderEffectSource.RGBA
        layer.smooth: false
        layer.mipmap: false
        clip: false
        visible: true
        anchors.fill: parent
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
        x: 191
        y: 142
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
        x: 1423
        y: 761
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
        y: 518
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
        x: 1451
        y: 152
        width: 230
        height: 230
        text: qsTr("SECURITY")
        contentItem: Text {
            width: 214
            height: 218
            color: bt_heat_system.down ? "#ffffff" : "#ffff00"
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
        x: 1417
        y: 97
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
        x: 1417
        y: 123
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
        x: 1501
        y: 671
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
        x: 1417
        y: 71
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
        x: 135
        y: 359
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
        x: 135
        y: 379
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
        x: 135
        y: 421
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
        x: 135
        y: 399
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
        x: 246
        y: 359
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
        x: 246
        y: 379
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
        x: 246
        y: 421
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
        x: 246
        y: 399
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
        x: 357
        y: 359
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
        x: 357
        y: 379
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
        x: 357
        y: 421
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
        x: 357
        y: 399
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
        x: 1501
        y: 696
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
        x: 1501
        y: 721
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

    Button {
        id: bt_energy
        x: 1607
        y: 379
        width: 200
        height: 200
        text: qsTr("ENERGY")
        background: Rectangle {
            color: bt_energy.down ? "#007F05" : "#007b05"
            radius: 155
            implicitHeight: 40
            border.width: 10
            implicitWidth: 100
            opacity: enabled ? 1 : 0.3
            border.color: "#004f05"
        }
        font.family: domus.name
        font.pixelSize: 25
        contentItem: Text {
            width: 230
            height: 230
            color: bt_energy.down ? "#ffffff" : "#ffff00"
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
        id: bt_energy1
        x: 293
        y: 708
        width: 220
        height: 220
        text: qsTr("ENERGY")
        background: Rectangle {
            color: bt_energy1.down ? "#007F05" : "#007b05"
            radius: 155
            implicitHeight: 40
            border.width: 10
            implicitWidth: 100
            opacity: enabled ? 1 : 0.3
            border.color: "#004f05"
        }
        font.family: domus.name
        font.pixelSize: 25
        contentItem: Text {
            width: 230
            height: 230
            color: bt_energy1.down ? "#ffffff" : "#ffff00"
            text: "OUTLETS"
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            opacity: enabled ? 1.0 : 0.3
            verticalAlignment: Text.AlignVCenter
            font: bt_energy1.font
        }
    }

}

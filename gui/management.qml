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

        FontLoader {
            id: swiss2
            source: "assets/swiss2.ttf"
        }

        FontLoader {
            id: swiss911
            source: "assets/swiss911.ttf"
        }
    }

    Text {
        id: element
        x: 157
        y: 76
        width: 189
        height: 48
        color: "#288c98"
        text: qsTr("HOME CONTROL")
        font.pixelSize: 50
        font.family: swiss2.name
        font.weight: Font.ExtraLight
        styleColor: "#ff6600"
    }
}

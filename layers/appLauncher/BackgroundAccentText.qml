import QtQuick
import QtQuick.Effects
import "../.."

Item {
    id: item
    property string text
    Text {
        id: text
        color: "white"
        font.family: Config.fontSerif.font.family
        font.pixelSize: 48
        font.italic: Math.random() > 0.5 ? true : false
        text: item.text
        rotation: {
            return Math.random() * 5 - 2.5;
        }
        visible: false
    }

    MultiEffect {
        anchors.fill: text
        source: text
        blurEnabled: true
        blur: 1.0
        blurMax: 4
    }
}

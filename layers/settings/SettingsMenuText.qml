import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import "../.."

Rectangle {
    id: root
    color: "transparent"
    required property string text
    property bool hovered: false
    implicitHeight: text.height
    Text {
        id: text
        text: root.text
        color: Config.settings.menuTextColor
        horizontalAlignment: Text.AlignHCenter
        font.family: Config.fontBlocky.font.family
        font.pointSize: Config.settings.menuTextSize
        font.bold: false
        font.italic: root.hovered
        font.underline: root.hovered
        width: root.implicitWidth
        font.letterSpacing: 2
    }

    MultiEffect {
        anchors.fill: text
        source: text
        blurEnabled: true
        blur: 1.0
        brightness: 1.0
        contrast: 1.0
        blurMax: 1
        blurMultiplier: 30.0
        visible: root.hovered
    }
}

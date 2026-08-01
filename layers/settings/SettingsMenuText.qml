
import Quickshell.Widgets
import QtQuick
import "../.."

WrapperRectangle {
    color: "transparent"
    id: root
    required property string text
    property bool hovered: false
    Text {
        text: root.text
        color: Config.settings.menuTextColor
        horizontalAlignment: Text.AlignHCenter
        font.family: Config.fontBlocky.font.family
        font.pixelSize: 64 // TODO theme or base on screen height
        font.bold: false
        font.italic: root.hovered
        font.letterSpacing: 2
    }
}

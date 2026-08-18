import Quickshell.Networking
import Quickshell.Widgets
import QtQuick
import "../../.."

WrapperMouseArea {
    id: root
    required property NetworkDevice networkDevice
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true
    property real verticalMargin: connectText.font.pixelSize * (containsMouse ? 0.5 : 1.0)
    property int marginAnimDuration: 50
    topMargin: verticalMargin
    bottomMargin: verticalMargin
    rightMargin: connectText.font.pixelSize
    Behavior on topMargin {
        NumberAnimation {
            duration: root.marginAnimDuration
        }
    }
    Behavior on bottomMargin {
        NumberAnimation {
            duration: root.marginAnimDuration
        }
    }
    WrapperRectangle {
        color: Config.networkSettings.connectionButtonBackgroundColor
        margin: connectText.font.pixelSize / 2
        border.width: 2
        border.color: Config.networkSettings.connectionButtonBorderColor
        Text {
            id: connectText
            verticalAlignment: Text.AlignVCenter
            text: modelData.connected ? "DISCONNECT" : "CONNECT"
            font.pointSize: Config.networkSettings.deviceTextSize
            font.family: Config.fontTypewriter.font.family
            font.underline: root.containsMouse
            font.bold: root.containsMouse
        }
    }
}

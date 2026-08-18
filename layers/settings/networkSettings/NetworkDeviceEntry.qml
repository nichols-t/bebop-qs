import Quickshell.Networking
import QtQuick
import QtQuick.Layouts
import "../../.."

Rectangle {
    required property NetworkDevice networkDevice
    property real margin: 0.05 * panel.width
    Layout.leftMargin: margin
    color: Config.networkSettings.accentColor
    width: panel.width - 2 * margin
    height: panel.height
    RowLayout {
        anchors.fill: parent
        anchors.centerIn: parent
        NetworkDetailsText {
            networkDevice: modelData
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            Layout.leftMargin: font.pixelSize
        }

        Item {
            Layout.fillWidth: true
        }

        ConnectToggleButton {
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignRight
            networkDevice: modelData
        }
    }
}

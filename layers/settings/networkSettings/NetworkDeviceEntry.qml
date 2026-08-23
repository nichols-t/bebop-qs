import Quickshell.Networking
import QtQuick
import Quickshell.Widgets
import QtQuick.Layouts
import "../../.."

WrapperRectangle {
    required property NetworkDevice networkDevice
    color: Config.networkSettings.accentColor
    margin: text.font.pixelSize

    RowLayout {
        anchors.fill: parent
        anchors.centerIn: parent
        NetworkDetailsText {
            id: text
            networkDevice: modelData
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            Layout.leftMargin: font.pixelSize
        }

        Item {
            Layout.fillWidth: true
        }

        // TODO: This isn't implemented yet and I'm debating if that's a good idea or not
        ConnectToggleButton {
            visible: false
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignRight
            networkDevice: modelData
        }
    }
}

import Quickshell.Networking
import QtQuick
import QtQuick.Layouts
import ".."
import "./settings"
import "./settings/networkSettings"

SettingsSubMenu {
    title: "NETWORK"

    content: Component {
        
        ColumnLayout {
            id: cols
            anchors.top: parent.top
            anchors.topMargin: Config.networkSettings.deviceTextSize
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                visible: Networking.devices.values.length === 0
                text: "No Network Devices"
                color: "white"
                font.italic: true
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                font.family: Config.fontTypewriter.font.family
                font.pointSize: 18
            }

            Repeater {
                model: Networking.devices

                NetworkDeviceEntry {
                    Layout.alignment: Qt.AlignHCenter
                    required property var modelData
                    networkDevice: modelData
                    implicitWidth: cols.width * 0.9
                }
            }
        }
    }
}
import Quickshell
import Quickshell.Io
import Quickshell.Bluetooth
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import ".."
import "./settings"
import "./settings/bluetoothSettings"

SettingsSubMenu {
    title: "BLUETOOTH"

    content: Component {
        ColumnLayout {
            id: cols
            anchors.centerIn: parent

            Text {
                visible: Bluetooth.defaultAdapter == null
                text: "No Bluetooth Adapter"
                color: "white"
                font.italic: true
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                font.family: Config.fontTypewriter.font.family
                font.pointSize: 18
            }

            Repeater {
                model: Bluetooth.devices

                WrapperMouseArea {
                    required property var modelData
                    Layout.alignment: Qt.AlignCenter | Qt.AlignTop
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (modelData.paired) {
                            modelData.connected = !modelData.connected;
                        }
                    }

                    BluetoothDeviceEntry {
                        implicitWidth: cols.width * 0.9
                        device: modelData
                    }
                }
            }
        }
    }
}

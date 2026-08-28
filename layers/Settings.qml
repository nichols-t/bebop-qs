import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Bluetooth
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Hyprland
import "../"
import "./settings"

SettingsSubMenu {
    id: root

    title: "SETTINGS"
    property SystemInfo systemInfo
    property ShutdownMenu shutdownMenu
    property AudioSettings audioSettings
    property BluetoothSettings bluetoothSettings
    property NetworkSettings networkSettings

    content: Component {
        ColumnLayout {
            id: cols
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.fill: parent

            focus: true

            Item {
                implicitHeight: root.screen.height * 0.05
                Layout.fillHeight: true
            }
            SettingsMenuButton {
                text: "SYSTEM INFO"
                Layout.fillHeight: true
                Layout.fillWidth: true
                onClicked: () => {
                    root.systemInfo.shouldShow = true;
                }
            }

            SettingsMenuButton {
                text: "AUDIO"
                Layout.fillHeight: true
                Layout.fillWidth: true
                onClicked: () => {
                    root.audioSettings.show();
                }
            }

            SettingsMenuButton {
                visible: Bluetooth.defaultAdapter != null
                text: "BLUETOOTH"
                Layout.fillHeight: true
                Layout.fillWidth: true
                onClicked: () => {
                    root.bluetoothSettings.show();
                }
            }

            SettingsMenuButton {
                text: "NETWORK"
                Layout.fillHeight: true
                Layout.fillWidth: true
                onClicked: () => {
                    root.networkSettings.show();
                }
            }

            SettingsMenuButton {
                text: "NIXOS CONFIGS"
                Layout.fillHeight: true
                Layout.fillWidth: true
                onClicked: () => {
                    nixCfgsProcess.startDetached();
                    root.close();
                }
            }

            Process {
                id: nixCfgsProcess
                running: false
                command: Config.settings.nixConfigCmd
            }

            SettingsMenuButton {
                text: "POWER"
                Layout.fillHeight: true
                Layout.fillWidth: true
                onClicked: () => {
                    root.shutdownMenu.shouldShow = true;
                }
            }

            Item {
                implicitHeight: root.screen.height / 2
                Layout.fillHeight: true
            }

            // TODO fill it with some description or something maybe
            // WrapperRectangle {
            //     Layout.fillWidth: true
            //     Layout.alignment: Qt.AlignBottom
            //     implicitHeight: root.screen.height / 2
            //     color: "transparent"
            //     Text {
            //         text: "A ASDFASD"
            //         horizontalAlignment: Text.AlignHCenter
            //         verticalAlignment: Text.AlignVCenter
            //         font.family: Config.fontBlocky.font.family
            //         font.pointSize: root.screen.height * 0.01
            //     }
            // }
        }
    }
}

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
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            
            focus: true

            SettingsMenuButton {
                text: "SYSTEM INFO"
                Layout.fillWidth: true
                onClicked: () => {
                    root.systemInfo.shouldShow = true;
                }
            }

            SettingsMenuButton {
                text: "AUDIO"
                Layout.fillWidth: true
                onClicked: () => {
                    root.audioSettings.show();
                }
            }

            SettingsMenuButton {
                visible: Bluetooth.defaultAdapter != null
                text: "BLUETOOTH"
                Layout.fillWidth: true
                onClicked: () => {
                    root.bluetoothSettings.show();
                }
            }

            SettingsMenuButton {
                text: "NETWORK"
                Layout.fillWidth: true
                onClicked: () => {
                    root.networkSettings.show();
                }
            }

            SettingsMenuButton {
                text: "NIXOS CONFIGS"
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
                Layout.fillWidth: true
                onClicked: () => {
                    root.shutdownMenu.shouldShow = true;
                }
            }
        }
    }
}

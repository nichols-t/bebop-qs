import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Hyprland
import "../"
import "./settings"

Scope {
    id: root
    required property var screen
    property bool shouldShow: false

    function show() {
        shouldShow = true;
        panel.show();
    }

    function close() {
        shouldShow = false;
    }

    function beginClose() {
        panel.close();
    }

    property SystemInfo systemInfo
    property ShutdownMenu shutdownMenu
    property AudioSettings audioSettings
    property BluetoothSettings bluetoothSettings
    property NetworkSettings networkSettings
    property ThemeSettings themeSettings

    PanelWindow {
        id: panel
        visible: shouldShow
        screen: root.screen

        color: Config.settings.backgroundColor
        anchors {
            top: true
            bottom: true
            right: true
        }

        margins.right: root.shouldShow ? 0 : -width

        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        implicitWidth: screen.width * 0.3
        Behavior on margins.right {
            SequentialAnimation {
                NumberAnimation {
                    duration: 100
                }
                ScriptAction {
                    script: {
                        if (panel.margins.right < 0) {
                            root.close();
                        }
                    }
                }
            }
        }

        function show() {
            margins.right = 0;
        }

        function close() {
            // This should trigger an animation that reset root.onClose when it is done
            panel.margins.right = -panel.width;
        }

        HyprlandFocusGrab {
            windows: [cols]
        }

        ColumnLayout {
            id: cols
            anchors.top: parent.top

            SettingsMenuTitleText {
                text: "SETTINGS"
            }

            Item {}

            SettingsMenuButton {
                text: "SYSTEM INFO"

                onClicked: () => {
                    root.systemInfo.shouldShow = true;
                }
            }

            SettingsMenuButton {
                text: "AUDIO"

                onClicked: () => {
                    root.audioSettings.show();
                }
            }

            SettingsMenuButton {
                text: "BLUETOOTH"

                onClicked: () => {
                    root.bluetoothSettings.show();
                }
            }

            SettingsMenuButton {
                text: "NETWORK"

                onClicked: () => {
                    root.networkSettings.show();
                }
            }

            SettingsMenuButton {
                text: "THEME"

                onClicked: () => {
                    root.themeSettings.show();
                }
            }

            SettingsMenuButton {
                text: "NIXOS CONFIGS"

                onClicked: () => {
                    nixCfgsProcess.startDetached();
                    root.beginClose();
                }
            }

            Process {
                id: nixCfgsProcess
                running: false
                command: Config.settings.nixConfigCmd
            }

            SettingsMenuButton {
                text: "POWER"

                onClicked: () => {
                    shutdownMenu.shouldShow = true;
                }
            }

            focus: true

            Keys.onPressed: event => {
                if (event.key === Qt.Key_Escape) {
                    event.accepted = true;
                    root.beginClose();
                }
            }
        }
    }
}

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../"
import "./settings"

Scope {
    id: root
    required property var modelData
    property bool shouldShow: false

    function onClose() {
        shouldShow = false;
    }

    property SystemInfo systemInfo
    property ShutdownMenu shutdownMenu

    PanelWindow {
        id: panel
        visible: shouldShow
        screen: modelData

        color: Config.settings.backgroundColor
        anchors {
            top: true
            bottom: true
            right: true
        }

        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        implicitWidth: !root.shouldShow ? 0 : screen.width * 0.3
        Behavior on implicitWidth {
            NumberAnimation {
                duration: 100
            }
        }

        ColumnLayout {
            id: cols
            anchors.top: parent.top
            anchors.topMargin: panel.height * 0.1

            // TODO heading and I am questioning my font choices

            SettingsMenuButton {
                text: "SYSTEM INFO"

                onClicked: () => {
                    root.systemInfo.shouldShow = true;
                }
            }

            SettingsMenuButton {
                text: "AUDIO"
            }

            SettingsMenuButton {
                text: "BLUETOOTH"
            }

            SettingsMenuButton {
                text: "NETWORK"
            }

            SettingsMenuButton {
                text: "THEME"
            }

            SettingsMenuButton {
                text: "NIXOS CONFIGS"

                onClicked: () => {
                    nixCfgsProcess.startDetached()
                    root.onClose()
                }
            }

            Process {
                id: nixCfgsProcess
                running: false
                command: ["code", "/etc/nixos"]
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
                    root.onClose();
                }
            }
        }
    }
}

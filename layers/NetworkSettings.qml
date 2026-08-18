import Quickshell
import Quickshell.Networking
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../"
import "./settings/networkSettings"

Scope {
    id: root
    required property var modelData
    property bool shouldShow: false

    function show() {
        shouldShow = true;
        panel.show();
    }

    function close() {
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

        ColumnLayout {
            anchors.top: parent.top
            anchors.topMargin: Config.networkSettings.deviceTextSize
            Text {
                id: titleText
                text: "NETWORK"
                color: "white"
                font.family: Config.fontBlocky.font.family
                Layout.fillWidth: true
                width: panel.width
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: Config.networkSettings.menuTitleTextSize
            }

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
                    required property var modelData
                    networkDevice: modelData
                }
            }

            focus: true

            Keys.onPressed: event => {
                if (event.key === Qt.Key_Escape) {
                    event.accepted = true;
                    panel.close();
                }
            }
        }
    }
}

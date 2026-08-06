import Quickshell
import Quickshell.Networking
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../"

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

        margins.right: root.shouldShow ? 0 : -width;

        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        implicitWidth: screen.width * 0.3
        Behavior on margins.right {
            SequentialAnimation {
                NumberAnimation {
                    duration: 100
                }
                ScriptAction {
                    script: {
                        if (panel.margins.right < 0) {
                            root.close()
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


        Text {
            id: titleText
            text: "NETWORK"
            color: "white"
            rotation: 90
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: -width / 3
            font.family: Config.fontBlocky.font.family
            font.pointSize: 60
        }

        ColumnLayout {
            anchors.top: parent.top
            anchors.topMargin: Config.networkSettings.deviceTextSize
            // TODO maybe repeat with empty cells?
            Repeater {
                model: Networking.devices

                Rectangle {
                    required property var modelData
                    Layout.leftMargin: text.font.pointSize
                    color: Config.networkSettings.accentColor
                    height: text.height + 2 * text.font.pointSize
                    width: panel.width - 2 * text.font.pointSize
                    Text {
                        id: text
                        text: {
                            const netType = modelData.type === DeviceType.Wifi ? 'WiFi' : 'Ethernet'
                            return `
                        Device Name: ${modelData.name} (${netType})
                        Is Connected: ${modelData.connected}
                        `
                        }
                        color: Config.networkSettings.deviceTextColor
                        font.pointSize: Config.networkSettings.deviceTextSize
                        font.family: Config.fontTypewriter.font.family
                    }
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

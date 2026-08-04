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

        ColumnLayout {

            Text {
                text: "NETWORK STUFF"
                color: "white"
            }

            Text {
                text: `Is wifi: ${Networking.wifiEnabled}`
                color: "white"
            }

            Text {
                // See quickshell.org/docs/v0.3.0/types/Quickshell.Networking/NetworkConnectivity/
                text: `Connectivity: ${Networking.connectivity}`
                color: "white"
            }

            Text {
                text: "Devices:"
                color: "white"
            }
            Repeater {
                model: Networking.devices

                Text {
                    required property var modelData
                    text: modelData.name
                    color: "white"
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

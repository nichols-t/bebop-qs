import Quickshell
import Quickshell.Io
import Quickshell.Bluetooth
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
            width: panel.width
            Text {
                id: titleText
                text: "BLUETOOTH"
                color: "white"
                font.family: Config.fontBlocky.font.family
                Layout.fillWidth: true
                width: panel.width
                horizontalAlignment: Text.AlignHCenter
                font.pointSize: Config.networkSettings.menuTitleTextSize
            }

            Repeater {
                model: Bluetooth.devices

                WrapperMouseArea {
                    required property var modelData
                    Layout.alignment: Qt.AlignCenter
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (modelData.paired) {
                            modelData.connected = !modelData.connected;
                        }
                    }

                    WrapperRectangle {
                        color: Config.bluetoothSettings.accentColor
                        margin: 10
                        implicitWidth: panel.width * 0.9

                        ColumnLayout {
                            // There is bunch of other stuff here, see
                            // https://quickshell.org/docs/v0.3.0/types/Quickshell.Bluetooth/BluetoothDevice/

                            Text {
                                text: modelData.name
                                color: Config.bluetoothSettings.deviceTextColor
                                font.family: Config.fontBlocky.font.family
                                font.pointSize: Config.bluetoothSettings.deviceTextSize
                            }
                            Text {
                                text: modelData.connected ? 'CONNECTED' : 'DISCONNECTED'
                                color: Config.bluetoothSettings.deviceTextColor
                                font.family: Config.fontBlocky.font.family
                                font.pointSize: Config.bluetoothSettings.deviceTextSize
                            }
                        }
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

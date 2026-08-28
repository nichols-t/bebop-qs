import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../"
import "../.."

Scope {
    id: root
    required property var screen
    required property string title
    property bool shouldShow: false
    property bool showAccentRect: false

    function show() {
        shouldShow = true;
        panel.show();
    }

    function close() {
        shouldShow = false;
    }

    property Component content

    HyprlandFocusGrab {
        windows: [panel]
    }

    PanelWindow {
        id: panel
        visible: shouldShow
        screen: root.screen

        color: "transparent"
        anchors {
            top: true
            bottom: true
            right: true
        }

        Component.onCompleted: {
            if (this.WlrLayershell != null) {
                this.WlrLayershell.layer = WlrLayer.Top;
                this.WlrLayershell.namespace = "settings";
            }
        }

        HyprlandFocusGrab {
            id: grab
            windows: [panel]
        }

        margins.right: root.shouldShow ? 0 : -width

        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        implicitWidth: screen.width
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

        Rectangle {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: parent.width * 0.3
            color: Config.settings.backgroundColor
            ColumnLayout {
                id: ccc
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: screen.width * 0.3
                SettingsMenuTitleText {
                    id: mm
                    Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                    text: root.title
                }

                Loader {
                    id: contentLoader
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                    sourceComponent: root.shouldShow ? content : null
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
}

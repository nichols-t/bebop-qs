import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland

import "../.."

Scope {
    id: root
    property bool shouldShow
    property var screen
    property var dayInfo
    property var date
    property real width
    property real height
    property color backgroundColor

    function reset() {
        shouldShow = false;
        dayInfo = false;
        date = false;
        backgroundColor = false;
    }

    PanelWindow {
        id: panel
        screen: root.screen
        visible: root.shouldShow
        color: root.backgroundColor

        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        implicitWidth: root.width + 1 // saw a weird glitch on the left that showed beneath so add 1 just in case
        implicitHeight: root.height

        ColumnLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            focus: true
            Keys.onPressed: event => {
                // close: Escape
                if (event.key === Qt.Key_Escape) {
                    event.accepted = true;
                    root.shouldShow = false;
                }
            }

            Text {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.topMargin: root.height / 18
                font.family: Config.fontBlocky.font.family
                font.pixelSize: root.height / 18
                text: date ? Qt.formatDateTime(date, 'dddd, MMMM dd yyyy') : ''
            }
            Repeater {
                model: dayInfo || []
                DayEventText {
                    required property var modelData
                    event: modelData
                    Layout.topMargin: root.height / 9
                    Layout.fillWidth: true
                    Layout.preferredWidth: width
                    width: root.implicitWidth * 0.9

                }
            }
        }

        MouseArea {
            id: backgroundMouseArea
            anchors.fill: parent
            onClicked: {
                root.shouldShow = false;
            }
        }
    }
}

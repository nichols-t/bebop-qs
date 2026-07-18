import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import Quickshell.Hyprland
import ".."

Scope {
    id: root
    property int panelDuration: 1500
    PanelWindow {
        color: '#f8ca24'
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
        anchors {
            top: true
            left: true
            bottom: true
            right: true
        }

        Rectangle {
            anchors.bottom: parent.bottom
            implicitWidth: parent.width
            implicitHeight: 400
            color: "black"
            z: 1
        }

        // TODO "frame" black rectangles on left/right
        // TODO better calculation for these bar that's more flexible for different screens

        Repeater {
            id: rep
            model: (parent.width / 50 * 2)
            Rectangle {
                anchors.top: parent.top
                implicitWidth: model.index % 2 === 0 ? 30 : 200
                implicitHeight: parent.height
                color: "black"
                visible: model.index % 2 === 0
                x: model.index * 100
            }
        }

        Text {
            id: mytext
            anchors.top: parent.top
            font {
                pixelSize: 100
            }
            x: parent.width
            text: "Some bebop related text to indicate that something has happened"
            Behavior on x {
                NumberAnimation { duration: root.panelDuration }
            }
            Timer {
                interval: 0; running: true; repeat: false
                onTriggered: mytext.x = -parent.width / 2
            }
        }
    }

    Timer {
        id: goodbyeTimer
        interval: root.panelDuration; running: true; repeat: false
        onTriggered: {
            Qt.quit();
        }
    }
}
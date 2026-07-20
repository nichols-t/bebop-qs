import QtQuick
import Quickshell.Widgets
import QtQuick.Layouts
import Quickshell.Hyprland
import ".."
import "../.."
import QtQuick.Shapes

// TODO not convinced this is good yet
Rectangle {
    id: root
    color: Config.taskbar.workspaces.backgroundColorWithWindows;
    anchors.left: parent
    // Want it to stop before the end of the workspace buttons so that
    // it covers the left side gap but does not appear on the right
    // TODO trig it to be exact?? Not sure how correct this is, figure out later perhaps
    //implicitWidth: rows.width - Config.taskbar.taskbarHeight * Math.cos(35 * (Math.PI/180)) + 3
    implicitWidth: rows.width
    radius: 2
    z: 0
    implicitHeight: Config.taskbar.taskbarHeight
    RowLayout {
        id: rows
        spacing: 0
        z: 2

        Repeater {
            model: 6

            Rectangle {
                id: wsButton
                Layout.topMargin: -Config.taskbar.taskbarHeight - border.width - 2
                radius: 2
                color: {
                    // TODO there is an interesting effect in the credits where it inverts
                    // lighten/darken depending on # of layers... see if I can get that
                    if (isActive) {
                        return Config.taskbar.workspaces.backgroundColorActive;
                    } else if (hasWindows) {
                        return Config.taskbar.workspaces.backgroundColorWithWindows;
                    } else {
                        return Config.taskbar.workspaces.backgroundColorInactive;
                    }
                }
                y: -100
                border.width: 2
                border.color: "#250000"
                // TODO more interesting to rotate on index here, but need to figure out
                // how I can do that properly...
                rotation: 35
                required property var modelData
                required property int index
                property var hasWindows: Hyprland.workspaces.values.find(w => w.id === index + 1)
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

                property bool isHovered: false
                // Creates a shape that is the right size for bounds of a regular hexagon
                height: Config.taskbar.taskbarHeight * 2
                width: Config.taskbar.taskbarHeight

                Text {
                    id: label
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: 4
                    anchors.bottomMargin: 2
                    rotation: -wsButton.rotation
                    text: index + 1
                    // If the weight is wrong it just doesn't load, so just read weight directly from the
                    // file that we imported
                    font {
                        family: Config.fontTypewriter.font.family
                        bold: isActive
                        pixelSize: Config.taskbar.workspaces.fontSize +( isActive ? 1 : 0)
                    }

                    color: {
                        if (isActive)
                            return Config.taskbar.workspaces.textColorActive;
                        if (hasWindows)
                            return Config.taskbar.workspaces.textColorWithWindows;
                        return Config.taskbar.workspaces.textColorInactive;
                    }
                }
                MouseArea {
                    anchors.fill: wsButton
                    // Lua version is uncommented. If hyprland config is old switch to that other one
                    onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + (parent.index + 1) + "})")
                    // onClicked: Hyprland.dispatch("workspace " + (parent.index + 1))
                    hoverEnabled: true
                    onEntered: {
                        wsButton.isHovered = true;
                    }
                    onExited: {
                        wsButton.isHovered = false;
                    }
                }
            }
        }
    }

    Rectangle {
        width: Config.taskbar.taskbarHeight
        height: Config.taskbar.taskbarHeight * 1.41
        anchors.right: parent.right
        anchors.rightMargin: -width /2.5 - 3
        anchors.topMargin: -Config.taskbar.taskbarHeight / 2
        anchors.top: parent.top
        rotation: 35
        color: Config.taskbar.workspaces.backgroundColorWithWindows
        z: 1
    }
}

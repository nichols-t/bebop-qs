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
    color: "transparent"
    // Want it to stop before the end of the workspace buttons so that
    // it covers the left side gap but does not appear on the right
    implicitWidth: rows.width
    radius: 2
    z: 0
    implicitHeight: Config.taskbar.taskbarHeight
    RowLayout {
        id: rows
        spacing: 0
        z: 2

        Repeater {
            model: 6 // TODO how to control this more dynamically? Some people use different number of workspaces

            Rectangle {
                id: wsButton
                clip: true
                Layout.topMargin: isActive ? -Config.taskbar.taskbarHeight /2 : -Config.taskbar.taskbarHeight
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
                property var hoverColor: {
                    if (isActive) {
                        return Config.taskbar.workspaces.backgroundColorHovered;
                    } else if (hasWindows) {
                        return Config.taskbar.workspaces.backgroundColorActive;
                    } else {
                        return Config.taskbar.workspaces.backgroundColorWithWindows;
                    }
                }
                border.width: 2
                border.color: Config.taskbar.workspaces.borderColor
                z: isActive ? 3 : 2
                required property var modelData
                required property int index
                property var hasWindows: Hyprland.workspaces.values.find(w => w.id === index + 1)
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

                property bool isHovered: false
                // Creates a shape that is the right size for bounds of a regular hexagon
                height: Config.taskbar.taskbarHeight * 1.5
                width: Config.taskbar.taskbarHeight * 1.5

                Text {
                    id: label
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottomMargin: 1
                    text: index + 1
                    z: 1
                    // If the weight is wrong it just doesn't load, so just read weight directly from the
                    // file that we imported
                    font {
                        family: Config.fontTypewriter.font.family
                        bold: isActive
                        pixelSize: Config.taskbar.workspaces.fontSize
                    }

                    color: {
                        return Config.taskbar.workspaces.textColorWithWindows;
                        if (isActive)
                            return Config.taskbar.workspaces.textColorActive;
                        if (hasWindows)
                            return Config.taskbar.workspaces.textColorWithWindows;
                        return Config.taskbar.workspaces.textColorInactive;
                    }
                }

                Rectangle {
                    width: wsButton.width / 4
                    height: wsButton.height / 2
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: width + 1
                    anchors.verticalCenterOffset: index % 2 === 0 ? 10 : 0
                    border.width: 2
                    border.color: Config.taskbar.workspaces.borderColor
                    // TODO theme this to be "shade + 1" instead of going straight to hovered
                    color: wsButton.isHovered ? wsButton.hoverColor : wsButton.color
                    z: 0
                }
                Rectangle {
                    width: wsButton.width / 4
                    height: wsButton.height / 2
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: -width - 1
                    anchors.verticalCenterOffset: index % 2 === 0 ? 0 : 10
                    // anchors.horizontalCenterOffset: -Config.taskbar.taskbarHeight / 2
                    border.width: 2
                    border.color: Config.taskbar.workspaces.borderColor
                    color: wsButton.isHovered ? wsButton.hoverColor : wsButton.color
                    z: 0
                }

                MouseArea {
                    anchors.fill: wsButton
                    // Lua version is uncommented. If hyprland config is old switch to that other one
                    onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + (parent.index + 1) + "})")
                    // onClicked: Hyprland.dispatch("workspace " + (parent.index + 1))
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
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
}

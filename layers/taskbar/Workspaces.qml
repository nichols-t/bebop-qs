import QtQuick
import Quickshell.Widgets
import QtQuick.Layouts
import Quickshell.Hyprland
import ".."
import "../.."
import QtQuick.Shapes

Rectangle {
    id: root
    color: "transparent"
    // Want it to stop before the end of the workspace buttons so that
    // it covers the left side gap but does not appear on the right
    implicitWidth: rows.width
    z: 0
    height: Config.taskbar.taskbarHeight

    Rectangle {
        height: Config.taskbar.taskbarHeight / 4
        width: rows.width
        anchors.bottom: parent.bottom
        color: Config.taskbar.workspaces.borderColor
        z: 1
    }

    RowLayout {
        id: rows
        spacing: 0

        Repeater {
            id: repeater
            // Hyprland.workspaces.values.length only shows this monitor
            model: 6
            WrapperMouseArea {
                id: area
                required property var modelData
                required property int index
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                property bool hasWindows: !!Hyprland.workspaces.values.find(w => w.id === area.index + 1)

                // Lua version is uncommented. If hyprland config is old switch to that other one
                onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + (index + 1) + "})")
                // onClicked: Hyprland.dispatch("workspace " + (parent.index + 1))
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: {
                    wsButton.isHovered = true;
                }
                onExited: {
                    wsButton.isHovered = false;
                }

                Item {
                    implicitWidth: wsButton.width
                    implicitHeight: wsButton.height
                    Rectangle {
                        id: wsButton
                        clip: true
                        anchors.top: parent.top
                        color: {
                            if (area.isActive) {
                                return Config.taskbar.workspaces.backgroundColorActive;
                            } else if (hasWindows) {
                                return Config.taskbar.workspaces.backgroundColorWithWindows;
                            } else {
                                return Config.taskbar.workspaces.backgroundColorInactive;
                            }
                        }
                        property var hoverColor: {
                            if (area.isActive) {
                                return Config.taskbar.workspaces.backgroundColorHovered;
                            } else if (hasWindows) {
                                return Config.taskbar.workspaces.backgroundColorActive;
                            } else {
                                return Config.taskbar.workspaces.backgroundColorWithWindows;
                            }
                        }
                        border.width: 2
                        border.color: Config.taskbar.workspaces.borderColor
                        z: area.isActive ? 3 : 2

                        property bool isHovered: false
                        // Creates a shape that is the right size for bounds of a regular hexagon
                        height: Config.taskbar.taskbarHeight
                        width: Config.taskbar.taskbarHeight * 1.3

                        Text {
                            id: label
                            anchors.centerIn: parent
                            text: area.index + 1
                            z: 1
                            // If the weight is wrong it just doesn't load, so just read weight directly from the
                            // file that we imported
                            anchors.verticalCenterOffset: area.isActive ? -2 : 0
                            font.family: area.isActive ? Config.fontBlocky.font.family : Config.fontTypewriter.font.family
                            font.bold: wsButton.isHovered
                            font.pointSize: Config.taskbar.workspaces.fontSize

                            color: Config.taskbar.workspaces.textColor
                        }

                        Rectangle {
                            visible: area.isActive
                            width:wsButton.width / 2
                            height: area.isActive ? wsButton.height : 0
                            anchors.top: parent.top
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: wsButton.isHovered ? Config.taskbar.workspaces.backgroundColorHovered: Config.taskbar.workspaces.backgroundColorActive
                            border.color: Config.taskbar.workspaces.borderColor
                            border.width: 2
                            Behavior on height {
                                NumberAnimation {}
                            }
                        }

                        Rectangle {
                            visible: area.isActive
                            width:wsButton.width / 2
                            height: area.isActive ? wsButton.height : 0
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: wsButton.isHovered ? Config.taskbar.workspaces.backgroundColorHovered: Config.taskbar.workspaces.backgroundColorActive
                            border.color: Config.taskbar.workspaces.borderColor
                            border.width: 2
                            Behavior on height {
                                NumberAnimation {}
                            }
                        }

                        Rectangle {
                            width: wsButton.width / 8
                            height: wsButton.height
                            anchors.right: parent.right
                            color: Config.taskbar.workspaces.borderColor
                            z: 0
                        }
                        Rectangle {
                            width: wsButton.width / 8
                            height: wsButton.height
                            anchors.left: parent.left
                            color: Config.taskbar.workspaces.borderColor
                            z: 0
                        }
                    }
                }
            }
        }
    }
}

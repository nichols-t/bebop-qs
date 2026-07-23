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
    radius: 2
    z: 0
    implicitHeight: Config.taskbar.taskbarHeight
    RowLayout {
        id: rows
        spacing: 0
        z: 2

        Repeater {
            model: 6 // TODO how to control this more dynamically? Some people use different number of workspaces
            WrapperMouseArea {
                id: area
                required property var modelData
                required property int index
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

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
                    implicitHeight: Config.taskbar.taskbarHeight
                    implicitWidth: wsButton.width
                    Rectangle {
                        id: wsButton
                        clip: true
                        anchors.top: parent.top
                        anchors.topMargin: area.isActive ? -Config.taskbar.taskbarHeight / 2 : -Config.taskbar.taskbarHeight * 0.8
                        radius: 2
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
                        property var hasWindows: Hyprland.workspaces.values.find(w => w.id === area.index + 1)

                        property bool isHovered: false
                        // Creates a shape that is the right size for bounds of a regular hexagon
                        height: Config.taskbar.taskbarHeight * 1.5
                        width: Config.taskbar.taskbarHeight * 1.5

                        Text {
                            id: label
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottomMargin: 1
                            text: area.index + 1
                            z: 1
                            // If the weight is wrong it just doesn't load, so just read weight directly from the
                            // file that we imported
                            font {
                                family: Config.fontTypewriter.font.family
                                bold: area.isActive
                                pixelSize: Config.taskbar.workspaces.fontSize
                            }

                            color: {
                                return Config.taskbar.workspaces.textColorWithWindows;
                                if (area.isActive)
                                    return Config.taskbar.workspaces.textColorActive;
                                if (area.hasWindows)
                                    return Config.taskbar.workspaces.textColorWithWindows;
                                return Config.taskbar.workspaces.textColorInactive;
                            }
                        }

                        Rectangle {
                            width: wsButton.width / 4
                            height: wsButton.height / 2
                            anchors.centerIn: parent
                            anchors.horizontalCenterOffset: width + 1
                            anchors.verticalCenterOffset: area.index % 2 === 0 ? 10 : 0
                            border.width: 2
                            border.color: Config.taskbar.workspaces.borderColor
                            color: wsButton.isHovered ? wsButton.hoverColor : wsButton.color
                            z: 0
                        }
                        Rectangle {
                            width: wsButton.width / 4
                            height: wsButton.height / 2
                            anchors.centerIn: parent
                            anchors.horizontalCenterOffset: -width - 1
                            anchors.verticalCenterOffset: area.index % 2 === 0 ? 0 : 10
                            // anchors.horizontalCenterOffset: -Config.taskbar.taskbarHeight / 2
                            border.width: 2
                            border.color: Config.taskbar.workspaces.borderColor
                            color: wsButton.isHovered ? wsButton.hoverColor : wsButton.color
                            z: 0
                        }
                    }
                }
            }
        }
    }
}

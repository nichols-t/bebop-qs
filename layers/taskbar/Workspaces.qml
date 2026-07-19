import QtQuick
import Quickshell.Widgets
import QtQuick.Layouts
import Quickshell.Hyprland
import ".."
import "../.."

RowLayout {
    id: root
    spacing: 7

    Repeater {
        model: 6
    
        // TODO maybe it should be hex and not rectangle?
        Rectangle {
            id: wsButton
            // TODO fix and add to theme
            border.color: '#5c517a'
            radius: 4
            required property int index

            property var hasWindows: Hyprland.workspaces.values.find(w => w.id === index + 1)
            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
        
            implicitHeight: Config.taskbar.taskbarHeight
            width: 20

            color: {
                if (isActive) return Config.taskbar.workspaces.backgroundColorActive
                if (hasWindows) return Config.taskbar.workspaces.backgroundColorWithWindows
                return Config.taskbar.workspaces.backgroundColorInactive
            }
        
            Text {
                id: label
                anchors.centerIn: parent
                text: index + 1
                // If the weight is wrong it just doesn't load, so just read weight directly from the
                // file that we imported
                font {
                    family: Config.fontTypewriter.font.family
                    bold: isActive
                    pixelSize: 18
                }

                color: {
                    if (isActive) return Config.taskbar.workspaces.textColorActive
                    if (hasWindows) return Config.taskbar.workspaces.textColorWithWindows
                    return Config.taskbar.workspaces.textColorInactive
                }
            }

            MouseArea {
                anchors.fill: wsButton
                // Lua version is uncommented. If hyprland config is old switch to that other one
                onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + (parent.index + 1) + "})")
                // onClicked: Hyprland.dispatch("workspace " + (parent.index + 1))
                hoverEnabled: true
                onEntered: {
                    wsButton.border.width = 2
                }
                onExited: {
                    wsButton.border.width = 0
                }
            }
        }
    }
}

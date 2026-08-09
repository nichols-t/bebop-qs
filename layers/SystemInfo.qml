import Quickshell
import QtQuick
import Quickshell.Widgets
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import Quickshell.Hyprland
import ".."
import "./systemInfoMenu"
import "../utils"

Scope {
    id: root
    required property var modelData
    required property var shouldShow
    PanelWindow {
        id: panel
        screen: root.modelData
        visible: root.shouldShow
        color: "transparent"
        anchors {
            top: true
            left: true
            bottom: true
            right: true
        }
        // Center offset for "row headings" of this page
        property var rowHeadingHorizontalOffset: -modelData.width * 0.1
        property var sectionVerticalSpaceHeight: modelData.height * 0.05
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
        
        // determines which (if any) detail screens are shown on the right
        property string showDetails: ""

        Connections {
            target: root
            function onShouldShowChanged() {
                SysInfo.active = root.shouldShow;
            }
        }

        Component.onCompleted: {
            if (this.WlrLayershell != null) {
                this.WlrLayershell.layer = WlrLayer.Top;
                this.WlrLayershell.namespace = "calendar";
            }
        }

        HyprlandFocusGrab {
            id: grab
            windows: [blackRect]
        }

        Rectangle {
            id: blackRect
            //  anchors.fill: parent
            width: modelData.width * 0.6
            height: modelData.height
            color: Config.calendar.backgroundColor
            visible: true
            // Needs to be focused to get key press event
            focus: true
            Keys.onPressed: event => {
                // close: Escape
                if (event.key === Qt.Key_Escape) {
                    event.accepted = true;
                    root.shouldShow = false;
                }
            }

            ColumnLayout {
                id: grid
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: modelData.height * 0.05
                anchors.leftMargin: modelData.width * 0.1
                anchors.rightMargin: modelData.width * 0.2
                // Layout.row and Layout.column for where an element goes
                SectionHeader { text: "SYSTEM STATISTICS" }
                SectionStat { label: "OS"; value: SysInfo.os.osName; }
                SectionStat { label: "POWER"; value: SysInfo.power.pluggedIn ? 'AC POWER' : `${SysInfo.power.batteryPercent}%`}

                SectionSpacer {}
                SectionHeaderMouseArea {
                    SectionHeader { text: "CENTRAL PROCESSING UNIT" }
                    onClicked: { panel.showDetails = "CPU" }
                }
                SectionStat { label: "USAGE"; value: SysInfo.cpuUsage.cpuText }

                SectionSpacer {}
                SectionHeaderMouseArea {
                    SectionHeader { text: "RANDOM ACCESS MEMORY" }
                    onClicked: { panel.showDetails = "RAM" }
                }
                SectionStat { label: "USAGE"; value: SysInfo.ramUsage.memText; }

                SectionSpacer {}
                SectionHeaderMouseArea {
                    SectionHeader { text: "GRAPHICS PROCESSING UNIT" }
                    onClicked: { panel.showDetails = "GPU" }
                }
                SectionStat { label: "TEMP"; value: SysInfo.gpuUsage.gpuTempText; }
                SectionStat { label: "MEM USAGE"; value: SysInfo.gpuUsage.gpuMemText; }

                SectionSpacer {}
                SectionHeaderMouseArea {
                    SectionHeader { text: "SOLID STATE DRIVE" }
                    onClicked: { panel.showDetails = "SSD" }
                }
                SectionStat { label: "USAGE"; value: SysInfo.diskUsage.diskText; }
     
                MultiEffect {
                    id: hoverBlur
                    anchors.fill: source
                    blurEnabled: true
                    blur: 1.0
                    colorization: 0.5
                    colorizationColor: "white"
                }
            }
        }

        Rectangle {
            id: accentRect
            width: modelData.width * 0.4
            height: modelData.height
            anchors.right: parent.right
            color: Config.systemInfo.accentColor
            CpuDetails { visible: panel.showDetails === "CPU" }
            RamDetails { visible: panel.showDetails === "RAM" }
            GpuDetails { visible: panel.showDetails === "GPU" }
            DiskDetails { visible: panel.showDetails === "SSD" }
        }
    }

    component SectionSpacer: Item {
        height: panel.sectionVerticalSpaceHeight
    }

    component SectionHeaderMouseArea: WrapperMouseArea {
        id: self
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onEntered: {
            hoverBlur.source = self
        }
        onExited: {
            hoverBlur.source = null
        }
    }
}

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
import "./systemInfoMenu" as LayerParts
import "../utils"

// TODO interactivity and SVGs - MouseAreas are set up but right side is not
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

        // TODO unsure if it is needed
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
                // TODO put these in properties and maybe configurable
                anchors.topMargin: modelData.height * 0.05
                anchors.leftMargin: modelData.width * 0.1
                anchors.rightMargin: modelData.width * 0.2
                // Layout.row and Layout.column for where an element goes
                LayerParts.SectionHeader { text: "SYSTEM STATISTICS" }
                LayerParts.SectionStat { label: "OS"; value: SysInfo.osName; }
                LayerParts.SectionStat { label: "POWER"; value: `${SysInfo.batteryPercent}%`}

                SectionSpacer {}
                SectionHeaderMouseArea {
                    LayerParts.SectionHeader { text: "CENTRAL PROCESSING UNIT" }
                    onClicked: { panel.showDetails = "CPU" }
                }
                LayerParts.SectionStat { label: "USAGE"; value: SysInfo.cpuText }

                SectionSpacer {}
                SectionHeaderMouseArea {
                    LayerParts.SectionHeader { text: "RANDOM ACCESS MEMORY" }
                    onClicked: { panel.showDetails = "RAM" }
                }
                LayerParts.SectionStat { label: "USAGE"; value: SysInfo.memText; }

                SectionSpacer {}
                SectionHeaderMouseArea {
                    LayerParts.SectionHeader { text: "GRAPHICS PROCESSING UNIT" }
                    onClicked: { panel.showDetails = "GPU" }
                }
                LayerParts.SectionStat { label: "TEMP"; value: SysInfo.gpuTempText; }
                LayerParts.SectionStat { label: "MEM USAGE"; value: SysInfo.gpuMemText; }

                SectionSpacer {}
                SectionHeaderMouseArea {
                    LayerParts.SectionHeader { text: "SOLID STATE DRIVE" }
                    onClicked: { panel.showDetails = "SSD" }
                }
                LayerParts.SectionStat { label: "USAGE"; value: SysInfo.diskText; }
            }
        }

        Rectangle {
            id: accentRect
            width: modelData.width * 0.4
            height: modelData.height
            anchors.right: parent.right
            color: Config.systemInfo.accentColor
            LayerParts.CpuDetails { visible: panel.showDetails === "CPU" }
            LayerParts.RamDetails { visible: panel.showDetails === "RAM" }
            LayerParts.GpuDetails { visible: panel.showDetails === "GPU" }
            LayerParts.DiskDetails { visible: panel.showDetails === "SSD" }
        }
        MouseArea {
            id: closeMouseClick
            anchors.fill: parent
            onClicked: {
                panel.showDetails = ""
                root.shouldShow = false;
                // panel.visible = false
            }
        }
    }

    component SectionSpacer: Item {
        height: panel.sectionVerticalSpaceHeight
    }

    component SectionHeaderMouseArea: WrapperMouseArea {
        // TODO: some stronger user feedback on hover
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: {
            closeMouseClick.visible = false;
        }
        onExited: {
            closeMouseClick.visible = true;
        }
    }
}

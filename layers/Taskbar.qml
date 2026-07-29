import Quickshell
import QtQuick
import QtQuick.Layouts
import ".."
import "./taskbar" as LayerParts

PanelWindow {
    id: root
    required property var modelData
    screen: modelData

    property SystemInfo systemInfo
    property Calendar calendar

    color: Config.taskbar.backgroundColor
    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Config.taskbar.taskbarHeight

    RowLayout {
        spacing: 0
        anchors.fill: parent

        LayerParts.Workspaces {}
        Item { Layout.fillWidth: true }
        // Debug app menu launcher
        LayerParts.Battery {}
        LayerParts.Audio {}
        LayerParts.Clock { calendar: root.calendar }
        LayerParts.SystemInfoButton { systemInfo: root.systemInfo }
    }
}

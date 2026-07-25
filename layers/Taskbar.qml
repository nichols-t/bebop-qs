import Quickshell
import QtQuick
import QtQuick.Layouts
import ".."
import "./taskbar" as LayerParts

PanelWindow {
    id: panel
    required property var modelData
    screen: modelData

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
        // LayerParts.AppButton {}
        LayerParts.Battery {}
        LayerParts.Audio {}
        LayerParts.Clock {}
        LayerParts.SystemInfoButton {}
    }
}

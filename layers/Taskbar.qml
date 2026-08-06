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
    property Settings settings

    color: Config.taskbar.backgroundColor
    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Config.taskbar.taskbarHeight

    LayerParts.Workspaces {
        anchors.horizontalCenter: parent.horizontalCenter
    }
    RowLayout {
        spacing: 0
        anchors.fill: parent
        LayerParts.User {}
        Item { Layout.fillWidth: true }
        // Debug app menu launcher
        LayerParts.Network {}
        LayerParts.Battery {}
        LayerParts.Audio {}
        LayerParts.Clock { calendar: root.calendar }
        LayerParts.SettingsButton { settings: root.settings }
    }
}

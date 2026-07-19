import Quickshell
import QtQuick
import QtQuick.Layouts
import ".."
import "./taskbar" as LayerParts

PanelWindow {
    id: panel
    required property var modelData
    screen: modelData

    color: "transparent" // TODO theme
    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Config.taskbar.taskbarHeight

    RowLayout {
        anchors.fill: parent

        LayerParts.Workspaces {}
        Item { Layout.fillWidth: true }
        LayerParts.Audio {}
        LayerParts.Clock {}
    }

    // TODO: Not sure if this belongs here or separately
    //qWidgets.Notifications {}
}

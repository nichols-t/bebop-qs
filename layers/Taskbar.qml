import Quickshell
import QtQuick
import QtQuick.Layouts
import ".."
import "./taskbar"

PanelWindow {
    id: root
    required property var modelData
    screen: modelData

    property SystemInfo systemInfo
    property Calendar calendar
    property Settings settings
    property AudioSettings audioSettings
    property ShutdownMenu shutdownMenu

    color: Config.taskbar.backgroundColor
    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Config.taskbar.taskbarHeight

    Workspaces {
        anchors.horizontalCenter: parent.horizontalCenter
    }
    RowLayout {
        spacing: 0
        anchors.fill: parent
        User { shutdownMenu: root.shutdownMenu }
        Item { Layout.fillWidth: true }
        // Debug app menu launcher
        Network {}
        Battery {}
        AudioButton { audioSettings: root.audioSettings }
        Clock { calendar: root.calendar }
        SettingsButton { settings: root.settings }
    }
}

import Quickshell
import QtQuick
import QtQuick.Layouts
import ".."
import "./taskbar"

Scope {
    id: root
    required property var screen
    property SystemInfo systemInfo
    property Calendar calendar
    property Settings settings
    property AudioSettings audioSettings
    property BluetoothSettings bluetoothSettings
    property NetworkSettings networkSettings
    property ShutdownMenu shutdownMenu

    PanelWindow {
        id: panel
        screen: root.screen
        color: Config.taskbar.backgroundColor
        anchors {
            top: true
            left: true
            right: true
        }

        implicitHeight: Config.taskbar.taskbarHeight

        Loader {
            id: workspacesLoader
            asynchronous: true
            sourceComponent: workspaces
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Component {
            id: workspaces
            // Not inside the RowLayout so that we can center them exactly without doing a bunch
            // of nonsense
            Workspaces {
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        Loader {
            id: taskbarLoader
            asynchronous: true
            sourceComponent: rows
            anchors.fill: parent
        }
        Component {
            id: rows
            RowLayout {
                spacing: 4
                User { shutdownMenu: root.shutdownMenu }
                Item { Layout.fillWidth: true }
                BluetoothButton { bluetoothSettings: root.bluetoothSettings }
                NetworkButton { networkSettings: root.networkSettings }
                Battery {}
                AudioButton { audioSettings: root.audioSettings }
                Clock { calendar: root.calendar }
                SettingsButton { settings: root.settings }
            }
        }
    }
}

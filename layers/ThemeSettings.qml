import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "./settings"

import ".."

SettingsSubMenu {
    title: 'THEME'

    content: Component {
        ColumnLayout {
            anchors.centerIn: parent
            Text {
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
                text: "Coming Soon!"
                color: "white"
                font.family: Config.fontTypewriter.font.family
                font.pointSize: 18
            }
        }
    }
}

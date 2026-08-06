// ClockWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import "../../utils"
import ".."
import "../.."

WrapperMouseArea {
    id: root
    //cursorShape: Qt.PointingHandCursor
    enabled: false
    WrapperRectangle {
        color: Config.taskbar.clock.backgroundColor
        Item {
            implicitHeight: Config.taskbar.taskbarHeight
            implicitWidth: text.width * 1.5
            Text {
                id: text
                text: SysInfo.user.name
                font.family: Config.fontBlocky.font.family
                font.pixelSize: Config.taskbar.fontSize
                font.bold: false
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                // TODO why it is needed?? I think its font related
                anchors.verticalCenterOffset: 2
                color: Config.taskbar.clock.textColor
            }
        }
    }
}

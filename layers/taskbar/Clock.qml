// ClockWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import "../../utils"
import ".."
import "../.."

WrapperMouseArea {
    id: root
    cursorShape: Qt.PointingHandCursor
    property Calendar calendar
    onClicked: {
        calendar.shouldShow = true;
    }
    WrapperRectangle {
        color: Config.taskbar.clock.backgroundColor
        Item {
            implicitHeight: Config.taskbar.taskbarHeight
            implicitWidth: clockText.width
            Text {
                id: clockText
                text: Qt.formatDateTime(Time.time, " ddd MMM dd hh:mm AP ")
                font.family: Config.fontBlocky.font.family
                font.pointSize: Config.taskbar.fontSize
                font.bold: false
                anchors.centerIn: parent
                color: Config.taskbar.clock.textColor
            }
        }
    }
}

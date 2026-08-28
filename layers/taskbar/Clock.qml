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
    hoverEnabled: true
    property Calendar calendar
    onClicked: {
        calendar.shouldShow = true;
    }
    WrapperRectangle {
        color: Config.taskbar.clock.backgroundColor
        implicitHeight: Config.taskbar.taskbarHeight
        Text {
            id: clockText
            text: Qt.formatDateTime(Time.time, " ddd MMM dd hh:mm AP ")
            font.family: Config.fontBlocky.font.family
            font.pointSize: Config.taskbar.fontSize
            font.italic: root.containsMouse
            font.bold: root.containsMouse
            anchors.centerIn: parent
            color: Config.taskbar.clock.textColor
        }
    }
}

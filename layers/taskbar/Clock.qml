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
                font.family: Config.fontTypewriter.font.family
                font.pixelSize: 18
                font.bold: true
                anchors.centerIn: parent
                // TODO why it is needed?? I think its font related
                anchors.verticalCenterOffset: 2
                color: Config.taskbar.clock.textColor
            }
        }
    }
}

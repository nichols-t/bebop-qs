// ClockWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import "../../utils"
import ".."
import "../.."

WrapperMouseArea {
    cursorShape: Qt.PointingHandCursor
    onClicked: {
        systemInfo.shouldShow = true;
    }

    WrapperRectangle {
        color: Config.taskbar.clock.backgroundColor
        height: Config.taskbar.taskbarHeight
        margin: 5
        Text {
            id: sysText
            text: "SYS" // TODO better text or icon or some shit
            anchors.centerIn: parent
            font {
                family: Config.fontTypewriter.font.family
                pixelSize: 18
                bold: true
            }
            color: Config.taskbar.clock.textColor
        }
    }
}

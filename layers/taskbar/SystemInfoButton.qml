// ClockWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import "../../utils"
import ".."
import "../.."

WrapperMouseArea {
    cursorShape: Qt.PointingHandCursor
    property SystemInfo systemInfo
    onClicked: {
        systemInfo.shouldShow = true;
    }
    margin: 0
    WrapperRectangle {
        color: Config.taskbar.clock.backgroundColor
        margin: 0
        Item {
            implicitHeight: Config.taskbar.taskbarHeight
            implicitWidth: sysText.width
            Text {
                id: sysText
                text: "SYS " // TODO better text or icon or some shit
                anchors.centerIn: parent
                // TODO I think this is font related
                anchors.verticalCenterOffset: 2
                font {
                    family: Config.fontTypewriter.font.family
                    pixelSize: 18
                    bold: true
                }
                color: Config.taskbar.clock.textColor
            }
        }
    }
}

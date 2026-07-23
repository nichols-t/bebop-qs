// ClockWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import "../../utils"
import ".."
import "../.."

Rectangle {
  id: root
  color: Config.taskbar.clock.backgroundColor
  implicitHeight: Config.taskbar.taskbarHeight
  implicitWidth: battText.implicitWidth + 10

    Text {
    id: battText
    text: `${SysInfo.batteryPercent}% BATT`
    font {
        family: Config.fontTypewriter.font.family
        pixelSize: 18
        bold: true
    }
    anchors.centerIn: parent
    color: Config.taskbar.clock.textColor
  }
}
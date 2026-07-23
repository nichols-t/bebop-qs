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
  implicitWidth: clockText.implicitWidth + 10

  Text {
    id: clockText
    text: Qt.formatDateTime(Time.time, "ddd MMM dd hh:mm AP")
    font.family: Config.fontTypewriter.font.family
    font.pixelSize: 18
    font.bold: true
    anchors.centerIn: parent
    color: Config.taskbar.clock.textColor
  }

  MouseArea {
    anchors.fill: root
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      calendar.shouldShow = true
    }
  }
}
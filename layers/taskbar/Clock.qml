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
    text: Time.time
    font {
        // TODO: Should I use this font or find a more "plain"/"computer" one like
        // the in-universe UIs use?
        family: Config.fontTypewriter.font.family
        pixelSize: 18
        bold: true
    }
    anchors.centerIn: parent
    color: Config.taskbar.clock.textColor
  }

  MouseArea {
    anchors.fill: root
    onClicked: {
      calendar.shouldShow = true
    }
  }
}
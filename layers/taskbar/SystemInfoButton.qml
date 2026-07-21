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
  implicitWidth: 50

  Text {
    id: sysText
    text: "SYS" // TODO better text or icon or some shit
    anchors.centerIn: parent
    font {
        // TODO: Should I use this font or find a more "plain"/"computer" one like
        // the in-universe UIs use?
        family: Config.fontTypewriter.font.family
        pixelSize: 18
        bold: true
    }
    color: Config.taskbar.clock.textColor
  }

  MouseArea {
    anchors.fill: root
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      systemInfo.shouldShow = true
    }
  }
}
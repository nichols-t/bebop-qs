// ClockWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import "../../utils"
import ".."
import "../.."

Rectangle {
  color: "transparent"
  implicitHeight: Config.taskbar.taskbarHeight
  implicitWidth: clockText.implicitWidth + 10

  Image {
      id: backgroundImage
      z: 0
      anchors.leftMargin: -25
      anchors.fill: parent
      fillMode: Image.PreserveAspectFit
      source: Qt.resolvedUrl("../../assets/taskbarBackground.svg")
      visible: true // Only the colorized MultiEffect is visible
  }

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
}
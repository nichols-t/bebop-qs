import QtQuick
import "../../.."

Text {
    id: root
    required property bool isTooWide
    color: Config.audioSettings.trackTitleTextColor
    font.family: Config.fontTypewriter.font.family
    font.pointSize: Config.audioSettings.trackTitleTextSize
    font.bold: true
    anchors.horizontalCenter: isTooWide ? undefined : parent.horizontalCenter
    NumberAnimation on x {
        id: scrollAnim
        duration: Math.floor(root.width * 10)
        from: -root.width * 1.1
        to: root.width * 1.1
        running: root.isTooWide
        loops: Animation.Infinite
    }

}

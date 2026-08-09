import QtQuick
import "../../.."

// TODO animate if it is too long for container?
Text {
    color: Config.audioSettings.trackTitleTextColor
    font.family: Config.fontTypewriter.font.family
    font.pointSize: Config.audioSettings.trackTitleTextSize
    font.bold: true
}

import QtQuick
import "../../.."

Text {
    color: Config.audioSettings.trackTitleTextColor
    font.family: Config.fontTypewriter.font.family
    font.pointSize: Config.audioSettings.trackTitleTextSize
    font.bold: true
}

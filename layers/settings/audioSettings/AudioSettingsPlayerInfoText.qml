import QtQuick
import QtQuick.Layouts
import "../../.."

Text {
    color: Theme.audioSettingsColorSet.playerInfoTextColor
    font.family: Config.fontTypewriter.font.family
    font.pointSize: Config.audioSettings.playerInfoTextSize
    // Need to set both this and width explicitly to make it work inside a Layout
    Layout.preferredWidth: width
    wrapMode: Text.WordWrap
    width: cols.width - row.height * 1.5
}

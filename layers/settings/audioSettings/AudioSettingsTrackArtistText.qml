import QtQuick
import "../../.."

Text {
    color: Config.audioSettings.trackArtistTextColor // TODO
    font.family: Config.fontBlocky.font.family
    font.pointSize: Config.audioSettings.trackArtistTextSize
}

import QtQuick
import QtQuick.Layouts
import "../.."

Text {
    color: Config.settings.menuTitleTextColor
    Layout.alignment: Qt.AlignCenter
    font.family: Config.fontBlocky.font.family
    font.pixelSize: Config.settings.menuTitleTextSize
    fontSizeMode: Text.HorizontalFit
}

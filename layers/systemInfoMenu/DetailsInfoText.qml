import QtQuick
import QtQuick.Layouts
import Quickshell
import "../.."

// Used on the detailed view of system information
Text {
    property real maxWidth
    font.family: Config.fontBlocky.font.family
    font.pointSize: Config.systemInfo.detailsTextSize
    Layout.preferredWidth: width
    horizontalAlignment: Text.AlignHCenter
    wrapMode: Text.WordWrap
    width: maxWidth
}

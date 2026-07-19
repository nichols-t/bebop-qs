import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../.."

// This rectangle loaded as a goodbye message

Rectangle {
    id: goodbyeMessage
    anchors.fill: parent
    color: "#000000"
    z: 128

    Text {
        id: goodbyeText
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        visible: false
        font {
            family: Config.fontSerif.font.family
            pixelSize: 50
            italic: true
        }
        // TODO take color from theme?
        color: Config.colors.menuItemSelected
        text: "SEE YOU SPACE COWBOY... "
    }

    MultiEffect {
        blurEnabled: true
        blur: 1.0
        blurMax: 6
        source: goodbyeText
        anchors.fill: goodbyeText
    }
}

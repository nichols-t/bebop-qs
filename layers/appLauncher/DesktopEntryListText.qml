import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import "../.."

Item {
    id: root
    property var app
    property real desiredWidth
    implicitWidth: desiredWidth
    implicitHeight: text.height
    property bool isSelected
    Text {
        id: text
        text: `<span>
        <${root.isSelected ? 'u' : 'span'}>${app.name}</${root.isSelected ? 'u' : 'span'}>
        <br></br>
        <span style='white-space:pre'>\t${app.genericName}</span>
        <br></br>
        <span style='white-space:pre'>\t${app.categories}</span>
        <br></br>
        <span style='white-space:pre'>\t${app.keywords}</span>
        <br></br>
        <span style='white-space:pre'>\t${app.comment}</span>
        </span>`
        textFormat: Text.RichText
        // Need to set both this and width explicitly to make it work inside a Layout
        Layout.preferredWidth: width
        Layout.preferredHeight: font.pixelSize
        wrapMode: Text.WordWrap
        width: root.desiredWidth
        color: "white"
        // TODO pick better font?
        font.family: Config.fontSerif.font.family
        font.pixelSize: 16
        font.bold: root.isSelected
        visible: false
    }

    MultiEffect {
        anchors.fill: text
        source: text
        blurEnabled: false
        blur: 1.0
        blurMax: 2
    }
}

import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../.."
import "../../widgets" as Widgets

ShutdownMenuBackground {
    anchors.fill: parent
    visible: text === "LOCK"

    Text {
        id: textTypewriterWide
        text: parent.text
        visible: false // Only blurred MultiEffect is visible
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: -screen.width / 20
        anchors.verticalCenterOffset: -screen.height / 10
        color: textColor
        font.family: Config.fontTypewriter.font.family
        font.pixelSize: screen.height / 15
        font.letterSpacing: 50
    }
    MultiEffect {
        opacity: 0.5
        blurEnabled: true
        blur: 1.0
        blurMax: 16
        source: textTypewriterWide
        anchors.fill: textTypewriterWide
    }


    // ! Note that the MultiEffect needs to be rotated the same as the text.
    // This feels clumsy, but makes sense because it's a wholly separate element
    // so it's rendered first (apparently)
    Widgets.BigFirstLetterText {
        id: backgroundText1
        rawText: parent.text
        font.pixelSize: screen.height / 15
        font.family: Config.fontSerif.font.family
        visible: false // Only blurred MultiEffect is visible
        rotation: 90
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: screen.width / 4
        anchors.verticalCenterOffset: screen.height / 10
        color: textColor
    }
    MultiEffect {
        opacity: 0.3
        blurEnabled: true
        blur: 1.0
        rotation: backgroundText1.rotation
        blurMax: 8
        source: backgroundText1
        anchors.fill: backgroundText1
    }

    Widgets.BigFirstLetterText {
        id: backgroundText2
        rawText: parent.text
        visible: false // Only blurred MultiEffect is visible
        anchors.bottom: parent
        y: -(screen.height / 3) * 1.25
        color: textColor
        font.family: Config.fontSerif.font.family
        font.pixelSize: screen.height / 3
    }
    MultiEffect {
        blurEnabled: true
        blur: 1.0
        blurMax: 16
        opacity: 0.3
        source: backgroundText2
        anchors.fill: backgroundText2
    }

}

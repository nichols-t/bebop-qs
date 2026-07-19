import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../.."
import "../../widgets" as Widgets

ShutdownMenuBackground {
    id: shutdownBackground
    anchors.fill: parent
    visible: text === "LOCK"
    property string textColor: Config.colors.lock

    Text {
        id: textTypewriterWide
        text: parent.text
        visible: false // Only blurred MultiEffect is visible
        x: -400
        y: -200
        color: textColor
        font.family: Config.fontTypewriter.font.family
        font.pixelSize: 100
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
    // This feels clumsy
    Widgets.BigFirstLetterText {
        id: backgroundText1
        rawText: parent.text
        font.pixelSize: 100
        font.family: Config.fontSerif.font.family
        visible: false // Only blurred MultiEffect is visible
        rotation: 90
        x: 500
        y: -500
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
        x: -1400
        y: -1500
        color: textColor
        font.family: Config.fontSerif.font.family
        font.pixelSize: 500
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

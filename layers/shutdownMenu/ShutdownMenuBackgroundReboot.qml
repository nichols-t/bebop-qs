import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../.."
import "../../widgets" as Widgets

ShutdownMenuBackground {
    anchors.fill: parent
    visible: text === "REBOOT"
    property string textColor: Config.colors.reboot

    Text {
        id: textTypewriterWide
        text: parent.text
        visible: false // Only blurred MultiEffect is visible
        x: -400
        y: -00
        color: textColor
        font {
            family: fontTypewriter.font.family
            pixelSize: 100
            letterSpacing: 50
        }
    }
    MultiEffect {
        blurEnabled: true
        blur: 1.0
        opacity: 0.3
        blurMax: 10
        source: textTypewriterWide
        anchors.fill: textTypewriterWide
    }


    Widgets.BigFirstLetterText {
        id: backgroundText1
        rawText: parent.text
        font.pixelSize: 250
        font.family: fontSerif.font.family
        visible: false // Only blurred MultiEffect is visible
        rotation: -90
        x: -200
        y: -1000
        color: textColor
    }
    MultiEffect {
        opacity: 0.3
        blurEnabled: true
        blur: 1.0
        rotation: backgroundText1.rotation
        blurMax: 16
        source: backgroundText1
        anchors.fill: backgroundText1
    }

    Widgets.BigFirstLetterText {
        id: backgroundText2
        rawText: parent.text
        font.pixelSize: 500
        font.family: fontSerif.font.family
        visible: false // Only blurred MultiEffect is visible
        x: -1400
        y: -1500
        color: textColor
    }
    MultiEffect {
        blurEnabled: true
        blur: 1.0
        blurMax: 16
        blurMultiplier: 1.1
        opacity: 0.2
        source: backgroundText2
        anchors.fill: backgroundText2
    }
}

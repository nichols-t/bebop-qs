import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../.."
import "../../widgets" as Widgets

ShutdownMenuBackground {
    anchors.fill: parent
    visible: text === "SHUTDOWN"
    property string textColor: Config.colors.shutdown

    Text {
        id: textTypewriterWide
        text: parent.text
        visible: false // Only blurred MultiEffect is visible
        x: -400
        y: 200
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
        opacity: 0.4
        blurMax: 10
        source: textTypewriterWide
        anchors.fill: textTypewriterWide
    }


    Widgets.BigFirstLetterText {
        id: backgroundText1
        rawText: parent.text
        font.pixelSize: 300
        font.family: fontSerif.font.family
        visible: false // Only blurred MultiEffect is visible
        rotation: 90
        x: -350
        y: -600
        color: textColor
    }
    MultiEffect {
        opacity: 0.3
        blurEnabled: true
        blur: 1.0
        rotation: backgroundText1.rotation
        blurMax: 16
        blurMultiplier: 2
        source: backgroundText1
        anchors.fill: backgroundText1
    }

    Widgets.BigFirstLetterText {
        id: backgroundText2
        rawText: parent.text
        font.pixelSize: 100
        font.family: fontSerif.font.family
        visible: false // Only blurred MultiEffect is visible
        x: -1000
        y: -500
        color: textColor
    }
    MultiEffect {
        blurEnabled: true
        blur: 1.0
        blurMax: 16
        opacity: 0.5
        source: backgroundText2
        anchors.fill: backgroundText2
    }
}

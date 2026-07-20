import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../.."
import "../../widgets" as Widgets

ShutdownMenuBackground {
    anchors.fill: parent
    visible: text === "SHUTDOWN"

    Text {
        id: textTypewriterWide
        text: parent.text
        visible: false // Only blurred MultiEffect is visible
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: screen.width / 10
        anchors.verticalCenterOffset: screen.height / 10
        color: textColor
        font.family: Config.fontTypewriter.font.family
        font.pixelSize: screen.height / 15
        font.letterSpacing: 50
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
        font.pixelSize: screen.width / 8
        font.family: Config.fontSerif.font.family
        visible: false // Only blurred MultiEffect is visible
        rotation: 90
        anchors.left: parent
        x: -screen.width / 4
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

    Text {
        id: firstLetter1
        text: parent.text[0]
        visible: false // Only blurred MultiEffect is visible
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: -screen.width / 4
        anchors.verticalCenterOffset: -screen.height / 6
        color: textColor
        font.family: Config.fontSerif.font.family
        font.pixelSize: screen.width / 2
        font.bold: true
    }
    MultiEffect {
        id: firstLetter1Mf
        blurEnabled: true
        blur: 1.0
        blurMax: 16
        blurMultiplier: screen.width / 20
        source: firstLetter1
        anchors.fill: firstLetter1
        visible: false
    }
    MultiEffect {
        blurEnabled: true
        blur: 1.0
        blurMax: 8
        opacity: 0.9
        source: firstLetter1Mf
        anchors.fill: firstLetter1Mf
    }

    Widgets.BigFirstLetterText {
        id: backgroundText2
        rawText: parent.text
        font.pixelSize: screen.height / 20
        font.family: Config.fontSerif.font.family
        visible: false // Only blurred MultiEffect is visible
        color: textColor
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: screen.width / 2 - implicitWidth
        anchors.verticalCenterOffset: screen.height / 2 - (implicitHeight / 4)
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

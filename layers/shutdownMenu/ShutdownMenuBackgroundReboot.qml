import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../.."
import "../../widgets" as Widgets

ShutdownMenuBackground {
    anchors.fill: parent
    visible: text === "REBOOT"

    Text {
        id: textTypewriterWide
        text: parent.text
        visible: false // Only blurred MultiEffect is visible
        anchors.centerIn: parent
        // anchors.horizontalCenterOffset: -screen.width / 20
        // anchors.verticalCenterOffset: -screen.height / 10
        color: textColor
        font.family: Config.fontTypewriter.font.family
        font.pixelSize: screen.height / 15
        font.letterSpacing: 50
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
        font.pixelSize: screen.height / 8
        font.family: Config.fontSerif.font.family
        visible: false // Only blurred MultiEffect is visible
        rotation: -90
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: screen.width / 4
        anchors.verticalCenterOffset: -screen.height / 6
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
        anchors.horizontalCenterOffset: screen.width / 6
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
        layer.enabled: true
        layer.effect: ShaderEffect {
            fragmentShader: Qt.resolvedUrl("../../shaders/textErosionNoise.frag.qsb")
            property real noiseSize: 64
            property var resolution: [modelData.width, modelData.height]
        }
    }
    MultiEffect {
        blurEnabled: true
        blur: 1.0
        blurMax: 8
        opacity: 0.7
        source: firstLetter1Mf
        anchors.fill: firstLetter1Mf
        layer.enabled: true
        layer.effect: ShaderEffect {
            fragmentShader: Qt.resolvedUrl("../../shaders/textErosionNoise.frag.qsb")
            property real noiseSize: 64
            property var resolution: [modelData.width, modelData.height]
        }
    }

    Widgets.BigFirstLetterText {
        id: backgroundText2
        rawText: parent.text
        font.pixelSize: screen.height / 3
        font.family: Config.fontSerif.font.family
        visible: false // Only blurred MultiEffect is visible
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -screen.height / 2
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

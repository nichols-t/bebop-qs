import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

ShutdownMenuBackground {
    anchors.fill: parent
    visible: text === "REBOOT"
    property string textColor: root.colors.reboot
    z: -1

    Text {
        id: textTypewriterWide
        text: parent.text
        opacity: 0.1
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
        opacity: 0.1
        blurMax: 10
        source: textTypewriterWide
        anchors.fill: textTypewriterWide
    }


    BigFirstLetterText {
        text: parent.text
        basePixelSize: 250
        opacity: 0.3
        rotation: -90
        x: 00
        y: 800
        color: textColor
    }

    // LAYER 2: Larger and less opaque

    BigFirstLetterText {
        text: parent.text
        basePixelSize: 500
        opacity: 0.1
        x: -1400
        y: -1500
        color: textColor
    }
}

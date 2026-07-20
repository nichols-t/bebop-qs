import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "../.."

Item {
    anchors.fill: parent
    required property string text
    required property var screen
    required property string textColor
    z: 0


    Text {
        id: menuTitleText1
        text: Config.powerMenu.menuTitleText
        color: textColor
        anchors.top: parent
        y: screen.height / 20
        x: screen.width / 20
        anchors.verticalCenterOffset: -screen.height / 8
        font.family: Config.fontTypewriter.font.family
        font.pixelSize: screen.height / 15
        font.letterSpacing: 80
        visible: false
    }
    MultiEffect {
        blurEnabled: true
        blur: 1.0
        opacity: 0.5
        blurMax: 8
        blurMultiplier: 1
        source: menuTitleText1
        anchors.fill: menuTitleText1
    }

    Text {
        id: menuTitleText2
        text: Config.powerMenu.menuTitleText
        color: textColor
        anchors.bottom: parent
        x: screen.width / 4
        y: screen.height - implicitHeight - screen.height / 20
        font.family: Config.fontTypewriter.font.family
        font.pixelSize: screen.height / 15
        font.letterSpacing: 120
        visible: false
    }

    MultiEffect {
        blurEnabled: true
        blur: 1.0
        opacity: 0.2
        blurMax: 8
        blurMultiplier: 1
        source: menuTitleText2
        anchors.fill: menuTitleText2
    }
}
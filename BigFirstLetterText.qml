import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects


Text {
    id: myself
    // These are going to need to be controlled on a per-instance basis so we
    // DO NOT set them as part of this custom component
    // rotation: 90
    // z: 0

    required property string text
    required property int basePixelSize
    property real firstLetterMultiplier: 5
    property var fontFamily: fontSansSerif.font.family

    // Return the text property, which is a RichText string that makes the first character
    // larger
    function getText() {
        if (!text) {
            return "";
        }
        const first = text[0];
        const rest = text.substring(1);
        const bigLetterSize = basePixelSize * firstLetterMultiplier;

        return `<span style='font-size: ${bigLetterSize}px;'>${first}</span>` + `<span>${rest}</span>`;
    }

    MultiEffect {
        blurEnabled: true
        blur: 1.0
        blurMax: 10
        source: myText
        anchors.fill: myText
    }

    Text {
        id: myText
        font {
            family: fontFamily
            pixelSize: basePixelSize
        }
        color: myself.color
        text: myself.getText(myself.text, basePixelSize)
        textFormat: Text.RichText
    }
}

import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

Text {
    property real firstLetterMultiplier: 5
    property string rawText

    // Return the text property, which is a RichText string that makes the first character
    // larger
    function getText() {
        if (!rawText) {
            return "";
        }
        const first = rawText[0];
        const rest = rawText.substring(1);
        const bigLetterSize = font.pixelSize * firstLetterMultiplier;

        return `<span style='font-size: ${bigLetterSize}px;'>${first}</span>` +
            `<span>${rest}</span>`;
    }

    text: getText()
    textFormat: Text.RichText
}

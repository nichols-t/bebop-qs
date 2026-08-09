import QtQuick

import "../.."

Text {
    required property var date
    text: `${Qt.formatDateTime(date, 'MMMM')} ${Qt.formatDateTime(date, 'yyyy')}`
    rotation: 90
    font.family: Config.fontBlocky.font.family
    font.bold: true
    font.variableAxes: {
        "wght": 700
    }
    y: implicitWidth
    color: "white"
}

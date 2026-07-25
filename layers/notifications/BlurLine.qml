import Quickshell
import QtQuick
import QtQuick.Effects

Item {
    id: root
    property real rectHeight: rect.height
    property real rectWidth: rect.width
    property color color
    height: rect.height
    Rectangle {
        id: rect
        height: root.rectHeight
        width: root.rectWidth
        color: root.color
        visible: false // only hte blurred MultiEffect should be visible
    }
    MultiEffect {
        opacity: 1.0
        blurEnabled: true
        blur: 1.0
        blurMax: 6
        blurMultiplier: 1
        source: rect
        anchors.fill: rect
    }
}

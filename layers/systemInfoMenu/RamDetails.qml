import QtQuick
import QtQuick.VectorImage
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import "../.."
import "../../utils"

// NOTE: NEED TO CHECK "FLATTEN CLIP" IN INKSCAPE FOR IT TO RENDER HOLES PROPERLY!!!
// AGH!!!
Rectangle {
    id: root
    anchors.fill: parent
    color: "transparent"

    property int horizontalRamAnimSpeed: 1000
    property int verticalRamAnimSpeed: 400

    Image {
        id: ramImage1
        property real startY: parent.height * 0.1
        property real startX: width / 2
        property real endX: startX - width /2
        x: startX
        y: startY
        fillMode: Image.PreserveAspectFit
        source: Qt.resolvedUrl("../../assets/ram.svg")
        visible: true
        sourceSize.width: parent.width / 2
        //sourceSize.height: parent.width
    }

    Image {
        id: ramImage2
        property real startY: parent.height * 0.2
        property real startX: width / 2
        property real endX: startX + width / 2
        x: startX
        y: startY
        fillMode: Image.PreserveAspectFit
        source: Qt.resolvedUrl("../../assets/ram.svg")
        visible: true
        sourceSize.width: parent.width / 2
        //sourceSize.height: parent.width
    }

    SequentialAnimation {
        loops: Animation.Infinite
        running: true
        // Annoying that it doesn't have reverse...
        ParallelAnimation {
            loops: 1
            NumberAnimation {
                target: ramImage1
                property: "x"
                from: ramImage1.startX
                to: ramImage1.endX
                duration: horizontalRamAnimSpeed
            }
            NumberAnimation {
                target: ramImage2
                property: "x"
                from: ramImage2.startX
                to: ramImage2.endX
                duration: horizontalRamAnimSpeed
            }
        }
        ParallelAnimation {
            loops: 1
            NumberAnimation {
                target: ramImage1
                property: "y"
                from: ramImage1.startY
                to: ramImage2.startY
                duration: verticalRamAnimSpeed
            }
            NumberAnimation {
                target: ramImage2
                property: "y"
                from: ramImage2.startY
                to: ramImage1.startY
                duration: verticalRamAnimSpeed
            }
        }
        ParallelAnimation {
            loops: 1
            NumberAnimation {
                target: ramImage1
                property: "x"
                from: ramImage1.endX
                to: ramImage1.startX
                duration: horizontalRamAnimSpeed
            }
            NumberAnimation {
                target: ramImage2
                property: "x"
                from: ramImage2.endX
                to: ramImage2.startX
                duration: horizontalRamAnimSpeed
            }
        }
        // Annoying that it doesn't have reverse...
        ParallelAnimation {
            loops: 1
            NumberAnimation {
                target: ramImage1
                property: "x"
                from: ramImage1.startX
                to: ramImage1.endX
                duration: horizontalRamAnimSpeed
            }
            NumberAnimation {
                target: ramImage2
                property: "x"
                from: ramImage2.startX
                to: ramImage2.endX
                duration: horizontalRamAnimSpeed
            }
        }
        ParallelAnimation {
            loops: 1
            NumberAnimation {
                target: ramImage1
                property: "y"
                from: ramImage2.startY
                to: ramImage1.startY
                duration: verticalRamAnimSpeed
            }
            NumberAnimation {
                target: ramImage2
                property: "y"
                from: ramImage1.startY
                to: ramImage2.startY
                duration: verticalRamAnimSpeed
            }
        }
        ParallelAnimation {
            loops: 1
            NumberAnimation {
                target: ramImage1
                property: "x"
                from: ramImage1.endX
                to: ramImage1.startX
                duration: horizontalRamAnimSpeed
            }
            NumberAnimation {
                target: ramImage2
                property: "x"
                from: ramImage2.endX
                to: ramImage2.startX
                duration: horizontalRamAnimSpeed
            }
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        Repeater {
            model: SysInfo.ramUsage.systemInfoDetails
            DetailsInfoText {
                required property var modelData
                text: modelData
                maxWidth: root.width * 0.8
            }
        }
    }
}

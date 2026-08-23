import QtQuick
import QtQuick.VectorImage
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import "../.."
import "../../utils"

Rectangle {
    anchors.fill: parent
    color: "transparent"

    Image {
        id: cpuImage
        anchors.left: parent.left
        anchors.right: parent.right
        y: parent.height * 0.1
        fillMode: Image.PreserveAspectFit
        source: Qt.resolvedUrl("../../assets/cpu.svg")
        visible: true
        sourceSize.width: parent.width / 2
        //sourceSize.height: parent.width

        // I would rather do RowLayout but it breaks :(
        // Something about how I defined movingRect doesn't work right
        MovingRectangle {}
        MovingRectangle {
            anchors.horizontalCenterOffset: parent.width / 25
        }
        MovingRectangle {
            anchors.horizontalCenterOffset: 2* parent.width / 25
        }
        MovingRectangle {
            anchors.horizontalCenterOffset: -parent.width / 25
        }
        MovingRectangle {
            anchors.horizontalCenterOffset: -2* parent.width / 25
        }

        MovingRectangle { rotation: 90 }
        MovingRectangle {
            rotation: 90
            anchors.verticalCenterOffset: parent.width / 25
        }
        MovingRectangle {
            rotation: 90
            anchors.verticalCenterOffset: 2* parent.width / 25
        }
        MovingRectangle {
            rotation: 90
            anchors.verticalCenterOffset: -parent.width / 25
        }
        MovingRectangle {
            rotation: 90
            anchors.verticalCenterOffset: -2* parent.width / 25
        }
    }

    ListView {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: detailsCol.height * 0.5
        ColumnLayout {
            id: detailsCol
            anchors.centerIn: parent
            Repeater {
                model: SysInfo.cpuModel.systemInfoDetails
                DetailsInfoText {
                    required property var modelData
                    text: modelData
                }
            }
        }
    }

    component MovingRectangle: Rectangle {
        anchors.centerIn: parent
        width: parent.width / 50
        // This one is NOT themed because the SVGs are fixed to black
        color: "black"
        height: parent.width / 3
        radius: 4

        SequentialAnimation on anchors.verticalCenterOffset {
            loops: Animation.Infinite
            running: rotation === 0
            NumberAnimation {
                from: -parent.width / 100
                to: parent.width / 100
                duration: 1500 + Math.random() * 500 - 250;
            }
            NumberAnimation {
                from: parent.width / 100
                to: -parent.width / 100
                duration: 1500 + Math.random() * 500 - 250;
            }
        }

        SequentialAnimation on anchors.horizontalCenterOffset {
            loops: Animation.Infinite
            running: rotation === 90
            NumberAnimation {
                from: -parent.width / 100
                to: parent.width / 100
                duration: 1500 + Math.random() * 500 - 250;
            }
            NumberAnimation {
                from: parent.width / 100
                to: -parent.width / 100
                duration: 1500 + Math.random() * 500 - 250;
            }
        }
    }
}

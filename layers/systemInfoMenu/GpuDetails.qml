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

    property int loopDuration: 3000
    FanBodySVG {
        y: parent.height * 0.1
        id: gpuBody
        FanSVG {
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: -gpuBody.width * 0.185
        }
        FanSVG {
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: gpuBody.width * 0.105
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        Repeater {
            model: SysInfo.gpuModel.systemInfoDetails
            DetailsInfoText {
                required property var modelData
                text: modelData
                maxWidth: root.width * 0.8
            }
        }
        Repeater {
            model: SysInfo.gpuUsage.systemInfoDetails
            DetailsInfoText {
                required property var modelData
                text: modelData
                maxWidth: root.width * 0.8
            }
        }
    }

    component FanBodySVG: Image {
        id: myself
        fillMode: Image.PreserveAspectFit
        source: Qt.resolvedUrl("../../assets/gpu-body.svg")
        visible: true
        sourceSize.width: parent.width
    }
    component FanSVG: Image {
        fillMode: Image.PreserveAspectFit
        source: Qt.resolvedUrl("../../assets/fan.svg")
        visible: true
        sourceSize.width: gpuBody.width / 4
        sourceSize.height: gpuBody.width / 4

        RotationAnimation on rotation {
            loops: Animation.Infinite
            from: 0
            to: 360
            duration: loopDuration
        }
    }
}

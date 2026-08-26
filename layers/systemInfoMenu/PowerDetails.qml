import QtQuick
import QtQuick.VectorImage
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "../.."
import "../../utils"

Rectangle {
    id: root
    anchors.fill: parent
    color: "transparent"

    ColumnLayout {
        anchors.fill: parent
        anchors.top: parent.top
        spacing: 0
        // make a battery image - this is a placeholder
        Image {
            id: diskImage
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: root.height * 0.1
            //anchors.verticalCenterOffset: -root.height * 0.2
            fillMode: Image.PreserveAspectFit
            source: Qt.resolvedUrl("../../assets/power.svg")
            visible: true
            sourceSize.height: parent.height / 3
            z: 2
            Image {
                id: sparkImage
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                source: Qt.resolvedUrl("../../assets/power-spark.svg")
                visible: false
                sourceSize.height: parent.height / 2
                z: 3
            }

            MultiEffect {
                z: 3
                anchors.fill: sparkImage
                source: sparkImage
                blurEnabled: true
                blur: 1.0
                blurMax: 2
                colorization: 1.0
                colorizationColor: Config.systemInfo.power.sparkColor
                SequentialAnimation on visible {
                    loops: Animation.Infinite
                    PropertyAnimation {
                        to: true
                        duration: 50 + Math.random() * 50
                    }
                    PropertyAnimation {
                        to: false
                        duration: 500 + Math.random() * 100
                    }
                    PropertyAnimation {
                        to: true
                        duration: 50 + Math.random() * 50
                    }
                    PropertyAnimation {
                        to: false
                        duration: 500 + Math.random() * 100
                    }
                }
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: -parent.height * 0.55
            Repeater {
                model: SysInfo.power.systemInfoDetails
                DetailsInfoText {
                    required property var modelData
                    text: modelData
                    maxWidth: root.width * 0.8
                }
            }
        }
    }
}

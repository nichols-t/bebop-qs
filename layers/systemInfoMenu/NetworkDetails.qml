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

    property int jumpDuration: 10

    ColumnLayout {
        anchors.fill: parent
        anchors.top: parent.top
        spacing: 0
        Image {
            id: diskImage
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: root.height * 0.1
            //anchors.verticalCenterOffset: -root.height * 0.2
            fillMode: Image.PreserveAspectFit
            source: Qt.resolvedUrl("../../assets/network.svg")
            visible: true
            sourceSize.height: parent.height / 3
            // Calculated coords based on this image's dimensions
            // to correspond to each network node
            // very silly!
            property real ballDim: height * 0.03
            property real n1x: width * 0.57
            property real n1y: height * 0.45
            property real n2x: width * 0.72
            property real n2y: height * 0.1
            property real n3x: width * 0.77
            property real n3y: height * 0.85
            property real n4x: width * 0.168
            property real n4y: height * 0.25
            property real n5x: width * 0.168
            property real n5y: height * 0.70
            Rectangle {
                id: ball
                x: parent.n1x
                y: parent.n1y
                width: parent.ballDim
                height: width
                radius: width / 2
                visible: true
            }

            SequentialAnimation {
                loops: Animation.Infinite
                running: true

                ParallelAnimation {
                    loops: 1
                    NumberAnimation {
                        target: ball
                        property: "x"
                        from: diskImage.n1x
                        to: diskImage.n2x
                        duration: jumpDuration
                    }
                    NumberAnimation {
                        target: ball
                        property: "y"
                        from: diskImage.n1y
                        to: diskImage.n2y
                        duration: jumpDuration
                    }
                }
                ParallelAnimation {
                    loops: 1
                    NumberAnimation {
                        target: ball
                        property: "x"
                        from: diskImage.n2x
                        to: diskImage.n3x
                        duration: jumpDuration
                    }
                    NumberAnimation {
                        target: ball
                        property: "y"
                        from: diskImage.n2y
                        to: diskImage.n3y
                        duration: jumpDuration
                    }
                }
                ParallelAnimation {
                    loops: 1
                    NumberAnimation {
                        target: ball
                        property: "x"
                        from: diskImage.n3x
                        to: diskImage.n4x
                        duration: jumpDuration
                    }
                    NumberAnimation {
                        target: ball
                        property: "y"
                        from: diskImage.n3y
                        to: diskImage.n4y
                        duration: jumpDuration
                    }
                }
                ParallelAnimation {
                    loops: 1
                    NumberAnimation {
                        target: ball
                        property: "x"
                        from: diskImage.n4x
                        to: diskImage.n5x
                        duration: jumpDuration
                    }
                    NumberAnimation {
                        target: ball
                        property: "y"
                        from: diskImage.n4y
                        to: diskImage.n5y
                        duration: jumpDuration
                    }
                }
                ParallelAnimation {
                    loops: 1
                    NumberAnimation {
                        target: ball
                        property: "x"
                        from: diskImage.n5x
                        to: diskImage.n1x
                        duration: jumpDuration
                    }
                    NumberAnimation {
                        target: ball
                        property: "y"
                        from: diskImage.n5y
                        to: diskImage.n1y
                        duration: jumpDuration
                    }
                }
            }
        }

        MultiEffect {
            anchors.fill: diskImage
            source: diskImage
            colorization: 1.0
            colorizationColor: Config.systemInfo.network.graphicAccentColor
        }


        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: -parent.height * 0.55
            Repeater {
                model: SysInfo.network.systemInfoDetails
                DetailsInfoText {
                    required property var modelData
                    text: modelData
                    maxWidth: root.width * 0.8
                }
            }
        }
    }
}

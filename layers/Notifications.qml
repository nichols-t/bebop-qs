import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import ".."
import "../.."

import QtQuick.Shapes

// TODO: appearance is not designed at all, but it works
// Built from https://www.youtube.com/watch?v=leCzeCeNxas
Scope {
    id: root
    required property var modelData

    NotificationServer {
        id: server
        actionsSupported: true
        bodyImagesSupported: true
        imageSupported: true

        onNotification: n => {
            n.tracked = true;
        }
    }

    PanelWindow {
        anchors {
            top: true
            right: true
        }
        screen: modelData
        margins {
            // TODO: set to 0 to render above taskbar, but decide if that's actually
            // what I want
            top: Config.taskbar.taskbarHeight
            right: 2
        }

        //Behavior on implicitWidth {}
        implicitWidth: 380
        implicitHeight: Math.max(1, column.implicitHeight)
        color: "transparent"

        exclusionMode: ExclusionMode.Ignore

        ColumnLayout {
            id: column
            width: parent.width
            spacing: 10

            Repeater {
                model: server.trackedNotifications

                delegate: Shape {
                    // TODO: Style and prep this for re-use
                    id: card
                    required property var modelData

                    Timer {
                        running: card.modelData.urgency !== NotificationUrgency.Critical
                        interval: 5000
                        onTriggered: card.modelData.dismiss()
                    }
                    // TODO better means of doing this
                    width: 300
                    height: 150
                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                    //Layout.preferredHeight: layout.implicitHeight + 20
                    //required property var modelData
                    z: 0
                    ShapePath {
                        id: path
                        // see joinStyle
                        strokeWidth: 4
                        // TODO theme and re-use this shape!! could be fancy!!
                        strokeColor: "#6a5c72"
                        fillColor: "#504558"
                        strokeStyle: ShapePath.SolidLine
                        startX: path.strokeWidth
                        startY: path.strokeWidth
                        PathLine {
                            x: card.width - 20
                            y: path.strokeWidth
                        }
                        PathLine {
                            x: card.width
                            y: card.height - path.strokeWidth
                        }
                        // 20 here is "parellelogrametry" and 4 is strokeWidth
                        PathLine {
                            x: path.strokeWidth + 20
                            y: card.height - path.strokeWidth
                        }
                        PathLine {
                            x: path.strokeWidth
                            y: path.strokeWidth
                        }
                    }

                    RowLayout {
                        id: layout
                        anchors.fill: parent
                        anchors.margins: 10
                        anchors.leftMargin: 30
                        spacing: 10

                        // TODO: This image part isn't tested yet because I don't have a notification
                        // that uses one
                        Image {
                            id: image
                            Layout.preferredHeight: 36
                            Layout.preferredWidth: 36
                            Layout.alignment: Qt.AlignTop
                            fillMode: Image.PreserveAspectFit
                            visible: source.toString() !== ""
                            source: card.modelData.image || card.modelData.appIcon || ""
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                Layout.fillWidth: true
                                text: card.modelData.summary
                                color: "white" // TODO theme it
                                font.bold: true
                                font.family: Config.fontTypewriter.font.family
                                font.pixelSize: 18 // TODO them it
                                elide: Text.ElideRight
                            }

                            Text {
                                Layout.fillWidth: true
                                text: card.modelData.body
                                color: "white"
                                font.family: Config.fontTypewriter.font.family
                                font.pixelSize: Math.max(0, 16)
                                visible: text !== ""
                                wrapMode: Text.WordWrap
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: card.modelData.dismiss()
                    }
                }
            }
        }
    }
}

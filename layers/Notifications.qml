import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import ".."
import "../.."
import "./notifications" as LayerParts

import QtQuick.Shapes

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
        id: panel
        anchors {
            top: true
            right: true
        }
        screen: modelData
        margins {
            // TODO: set to 0 to render above taskbar, but decide if that's actually
            // what I want
            top: Config.taskbar.taskbarHeight + 2
            right: 0
        }

        property real notificationWidth: screen.width * 0.166
        implicitWidth: notificationWidth
        // TODO why is this max here?
        implicitHeight: Math.max(1, column.implicitHeight)
        color: "transparent"

        exclusionMode: ExclusionMode.Ignore

        ColumnLayout {
            id: column
            spacing: -20
            Layout.fillWidth: true
            // TODO: this is choppy when a lot of notifications come in. I'm not sure if that's fixable
            // This lets animations come in from the right edge; by default they come in from the left
            layoutDirection: Qt.RightToLeft
            // This allows the first notification to come in from the right. Otherwise it plays only
            // the top-down animation
            anchors.right: parent.right

            Repeater {
                model: server.trackedNotifications

                WrapperMouseArea {
                    // TODO: Style and prep this for re-use
                    id: card
                    onClicked: modelData.dismiss()
                    cursorShape: Qt.PointingHandCursor
                    required property var modelData
                    WrapperRectangle {
                        id: cardBackground
                        color: "black"
                        margin: 0
                        radius: 2
                        Layout.fillWidth: true
                        implicitWidth: 0 // ends up at panel.notificationWidth
                        Component.onCompleted: {
                            implicitWidth = panel.notificationWidth
                        }
                        Behavior on implicitWidth {
                            NumberAnimation {duration: 250 }
                        }
                        
                        ColumnLayout {
                            id: colLayout
                            anchors.fill: parent
                            // Margin in from left edge for items contained in this row
                            property real itemsLeftMargin: applicationText.font.pixelSize / 2
                            Layout.preferredWidth: cardBackground.width
                            
                            spacing: 0

                            RowLayout {
                                Image {
                                    id: image
                                    Layout.preferredHeight: panel.screen.height / 15
                                    Layout.preferredWidth: panel.screen.height / 15
                                    Layout.margins: colLayout.itemsLeftMargin
                                    Layout.alignment: Qt.AlignCenter
                                    fillMode: Image.PreserveAspectFit
                                    // Even when there is no image, we want to reserve this space
                                    visible: true // source.toString() !== ""
                                    source: card.modelData.image || card.modelData.appIcon || ""
                                }

                                LayerParts.BlurLine {
                                    Layout.alignment: Qt.AlignRight
                                    rectHeight: panel.screen.height / 10 + 2
                                    rectWidth: 2
                                    color: Config.notifications.lineColor
                                }

                                ColumnLayout {
                                    id: textColLayout
                                    Layout.fillWidth: true
                                    spacing: 0
                                    Layout.leftMargin: colLayout.itemsLeftMargin

                                    Text {
                                        id: applicationText
                                        text: card.modelData.summary
                                        Layout.fillWidth: true
                                        color: Config.notifications.applicationTextColor
                                        font.bold: false
                                        font.family: Config.fontBlocky.font.family
                                        font.pixelSize: 16
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        // TODO preferred height? or we just do max lines and calc font sizes?
                                        Layout.fillWidth: true
                                        text: card.modelData.body
                                        color: Config.notifications.summaryTextColor
                                        font.family: Config.fontTypewriter.font.family
                                        font.pixelSize: 16
                                        minimumPixelSize: 12
                                        // Cut off text (nicely, with elide) so that we
                                        // don't inadvertently run into issues with the fancy lines
                                        elide: Text.ElideRight
                                        maximumLineCount: 3
                                        fontSizeMode: Text.VerticalFit
                                        visible: text !== ""
                                        wrapMode: Text.WordWrap
                                    }
                                }
                            }

                            LayerParts.BlurLine {
                                Layout.topMargin: -30
                                id: horizontalYellowLine
                                rectHeight: 2
                                rectWidth: cardBackground.width
                                color: Config.notifications.lineColor
                            }
                        }
                    }

                    Timer {
                        running: card.modelData.urgency !== NotificationUrgency.Critical
                        interval: 5000
                        onTriggered: card.modelData.dismiss()
                    }
                }
            }
        }
    }
}

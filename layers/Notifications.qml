import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import ".."
import "../.."
import "./notifications"

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
            top: Config.taskbar.taskbarHeight + 2
            right: 0
        }

        property real notificationWidth: screen.width * 0.166
        implicitWidth: notificationWidth
        implicitHeight: column.implicitHeight
        color: "transparent"

        Component.onCompleted: {
            if (this.WlrLayershell != null) {
                // Note that things that take exclusive focus like menus mean we still can't click
                // it, but we probably want it to appear nonetheless
                this.WlrLayershell.layer = WlrLayer.Overlay;
            }
        }

        exclusionMode: ExclusionMode.Ignore

        ColumnLayout {
            id: column
            spacing: -20
            Layout.fillWidth: true
            // This lets animations come in from the right edge; by default they come in from the left
            layoutDirection: Qt.RightToLeft
            // This allows the first notification to come in from the right. Otherwise it plays only
            // the top-down animation
            anchors.right: parent.right

            Repeater {
                model: server.trackedNotifications

                WrapperMouseArea {
                    id: card
                    onClicked: modelData.dismiss()
                    cursorShape: Qt.PointingHandCursor
                    required property var modelData
                    WrapperRectangle {
                        id: cardBackground
                        color: Config.notifications.backgroundColor
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
                                spacing: 0
                                Image {
                                    id: image
                                    property bool hasImage: source.toString() !== ""
                                    property real size: hasImage ? panel.screen.height / 15 : panel.screen.height / 50;
                                    Layout.preferredHeight: size
                                    Layout.preferredWidth: size
                                    Layout.margins: colLayout.itemsLeftMargin
                                    Layout.alignment: Qt.AlignCenter
                                    fillMode: Image.PreserveAspectFit
                                    // Even when there is no image, we want to reserve this space
                                    visible: true // source.toString() !== ""
                                    source: card.modelData.image || card.modelData.appIcon || ""
                                }

                                BlurLine {
                                    Layout.alignment: Qt.AlignRight
                                    rectHeight: image.hasImage ? image.size * 1.5 : image.size * 3
                                    rectWidth: 2
                                    z: 1
                                    color: Config.notifications.lineColor
                                }

                                Rectangle {
                                    id: accentRect
                                    color: Config.notifications.accentColor
                                    Layout.alignment: Qt.AlignTop | Qt.AlignRight
                                    Layout.preferredWidth: cardBackground.width - image.width
                                    Layout.preferredHeight: cardBackground.height - 15
                                    ColumnLayout {
                                        id: textColLayout
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        spacing: 0

                                        Text {
                                            Layout.topMargin: colLayout.itemsLeftMargin
                                            Layout.leftMargin: colLayout.itemsLeftMargin
                                            id: applicationText
                                            text: card.modelData.summary
                                            Layout.fillWidth: true
                                            color: Config.notifications.applicationTextColor
                                            font.bold: false
                                            font.family: Config.fontBlocky.font.family
                                            font.pointSize: Config.notifications.headerTextSize
                                            font.italic: true
                                            elide: Text.ElideRight
                                        }

                                        Text {
                                            Layout.fillWidth: true
                                            Layout.leftMargin: colLayout.itemsLeftMargin
                                            text: card.modelData.body
                                            color: Config.notifications.summaryTextColor
                                            font.family: Config.fontTypewriter.font.family
                                            font.pointSize: Config.notifications.bodyTextSize
                                            minimumPixelSize: Config.notifications.bodyTextSize
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
                            }

                            BlurLine {
                                Layout.topMargin: -Config.notifications.horizontalLineHeight
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

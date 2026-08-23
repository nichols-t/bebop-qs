import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Notifications
import "../.."

WrapperMouseArea {
    id: root
    onClicked: notification.dismiss()
    cursorShape: Qt.PointingHandCursor
    required property var notification
    required property real notificationWidth
    required property real notificationHeight
    Layout.alignment: Qt.AlignRight

    WrapperRectangle {
        id: cardBackground
        color: Config.notifications.backgroundColor
        margin: 0
        radius: 2
        implicitWidth: notificationWidth
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
                    Layout.preferredHeight: notificationHeight
                    Layout.preferredWidth: notificationHeight
                    Layout.margins: colLayout.itemsLeftMargin
                    Layout.alignment: Qt.AlignCenter
                    fillMode: Image.PreserveAspectFit
                    // Even when there is no image, we want to reserve this space
                    visible: true // source.toString() !== ""
                    source: root.notification.image || root.notification.appIcon || ""
                }

                BlurLine {
                    Layout.alignment: Qt.AlignRight
                    rectHeight: image.hasImage ? notificationHeight * 1.5 : notificationHeight * 3
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
                            id: applicationText
                            Layout.topMargin: colLayout.itemsLeftMargin
                            Layout.leftMargin: colLayout.itemsLeftMargin
                            text: root.notification.summary
                            Layout.preferredWidth: width
                            width: accentRect.width * 0.9
                            color: Config.notifications.headerTextColor
                            font.bold: false
                            wrapMode: Text.WordWrap
                            font.family: Config.fontBlocky.font.family
                            font.pointSize: Config.notifications.headerTextSize
                            font.italic: true
                            elide: Text.ElideRight
                        }

                        Text {
                            Layout.preferredWidth: width
                            width: accentRect.width * 0.9
                            Layout.leftMargin: colLayout.itemsLeftMargin
                            text: root.notification.body
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
                id: horizontalYellowLine
                Layout.topMargin: -Config.notifications.horizontalLineHeight
                rectHeight: 2
                rectWidth: cardBackground.width
                color: Config.notifications.lineColor
            }
        }
    }

    Timer {
        running: root.notification.urgency !== NotificationUrgency.Critical
        interval: 5000
        onTriggered: root.notification.dismiss()
    }
}

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
    required property var screen

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
        screen: root.screen
        margins.top: Config.taskbar.taskbarHeight + 2
        margins.right: 0

        // On some screens this is really small so set a min width so that users can control if the card
        // is going to be tiny or not        
        property real notificationWidth: Math.max(screen.width * 0.166, Config.notifications.minimumWidth)
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
            spacing: 0
            Layout.fillWidth: true
            // This lets animations come in from the right edge; by default they come in from the left
            layoutDirection: Qt.RightToLeft
            // This allows the first notification to come in from the right. Otherwise it plays only
            // the top-down animation
            anchors.right: parent.right

            Repeater {
                model: server.trackedNotifications

                NotificationCard {
                    required property var modelData
                    notification: modelData
                    notificationWidth: panel.notificationWidth
                    property string source: modelData.image || modelData.appIcon || ""
                    property bool hasImage: source.toString() !== ""
                    notificationHeight: hasImage ? panel.screen.height / 15 : panel.screen.height / 50
                }
            }
        }
    }
}

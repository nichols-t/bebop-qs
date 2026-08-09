import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Mpris

import "../../.."

Rectangle {
    id: root
    color: "transparent"

    required property MprisPlayer player

    RowLayout {
        width: root.width
        spacing: 0

        AudioControlButton {
            onClicked: {
                if (root.player?.canGoPrevious) {
                    root.player.previous();
                }
            }
            layoutAlignment: Qt.AlignLeft
            implicitHeight: root.height
            implicitWidth: root.width * .25
            enabled: root.player?.canGoPrevious || false
            text: "PREV"
        }

        Item {
            Layout.fillWidth: true
        }

        AudioControlButton {
            onClicked: {
                if (root.player) {
                    root.player.isPlaying = !root.player.isPlaying;
                }
            }
            layoutAlignment: Qt.AlignCenter
            implicitHeight: root.height
            implicitWidth: root.width * 0.3
            text: {
                if (root.player?.isPlaying) {
                    return "PAUSE";
                } else {
                    return "PLAY";
                }
            }
        }

        Item {
            Layout.fillWidth: true
        }

        AudioControlButton {
            onClicked: {
                if (root.player?.canGoNext) {
                    root.player.next();
                }
            }
            layoutAlignment: Qt.AlignRight
            implicitHeight: root.height
            implicitWidth: root.width * 0.25
            text: "NEXT"
            enabled: root.player?.canGoPrevious || false
        }
    }

    component AudioControlButton: WrapperMouseArea {
        cursorShape: Qt.PointingHandCursor
        property alias implicitWidth: btnRect.implicitWidth
        property alias implicitHeight: btnRect.implicitHeight
        property alias text: btnText.text
        property var layoutAlignment
        Rectangle {
            id: btnRect
            Layout.alignment: layoutAlignment
            color: Config.audioSettings.accentColor
            Text {
                id: btnText
                anchors.centerIn: parent
                color: Config.audioSettings.trackControlTextColor
                font.family: Config.fontBlocky.font.family
                font.pointSize: Config.audioSettings.trackControlTextSize
            }
        }
    }
}

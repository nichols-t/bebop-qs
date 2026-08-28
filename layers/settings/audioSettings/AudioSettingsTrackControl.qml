import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Mpris

import "../../.."

WrapperRectangle {
    id: root
    color: "transparent"

    required property MprisPlayer player
    required property real seekHeight

    Timer {
        // only emit the signal when the position is actually changing.
        running: player?.playbackState == MprisPlaybackState.Playing
        // Make sure the position updates at least once per second.
        interval: 1000
        repeat: true
        // emit the positionChanged signal every second.
        onTriggered: player.positionChanged()
    }

    ColumnLayout {
        width: root.width
        spacing: root.width * 0.1 / 2

        AudioSettingsSeekSlider {
            player: root.player
            implicitHeight: seekHeight
        }

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
                enabled: !!root.player
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
        RowLayout {
            width: root.width
            spacing: 0

            AudioControlButton {
                layoutAlignment: Qt.AlignLeft
                implicitHeight: root.height
                implicitWidth: root.width * 0.25
                text: "SHUFFLE"
                enabled: root.player?.loopSupported || false
                onClicked: {
                    if (root.player) {
                        root.player.shuffle = !root.player.shuffle;
                    }
                }
            }

            Item {
                Layout.fillWidth: true
            }

            ColumnLayout {
                implicitHeight: root.height
                implicitWidth: root.width * 0.3
                Text {
                    Layout.alignment: Qt.AlignCenter
                    text: {
                        switch (root.player?.loopState) {
                        case MprisLoopState.None:
                            return "";
                        case MprisLoopState.Track:
                            return "LOOPING TRACK";
                        case MprisLoopState.Playlist:
                            return "LOOPING ALL";
                        default:
                            return "";
                        }
                    }
                    font.family: Config.fontTypewriter.font.family
                    font.pointSize: Config.audioSettings.trackControlIndicatorTextSize
                    color: Theme.audioSettingsColorSet.trackControlTextColor
                }
                Text {
                    Layout.alignment: Qt.AlignCenter
                    font.family: Config.fontTypewriter.font.family
                    font.pointSize: Config.audioSettings.trackControlIndicatorTextSize
                    text: root.player?.shuffle ? "SHUFFLING" : ""
                    color: Theme.audioSettingsColorSet.trackControlTextColor
                }
            }

            Item {
                Layout.fillWidth: true
            }

            AudioControlButton {
                layoutAlignment: Qt.AlignLeft
                implicitHeight: root.height
                implicitWidth: root.width * 0.25
                text: "LOOP"
                enabled: root.player?.loopSupported || false
                onClicked: {
                    if (root.player) {
                        let current = root.player.loopState;
                        if (current == MprisLoopState.None) {
                            root.player.loopState = MprisLoopState.Playlist;
                        } else if (current == MprisLoopState.Playlist) {
                            root.player.loopState = MprisLoopState.Track;
                        } else {
                            // it is track -> none
                            root.player.loopState = MprisLoopState.None;
                        }
                    }
                }
            }
        }
    }

    component AudioControlButton: WrapperMouseArea {
        id: self
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        property alias implicitWidth: btnRect.implicitWidth
        property alias implicitHeight: btnRect.implicitHeight
        property alias text: btnText.text
        property var layoutAlignment
        hoverEnabled: true
        Rectangle {
            id: btnRect
            Layout.alignment: layoutAlignment
            color: {
                if (self.enabled) {
                    return Theme.audioSettingsColorSet.trackControlBackgroundColor;
                } else {
                    return Theme.audioSettingsColorSet.trackControlDisabledBackgroundColor;
                }
            }
            Rectangle {
                anchors.centerIn: parent
                width: self.containsMouse ? parent.width : 0
                height: btnText.height * 1.1
                color: Theme.audioSettingsColorSet.trackControlHoverRectColor
                border.width: 2
                border.color: {
                    if (pressed) {
                        return Theme.audioSettingsColorSet.trackControlClickedBorderColor;
                    } else {
                        return Theme.audioSettingsColorSet.trackControlHoverBorderColor;
                    }
                }

                Behavior on width {
                    NumberAnimation {
                        duration: 100
                    }
                }
                Behavior on border.color {
                    ColorAnimation {
                        duration: 100
                    }
                }
            }
            Text {
                id: btnText
                z: 1
                font.italic: self.containsMouse
                font.letterSpacing: self.containsMouse ? 2 : 0
                anchors.centerIn: parent
                color: {
                    if (self.enabled) {
                        return Theme.audioSettingsColorSet.trackControlTextColor;
                    } else {
                        return Theme.audioSettingsColorSet.trackControlDisabledTextColor;
                    }
                }
                font.family: Config.fontBlocky.font.family
                font.pointSize: Config.audioSettings.trackControlTextSize
            }
        }
    }
}

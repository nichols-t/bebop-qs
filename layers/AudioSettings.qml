import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import "../utils"
import "./settings"
import "./settings/audioSettings"
import "./settings"
import ".."

SettingsSubMenu {
    title: 'AUDIO'

    content: Component {
        ColumnLayout {
            id: cols
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            property real itemsMargin: width * 0.1 / 2
            width: parent.width * 0.9
            spacing: itemsMargin

            // Must retain focus to close on Esc
            focus: true

            property var sink: Pipewire.defaultAudioSink || null
            // Used for track information
            // https://quickshell.org/docs/v0.3.0/types/Quickshell.Services.Mpris/MprisPlayer/
            property var player: Mpris.players.values[0] || null

            Keys.onPressed: event => {
                if (!!cols.player) {
                    if (event.key === Qt.Key_Space) {
                        cols.player.isPlaying = !cols.player.isPlaying;
                    } else if (event.key === Qt.Key_Left) {
                        cols.player.previous();
                    } else if (event.key === Qt.Key_Right) {
                        cols.player.next();
                    }
                }
            }

            Rectangle {
                id: displayRect
                height: cols.width * 0.6
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                implicitWidth: cols.width * 0.9
                color: Theme.audioSettingsColorSet.recordBackgroundColor
                clip: true

                AudioSettingsRecordGraphic {
                    z: 1
                    anchors.fill: parent
                    anchors.centerIn: parent
                    playing: cols.player?.isPlaying || false
                    player: cols.player
                }

                AudioSettingsTrackTitleText {
                    id: titleText
                    z: 1
                    text: cols.player?.trackTitle || ''
                    anchors.top: parent.top
                    anchors.topMargin: displayRect.height * 0.1
                    isTooWide: width > displayRect.width
                }

                AudioSettingsPositionDurationText {
                    z: 1
                    player: cols.player
                    anchors.top: parent.top
                    anchors.topMargin: displayRect.height * 0.2
                    textWidth: displayRect.width
                }

                AudioSettingsApplicationText {
                    z: 1
                    text: cols.player?.identity || ''
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -width / 2
                    anchors.left: parent.left
                    anchors.leftMargin: font.pixelSize * 1.5
                }

                AudioSettingsTrackArtistText {
                    z: 1
                    text: cols.player?.trackArtist || ''
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height * 0.02
                }

                AudioSettingsVolumeIndicator {
                    container: displayRect
                    width: displayRect.width
                    maxHeight: container.height
                    anchors.bottom: displayRect.bottom
                    anchors.horizontalCenter: displayRect.horizontalCenter
                    sink: cols.sink
                }
            }

            AudioSettingsTrackControl {
                id: trackControl
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                player: cols.player
                implicitHeight: cols.width * 0.1
                implicitWidth: cols.width * 0.9
                seekHeight: cols.width * 0.03
                // For some reason the seek slider doesn't cause height to be recalculated
                // and also the height of this control doesn't seem to push stuff beneath it down
                // so we manually throw a margin here
                Layout.bottomMargin: (height + seekHeight) * 1.4
            }

            AudioSettingsPlayerSelect {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                width: cols.width
                Layout.fillHeight: true
                spacing: width * 0.01
                currentPlayer: cols.player
                setPlayer: player => {
                    cols.player = player;
                }
            }
        }
    }
}

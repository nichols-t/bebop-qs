import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import "../"
import "../utils"
import "./settings"
import "./settings/audioSettings"

Scope {
    id: root
    required property var modelData
    property bool shouldShow: false

    function show() {
        shouldShow = true;
        panel.show();
    }

    function close() {
        shouldShow = false;
    }

    property SystemInfo systemInfo
    property ShutdownMenu shutdownMenu

    PanelWindow {
        id: panel
        visible: shouldShow
        screen: modelData

        color: Config.settings.backgroundColor
        anchors {
            top: true
            bottom: true
            right: true
        }

        margins.right: root.shouldShow ? 0 : -width

        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        implicitWidth: screen.width * 0.3
        Behavior on margins.right {
            SequentialAnimation {
                NumberAnimation {
                    duration: 100
                }
                ScriptAction {
                    script: {
                        if (panel.margins.right < 0) {
                            root.close();
                        }
                    }
                }
            }
        }

        function show() {
            margins.right = 0;
        }

        function close() {
            // This should trigger an animation that reset root.onClose when it is done
            panel.margins.right = -panel.width;
        }

        ColumnLayout {
            id: cols
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            property real itemsMargin: panel.width * 0.1 / 2
            anchors.topMargin: itemsMargin
            width: panel.width * 0.9
            spacing: itemsMargin

            // Must retain focus to close on Esc
            focus: true

            property var sink: Pipewire.defaultAudioSink
            // Used for track information
            // https://quickshell.org/docs/v0.3.0/types/Quickshell.Services.Mpris/MprisPlayer/
            property var mpris: Mpris.players.values[0] || null

            Keys.onPressed: event => {
                if (event.key === Qt.Key_Escape) {
                    event.accepted = true;
                    panel.close();
                } else if (!!cols.mpris) {
                    if (event.key === Qt.Key_Space) {
                        cols.mpris.isPlaying = !cols.mpris.isPlaying;
                    } else if (event.key === Qt.Key_Left) {
                        cols.mpris.previous();
                    } else if (event.key === Qt.Key_Right) {
                        cols.mpris.next();
                    }
                }
            }

            SettingsMenuTitleText {
                id: titleText
                text: "AUDIO"
            }

            Rectangle {
                id: displayRect
                height: cols.width * 0.6
                implicitWidth: cols.width
                color: Config.audioSettings.accentColor
                clip: true

                AudioSettingsRecordGraphic {
                    anchors.fill: parent
                    anchors.centerIn: parent
                    playing: cols.mpris?.isPlaying || false
                }

                AudioSettingsTrackTitleText {
                    text: cols.mpris?.trackTitle || ''
                    width: displayRect.width
                    horizontalAlignment: Text.AlignHCenter
                    anchors.top: parent.top
                    anchors.topMargin: displayRect.height * 0.1
                }

                AudioSettingsPositionDurationText {
                    player: cols.mpris
                    anchors.top: parent.top
                    anchors.topMargin: displayRect.height * 0.2
                    textWidth: displayRect.width
                }

                AudioSettingsApplicationText {
                    z: 1
                    text: cols.mpris?.identity || ''
                    anchors.top: parent.top
                    anchors.topMargin: font.pixelSize * 0.2
                    anchors.left: parent.left
                    anchors.leftMargin: font.pixelSize * 1.5
                }

                AudioSettingsTrackArtistText {
                    z: 1
                    text: cols.mpris?.trackArtist || ''
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height * 0.02
                }

                AudioSettingsVolumeIndicator {
                    container: displayRect
                    width: displayRect.width
                    maxHeight: container.height * 0.22
                    anchors.bottom: displayRect.bottom
                    anchors.horizontalCenter: displayRect.horizontalCenter
                    sink: cols.sink
                }
            }

            AudioSettingsTrackControl {
                player: cols.mpris
                implicitHeight: cols.width * 0.1
                implicitWidth: cols.width
            }
        }
    }
}

import Quickshell
import Quickshell.Io
// TODO should audio info be from singleton? Is it already??
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

            // TODO is shuffled icon/text? cols.mpris?.shuffle
            // TODO rate control cols.mpris?.rate ${cols.mpris?.minRate} - ${cols.mpris?.maxRate}
            // TODO loop cols.mpris?.loopSupported
            // TODO position or length: cols.mpris?.length
            //  (note for streaming this is random timestamp I thikn)
            // TODO audio player ID (i.e. the app) cols.mpris?.identity
            // TODO track album cols.mpris?.trackAlbum
            // TODO track title cols.mpris?.trackTitle
            Rectangle {
                id: displayRect
                height: cols.width * 0.6
                implicitWidth: cols.width
                color: Config.audioSettings.accentColor
                clip: true

                Rectangle {
                    z: 1
                    visible: false
                    color: Config.audioSettings.accentColor
                    height: displayRect.height
                    width: displayRect.height * 0.05
                    anchors.left: parent.left
                }

                Rectangle {
                    z: 1
                    visible: false
                    color: Config.audioSettings.accentColor
                    height: displayRect.height
                    width: displayRect.height * 0.05
                    anchors.right: parent.right
                }

                AudioSettingsRecordGraphic {
                    anchors.fill: parent
                    anchors.centerIn: parent
                    playing: cols.mpris?.isPlaying || false
                }

                // TODO animate if it is long?
                Text {
                    text: cols.mpris?.trackTitle || ''
                    color: Config.audioSettings.trackTitleTextColor
                    width: displayRect.width
                    horizontalAlignment: Text.AlignHCenter
                    anchors.top: parent.top
                    anchors.topMargin: displayRect.height * 0.1
                    font.family: Config.fontTypewriter.font.family
                    font.pointSize: Config.audioSettings.trackTitleTextSize
                    font.bold: true
                }

                // Per docs position doesn't really update reactively unless we tell it to
                Timer {
                    // only emit the signal when the position is actually changing.
                    running: cols.mpris?.playbackState == MprisPlaybackState.Playing
                    // Make sure the position updates at least once per second.
                    interval: 1000
                    repeat: true
                    // emit the positionChanged signal every second.
                    onTriggered: cols.mpris.positionChanged()
                }
                Text {
                    text: {
                        const duration = Time.toHH_MM_SS(cols.mpris?.length || 0);
                        const position = Time.toHH_MM_SS(cols.mpris?.position || 0);

                        return `${position}/${duration}`;
                    }
                    color: Config.audioSettings.trackDurationTextColor
                    visible: cols.mpris?.positionSupported || false
                    width: displayRect.width
                    horizontalAlignment: Text.AlignHCenter
                    anchors.top: parent.top
                    anchors.topMargin: displayRect.height * 0.2
                    font.family: Config.fontTypewriter.font.family
                    font.pointSize: Config.audioSettings.trackDurationTextSize
                }

                Text {
                    z: 1
                    text: cols.mpris?.identity || ''
                    color: Config.audioSettings.playerTextColor // TODO theme
                    anchors.top: parent.top
                    anchors.topMargin: font.pixelSize * 0.2
                    anchors.left: parent.left
                    anchors.leftMargin: font.pixelSize * 1.5
                    font.family: Config.fontBlocky.font.family
                    font.pointSize: Config.audioSettings.playerTextSize
                    transform: Rotation {
                        origin.x: 0
                        origin.y: 0
                        angle: 90
                        axis {
                            x: 0
                            y: 0
                            z: 1
                        }
                    }
                }

                Text {
                    z: 1
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: cols.mpris?.trackArtist || ''
                    color: Config.audioSettings.trackArtistTextColor // TODO
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height * 0.02
                    font.family: Config.fontBlocky.font.family
                    font.pointSize: Config.audioSettings.trackArtistTextSize
                }

                Rectangle {
                    id: volumeRect
                    // TODO: vol bars thinggy?
                    width: displayRect.width
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Config.audioSettings.volumeBarColor
                    property real maxHeight: displayRect.height * 0.22
                    height: {
                        const vol = cols.sink?.audio.volume || 0;

                        if (cols.sink?.audio.muted) {
                            return 0;
                        }

                        return vol * maxHeight;
                    }

                    Behavior on height {
                        NumberAnimation {
                            duration: 100
                        }
                    }
                }
            }

            Rectangle {
                id: controlRect
                height: cols.width * 0.1
                implicitWidth: cols.width
                color: "black"

                RowLayout {
                    width: parent.width
                    spacing: cols.itemsMargin

                    AudioControlButton {
                        onClicked: {
                            if (cols.mpris?.canGoPrevious) {
                                cols.mpris.previous();
                            }
                        }
                        layoutAlignment: Qt.AlignLeft
                        implicitHeight: controlRect.height
                        implicitWidth: controlRect.width * .25
                        enabled: cols.mpris?.canGoPrevious || false
                        text: "PREV"
                    }

                    AudioControlButton {
                        onClicked: {
                            if (cols.mpris) {
                                cols.mpris.isPlaying = !cols.mpris.isPlaying;
                            }
                        }
                        layoutAlignment: Qt.AlignCenter
                        implicitHeight: controlRect.height
                        implicitWidth: controlRect.width * 0.30
                        text: {
                            if (cols.mpris?.isPlaying) {
                                return "PAUSE";
                            } else {
                                return "PLAY";
                            }
                        }
                    }

                    AudioControlButton {
                        onClicked: {
                            if (cols.mpris?.canGoNext) {
                                cols.mpris.next();
                            }
                        }
                        layoutAlignment: Qt.AlignRight
                        implicitHeight: controlRect.height
                        implicitWidth: controlRect.width * 0.25
                        text: "NEXT"
                        enabled: cols.mpris?.canGoPrevious || false
                    }
                }
            }
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

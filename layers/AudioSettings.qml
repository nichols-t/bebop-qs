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
import "./settings" as LayerParts

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
                }
            }

            LayerParts.SettingsMenuTitleText {
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

                LayerParts.AudioSettingsRecordGraphic {
                    anchors.fill: parent
                    anchors.centerIn: parent
                    playing: cols.mpris?.isPlaying
                }

                // TODO animate if it is long?
                Text {
                    text: cols.mpris?.trackTitle || ''
                    color: "white"
                    width: displayRect.width
                    horizontalAlignment: Text.AlignHCenter
                    anchors.top: parent.top
                    anchors.topMargin: displayRect.height * 0.1
                    font.family: Config.fontTypewriter.font.family
                    font.pointSize: Config.audioSettings.trackTitleTextSize
                }

                Text {
                    z: 1
                    text: cols.mpris?.trackAlbum || ''
                    color: "black" // TODO theme
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -parent.height / 4
                    anchors.left: parent.left
                    anchors.leftMargin: font.pixelSize * 1.5
                    font.family: Config.fontBlocky.font.family
                    font.pointSize: Config.audioSettings.artistTextSize
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
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: cols.mpris?.trackArtist || ''
                    color: Config.audioSettings.trackControlTextColor // TODO
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height * 0.05
                    font.family: Config.fontBlocky.font.family
                    font.pointSize: Config.audioSettings.artistTextSize
                }

                Rectangle {
                    id: volumeRect
                    // TODO: vol bars thinggy?
                    height: displayRect.height * 0.06
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Config.audioSettings.volumeBarColor
                    width: {
                        const vol = cols.sink?.audio.volume || 0;

                        if (cols.sink?.audio.muted) {
                            return 0;
                        }

                        return vol * displayRect.width;
                    }

                    Behavior on width {
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
                color: Config.audioSettings.accentColor

                RowLayout {
                    width: parent.width
                    spacing: cols.itemsMargin

                    WrapperMouseArea {
                        onClicked: {
                            if (cols.mpris?.canGoPrevious) {
                                cols.mpris.previous();
                            }
                        }
                        cursorShape: Qt.PointingHandCursor
                        Rectangle {
                            Layout.alignment: Qt.AlignLeft
                            implicitHeight: controlRect.height
                            implicitWidth: controlRect.width * .25
                            color: "transparent"
                            Text {
                                anchors.centerIn: parent
                                text: "PREV"
                                color: Config.audioSettings.trackControlTextColor
                                font.family: Config.fontBlocky.font.family
                                font.pointSize: Config.audioSettings.trackControlTextSize
                            }
                        }
                    }

                    WrapperMouseArea {
                        onClicked: {
                            if (cols.mpris) {
                                cols.mpris.isPlaying = !cols.mpris.isPlaying;
                            }
                        }
                        cursorShape: Qt.PointingHandCursor
                        Rectangle {
                            Layout.alignment: Qt.AlignCenter
                            implicitHeight: controlRect.height
                            implicitWidth: controlRect.width * 0.30
                            color: "transparent"
                            Text {
                                anchors.centerIn: parent
                                text: {
                                    if (cols.mpris?.isPlaying) {
                                        return "PAUSE";
                                    } else {
                                        return "PLAY";
                                    }
                                }
                                color: Config.audioSettings.trackControlTextColor
                                font.family: Config.fontBlocky.font.family
                                font.pointSize: Config.audioSettings.trackControlTextSize
                            }
                        }
                    }

                    WrapperMouseArea {
                        onClicked: {
                            if (cols.mpris?.canGoNext) {
                                cols.mpris.next();
                            }
                        }
                        cursorShape: Qt.PointingHandCursor
                        Rectangle {
                            Layout.alignment: Qt.AlignRight
                            implicitHeight: controlRect.height
                            implicitWidth: controlRect.width * 0.25
                            color: "transparent"
                            Text {
                                anchors.centerIn: parent
                                text: "NEXT"
                                color: Config.audioSettings.trackControlTextColor
                                font.family: Config.fontBlocky.font.family
                                font.pointSize: Config.audioSettings.trackControlTextSize
                            }
                        }
                    }
                }
            }
        }
    }
}

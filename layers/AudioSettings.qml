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
            property var player: Mpris.players.values[0] || null

            Keys.onPressed: event => {
                if (event.key === Qt.Key_Escape) {
                    event.accepted = true;
                    panel.close();
                } else if (!!cols.player) {
                    if (event.key === Qt.Key_Space) {
                        cols.player.isPlaying = !cols.player.isPlaying;
                    } else if (event.key === Qt.Key_Left) {
                        cols.player.previous();
                    } else if (event.key === Qt.Key_Right) {
                        cols.player.next();
                    }
                }
            }

            SettingsMenuTitleText {
                id: titleText
                text: "AUDIO"
            }

            Loader {
                id: audioInfoLoader
                sourceComponent: panel.visible ? audioInfo : null
                asynchronous: false
                height: cols.width * 0.6
                // This can be used if partial loading needs to be avoided
                //visible: status == Loader.Ready
            }

            Component {
                id: audioInfo
                Rectangle {
                    id: displayRect
                    implicitWidth: cols.width
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
            }

            Loader {
                id: audioControlsLoader
                sourceComponent: panel.visible ? audioControls : null
                asynchronous: true
            }

            Component {
                id: audioControls
                AudioSettingsTrackControl {
                    player: cols.player
                    implicitHeight: cols.width * 0.1
                    implicitWidth: cols.width
                }
            }

            Rectangle {
                Layout.topMargin: 2 * cols.itemsMargin
                color: "transparent"
                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
            }

            ColumnLayout {
                Text {
                    visible: Mpris.players.values.length !== 0
                    text: "NOW PLAYING"
                    color: Config.settings.menuTitleTextColor
                    font.family: Config.fontBlocky.font.family
                    font.italic: true
                    font.pointSize: Config.settings.menuTitleTextSize * 0.6
                }
                spacing: cols.spacing * 0.3
                Repeater {
                    model: Mpris.players.values
                    WrapperMouseArea {
                        id: playerBase
                        required property MprisPlayer modelData
                        required property int index
                        property MprisPlayer player: modelData
                        property bool hovered: false
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: {
                            cols.player = player;
                            const playerIndex = Mpris.players.values.findIndex(p => p === player);
                            Theme.audioSettingsColorSet = Config.audioSettings.colorSets[playerIndex % Config.audioSettings.colorSets.length];
                        }
                        onEntered: {
                            hovered = true;
                        }
                        onExited: {
                            hovered = false;
                        }
                        preventStealing: true
                        WrapperRectangle {
                            id: playerWrapper
                            color: Theme.audioSettingsColorSet.playerBackgroundColor
                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            implicitWidth: cols.width
                            margin: implicitWidth * 0.01
                            RowLayout {
                                id: row
                                spacing: 0
                                ColumnLayout {
                                    z: 1
                                    PlayerInfoText {
                                        text: player?.identity || 'UNKNOWN APP'
                                    }
                                    PlayerInfoText {
                                        text: player?.trackTitle || 'UNKNOWN TRACK'
                                    }
                                    PlayerInfoText {
                                        text: player?.trackArtist || 'UNKNOWN ARTIST'
                                    }
                                }

                                WrapperRectangle {
                                    id: iconWrapper
                                    color: "white"
                                    Item {
                                        Rectangle {
                                            width: visible ? playerWrapper.width : 0
                                            height: visible ? playerWrapper.height : 0
                                            anchors.right: parent.right
                                            anchors.rightMargin: -playerWrapper.margin
                                            anchors.verticalCenter: parent.verticalCenter
                                            color: Theme.audioSettingsColorSet.playerInfoHoverColor
                                            //radius: 2
                                            //border.width: 2
                                            visible: hovered
                                            Behavior on width {
                                                NumberAnimation {
                                                    duration: 100
                                                }
                                            }
                                            Behavior on height {
                                                NumberAnimation {
                                                    duration: 100
                                                }
                                            }
                                        }
                                        Image {
                                            id: recordSVG
                                            anchors.centerIn: parent
                                            anchors.horizontalCenterOffset: -row.height * .6
                                            fillMode: Image.PreserveAspectFit
                                            visible: false
                                            sourceSize.width: row.height
                                            source: Qt.resolvedUrl("../assets/record.svg")
                                        }

                                        MultiEffect {
                                            id: effect
                                            opacity: cols.player === playerBase.player ? 1.0 : 0.0
                                            colorization: 1.0
                                            colorizationColor: Theme.audioSettingsColorSet.playerInfoActiveIconColor
                                            source: recordSVG
                                            anchors.fill: recordSVG
                                            blurEnabled: true
                                            blur: 1.0
                                            blurMax: 0
                                            Behavior on opacity {
                                                NumberAnimation {
                                                    duration: 75
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    component PlayerInfoText: Text {
        color: Theme.audioSettingsColorSet.playerInfoTextColor
        font.family: Config.fontTypewriter.font.family
        font.pointSize: Config.audioSettings.playerInfoTextSize
        // Need to set both this and width explicitly to make it work inside a Layout
        Layout.preferredWidth: width
        wrapMode: Text.WordWrap
        width: cols.width - row.height * 1.5
    }
}

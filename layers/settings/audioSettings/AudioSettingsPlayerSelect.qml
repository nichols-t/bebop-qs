import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Services.Mpris

import "../../.."

Rectangle {
    id: root
    color: "transparent"
    required property var spacing
    required property var setPlayer
    required property MprisPlayer currentPlayer
    ColumnLayout {
        anchors.fill: parent
        spacing: root.spacing
        Text {
            visible: Mpris.players.values.length !== 0
            text: "NOW PLAYING"
            color: Config.settings.menuTitleTextColor
            font.family: Config.fontBlocky.font.family
            font.italic: true
            font.pointSize: Config.settings.menuTitleTextSize * 0.6
        }
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
                    root.setPlayer(player);
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
                    implicitWidth: root.width
                    margin: implicitWidth * 0.01
                    RowLayout {
                        id: row
                        spacing: 0
                        ColumnLayout {
                            z: 1
                            AudioSettingsPlayerInfoText {
                                text: player?.identity || 'UNKNOWN APP'
                                maxWidth: root.width - iconWrapper.width
                            }
                            AudioSettingsPlayerInfoText {
                                text: player?.trackTitle || 'UNKNOWN TRACK'
                                maxWidth: root.width - iconWrapper.width
                            }
                            AudioSettingsPlayerInfoText {
                                text: player?.trackArtist || 'UNKNOWN ARTIST'
                                maxWidth: root.width - iconWrapper.width
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
                                    anchors.rightMargin:  playerWrapper.margin
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
                                    source: Qt.resolvedUrl("../../../assets/record.svg")
                                }

                                MultiEffect {
                                    id: effect
                                    opacity: root.currentPlayer === playerBase.player ? 1.0 : 0.0
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

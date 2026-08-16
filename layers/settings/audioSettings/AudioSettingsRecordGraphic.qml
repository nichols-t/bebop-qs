import QtQuick
import QtQuick.Effects
import Quickshell.Services.Mpris
import "../../.."

// Should be same size as its container rect
Rectangle {
    id: root
    color: "transparent"
    required property MprisPlayer player
    // Whether or not audio is currently playing
    property bool playing: true
    // Graphic is a view of a record player; this controls what angle that view is at
    // min X = playing
    // max X = not playing and state is paused
    property real xAngle: !playing && player?.playbackState == MprisPlaybackState.Paused ? minXAngle : maxXAngle
    property real maxXAngle: 80
    property real minXAngle: 20

    // Need these defined separately so we can signal canvas to repaint them when they change.
    property string trackTitle: player?.trackTitle || ''
    property string trackArtist: player?.trackArtist || ''
    property string trackAlbum: player?.trackAlbum || ''

    Behavior on xAngle {
        SequentialAnimation {
            NumberAnimation { duration: xAngle === minXAngle ? 75 : 150 }
        }
    }

    property int maxBlur: 2

    onTrackTitleChanged: {
        trackDetailsCanvas.requestPaint();
    }
    onTrackArtistChanged: {
        trackDetailsCanvas.requestPaint();
    }
    onTrackAlbumChanged: {
        trackDetailsCanvas.requestPaint();
    }

    component XRotation: Rotation {
        // must specify origin.x and origin.y
        angle: root.xAngle
        axis {
            x: 1
            y: 0
            z: 0
        }
    }


    component RotatingRecord: Item {
        id: record
        Image {
            id: recordSVG
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            visible: false
            sourceSize.width: parent.width
            source: Qt.resolvedUrl("../../../assets/record.svg")
        }

        MultiEffect {
            id: effect
            colorization: 1.0
            colorizationColor: Config.audioSettings.recordAccentColor
            source: recordSVG
            anchors.fill: recordSVG
            blurEnabled: true
            blur: 1.0
            blurMax: root.maxBlur
        }

        property real rotAngle: 0.0

        transform: [
            Rotation {
                origin.x: record.x + record.width / 2
                origin.y: record.y + record.height / 2
                angle: record.rotAngle
                axis {
                    x: 0
                    y: 0
                    z: 1
                }
            },
            // Static rotation that angles the image on the horizontal screen axis
            XRotation {
                origin.x: record.x + record.width / 2
                origin.y: record.y + record.height / 2
            }
        ]
        // Starting from rotAngle lets it restart from the same angle after it's paused.
        // When we use an absolute 0, it resets when you unpause which looks jarring
        RotationAnimation on rotAngle {
            running: root.playing
            loops: Animation.Infinite
            from: rotAngle
            to: rotAngle - 360
            duration: Config.audioSettings.recordRotationDuration
        }
    }

    RotatingRecord {
        id: record
        z: 3
        anchors.fill: parent
        anchors.centerIn: parent
    }

    AudioSettingsRecordText {
        id: trackDetailsCanvas
        z: 4
        anchors.fill: parent
        trackAlbum: root.trackAlbum
        trackArtist: root.trackArtist
        trackTitle: root.trackTitle
        transform: [
            Rotation {
                origin.x: trackDetailsCanvas.x + trackDetailsCanvas.width / 2
                origin.y: trackDetailsCanvas.y + trackDetailsCanvas.height / 2
                angle: record.rotAngle
                axis {
                    x: 0
                    y: 0
                    z: 1
                }
            },
            // Static rotation that angles the image on the horizontal screen axis
            XRotation {
                origin.x: trackDetailsCanvas.x + trackDetailsCanvas.width / 2
                origin.y: trackDetailsCanvas.y + trackDetailsCanvas.height / 2
            }
        ]
    }
    RecordFormCircle {
        z: 2
        anchors.centerIn: parent
        transform: XRotation {
            origin.x: 0
            origin.y: root.height * 0.01
        }
    }

    RecordShadowCircle {
        z: 0
        anchors.centerIn: parent
    }

    // Gives the illusion of thickness to the record SVG
    component RecordFormCircle: Item {
        Rectangle {
            id: recordFormCircle
            z: 2
            visible: false
            // This one is NOT themed because the SVG is fixed to black
            color: "black"
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -0.2 * root.height * Math.cos(xAngle)
            width: root.width * 0.81
            height: root.width * 0.81
            radius: width / 2
            
        }

        // I only actually added this because having it on the RecordShadowCircle but not
        // here causes the RecordShadowCircle to render its effect above this circle, no
        // matter what its z is.
        MultiEffect {
            blurEnabled: true
            anchors.fill: recordFormCircle
            source: recordFormCircle
            visible: root.xAngle === maxXAngle
        }
    }

    component RecordShadowCircle: Item {
        // TODO for some reason, this renders above the form circle no matter what z I make it
        Rectangle {
            id: highlightCircle
            z: -1
            color: Config.audioSettings.recordAccentColor
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -0.65 * record.height * Math.cos(xAngle)
            width: root.width * 0.82
            height: root.width * 0.82
            radius: width / 2
            visible: false
            transform: XRotation {
                origin.x: highlightCircle.width / 2
                origin.y: highlightCircle.height / 2
            }
        }

        MultiEffect {
            z: -1
            blurEnabled: true
            blur: 1.0
            blurMax: root.maxBlur * 2
            colorizationColor: 'black'
            colorization: Config.audioSettings.recordShadowFactor
            source: highlightCircle
            anchors.fill: highlightCircle
            opacity: root.xAngle === maxXAngle ? 1 : 0
            transform: XRotation {
                origin.x: highlightCircle.width / 2
                origin.y: highlightCircle.height / 2
            }
        }
    }
}

import QtQuick
import QtQuick.Effects
import "../.."

// Should be same size as its container rect
Rectangle {
    id: root
    color: "transparent"

    component RotatingRecordPiece: Image {
        required property bool clockwise
        id: outerRecord
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        visible: true
        sourceSize.width: parent.width * 1
        RotationAnimation on rotation {
            loops: Animation.Infinite
            from: clockwise ? 0 : 360
            to: clockwise ? 360 : 0
            duration: Config.audioSettings.recordOuterRotationDuration
        }
    }
    // TODO cooler to do a front-on view of a player and need better svg thing here
    RotatingRecordPiece {
        id: outerRecord
        source: Qt.resolvedUrl("../../assets/record-outer.svg")
        clockwise: true
    }
    MultiEffect {
        colorization: 1.0
        colorizationColor: Config.audioSettings.accentColor
        source: outerRecord
        anchors.fill: outerRecord
        rotation: outerRecord.rotation
    }

    RotatingRecordPiece {
        id: middleRecord
        source: Qt.resolvedUrl("../../assets/record-middle.svg")
        clockwise: false
    }

    MultiEffect {
        colorization: 1.0
        colorizationColor: Config.audioSettings.accentColor
        source: middleRecord
        anchors.fill: middleRecord
        rotation: middleRecord.rotation
    }

    RotatingRecordPiece {
        id: innerRecord
        source: Qt.resolvedUrl("../../assets/record-inner.svg")
        clockwise: true
    }

    MultiEffect {
        colorization: 1.0
        colorizationColor: Config.audioSettings.accentColor
        source: innerRecord
        anchors.fill: innerRecord
        rotation: innerRecord.rotation
    }

    Text {
        text: cols.mpris?.trackTitle || ''
        color: "white"
        width: root.width
        horizontalAlignment: Text.AlignHCenter
        anchors.top: parent.top
        anchors.topMargin: root.height * 0.1
        font.family: Config.fontTypewriter.font.family
        font.pointSize: Config.audioSettings.trackTitleTextSize
    }

    Text {
        z: 1
        text: cols.mpris?.trackArtist || ''
        color: "black" // TODO theme
        rotation: 90
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        font.family: Config.fontBlocky.font.family
        font.pointSize: Config.audioSettings.artistTextSize
    }

    Rectangle {
        id: volumeRect
        radius: 2
        border.color: Config.audioSettings.volumeBarBorderColor
        // TODO: vol bars thinggy?
        height: root.height * 0.05
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        color: Config.audioSettings.volumeBarColor
        width: {
            const vol = cols.sink?.audio.volume || 0;

            if (cols.sink?.audio.muted) {
                return 0;
            }

            return vol * root.width;
        }

        Behavior on width {
            NumberAnimation {
                duration: 100
            }
        }
    }
}

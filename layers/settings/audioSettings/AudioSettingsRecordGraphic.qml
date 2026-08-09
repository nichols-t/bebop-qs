import QtQuick
import QtQuick.Effects
import "../../.."

// Should be same size as its container rect
Rectangle {
    id: root
    color: "transparent"
    // Whether or not audio is currently playing
    property bool playing: true
    // Graphic is a view of a record player; this controls what angle that view is at
    property real xAngle: 80

    property int maxBlur: 2

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

    Image {
        id: recordHighlight
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        visible: false
        sourceSize.width: parent.width
        source: Qt.resolvedUrl("../../../assets/record-highlight.svg")
    }
    MultiEffect {
        z: 4
        source: recordHighlight
        anchors.fill: source
        blurEnabled: true
        blur: 1.0
        blurMax: 4
        opacity: Config.audioSettings.recordHighlightOpacity
        colorization: 1.0
        colorizationColor: Config.audioSettings.recordHighlightColor
        transform: [
            Rotation {
                origin.x: recordHighlight.width / 2
                origin.y: recordHighlight.height / 2
                axis { x: 0; y: 0; z: 1 }
                angle: Config.audioSettings.recordHighlightAngle            },
            XRotation {
                origin.x: recordHighlight.width / 2
                origin.y: recordHighlight.height / 2
            }
        ]
    }

    // Gives the illusion of thickness
    Rectangle {
        id: recordFormCircle
        z: 2
        // This one is NOT themed because the SVG is fixed to black
        color: "black"
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -0.1 * record.height * Math.cos(xAngle)
        width: root.width * 0.81
        height: root.width * 0.81
        radius: width / 2
        transform: XRotation {
            origin.x: recordFormCircle.width / 2
            origin.y: recordFormCircle.height / 2
        }
    }

    Rectangle {
        id: highlightCircle
        z: 1
        color: Config.audioSettings.accentColor
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -0.65 * record.height * Math.cos(xAngle)
        width: root.width * 0.85
        height: root.width * 0.85
        radius: width / 2
        visible: false
        transform: XRotation {
            origin.x: highlightCircle.width / 2
            origin.y: highlightCircle.height / 2
        }
    }

    MultiEffect {
        z: 1
        blurEnabled: true
        blur: 1.0
        blurMax: root.maxBlur
        colorizationColor: 'black'
        colorization: 0.3
        source: highlightCircle
        anchors.fill: highlightCircle
        transform: XRotation {
            origin.x: highlightCircle.width / 2
            origin.y: highlightCircle.height / 2
        }
    }
}

import QtQuick
import QtQuick.Effects
import "../.."

// Should be same size as its container rect
Rectangle {
    id: root
    color: "transparent"
    // Whether or not audio is currently playing
    property bool playing: true
    // Graphic is a view of a record player; this controls what angle that view is at
    property real xAngle: 80

    // TODO cooler to do a front-on view of a player and need better svg thing here

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
            id: outerRecord
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
            visible: false
            sourceSize.width: parent.width
            source: Qt.resolvedUrl("../../assets/record.svg")
        }

        MultiEffect {
            id: effect
            colorization: 1.0
            colorizationColor: Config.audioSettings.accentColor
            source: outerRecord
            anchors.fill: outerRecord
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
        RotationAnimation on rotAngle {
            running: root.playing
            loops: Animation.Infinite
            from: 360
            to: 0
            duration: Config.audioSettings.recordOuterRotationDuration
        }
    }

    RotatingRecord {
        z: 2
        id: record
        anchors.fill: parent
        anchors.centerIn: parent
    }
    Rectangle {
        color: "black"
        width: root.width
        height: root.height * 0.3
        anchors.bottom: parent.bottom
        anchors.bottomMargin: root.height * 0.05
    }

    Rectangle {
        id: c
        z: 1
        color: Config.audioSettings.accentColor
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -0.7 * record.height * Math.cos(xAngle)
        width: root.width * 0.65
        height: root.width * 0.65
        radius: width / 2
        transform: XRotation {
            origin.x: c.width / 2
            origin.y: c.height / 2
        }
    }

    Rectangle {
        id: r
        color: "black"
        width: root.width * 1.1
        height: root.height * 0.9
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -0.035 * height + -record.height * Math.cos(xAngle)
        transform: XRotation {
            origin.x: r.width / 2
            origin.y: r.height / 2
        }

    }
}

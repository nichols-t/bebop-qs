import QtQuick
import QtQuick.Effects
import Quickshell.Services.Mpris
import "../../.."

// Should be same size as its container rect
Rectangle {
    id: root
    color: "transparent"
    // Whether or not audio is currently playing
    property bool playing: true
    // Graphic is a view of a record player; this controls what angle that view is at
    property real xAngle: playing ? maxXAngle : minXAngle
    property real maxXAngle: 80
    property real minXAngle: 20

    Behavior on xAngle {
        SequentialAnimation {
            NumberAnimation { duration: 250 }
        }
    }

    property int maxBlur: 2
    property var mpris: Mpris.players.values[0] || null

    // Need these defined separately so we can signal canvas to repaint them
    property string trackTitle: mpris?.trackTitle || ''
    property string trackArtist: mpris?.trackArtist || ''
    property string trackAlbum: mpris?.trackAlbum || ''
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

    // This technique from https://stackoverflow.com/questions/50010671/how-i-can-create-a-curved-text-in-qml-canvas-element
    Canvas {
        id: trackDetailsCanvas
        z: 4
        anchors.fill: parent
        // https://stackoverflow.com/questions/2936112/text-wrap-in-a-canvas-element
        function getLines(ctx, text, maxWidth) {
            var words = text.split(" ");
            var lines = [];
            var currentLine = words[0];

            for (var i = 1; i < words.length; i++) {
                var word = words[i];
                var width = ctx.measureText(currentLine + " " + word).width;
                if (width < maxWidth) {
                    currentLine += " " + word;
                } else {
                    lines.push(currentLine);
                    currentLine = word;
                }
            }
            lines.push(currentLine);
            return lines;
        }
        function drawTextAlongArc(context, str, centerX, centerY, radius, angle) {
            context.save();
            context.translate(centerX, centerY);
            context.rotate(-1 * angle / 2);
            context.rotate(-1 * (angle / str.length) / 2);
            for (var n = 0; n < str.length; n++) {
                context.rotate(angle / str.length);
                context.save();
                context.translate(0, -1 * radius);
                var char1 = str[n];
                context.fillText(char1, 0, 0);
                context.restore();
            }
            context.restore();
        }
        function drawText(context, str, centerX, centerY) {
            context.save();
            context.translate(centerX, centerY);
            context.fillText(str, 0, 0);
            context.restore();
        }
        onPaint: {
            var ctx = getContext("2d");
            context.clearRect(0, 0, trackDetailsCanvas.width, trackDetailsCanvas.height);

            const fontSize = Math.floor(trackDetailsCanvas.width * 0.02);
            ctx.font = `${fontSize}px '${Config.fontTypewriter.font.family}'`;

            ctx.textAlign = "center";

            var centerX = width / 2;
            var centerY = height / 2;
            var angle = Math.PI * 0.04 * root.trackTitle.length; // radians
            var radius = trackDetailsCanvas.width * 0.12;
            ctx.fillStyle = Config.audioSettings.recordTextColor;
            drawTextAlongArc(ctx, root.trackTitle, centerX, centerY, radius, angle);
            const lines = getLines(ctx, root.trackAlbum, radius * 1.8);
            context.save();
            ctx.translate(0, -fontSize * lines.length * 0.5)
            for (let i = 0; i < lines.length; i++) {
                const line = lines[i];
                ctx.translate(0, fontSize);
                drawText(ctx, line, centerX, centerY);
            }
            ctx.translate(0, fontSize);
            drawText(ctx, trackArtist, centerX, centerY);
            context.restore();
        }
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

    // Gives the illusion of thickness
    Rectangle {
        id: recordFormCircle
        z: 2
        visible: root.xAngle === maxXAngle && root.playing
        // This one is NOT themed because the SVG is fixed to black
        color: "black"
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -0.1 * root.height * Math.cos(xAngle)
        width: root.width * 0.81
        height: root.width * 0.81
        radius: width / 2
        transform: XRotation {
            origin.x: recordFormCircle.width / 2
            origin.y: recordFormCircle.height / 2
        }
        Behavior on height {
            NumberAnimation {}
        }
    }

    Rectangle {
        id: highlightCircle
        z: -1
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

    // MultiEffect {
    //     z: -1
    //     blurEnabled: true
    //     blur: 1.0
    //     blurMax: root.maxBlur
    //     colorizationColor: 'black'
    //     colorization: 0.3
    //     source: highlightCircle
    //     anchors.fill: highlightCircle
    //     opacity: root.xAngle === maxXAngle && root.playing ? 1.0 : 0.0
    //     transform: XRotation {
    //         origin.x: highlightCircle.width / 2
    //         origin.y: highlightCircle.height / 2
    //     }
    // }
}

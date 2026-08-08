import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Widgets
import ".."
import "../.."

// TODO some kind of image background or something?
// TODO not entirely happy with the text here
WrapperMouseArea {
    id: root
    property AudioSettings audioSettings
    cursorShape: Qt.PointingHandCursor

    onClicked: {
        audioSettings.show();
    }

    property var sink: Pipewire.defaultAudioSink

    readonly property bool ready: sink && sink.ready
    readonly property bool muted: ready && sink.audio.muted
    readonly property int vol: ready ? Math.round(sink.audio.volume * 100) : 0

    // Used for track information
    // https://quickshell.org/docs/v0.3.0/types/Quickshell.Services.Mpris/MprisPlayer/
    property var mpris: Mpris.players.values[0] || null

    readonly property int audioLevel: {
        // Got from https://www.nerdfonts.com/cheat-sheet
        if (!ready || muted || vol === 0)
            return 0;
        else
            // Done so that 0-20 = 1 bar, 20 - 40 = 2 bar, etc.
            return Math.floor(vol);
    }

    WrapperRectangle {
        color: Config.taskbar.audio.backgroundColor
        margin: 0
        Item {
            id: item
            implicitHeight: Config.taskbar.taskbarHeight
            //spacing: 0
            implicitWidth: icon.width * 1.5
            anchors.right: parent.right
            anchors.rightMargin: 2

            Image {
                id: icon
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                source: Qt.resolvedUrl("../../assets/volume-icon.svg")
                visible: false
                sourceSize.width: parent.height - 6
            }

            // Note that the icon is white so that we can recolor it based
            // on theme as needed.
            MultiEffect {
                colorizationColor: Config.taskbar.clock.textColor
                colorization: 1.0
                source: icon
                anchors.fill: icon
            }

            // I just placed these by experimentation, may need to adjust if icon changes
            Rectangle {
                id: lowVolRect
                visible: root.audioLevel > 0
                color: Config.taskbar.clock.textColor
                width: 4
                height: 2
                radius: 1
                rotation: 30
                x: icon.width * 0.9
                y: icon.height * 0.5
            }
            Rectangle {
                id: medVolRect
                visible: root.audioLevel > 37
                color: Config.taskbar.clock.textColor
                width: 6
                height: 2
                radius: 1
                rotation: 30
                x: icon.width * 0.92
                y: icon.height * 0.4
            }
            Rectangle {
                id: highVolRect
                visible: root.audioLevel > 75
                color: Config.taskbar.clock.textColor
                width: 8
                height: 2
                radius: 1
                rotation: 30
                x: icon.width * 0.93
                y: icon.height * 0.3
            }
            PwObjectTracker {
                objects: [root.sink]
            }
        }
    }
}

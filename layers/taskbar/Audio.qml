import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import ".."
import "../.."

// TODO some kind of image background or something
RowLayout {
    id: root
    implicitHeight: Config.taskbar.taskbarHeight
    spacing: 0

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

    Rectangle {
        anchors.fill: parent
        color: Config.taskbar.audio.backgroundColor
    }

    RowLayout {
        anchors.centerIn: parent
        spacing: 2
        Repeater {
            id: repeater
            model: 11
            Rectangle {
                id :r
                required property int index
                color: Config.taskbar.audio.barsColor
                // double this because our "index" is 1/2 what it would have been for a unidirectional thing
                property real threshold: 2 * 100 / (repeater.model - 1)
                property bool active: Math.abs(index - (repeater.model - 1) / 2) <= root.audioLevel / threshold
                implicitHeight: {
                    if (active) {
                        return Config.taskbar.taskbarHeight;
                    } else {
                        return Config.taskbar.taskbarHeight * 2 / 3;
                    }
                }
                implicitWidth: 8
            }
        }
    }

    Text {
        id: audioText
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 2
        text: {
            return root.audioLevel
            if (!root.ready)
                return "-";
            if (root.muted)
                return "muted";

            if (mpris?.playbackState !== MprisPlaybackState.Playing) {
                return root.vol + "% VOL";
            }

            // TODO: Not sure if I want this, and if I do, probably to the left of the bars
            // var title = mpris.trackTitle || "[untitled]";
            // var artist = mpris.trackArtist || "[unknown]";

            // return title + " BY " + artist + " @ " + root.vol + "%";
            return root.vol + "% VOL";
        }

        font {
            family: Config.fontTypewriter.font.family
            pixelSize: 18
            bold: true
            capitalization: Font.AllUppercase
        }
        color: Config.taskbar.audio.textColor
    }
    

    PwObjectTracker {
        objects: [root.sink]
    }
}

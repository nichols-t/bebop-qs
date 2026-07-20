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
            return Math.floor(vol / 20) + 1
    }

    Rectangle {
        anchors.fill: parent
        anchors.leftMargin: 0 // can use to move box leftwards
        anchors.rightMargin: -10
        color: Config.taskbar.audio.backgroundColor
        // TODO make it spicier
        implicitWidth: 10
        implicitHeight: Config.taskbar.taskbarHeight
    }

    RowLayout {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        spacing: 2
        Repeater {
            id: repeater
            model: 5
            Rectangle {
                required property int index
                //  (inverse index) < audio level
                //visible: repeater.model - (index + 1) < root.audioLevel
                color: {
                    if (repeater.model - (index + 1) >= root.audioLevel) {
                        return "transparent"
                    }
                    return Config.taskbar.audio.barsColor;
                }
                implicitHeight: 20
                implicitWidth: 4
            }
        }
    }

    Rectangle {
        implicitWidth: audioText.font.pixelSize * 6
        implicitHeight: Config.taskbar.taskbarHeight
        color: "transparent"
        Text {
            id: audioText
            anchors.centerIn: parent
            text: {
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
    }

    PwObjectTracker {
        objects: [root.sink]
    }
}

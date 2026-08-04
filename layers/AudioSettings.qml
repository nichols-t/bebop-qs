import Quickshell
import Quickshell.Io
// TODO should audio info be from singleton? Is it already??
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../"

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

        margins.right: root.shouldShow ? 0 : -width;

        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        implicitWidth: screen.width * 0.3
        Behavior on margins.right {
            SequentialAnimation {
                NumberAnimation {
                    duration: 100
                }
                ScriptAction {
                    script: {
                        if (panel.margins.right < 0) {
                            root.close()
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

            Text {
                text: "AUDIO STUFF"
                color: "white"
            }

            id: cols

            property var sink: Pipewire.defaultAudioSink
            // Used for track information
            // https://quickshell.org/docs/v0.3.0/types/Quickshell.Services.Mpris/MprisPlayer/
            property var mpris: Mpris.players.values[0] || null

            Text {
                text: `Ready: ${cols.sink?.ready}`
                color: "white"
            }

            Text {
                text: `Muted? ${cols.sink?.ready && cols.sink?.audio.muted}`
                color: "white"
            }

            Text {
                text: `Volume: ${cols.sink?.audio.volume}`
                color: 'white'
            }

            Text {
                text: `Playback State: ${cols.mpris?.playbackState}`
                color: 'white'
            }

            Text {
                text: `Current Artist ${cols.mpris?.trackArtist}`
                color: 'white'
            }

            Text {
                text: `Is shuffled: ${cols.mpris?.shuffle}`
                color: 'white'
            }

            // They note that players can ignore this and are more likely to
            // accept common multipliers. So like 0.25, 0.5, 1, 1.5 2 type beat
            Text {
                text: `Rate: ${cols.mpris?.rate} (${cols.mpris?.minRate} - ${cols.mpris?.maxRate})`
                color: 'white'
            }

            // Lots of other bools here I could use to show controls
            Text {
                text: `Can loop: ${cols.mpris?.loopSupported}`
                color: 'white'
            }

            Text {
                text: `Position or length: ${cols.mpris?.length}`
                color: 'white'
            }

            Text {
                text: `Player identity ${cols.mpris?.identity}`
                color: 'white'
            }

            Text {
                text: `Track album ${cols.mpris?.trackAlbum}`
                color: 'white'
            }

            Text {
                text: `Track title ${cols.mpris?.trackTitle}`
                color: 'white'
            }

            Text {
                text: `Track vol ${cols.mpris?.volume}`
                color: 'white'
            }

            focus: true

            Keys.onPressed: event => {
                if (event.key === Qt.Key_Escape) {
                    event.accepted = true;
                    panel.close();
                }
            }
        }
    }
}

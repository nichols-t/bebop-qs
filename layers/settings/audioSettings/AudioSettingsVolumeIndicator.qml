import QtQuick
import Quickshell.Services.Pipewire 
import "../../.."

Rectangle {
    required property var container
    required property PwNode sink
    required property real maxHeight
    color: Config.audioSettings.volumeBarColor
    height: {
        const vol = sink?.audio.volume || 0;

        if (sink?.audio.muted) {
            return 0;
        }

        return vol * maxHeight;
    }

    Behavior on height {
        NumberAnimation {
            duration: 100
        }
    }
}

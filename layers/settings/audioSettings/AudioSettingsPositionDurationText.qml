import QtQuick
import Quickshell.Services.Mpris
import "../../.."
import "../../../utils"

Item {
    id: root
    property var textWidth

    required property MprisPlayer player

    // Per docs position doesn't really update reactively unless we tell it to
    Timer {
        // only emit the signal when the position is actually changing.
        running: root.player?.playbackState == MprisPlaybackState.Playing
        // Make sure the position updates at least once per second.
        interval: 1000
        repeat: true
        // emit the positionChanged signal every second.
        onTriggered: root.player.positionChanged()
    }

    Text {
        id: text
        text: {
            const duration = Time.toHH_MM_SS(root.player?.length || 0);
            const position = Time.toHH_MM_SS(root.player?.position || 0);

            return `${position}/${duration}`;
        }
        color: Config.audioSettings.trackDurationTextColor
        visible: root.player?.positionSupported || false
        width: root.textWidth
        horizontalAlignment: Text.AlignHCenter
        font.family: Config.fontTypewriter.font.family
        font.pointSize: Config.audioSettings.trackDurationTextSize
    }
}

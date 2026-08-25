import QtQuick
import Quickshell.Services.Mpris
import "../../.."
import "../../../utils"

Item {
    id: root
    property var textWidth

    required property MprisPlayer player
    property bool isLivestream: {
        // Livestreams like twitch seem to report these as like a timestamp or something
        // instead of a true length. This is 1 billion ms (or s, not really sure) which
        // is *probably* longer than anything that has a real duration.

        // This works for Twitch at least, and YouTube seemingly doesn't return the length
        // flags so it doesn't appear at all
        return !root.player?.lengthSupported || root.player?.length > 1000000000
    }

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
            const position = Time.toHH_MM_SS(root.player?.position || 0);
            if (isLivestream) {
                return `Watching for ${position}`;
            }
            
            const duration = Time.toHH_MM_SS(root.player?.length || 0);

            return `${position}/${duration}`;
        }
        color: Config.audioSettings.trackDurationTextColor
        visible: root.player?.positionSupported && root.player?.lengthSupported || false
        width: root.textWidth
        horizontalAlignment: Text.AlignHCenter
        font.family: Config.fontTypewriter.font.family
        font.pointSize: Config.audioSettings.trackDurationTextSize
    }
}

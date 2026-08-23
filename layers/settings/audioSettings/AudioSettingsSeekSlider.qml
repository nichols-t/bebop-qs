import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Widgets

import "../../.."

Slider {
    id: root
    enabled: true
    required property var player
    // TODO I need to tweak to make it work right
    visible: player ? player.canSeek && player.lengthSupported : false
    from: 0
    to: 100
    // Do not update value while handle is being dragged, only once it's released
    live: false
    // See AudioSettingsPositionDurationText isLivestream
    property bool isLivestream: !player?.lengthSupported || player?.length > 1000000000
    value: {
        if (isLivestream) {
            return 100;
        }

        return player?.position / player?.length * 100;
    }
    onPressedChanged: {
        // Annoying to have it skipping while user is dragging the handle so pause
        // while we are doing that
        if (pressed && player) {
            player.pause();
        } else if (player) {
            const newPosition = player.length * value / 100;
            const diff = newPosition - player.position;

            // This seems like the more intended way to set position rather than
            // assigning directly.
            player.seek(diff);
            // Note: I tried seeing if waiting a few MS before calling .play()
            // made it sound less like "skipping" but it did not
            player.play();
        }
    }
    Layout.fillWidth: true
    implicitHeight: 30
    handle: WrapperMouseArea {
        cursorShape: Qt.PointingHandCursor
        // The actual clicks are handled by the Slider, so we don't want
        // to try and steal them. The MouseArea itself is really just for
        // hover and cursor behavior.
        acceptedButtons: Qt.NoButton
        x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
        y: root.topPadding + root.availableHeight / 2 - height / 2
        width: root.height * 1.5
        height: root.height * 1.5
        Rectangle {
            color: Theme.audioSettingsColorSet.seekBarControlColor
            border.width: 2
            border.color: {
                if (root.pressed) {
                    return Theme.audioSettingsColorSet.seekBarControlActiveBorderColor;
                } else {
                    return Theme.audioSettingsColorSet.seekBarControlBorderColor;
                }
            }
            radius: 2
        }
    }
    background: WrapperMouseArea {
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.NoButton
        Rectangle {
            width: root.availableWidth
            color: Theme.audioSettingsColorSet.seekBarColor
            Rectangle {
                width: root.visualPosition * parent.width
                height: parent.height
                color: Theme.audioSettingsColorSet.seekBarPastPositionColor
                radius: 2
            }
        }
    }
}

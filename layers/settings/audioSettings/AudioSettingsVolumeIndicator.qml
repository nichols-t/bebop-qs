import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire 
import "../../.."

Rectangle {
    id: root
    required property var container
    required property PwNode sink
    required property real maxHeight
    color: "transparent"
    height: maxHeight
    property real volHeight: {
        const vol = sink?.audio.volume || 0;

        if (sink?.audio.muted) {
            return 0;
        }

        return vol * maxHeight;
    }

    // For some reason if they're in a RowLayout they don't anchor to bottom correctly
    Repeater {
        id: repeater
        model: 18
        property real itemMargin: 4
        property real itemWidth: (root.width / repeater.model) - itemMargin
        Rectangle {
            required property var modelData
            x: modelData * (repeater.itemWidth + repeater.itemMargin) + repeater.itemMargin / 2
            anchors.bottom: root.bottom
            width: repeater.itemWidth
            height: root.sink?.audio.muted ? 0 : root.volHeight + Config.audioSettings.volumeBarMaxRandomHeight* Math.random()
            color: Config.audioSettings.volumeBarColor
            border.width: 2
            border.color: Config.audioSettings.volumeBarBorderColor
            radius: 2

            Behavior on height {
                NumberAnimation {}
            }
        }
    }

    Behavior on height {
        NumberAnimation {
            duration: 100
        }
    }
}

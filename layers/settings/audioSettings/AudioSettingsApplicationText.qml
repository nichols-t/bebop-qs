import QtQuick
import "../../.."

Text {
    color: Config.audioSettings.playerTextColor
    font.family: Config.fontBlocky.font.family
    font.pointSize: Config.audioSettings.playerTextSize
    transform: Rotation {
        origin.x: 0
        origin.y: 0
        angle: 90
        axis {
            x: 0
            y: 0
            z: 1
        }
    }
}

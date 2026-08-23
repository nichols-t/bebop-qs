import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../.."

WrapperRectangle {
    property var device
    color: Config.bluetoothSettings.accentColor
    margin: 10

    ColumnLayout {
        // There is bunch of other stuff here, see
        // https://quickshell.org/docs/v0.3.0/types/Quickshell.Bluetooth/BluetoothDevice/

        Text {
            text: device.name
            color: Config.bluetoothSettings.deviceTextColor
            font.family: Config.fontBlocky.font.family
            font.pointSize: Config.bluetoothSettings.deviceTextSize
        }
        Text {
            text: device.connected ? 'CONNECTED' : 'DISCONNECTED'
            color: Config.bluetoothSettings.deviceTextColor
            font.family: Config.fontBlocky.font.family
            font.pointSize: Config.bluetoothSettings.deviceTextSize
        }
    }
}

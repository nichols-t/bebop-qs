import Quickshell
import Quickshell.Bluetooth
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Widgets
import ".."
import "../.."

WrapperMouseArea {
    id: root
    visible: hasBluetooth
    property BluetoothSettings bluetoothSettings
    cursorShape: Qt.PointingHandCursor

    onClicked: {
        bluetoothSettings.show();
    }

    property bool hasBluetooth: Bluetooth.defaultAdapter != null

    WrapperRectangle {
        color: Config.taskbar.audio.backgroundColor
        margin: 0
        Item {
            id: item
            implicitHeight: Config.taskbar.taskbarHeight
            //spacing: 0
            implicitWidth: icon.width
            anchors.right: parent.right
            anchors.rightMargin: 2

            Image {
                id: icon
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                source: Qt.resolvedUrl("../../assets/bluetooth-icon.svg")
                visible: false
                sourceSize.width: parent.height - 6
            }

            // Note that the icon is white so that we can recolor it based
            // on theme as needed.
            MultiEffect {
                colorizationColor: {
                    if (hasBluetooth) {
                        return Config.taskbar.bluetooth.bluetoothActiveColor; 
                    } else {
                        return Config.taskbar.bluetooth.bluetoothDisabledColor;
                    }
                }
                colorization: 1.0
                source: icon
                anchors.fill: icon
            }
        }
    }
}

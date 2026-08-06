import Quickshell.Networking
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import ".."
import "../.."

// TODO some kind of image background or something?
// TODO not entirely happy with the text here
WrapperRectangle {
    color: Config.taskbar.battery.backgroundColor
    // TODO singleton it
    Item {
        anchors.centerIn: parent
        implicitHeight: Config.taskbar.taskbarHeight
        implicitWidth:1.25 * icon.width // TODO should be using a wrapper rect here, I think
    
        Image {
            anchors.centerIn: parent
            id: icon
            fillMode: Image.PreserveAspectFit
            source: {
                // TODO icons for captive portal, limited?
                if (Networking.connectivity !== NetworkConnectivity.Full) {
                    return Qt.resolvedUrl("../../assets/network-none-icon.svg");
                }

                // TODO should we check if it is active
                const networkingType = Networking.devices.values[0].type;
                switch (networkingType) {
                    case DeviceType.Wifi:
                        return Qt.resolvedUrl("../../assets/network-none-icon.svg");
                    case DeviceType.Wired:
                        return Qt.resolvedUrl("../../assets/network-wired-icon.svg");
                    case DeviceType.None:
                        return Qt.resolvedUrl("../../assets/network-none-icon.svg");
                }
                
            }
            visible: true
            sourceSize.width: parent.height - 4
        }
    }
}

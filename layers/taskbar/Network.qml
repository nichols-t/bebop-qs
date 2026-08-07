import Quickshell.Networking
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import ".."
import "../.."

WrapperRectangle {
    color: Config.taskbar.battery.backgroundColor
    Item {
        anchors.centerIn: parent
        implicitHeight: Config.taskbar.taskbarHeight
        implicitWidth:1.25 * icon.width

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
                const connectedDevices = Networking.devices.values.filter((dev) => dev.connected);
                // In theory if Networking.connectivity said we're up, we should have an entry here,
                // but just in case guard it
                if (connectedDevices.length > 0) {
                    const networkingType = connectedDevices[0].type;
                    switch (networkingType) {
                        case DeviceType.Wifi:
                            return Qt.resolvedUrl("../../assets/network-wifi-icon.svg");
                        case DeviceType.Wired:
                            return Qt.resolvedUrl("../../assets/network-wired-icon.svg");
                        case DeviceType.None:
                            return Qt.resolvedUrl("../../assets/network-none-icon.svg");
                    }
                }
                
            }
            visible: true
            sourceSize.width: parent.height - 4
        }
    }
}

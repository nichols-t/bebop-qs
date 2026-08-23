import Quickshell.Networking
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import ".."
import "../.."

WrapperMouseArea {
    id: root
    property NetworkSettings networkSettings
    cursorShape: Qt.PointingHandCursor

    onClicked: {
        networkSettings.show();
    }

    WrapperRectangle {
        color: Config.taskbar.battery.backgroundColor
        Item {
            anchors.centerIn: parent
            implicitHeight: Config.taskbar.taskbarHeight
            implicitWidth: icon.width

            Image {
                id: icon
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                source: {
                    if ([NetworkConnectivity.None, NetworkConnectivity.Limited].includes(Networking.connectivity)) {
                        return Qt.resolvedUrl("../../assets/network-none-icon.svg");
                    } else if (Networking.connectivity === NetworkConnectivity.Portal) {
                        return Qt.resolvedUrl("../../assets/network-captive-icon.svg");
                    }

                    const connectedDevices = Networking.devices.values.filter(dev => dev.connected);
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
                    } else {
                        return null;
                    }
                }
                visible: true
                sourceSize.width: parent.height - 4
            }
        }
    }
}

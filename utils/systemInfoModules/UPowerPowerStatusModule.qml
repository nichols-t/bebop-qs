import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick
import "./base"

// Uses UPower daemon to get changes in battery state automatically,
// without needing to spawn processes
PowerStatusModule {
    id: root
    property real batteryPercent: {
        const battery = _getBattery();

        if (battery) {
            return Math.floor(battery.percentage * 100)
        }

        // Assume no battery
        return 0
    }

    property bool isSupported: true

    property bool hasBattery: !!_getBattery()

    property bool pluggedIn: !UPower.onBattery

    property var read: () => {}

    function _getBattery() {
        // Note that we are assuming this is a laptop battery, but that feels
        // generally safe to do.
        return UPower.devices.values.find((device) => {
            return device.powerSupply && device.isPresent && device.isLaptopBattery;
        });
    }
}
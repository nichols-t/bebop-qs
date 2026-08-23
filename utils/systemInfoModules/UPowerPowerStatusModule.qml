import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick
import "./base"

// Uses UPower daemon to get changes in battery state automatically,
// without needing to spawn processes
PowerStatusModule {
    id: root
    batteryPercent: {
        const battery = _getBattery();

        if (battery) {
            return Math.floor(battery.percentage * 100);
        }

        // Assume no battery
        return 0;
    }

    isSupported: true

    hasBattery: !!_getBattery()

    pluggedIn: !UPower.onBattery

    function read() {}

    // TODO add to the type
    powerText: {
        if (hasBattery) {
            const str = pluggedIn ? 'CHARGE ' : '';
            return `${str}${batteryPercent}%`;
        } else {
            return 'AC';
        }
    }

    systemInfoDetails: {
        const lines = [];
        for (const device in UPower.devices.values) {
            lines.push('TODO me when device');
        }

        if (lines.length === 0) {
            lines.push(`No UPower information available (probably on AC!)`);
        }

        return lines;
    }

    function _getBattery() {
        // Note that we are assuming this is a laptop battery, but that feels
        // generally safe to do.
        return UPower.devices.values.find(device => {
            return device.powerSupply && device.isPresent && device.isLaptopBattery;
        });
    }
}

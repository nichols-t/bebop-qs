import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick
import "./base"
import ".."

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
        if (UPower.devices.values.length === 0) {
            lines.push(`No UPower information available (probably on AC!)`);
        }

        const devicesToShow = UPower.devices.values.filter((d) => d.ready && d.powerSupply && d.state !== UPowerDeviceState.Unknown);
        for (const device of devicesToShow) {
            // TODO is it valid for AC power
            const chargePercent = (device.percentage * 100).toFixed(2)
            lines.push(`Charge: ${chargePercent} (${device.energy} W/h of ${device.energyCapacity} W/h)`);
            lines.push(`Change: ${device.changeRate} W`);
            if (device.timeToEmpty > 0) {
                lines.push(`Time-to-empty (est): ${Time.toHH_MM_SS(device.timeToEmpty)}`);
            }
            if (device.timeToFull > 0) {
                lines.push(`Time-to-full (est): ${Time.toHH_MM_SS(device.timeToFull)}`);
            }
            if (device.healthSupported) {
                lines.push(`Health: ${device.healthPercentage}%`);
            }
            lines.push(`Type: ${UPowerDeviceType.toString(device.type)}`);
            lines.push(`State: ${UPowerDeviceState.toString(device.state)}`);
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

import Quickshell
import Quickshell.Io
import QtQuick
import "./base"

// Reads OS data from /etc/os-release
PowerStatusModule {
    id: root
    // This defaults to 100, so that if we don't have a battery,
    // (i.e. on AC) it shows as full.
    property real batteryPercent: 100

    property bool isSupported: true

    property bool hasBattery: batteryProc.success

    property bool pluggedIn: !hasBattery || _acOnline

    property bool _acOnline

    property var read: () => {
        batteryProc.running = true
        acPowerProc.running = true
    }

    Process {
        id: batteryProc
        running: true
        command: ["sh", "-c", "cat /sys/class/power_supply/BAT0/capacity"]
        stdout: SplitParser {
            onRead: data => root.batteryPercent = Number(data.trim())
        }
        property bool success: false
        onExited: (code) => {
            success = code === 0;
        }
    }

    Process {
        id: acPowerProc
        running: true
        command: ["sh", "-c", "cat /sys/class/power_supply/AC/online"]
        property bool success: false
        stdout: SplitParser {
            onRead: data => root._acOnline = Number(data.trim()) === 1
        }
        onExited: (code) => {
            success = code === 0
        }
    }
}
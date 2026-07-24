import Quickshell
import Quickshell.Io
import QtQuick
import "./base"

// Reads OS data from /etc/os-release
PowerStatusModule {
    id: root
    // This defaults to 100, so that if we don't have a battery,
    // (i.e. on AC) it shows as full.
    readonly property real batteryPercent: 100

    property bool isSupported: true

    property bool hasBattery: batteryProc.success

    // TODO: I don't know how to determine "are we plugged in"
    // from this...
    property bool pluggedIn: false

    property var read: () => {
        batteryProc.running = true
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
            // Here, we are assuming that a failure to read BAT0 means we're on AC
            success = code === 0;
        }
    }
}
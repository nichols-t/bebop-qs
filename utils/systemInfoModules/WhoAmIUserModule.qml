import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick
import "./base"

// Uses UPower daemon to get changes in battery state automatically,
// without needing to spawn processes
// TODO: Upower has other useful stuff like battery health, time to discharge,
// et cetera. That could be implemented into the System Info menu or elsewhere
UserModule {
    id: root
    
    property var read: () => {
        batteryProc.running = true
        acPowerProc.running = true
    }

    Process {
        id: batteryProc
        running: true
        command: ["sh", "-c", "whoami"]
        stdout: SplitParser {
            onRead: data => root.name = data.trim()
        }
        property bool success: false
        onExited: (code) => {
            success = code === 0;
        }
    }
}
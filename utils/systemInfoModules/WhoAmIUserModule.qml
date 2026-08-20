import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick
import "./base"

// Uses UPower daemon to get changes in battery state automatically,
// without needing to spawn processes
UserModule {
    id: root
    
    property var read: () => {
        if (isSupported) {
            proc.running = true
        }
    }
    isSupported: proc.success

    Process {
        id: proc
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
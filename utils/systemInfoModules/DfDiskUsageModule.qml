import Quickshell
import Quickshell.Io
import "./base"

DiskUsageModule {
    id: root
    readonly property real diskUsage: _diskTotal > 0 ? _diskUsed / _diskTotal : 0
    readonly property string diskText: (_diskUsed / 1073741824).toFixed(1) + " / " + (_diskTotal / 1073741824).toFixed(1) + " GB"
    property real _diskUsed: 0
    property real _diskTotal: 1

    property bool isSupported: dfShell.success
    property var read: () => {
        dfShell.running = true;
        if (dfShell.running)
            dfShell.write("df -B1 / | awk 'NR==2{print $1\" \"$2\" \"$3}'; echo '@@END@@'\n");
    }

    systemInfoDetails: {
        const lines = [];
        lines.push(`Used: ${diskText}`)

        return lines;
    }

    Process {
        id: dfShell
        command: ["sh"]
        stdinEnabled: true
        running: true
        onRunningChanged: {
            if (running)
                diskTimer.triggered();  // immediate first read
        }
        stdout: SplitParser {
            splitMarker: "@@END@@"
            onRead: data => {
                const parts = data.trim().split(/\s+/);
                if (parts.length >= 3) {
                    root._diskTotal = parseInt(parts[1]);
                    root._diskUsed = parseInt(parts[2]);
                }
            }
        }
        property bool success: false
        onExited: (code) => {
            success = code === 0
        }
    }
}
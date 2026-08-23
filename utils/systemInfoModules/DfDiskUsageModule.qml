import Quickshell
import Quickshell.Io
import "./base"

DiskUsageModule {
    id: root
    readonly property real diskUsage: _diskTotal > 0 ? _diskUsed / _diskTotal : 0
    readonly property string diskText: (_diskUsed / 1073741824).toFixed(1) + " / " + (_diskTotal / 1073741824).toFixed(1) + " GB"
    property real _diskUsed: 0
    property real _diskTotal: 1
    property var blockDevices: []

    property bool isSupported: dfShell.success
    property var read: () => {
        dfShell.running = true;
        if (dfShell.running)
            dfShell.write("df -B1 / | awk 'NR==2{print $1\" \"$2\" \"$3}'; echo '@@END@@'\n");
    }

    systemInfoDetails: {
        const lines = [];
        lines.push(`Used: ${diskText}`)

        for (let i = 0; i < blockDevices.length; i++) {
            const blkDev = blockDevices[i]
            lines.push(`${blkDev.name} (${blkDev.size})`);
            lines.push(`    Removable: ${blkDev.rm}`);
            lines.push(`    Read-Only: ${blkDev.ro}`);
            lines.push(`    Mounts:`);

            for (let j = 0; j < blkDev.children.length; j++) {
                const child = blkDev.children[j];
                if (child.type === 'part') {
                    let partStr = `${child.name} (${child.size})`;
                    if (child.mountpoints.length > 0) {
                        partStr += child.mountpoints.join(':');
                    }
                    lines.push(`        ${partStr}`)
                }
            }
        }

        return lines;
    }

    Process {
        id: lsblkShell
        command: ['lsblk', '--json']
        running: true
        property string out: ''
        stdout: SplitParser {
            onRead: data => {
                lsblkShell.out += data
                try {
                    const output = JSON.parse(lsblkShell.out);
                    if (output.blockdevices) {
                        root.blockDevices = output.blockdevices;
                    }
                } catch (_e) {

                }
            }
        }
        property bool success: false
        onExited: (code) => {
            success = code === 0
        }

    }

    Process {
        id: dfShell
        command: ["sh"]
        stdinEnabled: true
        running: true
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
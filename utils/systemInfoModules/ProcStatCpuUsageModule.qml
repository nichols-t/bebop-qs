import Quickshell
import Quickshell.Io
import QtQuick
import "./base"

// Reads OS data from /etc/os-release
CpuUsageModule {
    id: root
    readonly property real cpuUsage: _cpuUsage
    property string cpuText: (_cpuUsage * 100).toFixed(2) + "%"
    property real _cpuUsage: 0
    property real _lastCpuIdle: 0
    property real _lastCpuTotal: 0

    property var read: () => {
        cpuFile.reload();
    }

    FileView {
        id: cpuFile
        path: "/proc/stat"
        onLoaded: {
            const line = text().match(/^cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/);
            if (!line)
                return;
            const s = line.slice(1).map(Number);
            const idle = s[3] + s[4];                          // idle + iowait
            const total = s[0] + s[1] + s[2] + s[3] + s[4] + s[5] + s[6]; // all fields
            if (root._lastCpuTotal > 0) {
                const dt = total - root._lastCpuTotal;
                const di = idle - root._lastCpuIdle;
                if (dt > 0)
                    root._cpuUsage = 1 - di / dt;
            }
            root._lastCpuIdle = idle;
            root._lastCpuTotal = total;
        }
    }
}
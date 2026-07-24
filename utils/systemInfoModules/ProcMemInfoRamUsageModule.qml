import Quickshell
import Quickshell.Io
import "./base"

RamUsageModule {
    id: root
    property real swapUsage: _swapTotal > 0 ? (_swapTotal - _swapFree) / _swapTotal : 0;
    property string swapText: ((_swapTotal - _swapFree) / 1073741824).toFixed(1) + " / " + (_swapTotal / 1073741824).toFixed(1) + " GB"
    property real memUsage: _memTotal > 0 ? _memUsed / _memTotal : 0
    property string memText: (_memUsed / 1073741824).toFixed(1) + " / " + (_memTotal / 1073741824).toFixed(1) + " GB"
    
    property real _memTotal: 0
    property real _memUsed: 0
    property real _swapTotal: 0
    property real _swapFree: 0

    property bool isSupported: false

    property var read: () => {
        memFile.reload();
    }

    FileView {
        id: memFile
        path: "/proc/meminfo"
        onLoadFailed: {
            root.isSupported = false
        }
        onLoaded: {
            root.isSupported = true
            const t = text();
            const total = parseInt(t.match(/MemTotal:\s+(\d+)/)?.[1] ?? 0);
            const avail = parseInt(t.match(/MemAvailable:\s+(\d+)/)?.[1] ?? 0);
            const swapTotal = parseInt(t.match(/SwapTotal:\s+(\d+)/)?.[1] ?? 0);
            const swapAvail = parseInt(t.match(/SwapFree:\s+(\d+)/)?.[1] ?? 0);

            if (total > 0) {
                root._memTotal = total * 1024;
                root._memUsed = (total - avail) * 1024;
                root._swapTotal = swapTotal * 1024;
                root._swapFree = swapAvail * 1024;
            }
        }
    }
}
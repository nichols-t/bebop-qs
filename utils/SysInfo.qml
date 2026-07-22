pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

// Copied a lot from https://github.com/Yujonpradhananga/Persona-Quickshell/blob/main/Widgets/Info/SysInfo.qml
Singleton {
    id: root
    property bool active: false

    readonly property real cpuUsage: _cpuUsage
    property string cpuText: (_cpuUsage * 100).toFixed(2) + "%"
    property real _cpuUsage: 0
    property string cpuName: ""
    property real cpuMhz: 0
    property string cpuArch: ""
    property real _lastCpuIdle: 0
    property real _lastCpuTotal: 0

    property real _memTotal: 0
    property real _memUsed: 0
    readonly property real memUsage: _memTotal > 0 ? _memUsed / _memTotal : 0
    readonly property string memText: (_memUsed / 1073741824).toFixed(1) + " / " + (_memTotal / 1073741824).toFixed(1) + " GB"
    
    property real _swapTotal: 0
    property real _swapFree: 0
    readonly property real swapUsage: _swapTotal > 0 ? (_swapTotal - _swapFree) / _swapTotal : 0;
    readonly property string swapText: ((_swapTotal - _swapFree) / 1073741824).toFixed(1) + " / " + (_swapTotal / 1073741824).toFixed(1) + " GB"
    property real numMemDevices: 0

    // Based on https://stackoverflow.com/questions/1332861/how-can-i-determine-the-current-cpu-utilization-from-the-shell,
    // it looks like the /proc/stat is the best way to get CPU stuff
    property real _diskUsed: 0
    property real _diskTotal: 1
    readonly property real diskUsage: _diskTotal > 0 ? _diskUsed / _diskTotal : 0
    readonly property string diskText: (_diskUsed / 1073741824).toFixed(1) + " / " + (_diskTotal / 1073741824).toFixed(1) + " GB"

    property string osName: ""

    property real _gpuMemTotal: 0
    property real _gpuMemFree: 0
    property real gpuMemUsage: _gpuMemTotal > 0 ? (_gpuMemTotal - _gpuMemFree) / _gpuMemTotal : 0
    // Similar to memory calc above but nvidia smi utility reports quantities in MiB, not bytes
    property string gpuMemText: ((_gpuMemTotal - _gpuMemFree) / 1024).toFixed(1) + " / " + (_gpuMemTotal / 1024).toFixed(1) + " GB"
    property real _gpuTemp: 0
    property string gpuTempText: _gpuTemp + " °C"
    property string gpuName: ""
    property string gpuDriver: ""
    property string gpuPower: ""

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

    FileView {
        id: memFile
        path: "/proc/meminfo"
        onLoaded: {
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

    Process {
        id: cpuNameProc
        command: ["sh", "-c", "lscpu | grep 'Model name:' | xargs | cut -d ' ' -f3-"]
        running: true
        stdout: SplitParser {
            onRead: data => root.cpuName = data.trim()
        }
    }
    Process {
        id: cpuMhzProc
        command: ["sh", "-c", "lscpu | grep 'CPU max MHz:' | xargs | cut -d ':' -f2- | tr -d ' '"]
        running: true
        stdout: SplitParser {
            onRead: data => root.cpuMhz = Number(data.trim())
        }
    }
    Process {
        id: cpuArchProc
        command: ["sh", "-c", "lscpu | grep 'Architecture:' | xargs | cut -d ' ' -f2"]
        running: true
        stdout: SplitParser {
            onRead: data => root.cpuArch = data.trim()
        }
    }

    Process {
        id: dfShell
        command: ["sh"]
        stdinEnabled: true
        running: root.active
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
    }

    Process {
        id: osProc
        command: ["sh", "-c", ". /etc/os-release && echo $PRETTY_NAME"]
        running: true
        stdout: SplitParser {
            onRead: data => root.osName = data.trim()
        }
    }

    Process {
        id: gpuTempProc
        running: true
        command: ["sh", "-c", "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader"]
        stdout: SplitParser {
            onRead: data => root._gpuTemp = Number(data.trim())
        }
    }
    Process {
        id: gpuDriverProc
        running: true
        command: ["sh", "-c", "nvidia-smi --query-gpu=driver_version --format=csv,noheader"]
        stdout: SplitParser {
            onRead: data => root.gpuDriver = data.trim()
        }
    }
    Process {
        id: gpuMemFreeProc
        running: true
        command: ["sh", "-c", "nvidia-smi --query-gpu=memory.free --format=csv,noheader | cut -d ' ' -f1"]
        stdout: SplitParser {
            onRead: data => root._gpuMemFree = Number(data.trim())
        }
    }
    Process {
        id: gpuMemTotalProc
        running: true
        command: ["sh", "-c", "nvidia-smi --query-gpu=memory.total --format=csv,noheader | cut -d ' ' -f1"]
        stdout: SplitParser {
            onRead: data => root._gpuMemTotal = Number(data.trim())
        }
    }
    Process {
        id: gpuPowerProc
        running: true
        command: ["sh", "-c", "nvidia-smi --query-gpu=power.draw.average --format=csv,noheader"]
        stdout: SplitParser {
            onRead: data => root.gpuPower = data.trim()
        }
    }
    Process {
        id: gpuNameProc
        running: true
        command: ["sh", "-c", "nvidia-smi --query-gpu=name --format=csv,noheader"]
        stdout: SplitParser {
            onRead: data => root.gpuName = data.trim()
        }
    }

    Timer {
        interval: 2000
        repeat: true
        running: root.active
        triggeredOnStart: true
        onTriggered: {
            cpuFile.reload();
            memFile.reload();
        }
    }
    Timer {
        id: diskTimer
        interval: 30000
        repeat: true
        running: root.active
        onTriggered: {
            if (dfShell.running)
                dfShell.write("df -B1 / | awk 'NR==2{print $1\" \"$2\" \"$3}'; echo '@@END@@'\n");

            // TODO don't run all of these at this interval
            gpuTempProc.running = true
            gpuDriverProc.running = true
            gpuMemFreeProc.running = true
            gpuMemTotalProc.running = true
            gpuPowerProc.running = true
            gpuNameProc.running = true
            cpuNameProc.running = true
            cpuMhzProc.running = true
            cpuArchProc.running = true
        }
    }
}
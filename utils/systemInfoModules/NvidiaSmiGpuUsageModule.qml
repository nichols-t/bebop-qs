import Quickshell
import Quickshell.Io
import "./base"

GpuUsageModule {
    id: root
    property real gpuMemUsage: _gpuMemTotal > 0 ? (_gpuMemTotal - _gpuMemFree) / _gpuMemTotal : 0
    // Similar to memory calc above but nvidia smi utility reports quantities in MiB, not bytes
    property string gpuMemText: ((_gpuMemTotal - _gpuMemFree) / 1024).toFixed(1) + " / " + (_gpuMemTotal / 1024).toFixed(1) + " GB"
    property string gpuTempText: _gpuTemp + " °C"
    property string gpuPower: ""

    property real _gpuMemTotal: 0
    property real _gpuMemFree: 0
    property real _gpuTemp: 0

    property bool isSupported: {
        return gpuTempProc.success && gpuMemFreeProc && gpuMemTotalProc && gpuPowerProc
    }

    property var read: () => {
        gpuTempProc.running = true
        gpuPowerProc.running = true
        gpuMemFreeProc.running = true

    }

    Process {
        id: gpuTempProc
        running: true
        command: ["sh", "-c", "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader"]
        stdout: SplitParser {
            onRead: data => root._gpuTemp = Number(data.trim())
        }
        property bool success: false
        onExited: (code) => {
            success = code === 0
        }
    }
    Process {
        id: gpuMemFreeProc
        running: true
        command: ["sh", "-c", "nvidia-smi --query-gpu=memory.free --format=csv,noheader | cut -d ' ' -f1"]
        stdout: SplitParser {
            onRead: data => root._gpuMemFree = Number(data.trim())
        }
        property bool success: false
        onExited: (code) => {
            success = code === 0
        }
    }
    Process {
        id: gpuMemTotalProc
        running: true
        command: ["sh", "-c", "nvidia-smi --query-gpu=memory.total --format=csv,noheader | cut -d ' ' -f1"]
        stdout: SplitParser {
            onRead: data => root._gpuMemTotal = Number(data.trim())
        }
        property bool success: false
        onExited: (code) => {
            success = code === 0
        }
    }
    Process {
        id: gpuPowerProc
        running: true
        command: ["sh", "-c", "nvidia-smi --query-gpu=power.draw.average --format=csv,noheader"]
        stdout: SplitParser {
            onRead: data => root.gpuPower = data.trim()
        }
        property bool success: false
        onExited: (code) => {
            success = code === 0
        }
    }
}
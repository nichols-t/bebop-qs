import Quickshell
import Quickshell.Io

import "./base"

// Provides information about the CPU read using the lscpu command
CpuModelModule {
    id: root
    property bool isSupported: cpuNameProc.success && cpuMhzProc.success && cpuArchProc.success

    systemInfoDetails: {
        const lines = [];
        lines.push(cpuName);
        lines.push(`Arch: ${cpuArch}`);
        lines.push(`Max Speed: ${cpuMhz.toFixed(0)} Mhz`);

        return lines;
    }

    Process {
        id: cpuNameProc
        command: ["sh", "-c", "lscpu | grep 'Model name:' | xargs | cut -d ' ' -f3-"]
        running: true
        stdout: SplitParser {
            onRead: data => root.cpuName = data.trim()
        }

        onExited: code => {
            success = code === 0;
        }
        property bool success: false
    }
    Process {
        id: cpuMhzProc
        command: ["sh", "-c", "lscpu | grep 'CPU max MHz:' | xargs | cut -d ':' -f2- | tr -d ' '"]
        running: true
        stdout: SplitParser {
            onRead: data => root.cpuMhz = Number(data.trim())
        }

        onExited: code => {
            success = code === 0;
        }
        property bool success: false
    }
    Process {
        id: cpuArchProc
        command: ["sh", "-c", "lscpu | grep 'Architecture:' | xargs | cut -d ' ' -f2"]
        running: true
        stdout: SplitParser {
            onRead: data => root.cpuArch = data.trim()
        }

        onExited: code => {
            success = code === 0;
        }
        property bool success: false
    }
}

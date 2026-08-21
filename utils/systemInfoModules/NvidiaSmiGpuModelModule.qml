import Quickshell
import Quickshell.Io

import "./base"

// Reads GPU data use the nvidia-smi command
GpuModelModule {
    id: root
    property bool isSupported: gpuNameProc.success && gpuDriverProc.success
    
    systemInfoDetails: {
        const lines = [];
        lines.push(gpuName);
        lines.push(`Driver: ${gpuDriver}`);

        return lines;
    }

    Process {
        id: gpuNameProc
        running: true
        command: ["sh", "-c", "nvidia-smi --query-gpu=name --format=csv,noheader"]
        stdout: SplitParser {
            onRead: data => root.gpuName = data.trim()
        }

        onExited: code => {
            success = code === 0
        }
        property bool success: false
    }
    Process {
        id: gpuDriverProc
        running: true
        command: ["sh", "-c", "nvidia-smi --query-gpu=driver_version --format=csv,noheader"]
        stdout: SplitParser {
            onRead: data => root.gpuDriver = data.trim()
        }

        onExited: code => {
            success = code === 0
        }

        property bool success: false
    }
}
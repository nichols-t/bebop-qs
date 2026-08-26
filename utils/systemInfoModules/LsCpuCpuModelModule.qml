import Quickshell
import Quickshell.Io

import "./base"

// Provides information about the CPU read using the lscpu command
CpuModelModule {
    id: root

    systemInfoDetails: {
        const lines = [];
        cpuName && lines.push(cpuName);
        cpuArch && lines.push(`Arch: ${cpuArch}`);
        cpuMhz && lines.push(`Max Speed: ${cpuMhz.toFixed(0)} Mhz`);
        _cpuAddrSizes && lines.push(`Address Sizes: ${_cpuAddrSizes}`);
        _byteOrder && lines.push(`Byte Order: ${_byteOrder}`);
        _vendorId && lines.push(`Vendor ID: ${_vendorId}`);
        _cores && lines.push(`Cores: ${_cores}`);
        _threadsPerCore && lines.push(`Threads/Core: ${_threadsPerCore}`);

        return lines;
    }

    property string _cpuAddrSizes: ''
    property string _byteOrder: ''
    property string _vendorId: ''
    property string _cores: ''
    property string _threadsPerCore: ''

    Process {
        id: proc
        command: ['lscpu']
        running: true
        stdout: SplitParser {
            readonly property string cpuNameMatch: 'Model name:'
            readonly property string cpuMaxMhzMatch: 'CPU max MHz:'
            readonly property string cpuArchMatch: 'Architecture:'
            readonly property string cpuAddrSizeMatch: 'Address sizes:'
            readonly property string cpuByteOrderMatch: 'Byte Order:'
            readonly property string cpuVendorIdMatch: 'Vendor ID:'
            // Technically I'm assuming 1 socket but I've never seen a consumer PC that has a CPU that
            // spans more than 1 socket
            readonly property string coresMatch: 'Core(s) per socket:'
            readonly property string threadsPerCoreMatch: 'Thread(s) per core:'
            onRead: (line) => {
                if (line.includes(cpuNameMatch)) {
                    root.cpuName = line.split(cpuNameMatch)[1].trim();
                }
                if (line.includes(cpuMaxMhzMatch)) {
                    root.cpuMhz = Number(line.split(cpuMaxMhzMatch)[1].trim())
                }
                if (line.includes(cpuArchMatch)) {
                    root.cpuArch = line.split(cpuArchMatch)[1].trim()
                }
                if (line.includes(cpuAddrSizeMatch)) {
                    root._cpuAddrSizes = line.split(cpuAddrSizeMatch)[1].trim()
                }
                if (line.includes(cpuByteOrderMatch)) {
                    root._byteOrder = line.split(cpuByteOrderMatch)[1].trim()
                }
                if (line.includes(cpuVendorIdMatch)) {
                    root._vendorId = line.split(cpuVendorIdMatch)[1].trim()
                }
                if(line.includes(coresMatch)) {
                    root._cores = line.split(coresMatch)[1].trim();
                }
                if (line.includes(threadsPerCoreMatch)) {
                    root._threadsPerCore = line.split(threadsPerCoreMatch)[1].trim()
                }
            }
        }
    }
}

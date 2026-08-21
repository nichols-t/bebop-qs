import Quickshell

SystemInfoModule {
    // Model name of the CPU
    property string cpuName
    // Reported max MHz of the CPU
    property real cpuMhz
    // Architecture of the CPU
    property string cpuArch
    // Lines for the system info details display
    property list<string> systemInfoDetails
}
import Quickshell

SystemInfoModule {
    // Disk usage as a fraction
    property real diskUsage
    // Disk usage as a human-readable fraction with unit
    property string diskText
    // Lines for the system info details display
    property list<string> systemInfoDetails
}
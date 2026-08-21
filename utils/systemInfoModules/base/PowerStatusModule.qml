import Quickshell

SystemInfoModule {
    // The percent of battery charge remaining
    property real batteryPercent
    // Are we plugged in to AC power?
    property bool pluggedIn
    // Do we have a battery on this system?
    property bool hasBattery
    // Text displayed to indicate the current power level
    property string powerText
    // Lines for the system info details display
    property list<string> systemInfoDetails
}
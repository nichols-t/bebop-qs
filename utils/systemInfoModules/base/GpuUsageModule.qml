import Quickshell

SystemInfoModule {
    // GPU VRAM usage as a fraction
    property real gpuMemUsage
    // GPU VRAM usage as a human-readable percentage
    property string gpuMemText
    // GPU human-readable temperature with unit
    property string gpuTempText
    // GPU human-readable power consumption with unit
    property string gpuPower
}
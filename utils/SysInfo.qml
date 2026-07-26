pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import "./systemInfoModules"
import "./systemInfoModules/base"

// Copied a lot from https://github.com/Yujonpradhananga/Persona-Quickshell/blob/main/Widgets/Info/SysInfo.qml
// on how to get the basic mem/cpu stuff, then I added more based on my setup and split this into
// separate parts so that people running different utilities have an easier time reading the information.
Singleton {
    id: root
    property bool active: false

    // Provides OS information. Only read on startup 
    property OsModule os: OsReleaseModule {}
    // Provides CPU model information. Only read on startup
    property CpuModelModule cpuModel: LsCpuCpuModelModule {}
    // Provides GPU model information. Only read on startup
    property GpuModelModule gpuModel: NvidiaSmiGpuModelModule {}
    // Provides live CPU usage information. Read periodically
    property CpuUsageModule cpuUsage: ProcStatCpuUsageModule {}
    // Provides live RAM usage information. Read periodically
    property RamUsageModule ramUsage: ProcMemInfoRamUsageModule {}
    // Provides live disk usage information. Read periodically
    property DiskUsageModule diskUsage: DfDiskUsageModule {}
    // Provides live GPU usage information. Read periodically
    property GpuUsageModule gpuUsage: NvidiaSmiGpuUsageModule {}
    // Provides live power supply information. Read periodically
    property PowerStatusModule power: UPowerPowerStatusModule {}

    // TODO: Something like this can be used/read from the Config.qml in order to create a "fallback list"
    // of modules; will need to have SystemInfoModules use their isSupported status, etc but also need to
    // ensure that we give the processes they run a chance to complete. So maybe a hasLoaded property, and
    // we wait for that is true before assigning the first supported module to our "active module" slot.
    property list<PowerStatusModule> powerModuleOptions

    Timer {
        interval: 2000
        repeat: true
        running: root.active
        triggeredOnStart: true
        onTriggered: {
            cpuUsage.read()
            ramUsage.read()
        }
    }

    Timer {
        id: diskTimer
        interval: 30000
        repeat: true
        running: root.active
        onTriggered: {
            diskUsage.read()
            gpuUsage.read()
        }
    }

    // Taskbar information should always refresh
    // TODO: This feels clumsy. Maybe config value for what is always
    // running?
    Timer {
        id: alwaysOnTimer
        interval: 30000
        repeat: true
        running: true
        onTriggered: {
            poewr.read()
        }
    }
}
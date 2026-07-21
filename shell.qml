import Quickshell
import "./layers" as Layers

Scope {
    Variants {
        model: Quickshell.screens
        Scope {
            id: perMonitor
            required property var modelData
            Layers.ShutdownMenu { modelData: perMonitor.modelData }
            Layers.Taskbar { modelData: perMonitor.modelData }
            Layers.Calendar {
               id: calendar
               shouldShow: false
               modelData: perMonitor.modelData
            }
            Layers.SystemInfo {
                id: systemInfo
                shouldShow: false
                modelData: perMonitor.modelData
            }

            Layers.Notifications{ modelData: perMonitor.modelData }
        }
    }
}

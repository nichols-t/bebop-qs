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
        }
    }
}
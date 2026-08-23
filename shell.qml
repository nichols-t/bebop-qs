import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import "./layers" as Layers

Scope {
    // IpcHandlers are defined in the root scope, before we send to variants, because
    // if we put them inside the Variant it spawns 2 copies of the handler, and we have
    // to do some weird stuff with ID and monitor name to get it working right. Instead
    // define here and pass things through.
    // The Variant itself can handle deciding which of its instances should activate,
    // based on the currently focused monitor as reported by Hyprland.
    IpcHandler {
        target: `root`
        function showShutdownMenu() {
            variants.showShutdownMenu();
        }
        function showAppLauncher() {
            variants.showAppLauncher();
        }
    }

    Variants {
        id: variants
        model: Quickshell.screens
        function showShutdownMenu() {
            for (const instance of instances) {
                instance.showShutdown();
            }
        }
        function showAppLauncher() {
            for (const instance of instances) {
                instance.showAppLauncher();
            }
        }
        Scope {
            id: perMonitor
            required property var modelData
            function _isMonitorFocused() {
                return Hyprland.focusedMonitor?.name === modelData.name;
            }
            function showShutdown() {
                if (_isMonitorFocused()) {
                    shutdownMenu.shouldShow = true;
                }
            }
            function showAppLauncher() {
                if (_isMonitorFocused()) {
                    appLauncher.shouldShow = true;
                }
            }
            // I think maybe this technically doesn't need to be in Variant
            // (pretty sure Lock automatically goes to true) but I think it
            // is easier to pass screen data in.
            Layers.LockScreen {
                id: lockRoot
                modelData: perMonitor.modelData
            }
            Layers.ShutdownMenu {
                id: shutdownMenu
                lockRoot: lockRoot
                shouldShow: false
                modelData: perMonitor.modelData
            }
            Layers.Taskbar {
                modelData: perMonitor.modelData
                systemInfo: systemInfo
                settings: settings
                calendar: calendar
                audioSettings: audioSettings
                bluetoothSettings: bluetoothSettings
                networkSettings: networkSettings
                shutdownMenu: shutdownMenu
            }
            Layers.Calendar {
                id: calendar
                shouldShow: false
                modelData: perMonitor.modelData
            }
            Layers.AudioSettings {
                id: audioSettings
                shouldShow: false
                screen: perMonitor.modelData
            }
            Layers.BluetoothSettings {
                id: bluetoothSettings
                shouldShow: false
                screen: perMonitor.modelData
            }
            Layers.NetworkSettings {
                id: networkSettings
                shouldShow: false
                screen: perMonitor.modelData
            }
            Layers.ThemeSettings {
                id: themeSettings
                shouldShow: false
                screen: perMonitor.modelData
            }
            Layers.Settings {
                id: settings
                shouldShow: false
                modelData: perMonitor.modelData
                systemInfo: systemInfo
                shutdownMenu: shutdownMenu
                audioSettings: audioSettings
                bluetoothSettings: bluetoothSettings
                networkSettings: networkSettings
                themeSettings: themeSettings
            }
            Layers.SystemInfo {
                id: systemInfo
                shouldShow: false
                modelData: perMonitor.modelData
            }
            Layers.AppLauncher {
                id: appLauncher
                shouldShow: false
                modelData: perMonitor.modelData
            }

            Layers.Notifications {
                modelData: perMonitor.modelData
            }
        }
    }
}

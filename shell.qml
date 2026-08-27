import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import "./layers"

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
            LockScreen {
                id: lockRoot
                screen: perMonitor.modelData
            }
            ShutdownMenu {
                id: shutdownMenu
                lockRoot: lockRoot
                shouldShow: false
                screen: perMonitor.modelData
            }
            Taskbar {
                screen: perMonitor.modelData
                systemInfo: systemInfo
                settings: settings
                calendar: calendar
                audioSettings: audioSettings
                bluetoothSettings: bluetoothSettings
                networkSettings: networkSettings
                shutdownMenu: shutdownMenu
            }
            Calendar {
                id: calendar
                shouldShow: false
                screen: perMonitor.modelData
            }
            AudioSettings {
                id: audioSettings
                shouldShow: false
                screen: perMonitor.modelData
            }
            BluetoothSettings {
                id: bluetoothSettings
                shouldShow: false
                screen: perMonitor.modelData
            }
            NetworkSettings {
                id: networkSettings
                shouldShow: false
                screen: perMonitor.modelData
            }
            Settings {
                id: settings
                shouldShow: false
                screen: perMonitor.modelData
                systemInfo: systemInfo
                shutdownMenu: shutdownMenu
                audioSettings: audioSettings
                bluetoothSettings: bluetoothSettings
                networkSettings: networkSettings
            }
            SystemInfo {
                id: systemInfo
                shouldShow: false
                screen: perMonitor.modelData
            }
            AppLauncher {
                id: appLauncher
                shouldShow: false
                screen: perMonitor.modelData
            }

            Notifications {
                screen: perMonitor.modelData
            }
        }
    }
}

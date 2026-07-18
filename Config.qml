// TODO: Don't actually know what this does or why it's needed
pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property var colors: {
        "menuItemSelected": "#e1e1e1",
        "menuItemUnselected": "#aaaaaaaa",
        // Note: "The biggest trap is often related to nested opacity.
        // In QML, a child Item inherits the effective opacity of its parent.
        // This means the child's own opacity property is multiplied by the parent's effective opacity."
        // - https://runebook.dev/en/docs/qt/qml-qtqml-qt/rgba-method
        // Note VScode may preview these in the wrong way because it's not used to argb hex
        "lock": "#005a17",
        "reboot": "#d6c23d",
        "shutdown": "#46009b"
    }
}
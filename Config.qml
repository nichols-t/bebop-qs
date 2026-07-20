// TODO: Don't actually know what this does or why it's needed
pragma Singleton

import Quickshell
import QtQuick

Singleton {
    // TODO: Separate these colors into their specific menu sub-parts when necessary.
    readonly property var colors: {
        "menuItemSelected": "#e1e1e1",
        "menuItemUnselected": "#aaaaaa",
        // Note: "The biggest trap is often related to nested opacity.
        // In QML, a child Item inherits the effective opacity of its parent.
        // This means the child's own opacity property is multiplied by the parent's effective opacity."
        // - https://runebook.dev/en/docs/qt/qml-qtqml-qt/rgba-method
        // Note VScode may preview these in the wrong way because it's not used to argb hex
        "lock": "#005a17",
        "reboot": "#d6c23d",
        "shutdown": "#46009b"
    }

    readonly property var fontTypewriter: FontLoader {
        id: fontTypewriter
        source: "./fonts/SpecialElite-Regular.ttf"
    }

    readonly property var fontSerif: FontLoader {
        id: fontSerif
        source: "./fonts/Cormorant-VariableFont_wght.ttf"
    }

    readonly property var powerMenu: {
        "menuTitleText": "Power Menu #1"
    }

    readonly property var taskbar: {
        "taskbarHeight": 30,
        "clock": {
            "textColor": "#e1e1e1"
        },
        "audio": {
            "textColor": "#e1e1e1",
            "barsColor": "#78eae7"
        },
        "workspaces": {
            "textColorActive": "#1b1835",
            "textColorInactive": "#aaaaaa",
            "textColorWithWindows": "#aaaaaa",
            "backgroundColorActive": "#28bddf",
            "backgroundColorInactive": "#1b1835",
            "backgroundColorWithWindows": "#6e7bad"
        }
    }
}
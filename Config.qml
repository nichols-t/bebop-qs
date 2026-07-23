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

    readonly property var fontSansSerif: FontLoader {
        id: fontSansSerif
        source: "./fonts/Montserrat-VariableFont_wght.ttf"
    }

    readonly property var fontSerif: FontLoader {
        id: fontSerif
        source: "./fonts/Cormorant-VariableFont_wght.ttf"
    }

    readonly property var fontBlocky: FontLoader {
        id: fontBlocky
        source: "./fonts/Bevan-Regular.ttf"
    }

    readonly property var powerMenu: {
        "menuTitleText": "Power Menu #1"
    }

    readonly property var lockScreen: {
        "dateTextColor": "#fabb3f",
        "passwordTextColor": "black",
        "accentColor": "#a21e1d"
    }

    readonly property var calendar: {
        "backgroundColor": "black",
        "backgroundColorDayOutOfRange": "#d2d6d3",
        // Background color for a Day, selected at random from this list
        "backgroundColorsDays": ["#3954f0", "#d7dbf8", "#fefefe", "#b1bdf8", "#a4aef8"],
        "fontSizeDays": 22,
        // Probability that a given Day's label will be italicized
        "fontDaysItalicThreshold": 0.5,
        "dayTextXOffsetRange": 10,
        "dayTextYOffsetRange": 10,
        "dayTextRotationRange": 15
    }

    readonly property var systemInfo: {
        "backgroundColor": "black",
        "accentColor": "#226499",
        "textColor": "#fabb3f"
    }

    readonly property var taskbar: {
        "taskbarHeight": 30,
        "backgroundColor": "transparent",
        "clock": {
            "textColor": "#e1e1e1",
            "backgroundColor": "#1b1835"
        },
        "audio": {
            "textColor": "#e1e1e1",
            "barsColor": '#4f65ef',
            "backgroundColor": "#1b1835"
        },
        // TODO theme dark mid light border
        // TODO these also need a new "hover color" above the lightest shade
        // 641c1a a21e1d cf2d1d 250000 reds
        // 6a0b50 bc128d e27abd 2f0020 purples
        // 5f5702 a49e02 eae104 0d0000 yellows
        "workspaces": {
            "textColorActive": "#1b1835",
            "textColorInactive": "#aaaaaa",
            "textColorWithWindows": "#cccccc",
            "backgroundColorActive": "#cf2d1d",
            "backgroundColorHovered": '#de5c5c',
            "backgroundColorInactive": "#641c1a",
            "backgroundColorWithWindows": "#a21e1d",
            "borderColor": "#250000",
            "fontSize": 16
        }
    }
}

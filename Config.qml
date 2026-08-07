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
        source: "./fonts/LibertinusSerif-Regular.ttf"
    }

    readonly property var fontBlocky: FontLoader {
        id: fontBlocky
        source: "./fonts/Bevan-Regular.ttf"
    }

    readonly property var powerMenu: {
        "menuTitleText": "Power Menu #1"
    }

    readonly property var lockScreen: {
        "dateTextColor": "#e1e1e1",
        "passwordTextColor": "black",
        "accentColor": "#a21e1d"
    }

    readonly property var appLauncher: {
        "searchTextSize": 48,
        "appListTextSize": 20,
        "textInputColor": "black",
        "backgroundColor": "#20236d",
        "backgroundTextMinSize": 16,
        "searchBarBackgroundColor": "#c3bb05",
        "searchBarBorderColor": "black",
        "searchBarBorderWidth": 2,
        "appListBackgroundColor": "black",
        "appListTextColor": "#e1e1e1"
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
        "dayTextRotationRange": 15,
        "dayView": {
            "backgroundColor": "#fefefe"
        }
    }

    readonly property var notifications: {
        "backgroundColor": "black",
        "applicationTextColor": "#e1e1e1",
        "summaryTextColor": "#e1e1e1",
        "lineColor": "#fabb3f",
        "accentColor": "#641c1a"
    }

    readonly property var systemInfo: {
        "backgroundColor": "black",
        "accentColor": "#226499",
        "textColor": "#fabb3f"
    }

    readonly property var taskbar: {
        "taskbarHeight": 30,
        "backgroundColor": "black",
        "fontSize": 18,
        "clock": {
            "textColor": "#e1e1e1",
            "backgroundColor": "black"
        },
        "audio": {
            // TODO previously #4f65ef which is a nice blue
            // and 1b1835 which is a nice purple
            "textColor": "#e1e1e1",
            "barsColor": '#de5c5c',
            "barsBorderColor": "#250000", 
            "backgroundColor": "black"
        },
        "battery": {
            "textColor": "#e1e1e1",
            "barsFilledColor": "#cf2d1d",
            "barsEmptyColor": "#a21e1d",
            "barsBorderColor": 'white',
            "backgroundColor": "black"
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
            "borderColor": "black",
            "fontSize": 16
        }
    }

    readonly property var settings: {
        "backgroundColor": "black",
        "menuTextColor": "#e1e1e1",
        "menuTextSize": 32
    }

    readonly property var networkSettings: {
        "accentColor": "#4f65ef",
        "deviceTextColor": "#e1e1e1",
        "deviceTextSize": 18
    }

    readonly property var audioSettings: {
        "accentColor": "#4f65ef",
        "volumeBarColor": '#222d71',
        "volumeBarBorderColor": '#0a0e30',
        "trackTitleFontSize": 14,
        "artistFontSize": 32,
        "recordOuterRotationDuration": 5000,
        "recordMiddleRotationDuration": 4000,
        "recordInnerRotationDuration": 3000,
        "trackControlTextColor": "#e1e1e1",
        "trackControlTextSize": 18,
    }
}

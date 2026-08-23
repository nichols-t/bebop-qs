pragma Singleton

import Quickshell
import QtQuick

Singleton {
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
        // The title used for the power menu
        "menuTitleText": "Power Menu #1",
        // The size of the title text
        "menuTitleTextSize": 45,
        // The size of the text for each option in the menu
        "optionTextSize": 75,
        // The text displayed on Logout/Shutdown/Reboot
        "goodbyeText": "SEE YOU SPACE COWBOY... ",
        // The size of the text displayed on Logout/Shutdown/Reboot
        "goodbyeTextSize": 40,
        // The color of each option text when it is the active selection
        "menuItemTextSelectedColor": "#e1e1e1",
        // The color of each option text when it is not the active selection
        "menuItemTextColor": "#aaaaaa",
        // The color used for the Lock option
        "lockColor": "#005a17",
        // The color used for the Reboot option
        "rebootColor": "#d6c23d",
        // The color used for the Shutdown option
        "shutdownColor": "#46009b"

    }

    readonly property var lockScreen: {
        // The color used for the text that displays the date
        "dateTextColor": "#e1e1e1",
        // The color that the password asterisks will appear
        "passwordTextColor": "black",
        // The size of the password asterisks
        "passwordTextSize": 16,
        // The accent color used for the background
        "accentColor": "#a21e1d",
        // The color used for the bars and top half of the screen
        "baseColor": "black"
    }

    readonly property var appLauncher: {
        // The size of the text that contains the current search string
        "searchTextSize": 36,
        // The size of the text for each item in the applications list
        "appListTextSize": 14,
        // The color of the search field text
        "textInputColor": "black",
        // The background color of the left side rectangle
        "backgroundColor": "#20236d",
        // The minimum size for text that appears in the back side rectangle
        "backgroundTextMinSize": 16,
        // The threshold of search results beyond which the background text
        // will start growing in size
        "backgroundTextGrowThreshold": 18,
        // The size by which the background text grows, per increment between
        // the number of results and the grow threshold
        "backgroundTextGrowStep": 8,
        // The background color for the search bar
        "searchBarBackgroundColor": "#c3bb05",
        // The border color for the search bar
        "searchBarBorderColor": "black",
        // The width of the search bar border
        "searchBarBorderWidth": 2,
        // The background for the right side applications list
        "appListBackgroundColor": "black",
        // The color of each entry in the right side applications list
        "appListTextColor": "#e1e1e1"
    }

    readonly property var calendar: {
        // Background color for the overall screen
        "backgroundColor": "black",
        // Background color for a day that is not part of the current month
        "backgroundColorDayOutOfRange": "#d2d6d3",
        // Background color for a day that is part of the current month,
        // selected at random from this list
        "backgroundColorsDays": ["#3954f0", "#d7dbf8", "#fefefe", "#b1bdf8", "#a4aef8"],
        "backgroundColorHovered": '#6d82f5',
        // Size of the text that shows each day
        "daysTextSize": 16,
        // Color of the text that shows each day
        "daysTextColor": "black",
        // Size of the text that shows events within a day
        "eventsTextSize": 15,
        // Color of the text that shows events within a day
        "eventsTextColor": "black",
        // Probability that a given Day's label will be italicized
        "fontDaysItalicThreshold": 0.5,
        // Range of the random value that is added to each Day text's x position
        "dayTextXOffsetRange": 10,
        // Range of the random value that is added to each Day text's y position
        "dayTextYOffsetRange": 10,
        // Range by which each Day text can be rotated (degrees)
        "dayTextRotationRange": 15
    }

    readonly property var notifications: {
        // Color for the overall notification card
        "backgroundColor": "black",
        // Color for the text that shows application name
        "headerTextColor": "#e1e1e1",
        // Color for the text that shows the application content
        "summaryTextColor": "#e1e1e1",
        // Color for the interior lines on the notification card
        "lineColor": "#fabb3f",
        // Color used for the section of the notification card that shows the
        // application title and text summary
        "accentColor": "#641c1a",
        // Size of the text that shows the notification title
        "headerTextSize": 12,
        // Size of the text that shows the notification content
        "bodyTextSize": 12,
        // Height of the horizontal interior line
        "horizontalLineHeight": 30
    }

    readonly property var systemInfo: {
        // Background color for the left side of the screen
        "backgroundColor": "black",
        // Background color for the right side/details screen
        "accentColor": "#226499",
        // Color of the text on the left side that shows basic info and sections
        "textColor": "#fabb3f",
        // Size of the text on the right side menu
        "textSize": 24,
        // Size of the text that shows the details on the right side screen
        "detailsTextSize": 18,
        // Settings for the disk details info display
        "disk": {
            // Color of the binary text that appears streaming to/fro the graphic
            "movingTextColor": "black"
        },
        // Settings for the power details info display
        "power": {
            "sparkColor": '#cfc05f'
        }
    }

    readonly property var taskbar: {
        // Height of the taskbar
        "taskbarHeight": 30,
        // Background color of the taskbar
        "backgroundColor": "black",
        // Size of most text that appears on the taskbar
        "fontSize": 13,
        // Settings for the clock widget
        "clock": {
            // Color of the clock widget text
            "textColor": "#e1e1e1",
            // Background color of the clock widget
            "backgroundColor": "transparent"
        },
        // Settings for the audio widget
        "audio": {
            // Background color of the audio widget
            "backgroundColor": "transparent"
        },
        // Settings for the battery indicator
        "battery": {
            // Color of the text that indicates charge level
            "textColor": "#e1e1e1",
            // Color of each bar of the batter graphic when the charge is
            // at or above its threshold
            "barsFilledColor": "#cf2d1d",
            // Color of each bar of the battery graphic when the charge is
            // below its threshold
            "barsEmptyColor": "#a21e1d",
            // Border color for each bar in the battery graphic
            "barsBorderColor": 'white',
            // Background color for the battery widget
            "backgroundColor": "transparent"
        },
        "bluetooth": {
            "bluetoothActiveColor": "#e1e1e1",
            "bluetoothDisabledColor": '#841515'
        },
        // Some other palettes from cowboy bebop:
        // (dark mid light border)
        // 641c1a a21e1d cf2d1d 250000 reds
        // 6a0b50 bc128d e27abd 2f0020 purples
        // 5f5702 a49e02 eae104 0d0000 yellows
        // Settings for the workspaces widget
        "workspaces": {
            // Color of text for workspace buttons
            "textColor": "#cccccc",
            // Color for the active workspace button
            "backgroundColorActive": "#cf2d1d",
            // Color for a workspace button if it is currently hovered
            "backgroundColorHovered": '#de5c5c',
            // Color for a workspace button if it has no windows in it and is not active
            "backgroundColorInactive": "#641c1a",
            // Color for a workspace button if it has windows in it, but is not active
            "backgroundColorWithWindows": "#a21e1d",
            // Color of the borders used for portions of the workspaces widget,
            // including the top and bottom borders along the button row.
            "borderColor": "black",
            // Size of the font that indicates each workspace number
            "fontSize": 12
        }
    }

    readonly property var settings: {
        // The background color for the settinsg pane
        "backgroundColor": "black",
        // The color of the text for each settings menu item
        "menuTextColor": "#e1e1e1",
        // The size of the text for each settings menu item
        "menuTextSize": 32,
        // The color of the text for the menu title
        "menuTitleTextColor": "#e1e1e1",
        // The size of the text for the menu title
        "menuTitleTextSize": 60,
        // The command used to open the NixOS config folder for editing
        "nixConfigCmd": ["codium", "/etc/nixos"]
    }

    readonly property var networkSettings: {
        // Color of the background rectangle for each network connection/device
        "accentColor": "#4f65ef",
        // Color of the text that displays the name of each connection
        "deviceTextColor": "#e1e1e1",
        // Size of the text that shows each connection details
        "deviceTextSize": 18,
        // Size of the menu title text
        "menuTitleTextSize": 45,
        // Color of the button that allows for connection or disconnection
        "connectionButtonBackgroundColor": '#7c8efe',
        // Color of the border of the button that allows for connection or disconnection
        "connectionButtonBorderColor": '#111428'
    }

    readonly property var audioSettings: {
        // The maximum random height that can be added to the background volume bars
        "volumeBarMaxRandomHeight": 50,
        // The size of the text that shows the track's title above the rotating record graphic
        "trackTitleTextSize": 14,
        // The color of the text that shows the track's title above the rotating record graphic
        "trackTitleTextColor": "black",
        // The size of the text that shows the track's duration above the rotating record graphic
        "trackDurationTextSize": 14,
        // The color of the text that shows the track's duration above the rotating record graphic
        "trackDurationTextColor": "black",
        // The size of the track artist text displayed beneath the rotating record graphic.
        "trackArtistTextSize": 32,
        // The color used to display the track artist beneath the rotating record graphic.
        "trackArtistTextColor": "black",
        // The length of time that the rotating record graphic takes to spin a full rotation.
        "recordRotationDuration": 5000,
        // Range from 0-1 by which the record color is darkened to produce the record shadow
        "recordShadowFactor": 0.4,
        // Angle by which each character of the curved text that appears on the rotating record
        // graphic is incremented. Essentially a text spacing control.
        "recordTextBaseAngle": Math.PI * 0.03,
        // Factor of the width that is used as the outer radius for the curved text that appears on
        // the rotating record graphic
        "recordTextBaseRadiusFactor": 0.12,
        // Factor of the circumference that is targeted as the maximum arc width of the text
        // that displays the track's artist on the rotating record graphic
        "recordTextTitleTargetArcFactor": 0.375,
        // Factor of the circumference that is targeted as the maximum arc width of the text
        // that displays the track's artist on the rotating record graphic
        "recordTextArtistTargetArcFactor": 0.375,
        // Factor of the overall width that is used to determine the font size of the
        // font that appears as part of the rotating record graphic
        "recordTextFontSizeFactor": 0.02,
        // Size of the text that displays which application is playing audio
        "playerTextSize": 14,
        // Color used for the text that displays which application is playing audio
        "playerTextColor": "black",
        // Size of the text used for the audio control buttons
        "trackControlTextSize": 18,
        // Size of the indicator text that appears amongst the track controls
        "trackControlIndicatorTextSize": 12,

        // Size of the text that shows info about each app currently playing audio
        "playerInfoTextSize": 12,

        // These properties are selected by index to allow us to switch colors when the player changes
        "colorSets": [
            {
                // Color of the record icon that appears for the active player entry
                "playerInfoActiveIconColor": "#421a5e",
                // Color of the rectangle that appears when a player info entry is hovered
                "playerInfoHoverColor": "#421a5e",
                // Color of the text that shows each app currently playing audio
                "playerInfoTextColor": "#e1e1e1",
                // Color of the rectangles that hold info for each app currently playing media under the
                // Now Playing header
                "playerBackgroundColor": '#703798',
                // Background color of the audio control buttons
                "trackControlBackgroundColor": "#8d41c5",
                // Background color of the audio control buttons if they are disabled
                "trackControlDisabledBackgroundColor": "#5b2f7a",
                // Border color of the rectangle that appears in an audio control button when it is hovered
                "trackControlHoverBorderColor": '#150c1b',
                // Border color of the rectangle that appears in an audio control button when it is clicked
                "trackControlClickedBorderColor": "#cf9cf4",
                // Color of the rectangle that appears in an audio control button when it is hovered
                "trackControlHoverRectColor": "#5b2f7a",
                // Color of the text used for the audio control buttons
                "trackControlTextColor": "#e1e1e1",
                // Color of the text used for the audio control buttons when they are disabled
                "trackControlDisabledTextColor": '#421a5e',
                // Color used for the text that appears as part of the rotating record graphic
                "recordTextColor": "#e1e1e1",
                // The color used as the background color for the rotating record graphic.
                "recordAccentColor": '#703798',
                "recordBackgroundColor": "#8d41c5",
                // The color of the background volume bars
                "volumeBarColor": '#cf9cf4',
                // The border color of the background volume bars
                "volumeBarBorderColor": "#150c1b",
                // The color of the seek bar to the right of the current position
                "seekBarColor": "#8d41c5",
                // The color of the seek bar control rectangle
                "seekBarControlColor": "#cf9cf4",
                // The color of the seek bar control rectangle's border
                "seekBarControlBorderColor": "#150c1b",
                // The color of the seek bar control rectangle's border when the seek bar is pressed
                "seekBarControlActiveBorderColor": '#cf9cf4',
                // The color of the seek bar to the left of the current position
                "seekBarPastPositionColor": "#5b2f7a",
            },
            {
                "playerInfoActiveIconColor": '#a6221e',
                "playerInfoHoverColor": "#a6221e",
                "playerInfoTextColor": "#e1e1e1",
                "playerBackgroundColor": '#db3e39',
                "trackControlBackgroundColor": '#b7322e',
                "trackControlDisabledBackgroundColor": '#8f231f',
                "trackControlHoverBorderColor": '#150c1b',
                "trackControlClickedBorderColor": '#6d0e0b',
                "trackControlHoverRectColor": "#8f231f",
                "trackControlTextColor": "#e1e1e1",
                "trackControlDisabledTextColor": '#50110f',
                "recordTextColor": "#e1e1e1",
                "recordAccentColor": '#db3e39',
                "recordBackgroundColor": "#b7322e",
                "volumeBarColor": '#e06762',
                "volumeBarBorderColor": "#150c1b",
                "seekBarColor": "#b7322e",
                "seekBarControlColor": "#e06762",
                "seekBarControlBorderColor": "#150c1b",
                "seekBarControlActiveBorderColor": '#e06762',
                "seekBarPastPositionColor": "#8f231f",
            },
            {
                "playerInfoActiveIconColor": '#c2bd2c',
                "playerInfoHoverColor": "#7b7823",
                "playerInfoTextColor": "#e1e1e1",
                "playerBackgroundColor": '#c2bd2c',
                "trackControlBackgroundColor": '#c2bd2c',
                "trackControlDisabledBackgroundColor": '#4b4c1a',
                "trackControlHoverBorderColor": '#150c1b',
                "trackControlClickedBorderColor": '#4b4c1a',
                "trackControlHoverRectColor": "#7b7823",
                "trackControlTextColor": "#150c1b",
                "trackControlDisabledTextColor": '#c2bd2c',
                "recordTextColor": "#e1e1e1",
                "recordAccentColor": '#d7d24e',
                "recordBackgroundColor": "#c2bd2c",
                "volumeBarColor": '#e9e56d',
                "volumeBarBorderColor": "#150c1b",
                "seekBarColor": "#c2bd2c",
                "seekBarControlColor": "#e9e56d",
                "seekBarControlBorderColor": "#150c1b",
                "seekBarControlActiveBorderColor": '#e9e56d',
                "seekBarPastPositionColor": "#7b7823",
            }
        ]
    }

    readonly property var bluetoothSettings: {
        // The color of the rectangle that displays a bluetooth device
        "accentColor": "#fabb3f",
        // The color of the text that shows bluetooth device information
        "deviceTextColor": "black",
        // The size of the text that shows bluetooth device information
        "deviceTextSize": 18,
    }
}

pragma Singleton

import Quickshell

import "./utils"

Singleton {
    id: theme
    // This can change reactively based on selected player
    property var audioSettingsColorSet: Config.audioSettings.colorSets[0]
}

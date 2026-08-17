pragma Singleton

import Quickshell
import QtQuick

Singleton {
    // This can change reactively based on selected player
    property var audioSettingsColorSet: Config.audioSettings.colorSets[0]
}
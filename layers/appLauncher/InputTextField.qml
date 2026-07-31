import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import "../.."

TextField {
    property bool shouldShow
    property string debouncedText: debounceTimer.text

    id: root
    z: 4
    focus: true
    verticalAlignment: Text.AlignVCenter
    color: Config.appLauncher.textInputColor
    font.pixelSize: Config.appLauncher.searchTextSize
    font.bold: false; //!!text
    font.family: Config.fontBlocky.font.family
    cursorDelegate: Item {}
    background: Rectangle {
        color: "transparent"
    }
    placeholderText: "search"
    placeholderTextColor: Config.appLauncher.textInputColor
    text: shouldShow ? '' : ''
    onTextChanged: {
        debounceTimer.running = true;
    }
    Timer {
        id: debounceTimer
        interval: 25
        running: false
        property string text: ''
        onRunningChanged: {
            if (!running) {
                text = root.text;
            }
        }
    }
}

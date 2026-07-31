import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import "../.."

TextField {
    property bool shouldShow
    property string debouncedText: debounceTimer.text

    id: root
    rotation: -30
    z: 4
    // anchors.left: parent.left
    // anchors.leftMargin: 0
    // anchors.top: parent.top
    // anchors.topMargin: parent.height * 0.3
    focus: true
    verticalAlignment: Text.AlignVCenter
    color: Config.appLauncher.textInputColor
    font.pixelSize: Config.appLauncher.searchTextSize
    font.bold: !!text
    font.family: Config.fontSerif.font.family
    // implicitWidth: parent.width
    cursorDelegate: Item {}
    background: Rectangle {
        color: "transparent"
        //    border.width: 2
        //    border.color: "black"
    }
    placeholderText: "search"
    placeholderTextColor: Config.appLauncher.textInputColor
    text: shouldShow ? '' : ''
    onTextChanged: {
        debounceTimer.running = true;
    }
    Timer {
        id: debounceTimer
        interval: 100
        running: false
        property string text: ''
        onRunningChanged: {
            if (!running) {
                text = root.text;
            }
        }
    }
}

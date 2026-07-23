import Quickshell
import QtQuick
import Quickshell.Widgets
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Layouts
import "./lockScreen" as LayerParts
import "../utils"
import ".."

Scope {
    id: root
    required property var modelData
    property var shouldShow: false

    function lock() {
        shouldShow = true;
        lock.locked = true;
    }

    LayerParts.LockContext {
        id: lockContext
        onUnlocked: {
            lock.locked = false
        }
    }

    WlSessionLock {
        id: lock

        WlSessionLockSurface {
            id: lockSurface
            // Stuff goes here
            Rectangle {
                id: backgroundRect;
                anchors.fill: parent
                color: "black" // TODO color

                WrapperRectangle {
                    color: "transparent"
                    border.width: 4
                    border.color: Config.lockScreen.dateTextColor
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: parent.top
                        topMargin: 200
                    }
                    Text {
                        id: clock
                        rightPadding: 30
                        leftPadding: 30
                        // TODO this font does NOT look good here, and I don't know why
                        font.pixelSize: Math.floor(backgroundRect.height / 15)
                        font.family: Config.fontSansSerif.font.family
                        font.bold: false
                        font.letterSpacing: 2
                        color: Config.lockScreen.dateTextColor

                        // updated when the date changes
                        text: {
                            return Qt.formatDateTime(Time.rawTime, "hh:mm AP")
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: parent.height * 0.6
                    anchors.bottom: parent.bottom
                    color: Config.lockScreen.accentColor
                }

                TextField {
                    id: passwordBox
                    anchors.centerIn: parent
                    padding: 10
                    placeholderText: "3, 2, 1, let's jam!"
                    placeholderTextColor: color
                    color: Config.lockScreen.passwordTextColor
                    font.family: Config.fontTypewriter.font.family
                    font.bold: true
                    // TODO setting these seemingly broke the placeholder text??
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    passwordCharacter: '*'
                    // TODO: can do a cursor delegate to make fancy shapes!
                    font.pixelSize: 24
                    background: Rectangle {
                        color: "transparent"
                        implicitWidth: 400
                        implicitHeight: 3 * 24
                    }

                    focus: true
                    enabled: !lockContext.unlockInProgress
                    echoMode: TextInput.Password
                    inputMethodHints: Qt.ImhSensitiveData

                    // Update the text in the context when the text in the box changes.
                    onTextChanged: lockContext.currentText = this.text;

                    // Try to unlock when enter is pressed.
                    onAccepted: lockContext.tryUnlock();

                    // Update the text in the box to match the text in the context.
                    // This makes sure multiple monitors have the same text.
                    Connections {
                        target: lockContext

                        function onCurrentTextChanged() {
                            passwordBox.text = lockContext.currentText;
                        }
                    }
                }

                Button {
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 100
                    visible: false // Don't know if I want to bother with explicit btn
                    text: "Unlock"
                    padding: 10

                    // don't steal focus from the text box
                    focusPolicy: Qt.NoFocus

                    enabled: !root.context.unlockInProgress && root.context.currentText !== "";
                    onClicked: root.context.tryUnlock();
                }
            }
        }
    }
}
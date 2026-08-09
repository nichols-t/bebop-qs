import Quickshell
import QtQuick
import Quickshell.Widgets
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Layouts
import "./lockScreen"
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

    LockContext {
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
                id: backgroundRect
                anchors.fill: parent
                color: "black" // TODO color

                WrapperRectangle {
                    color: "transparent"
                    z: 1
                    anchors {
                        //horizontalCenter: parent.horizontalCenter
                        top: parent.top
                        topMargin: parent.height - accentRect.height - 2.5 * clock.font.pixelSize
                        left: parent.left
                        leftMargin: lockSurface.screen?.width * 0.02;
                    }
                    ColumnLayout {
                        spacing: 0
                        LockTitleText {
                            verticalAlignment: Qt.AlignBottom
                            id: user
                            text: `Log in as ${lockContext.user}`
                            font.pixelSize: Math.floor(backgroundRect.height / 25)
                        }
                        LockTitleText {
                            id: clock
                            verticalAlignment: Qt.AlignTop
                            font.pixelSize: Math.floor(backgroundRect.height / 15)
                            // updated when the date changes
                            text: Qt.formatDateTime(Time.time, "hh:mm AP")
                        }
                    }
                }

                RowLayout {
                    id: barsRow
                    z:1
                    anchors.fill: parent
                    anchors.topMargin: lockSurface.screen?.height * 0.4
                    spacing: 0
                    Repeater {
                        id: bars
                        model: 4
                        Rectangle {
                            required property int index
                            // >= if model is even
                            Layout.alignment: {
                                if (index < bars.model / 2) {
                                    return Qt.AlignLeft
                                } else {
                                    return Qt.AlignRight
                                }
                            }
                            implicitWidth: {
                                if (index === 0 || index === bars.model - 1) {
                                    return lockSurface.screen?.width * 0.02;
                                } else {
                                    return lockSurface.screen?.width * 0.01;
                                }
                            }
                            implicitHeight: lockSurface.screen?.height * 0.6
                            color: backgroundRect.color
                        }
                    }
                }

                Rectangle {
                    id: bottomLocksRect
                    width: parent.width
                    height: parent.height * 0.05
                    anchors.bottom: parent.bottom
                    color: "black" // TODO color
                    z: 2
                }

                Rectangle {
                    id: accentRect
                    width: parent.width
                    height: parent.height * 0.6
                    anchors.bottom: parent.bottom
                    color: Config.lockScreen.accentColor
                }

                // This is only needed because center-aligning TextField text
                // entirely breaks the TextField placeholder - am I doing something wrong there?
                Text {
                    id: placeholderFallback
                    anchors.centerIn: parent
                    text: "3, 2, 1, let's jam!"
                    color: passwordBox.placeholderTextColor
                    font: passwordBox.font
                    z: 2
                    visible: passwordBox.text.length === 0
                }
                TextField {
                    z: 2
                    id: passwordBox
                    anchors.centerIn: parent
                    padding: 10
                    placeholderText: "3, 2, 1, let's jam!"
                    placeholderTextColor: color
                    color: Config.lockScreen.passwordTextColor
                    font.family: Config.fontTypewriter.font.family
                    font.bold: true
                    // setting these seemingly broke the placeholder text??
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    passwordCharacter: '*'
                    // TODO: Maybe there's a more interesting shape to use?
                    cursorDelegate: Rectangle {
                        color: Config.lockScreen.passwordTextColor
                        width: 4
                        // TextInput has a cursorVisible property but you can only set it
                        // in a signal handler; since we're doing a custom cursor component,
                        // don't bother with that and just control visibility explicitly
                        visible: passwordBox.focus && passwordBox.text.length > 0
                    }
                    font.pointSize: Config.lockScreen.passwordTextSize
                    background: Rectangle {
                        color: "transparent"
                        implicitWidth: parent.font.pixelSize * 10
                        implicitHeight: parent.font.pixelSize
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
            }
        }
    }
}
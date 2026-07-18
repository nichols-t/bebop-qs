import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import Quickshell.Hyprland
import ".."
import "./shutdownMenu" as MenuParts

Scope {
    id: root
    property bool shouldShow: false
    property var targetScreen: null
    property bool contentVisible: false

    // Need to load our fonts!!
    FontLoader {
        id: fontTypewriter
        source: "../fonts/SpecialElite-Regular.ttf"
    }

    FontLoader {
        id: fontSerif
        source: "../fonts/Cormorant-VariableFont_wght.ttf"
    }

    Process {
        id: shutdownProcess
        command: ["sh", "-c", "systemctl poweroff"]
        running: false
    }
    Process {
        id: rebootProcess
        command: ["sh", "-c", "systemctl reboot"]
        running: false
    }
    Process {
        id: logoutProcess
        command: ["sh", "-c", "hyprlock --no-fade-in"]
        running: false
    }

    PanelWindow {
        color: "transparent"
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
        anchors {
            top: true
            left: true
            bottom: true
            right: true
        }
        HyprlandFocusGrab {
        id: grab
        windows: [ itemsContainer ]
        }

        // This rectangle loaded as a goodbye message
        MenuParts.ShutdownMenuGoodbye {
            id: goodbyeMessage
            visible: false // Becomes visible only when clicked
            z: 128
        }

        // Overall rectangle forms the base background of the items
        Rectangle {
            anchors.fill: parent
            color: "#000000"
            // z: 0
            Image {
                id: backgroundTexture
                z: 0
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: Qt.resolvedUrl("../assets/LogoutMenuTextureBackground.png")
                visible: false // Only the colorized MultiEffect is visible
            }
            MultiEffect {
                blurEnabled: true
                blur: 1.0
                blurMax: 10
                opacity: 1 // backgroundTexture.opacity
                source: backgroundTexture
                anchors.fill: backgroundTexture
                brightness: 0
                colorization: 1.0
                colorizationColor: itemsContainer.selectedBaseColor
            }


            Item {
                id: itemsContainer
                focus: true
                anchors.centerIn: parent
                // Could use these to mess with stuff a little more flexibly?
                // anchors.horizontalCenterOffset: 50
                // anchors.verticalCenterOffset: 10
                property var selectedBtnItem: btnLock
                Keys.onPressed: event => {
                    // close: Escape
                    if (event.key === Qt.Key_Escape) {
                        event.accepted = true;
                        Qt.quit();
                    }
                    // execute: enter
                    if (event.key === Qt.Key_Return) {
                        selectedBtnItem.clicked()
                    }

                    // navigate: arrow keys
                    const order = [btnLock, btnReboot, btnShutdown];
                    let idx = -1;
                    for (let i = 0; i < order.length; i++) {
                        if (order[i] === selectedBtnItem) {
                            idx = i;
                        }
                    }

                    if (event.key === Qt.Key_Left || event.key === Qt.Key_Up) {
                        const newIdx = ((idx - 1 % order.length) + order.length) % order.length;
                        selectedBtnItem.focus = false;
                        selectedBtnItem = order[newIdx];
                        selectedBtnItem.focus = true;
                        event.accepted = true;
                        return;
                    }

                    if (event.key === Qt.Key_Right || event.key === Qt.Key_Down) {
                        const newIdx = ((idx + 1 % order.length) + order.length) % order.length;
                        selectedBtnItem.focus = false;
                        selectedBtnItem = order[newIdx];
                        selectedBtnItem.focus = true;
                        event.accepted = true;
                        return;
                    }
                }


                property var selectedBaseColor: {
                    if (selectedBtnItem === btnLock) {
                        return Config.colors.lock;
                    } else if (selectedBtnItem === btnReboot) {
                        return Config.colors.reboot;
                    } else if (selectedBtnItem === btnShutdown) {
                        return Config.colors.shutdown;
                    } else {
                        return "transparent";
                    }
                }

                // wonder if this is smarter way: https://doc.qt.io/qt-6/qml-qtquick-controls-buttongroup.html
                LogoutClickableButtonItem {
                    id: btnLock
                    text: "LOCK"
                    yOffset: -400
                    xOffset: -400
                    process: logoutProcess
                }
                LogoutClickableButtonItem {
                    id: btnReboot
                    text: "REBOOT"
                    yOffset: 0
                    xOffset: 400
                    process: rebootProcess
                }
                LogoutClickableButtonItem {
                    id: btnShutdown
                    text: "SHUTDOWN"
                    yOffset: 400
                    xOffset: -400
                    process: shutdownProcess
                }

                // We load each background, but they're only displayed when the text
                // actually matches
                MenuParts.ShutdownMenuBackgroundLock { text: itemsContainer.selectedBtnItem.text }
                MenuParts.ShutdownMenuBackgroundReboot { text: itemsContainer.selectedBtnItem.text }
                MenuParts.ShutdownMenuBackgroundShutdown { text: itemsContainer.selectedBtnItem.text }
            }
        }
    }

    component LogoutClickableButtonItem: Item {
        id: myself
        required property string text
        required property int yOffset
        required property int xOffset
        required property var action
        required property var process
        property bool selected: {
            return itemsContainer.selectedBtnItem === myself;
        }
        function clicked() {
            goodbyeMessage.visible = true;
            goodbyeTimer.running = true;
        }

        // Show goodbye message before executing process
        Timer {
            id: goodbyeTimer
            interval: 1200; running: false; repeat: false
            onTriggered: {
                process.startDetached();
                Qt.quit();
            }
        }

        Item {
            // Most positioning properties set here
            property bool hovered: false
            y: myself.yOffset
            x: myself.xOffset
            z: 1
            implicitWidth: 800
            implicitHeight: 300
            anchors.horizontalCenterOffset: 50
            anchors.verticalCenterOffset: 10

            Text {
                id: myText
                text: myself.text
                color: {
                    if (myself.selected) {
                        return Config.colors.menuItemSelected;
                    } else {
                        return Config.colors.menuItemUnselected;
                    }
                }

                font {
                    family: fontTypewriter.font.family
                    pixelSize: 100
                }
                visible: false
            }
            MultiEffect {
                blurEnabled: true
                blur: 1.0
                blurMax: 8
                source: myText
                anchors.fill: myText
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    myself.clicked()
                }
                hoverEnabled: true
                onEntered: {
                    parent.hovered = true;
                    itemsContainer.selectedBtnItem = myself;
                }
                onExited: {
                    parent.hovered = false;
                    // Do NOT clear the selectedButton text, to enforce
                    // the invariant that "some menu item is always selected"
                }
            }
        }
    }
}

import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import Quickshell.Hyprland
import ".."
import "./shutdownMenu"

Scope {
    id: root
    // This is the screen from Quickshell.screens
    required property var screen
    required property var lockRoot
    required property bool shouldShow

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
    Item {
        id: logoutProcess
        function startDetached() {
            lockRoot.lock();
        }
        property bool running: false
    }

    PanelWindow {
        id: shutdownMenuWindow
        screen: root.screen
        visible: root.shouldShow
        color: "transparent"
        Component.onCompleted: {
            if (this.WlrLayershell != null) {
                this.WlrLayershell.layer = WlrLayer.Top;
                this.WlrLayershell.namespace = "shutdownMenu";
            }
        }
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
            windows: [itemsContainer]
        }

        // This rectangle loaded as a goodbye message
        ShutdownMenuGoodbye {
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
                opacity: 0.5 // backgroundTexture.opacity
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
                property var selectedBtnItem: btnLock
                Keys.onPressed: event => {
                    // close: Escape
                    if (event.key === Qt.Key_Escape) {
                        event.accepted = true;
                        root.shouldShow = false;
                    }
                    // execute: enter
                    if (event.key === Qt.Key_Return) {
                        selectedBtnItem.clicked();
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
                        return Config.powerMenu.lockColor;
                    } else if (selectedBtnItem === btnReboot) {
                        return Config.powerMenu.rebootColor;
                    } else if (selectedBtnItem === btnShutdown) {
                        return Config.powerMenu.shutdownColor;
                    } else {
                        return "transparent";
                    }
                }

                Text {
                    id: menuTitleText
                    text: Config.powerMenu.menuTitleText
                    color: Config.powerMenu.menuItemTextSelectedColor

                    font {
                        family: Config.fontTypewriter.font.family
                        pointSize: Config.powerMenu.menuTitleTextSize
                    }
                    y: btnLock.yOffset - 100
                    x: btnLock.xOffset - 100
                    visible: false
                }

                MultiEffect {
                    blurEnabled: true
                    blur: 1.0
                    blurMax: 8
                    source: menuTitleText
                    anchors.fill: menuTitleText
                }

                LogoutClickableButtonItem {
                    id: btnLock
                    text: "LOCK"
                    yOffset: -400
                    xOffset: -400
                    shouldQuit: false
                    process: logoutProcess
                    background: backgroundLock
                }
                LogoutClickableButtonItem {
                    id: btnReboot
                    text: "REBOOT"
                    yOffset: 0
                    xOffset: 400
                    process: rebootProcess
                    background: backgroundReboot
                }
                LogoutClickableButtonItem {
                    id: btnShutdown
                    text: "SHUTDOWN"
                    yOffset: 400
                    xOffset: -400
                    process: shutdownProcess
                    background: backgroundShutdown
                }
            }

            Loader {
                id: backgroundLoader
                sourceComponent: itemsContainer.selectedBtnItem?.background || null
                asynchronous: true
                anchors.fill: parent
                // This can be used if partial loading needs to be avoided
                //visible: status == Loader.Ready
            }

            Component {
                id: backgroundLock
                ShutdownMenuBackgroundLock {
                    //id: lockButton
                    text: itemsContainer.selectedBtnItem.text
                    screen: root.screen
                    textColor: Config.powerMenu.lockColor
                }
            }
            Component {
                id: backgroundReboot
                ShutdownMenuBackgroundReboot {
                    text: itemsContainer.selectedBtnItem.text
                    screen: root.screen
                    textColor: Config.powerMenu.rebootColor
                }
            }
            Component {
                id: backgroundShutdown
                ShutdownMenuBackgroundShutdown {
                    text: itemsContainer.selectedBtnItem.text
                    screen: root.screen
                    textColor: Config.powerMenu.shutdownColor
                }
            }

        }
    }

    component LogoutClickableButtonItem: Item {
        id: myself
        required property string text
        required property int yOffset
        required property int xOffset
        required property var process
        required property Component background
        property bool shouldQuit: true
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
            interval: 1200
            running: false
            repeat: false
            onTriggered: {
                process.startDetached();
                root.shouldShow = false;
                goodbyeMessage.visible = false;
                if (shouldQuit) {
                    Qt.quit();
                }
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
                        return Config.powerMenu.menuItemTextSelectedColor;
                    } else {
                        return Config.powerMenu.menuItemTextColor;
                    }
                }

                font {
                    family: Config.fontTypewriter.font.family
                    pointSize: Config.powerMenu.optionTextSize
                }
                visible: false

            }
            MultiEffect {
                blurEnabled: true
                blur: 1.0
                blurMax: 4
                source: myText
                anchors.fill: myText
                layer.enabled: false
                layer.effect: ShaderEffect {
                    fragmentShader: Qt.resolvedUrl("../shaders/textErosionNoise.frag.qsb")
                    property real noiseSize: 64
                    property var resolution: [screen.width, screen.height]
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    myself.clicked();
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

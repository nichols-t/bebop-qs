import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import Quickshell.Hyprland
import ".."
import "./shutdownMenu" as LayerParts

Scope {
    id: root
    // This is the screen from Quickshell.screens
    required property var modelData
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
        screen: root.modelData
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
        LayerParts.ShutdownMenuGoodbye {
            id: goodbyeMessage
            visible: false // Becomes visible only when clicked
            z: 128
        }

        // Overall rectangle forms the base background of the items
        // TODO: Maybe this should be a ListItem of Buttons instead??
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
                // Could use these to mess with stuff a little more flexibly?
                // anchors.horizontalCenterOffset: 50
                // anchors.verticalCenterOffset: 10
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
                        return Config.colors.lock;
                    } else if (selectedBtnItem === btnReboot) {
                        return Config.colors.reboot;
                    } else if (selectedBtnItem === btnShutdown) {
                        return Config.colors.shutdown;
                    } else {
                        return "transparent";
                    }
                }

                Text {
                    id: menuTitleText
                    text: Config.powerMenu.menuTitleText
                    color: Config.colors.menuItemSelected

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

                // TODO insane idea: Voronoi mouse area lmao
                // wonder if this is smarter way: https://doc.qt.io/qt-6/qml-qtquick-controls-buttongroup.html
                LogoutClickableButtonItem {
                    id: btnLock
                    text: "LOCK"
                    yOffset: -400
                    xOffset: -400
                    shouldQuit: false
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
            }

            // We load each background, but they're only displayed when the text
            // actually matches
            LayerParts.ShutdownMenuBackgroundLock {
                id: lockButton
                text: itemsContainer.selectedBtnItem.text
                screen: root.modelData
                textColor: Config.colors.lock
            }
            LayerParts.ShutdownMenuBackgroundReboot {
                text: itemsContainer.selectedBtnItem.text
                screen: root.modelData
                textColor: Config.colors.reboot
            }
            LayerParts.ShutdownMenuBackgroundShutdown {
                text: itemsContainer.selectedBtnItem.text
                screen: root.modelData
                textColor: Config.colors.shutdown
            }
        }
    }

    // TODO should this be in a separate file
    // TODO should this be a Button? Does that automatically give us arrow key controls?
    component LogoutClickableButtonItem: Item {
        id: myself
        required property string text
        required property int yOffset
        required property int xOffset
        required property var process
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
                        return Config.colors.menuItemSelected;
                    } else {
                        return Config.colors.menuItemUnselected;
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
                // TODO need to TWEAK IT
                layer.effect: ShaderEffect {
                    fragmentShader: Qt.resolvedUrl("../shaders/textErosionNoise.frag.qsb")
                    property real noiseSize: 64
                    property var resolution: [modelData.width, modelData.height]
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

import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Layouts
import QtQuick.Effects
import ".."

Scope {
    id: root
    property bool shouldShow: false
    property var targetScreen: null
    property bool contentVisible: false
    property var colors: {
        "menuItemSelected": "#e1e1e1",
        "menuItemUnselected": "#aaaaaa",
        // Note: "The biggest trap is often related to nested opacity.
        // In QML, a child Item inherits the effective opacity of its parent.
        // This means the child's own opacity property is multiplied by the parent's effective opacity."
        // - https://runebook.dev/en/docs/qt/qml-qtqml-qt/rgba-method
        // Note VScode may preview these in the wrong way because it's not used to argb hex
        "lock": "#ff005a17",
        "reboot": "#ffd6c23d",
        "shutdown": "#ff46009b"
    }

    // Need to load our fonts!!
    FontLoader {
        id: fontTypewriter
        source: "fonts/SpecialElite-Regular.ttf"
    }

    FontLoader {
        id: fontSansSerif
        source: "fonts/Cormorant-VariableFont_wght.ttf"
    }

    Process {
        id: shutdownProcess
        // command: ["sh", "-c", "systemctl poweroff"]
        running: false
    }
    Process {
        id: rebootProcess
        // command: ["sh", "-c", "systemctl reboot"]
        running: false
    }
    Process {
        id: logoutProcess
        // TODO no fade in not working
        // command: ["sh", "-c", "hyprlock --no-fade-in"]
        running: false
    }

    PanelWindow {
        color: "transparent"
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
        anchors {
            top: true
            left: true
            bottom: true
            right: true
        }

        // Overall rectangle forms the base background of the items
        Rectangle {
            anchors.fill: parent
            color: "#000000"
            // z: 0

            Item {
                id: itemsContainer
                anchors.centerIn: parent
                // Could use these to mess with stuff a little more flexibly?
                // anchors.horizontalCenterOffset: 50
                // anchors.verticalCenterOffset: 10
                property string selectedButton: ""

                property var selectedBaseColor: {
                    if (selectedButton === "LOCK") {
                        return root.colors.lock;
                    } else if (selectedButton === "REBOOT") {
                        return root.colors.reboot;
                    } else if (selectedButton === "SHUTDOWN") {
                        return root.colors.shutdown;
                    } else {
                        return "#000000";
                    }
                }

                LogoutClickableButtonItem {
                    text: "LOCK"
                    yOffset: -400
                    xOffset: -400
                    process: logoutProcess
                }
                LogoutClickableButtonItem {
                    text: "REBOOT"
                    yOffset: 0
                    xOffset: 400
                    process: rebootProcess
                }
                LogoutClickableButtonItem {
                    text: "SHUTDOWN"
                    yOffset: 400
                    xOffset: -400
                    process: shutdownProcess
                }

                BigFirstLetterText {
                    text: itemsContainer.selectedButton
                    basePixelSize: 100
                    firstLetterMultiplier: 5
                    rotation: 90
                    x: 500
                    y: -500
                    z: -1
                    color: itemsContainer.selectedBaseColor
                }

                BigFirstLetterText {
                    text: itemsContainer.selectedButton
                    basePixelSize: 100
                    firstLetterMultiplier: 5
                    rotation: 0
                    x: -500
                    z: -1
                    color: itemsContainer.selectedBaseColor
                }

                BigFirstLetterText {
                    text: itemsContainer.selectedButton
                    basePixelSize: 100
                    firstLetterMultiplier: 5
                    x: 500
                    y: -500
                    z: -1
                    color: itemsContainer.selectedBaseColor
                }
                
            }
        }
    }

    component BigFirstLetterText: Text {
        id: myself
        // These are going to need to be controlled on a per-instance basis so we
        // DO NOT set them as part of this custom component
        // rotation: 90
        // z: 0

        required property string text
        required property int basePixelSize
        required property real firstLetterMultiplier


        function getText() {
            
            if (!text) {
                return ""
            }
            const first = text[0];
            const rest = text.substring(1);
            const bigLetterSize = basePixelSize * firstLetterMultiplier;

            return `<span style='font-size: ${bigLetterSize}px;'>${first}</span>` + 
            `<span>${rest}</span>`;
        }

        MultiEffect {
            blurEnabled: true
            blur: 1.0
            blurMax: 10
            source: myText
            anchors.fill: myText
        }

        Text {
            id: myText
            font {
                family: fontSansSerif.font.family
                pixelSize: basePixelSize
            }
            color: myself.color
            text: myself.getText(myself.text, basePixelSize)
            textFormat: Text.RichText
        }
    }

    component LogoutClickableButtonItem: Item {
        id: myself
        required property string text
        required property int yOffset
        required property int xOffset
        required property var action
        required property var process

        Item {
            // Most positioning properties set here
            property bool hovered: false
            y: myself.yOffset
            x: myself.xOffset
            implicitWidth: 800
            implicitHeight: 300
            anchors.horizontalCenterOffset: 50
            anchors.verticalCenterOffset: 10

            Text {
                id: myText
                text: myself.text
                color: {
                    if (itemsContainer.selectedButton === myself.text) {
                        return root.colors.menuItemSelected;
                    } else {
                        return root.colors.menuItemUnselected;
                    }
                }

                font {
                    family: fontTypewriter.font.family
                    pixelSize: 100
                }
            }
            MultiEffect {
                blurEnabled: true
                blur: 1.0
                blurMax: 5
                source: myText
                anchors.fill: myText
            }

            // TODO: keyboard focus too!
            // -> v : selection +1
            // <- ^ : selection -1
            // Esc : Quit
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    myself.process.startDetached();
                    Qt.quit();
                }
                hoverEnabled: true
                onEntered: {
                    parent.hovered = true;
                    itemsContainer.selectedButton = myself.text;
                }
                onExited: {
                    parent.hovered = false;
                    itemsContainer.selectedButton = "";
                }
            }
        }
    }
}

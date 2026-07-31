import Quickshell
import QtQuick
import Quickshell.Widgets
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import Quickshell.Hyprland
import ".."
import "../utils"
import "./appLauncher" as LayerParts

Scope {
    id: root
    required property var modelData
    required property var shouldShow

    function _reset() {
        appSearchField.text = '';
    }
    onShouldShowChanged: {
        _reset();
    }

    PanelWindow {
        id: panel
        screen: root.modelData
        visible: root.shouldShow
        color: "transparent"
        anchors {
            top: true
            left: true
            bottom: true
            right: true
        }
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        Component.onCompleted: {
            if (this.WlrLayershell != null) {
                this.WlrLayershell.layer = WlrLayer.Top;
                this.WlrLayershell.namespace = "appLauncher";
            }
        }

        HyprlandFocusGrab {
            id: grab
            windows: [panel]
        }

        LayerParts.InputHandler {
            id: inputHandler
            onClose: () => {
                root.shouldShow = false;
            }
            searchText: appSearchField.debouncedText

            Rectangle {
                id: blackRect
                anchors.fill: parent
                color: "#bb000000"
                visible: true

                Rectangle {
                    id: appLauncherRect
                    anchors.centerIn: parent
                    // anchors.fill: parent
                    width: panel.width * 0.5
                    height: panel.height * 0.5
                    color: Config.appLauncher.backgroundColor
                    radius: 4
                    clip: true
                    property var targetedAppShownProperties: {
                        if (!inputHandler.targetedApp) {
                            return [];
                        }
                        return [
                            inputHandler.targetedApp?.name,
                            inputHandler.targetedApp?.comment,
                            inputHandler.targetedApp?.keywords,
                            inputHandler.targetedApp?.genericName,
                            inputHandler.targetedApp?.categories
                        ].filter(datum => !!datum);
                    }

                    Rectangle {
                        z: 1
                        id: appSearchBackground
                        width: randomTextContainer.width
                        anchors.left: parent.left
                        // The background becomes less visible as the # of possible apps shrinks
                        height: {
                            // TODO math is slightly wrong
                            const diff = (parent.height - appSearchField.height) / 10;
                            const plus = (11 - Math.min(inputHandler.candidateApps.length, 11)) * diff;

                            return appSearchField.height + plus
                        }
                        Behavior on height {
                            NumberAnimation { duration: 100 }
                        }
                        anchors.verticalCenter: parent.verticalCenter
                        color: "black" // TODO theme it
                        LayerParts.InputTextField {
                            id: appSearchField
                            shouldShow: root.shouldShow
                            anchors.centerIn: parent
                        }
                    }


                    // TODO on if I need this now?
                    Text {
                        z: 4
                        visible: false 
                        id: selectedText
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: -parent.height * 0.02
                        anchors.horizontalCenterOffset: parent.width / 8
                        font.family: Config.fontSerif.font.family
                        font.pixelSize: appSearchField.font.pixelSize
                        color: Config.appLauncher.textInputColor
                        text: {
                            if (appSearchField.text !== '' && !!inputHandler.targetedApp) {
                                return `[${inputHandler.targetedApp.name}]`;
                            } else {
                                return '';
                            }
                        }
                    }

                    Rectangle {
                        id: randomTextContainer
                        color: "transparent"
                        width: parent.width * 0.7
                        anchors.left: parent.left
                        height: parent.height
                        clip: true
                        Repeater {
                            model: inputHandler.candidateApps
                            Item {
                                required property var modelData
                                property real maxX: randomTextContainer.width * 0.75
                                property int maxFontSize: {
                                    // TODO make this randomness configurable
                                    // TODO this may look better as "bias" rather than a hard cap, but TBD
                                    const plus = (18 - Math.min(18, inputHandler.candidateApps.length)) * 8;
                                    return 16 + plus;
                                }
                                // TODO probably make this into a container
                                // TODO bias the randoms so that fonts tend smaller when there are more entries
                                Text {
                                    x: Math.random() * maxX
                                    y: Math.random() * randomTextContainer.height
                                    font.family: Config.fontBlocky.font.family
                                    font.pixelSize: Math.random() * maxFontSize;
                                    font.italic: Math.random() > 0.5
                                    font.bold: Math.random() > 0.5
                                    text: modelData.categories.join()
                                }
                                Text {
                                    visible: !!modelData.genericName
                                    x: Math.random() * maxX
                                    y: Math.random() * randomTextContainer.height
                                    font.family: Config.fontBlocky.font.family
                                    font.pixelSize: Math.random() * maxFontSize;
                                    font.italic: Math.random() > 0.5
                                    font.bold: Math.random() > 0.5
                                    text: modelData.genericName
                                }
                                Text {
                                    visible: modelData.keywords.length > 0
                                    x: Math.random() * maxX
                                    y: Math.random() * randomTextContainer.height
                                    font.family: Config.fontBlocky.font.family
                                    font.pixelSize: Math.random() * maxFontSize;
                                    font.italic: Math.random() > 0.5
                                    font.bold: Math.random() > 0.5
                                    text: modelData.keywords.join()
                                }
                                Text {
                                    visible: !!modelData.comment
                                    x: Math.random() * maxX
                                    y: Math.random() * randomTextContainer.height
                                    font.family: Config.fontBlocky.font.family
                                    font.pixelSize: Math.random() * maxFontSize;
                                    font.italic: Math.random() > 0.5
                                    font.bold: Math.random() > 0.5
                                    text: modelData.comment
                                }
                            }
                        }
                    }
                    Rectangle {
                        id: appsListContainer
                        color: "black" // TODO theme
                        width: parent.width - randomTextContainer.width
                        height: parent.height
                        anchors.right: parent.right
                    }

                    ListView {
                        id: appsView
                        model: inputHandler.candidateApps

                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        height: Math.min(parent.height * 0.9, contentHeight)
                        width: parent.width / 4
                        anchors.rightMargin: parent.width / 20
                        
                        delegate: WrapperRectangle {
                            id: rect
                            color: "transparent"
                            Layout.alignment: Qt.AlignRight
                            width: appsView.width
                            required property var modelData
                            property bool isSelected: modelData.name === inputHandler.targetedApp?.name
                            Text {
                                width: rect.width / 2
                                horizontalAlignment: Text.AlignRight
                                text: rect.modelData.name
                                font.family: Config.fontSerif.font.family
                                font.pixelSize: 20
                                font.bold: isSelected
                                font.underline: isSelected
                                color: Config.appLauncher.textInputColor
                            }
                        }
                    }
                }
            }
        }
    }
}

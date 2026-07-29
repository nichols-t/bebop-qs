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
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

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
                        z: 5
                        anchors.fill: parent
                        color: "transparent"
                        radius: appLauncherRect.radius
                        border.color: Config.appLauncher.borderColor
                        border.width: 4
                    }

                    LayerParts.InputTextField {
                        id: appSearchField
                        shouldShow: root.shouldShow
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                        anchors.top: parent.top
                        anchors.topMargin: parent.height * 0.3
                        implicitWidth: parent.width
                    }

                    Rectangle {
                        id: bigRect
                        z: 3
                        width: parent.width * 0.2
                        height: parent.width
                        anchors.centerIn: parent
                        rotation: 60
                        radius: 2
                        border.width: 2
                        border.color: Config.appLauncher.borderColor
                        color: Config.appLauncher.accentColor
                    }

                    RowLayout {
                        z: 1
                        //anchors.horizontalCenter: parent.horizontalCenter
                        rotation: -30
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.leftMargin: 0 //parent.width * 0.05
                        Repeater {
                            model: 4
                            Rectangle {
                                required property var modelData
                                // TODO when I set these to be based on appLauncherRect it is not working as i expect
                                width: Config.appLauncher.searchTextSize * 3
                                height: appLauncherRect.height / 2
                                Layout.topMargin: 100
                                border.width: 2
                                radius: 2
                                border.color: Config.appLauncher.borderColor
                                color: Config.appLauncher.highlightColor
                            }
                        }
                    }

                    Text {
                        z: 4
                        id: selectedText
                        rotation: -30
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

                    // TODO it is crashing?? probably too fast changes
                    // ColumnLayout {
                    //     id: appsColumn
                    //     //anchors.right: parent.right
                    //     // anchors.verticalCenter: parent.verticalCenter
                    //     // width: panel.width * 0.3
                    //     //anchors.centerIn: parent
                    //     anchors.right: parent.right
                    //     anchors.verticalCenter: parent.verticalCenter
                    //     width: parent.width * 0.4

                    //     Repeater {
                    //         id: desktopEntries
                    //         model: inputHandler.candidateApps
                    //         LayerParts.DesktopEntryListText {
                    //             id: candidateAppInfo
                    //             required property var modelData
                    //             app: modelData
                    //             isSelected: inputHandler.targetedApp?.name === app.name
                    //             desiredWidth: appsColumn.height
                    //         }
                    //     }
                    // }
                }
            }
        }
    }
}

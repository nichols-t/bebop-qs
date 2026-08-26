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
import "./appLauncher"

Scope {
    id: root
    required property var screen
    required property var shouldShow

    function _reset() {
        appSearchField.text = '';
    }
    onShouldShowChanged: {
        _reset();
    }

    PanelWindow {
        id: panel
        screen: root.screen
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
                this.WlrLayershell.layer = WlrLayer.Overlay;
                this.WlrLayershell.namespace = "appLauncher";
            }
        }

        HyprlandFocusGrab {
            id: grab
            windows: [panel]
        }

        InputHandler {
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
                        // This container grows vertically as # of possible apps shrinks
                        height: {
                            const diff = (parent.height - appSearchField.height) / 10;
                            const plus = (11 - Math.min(inputHandler.candidateApps.length, 11)) * diff;

                            return appSearchField.height + plus
                        }
                        Behavior on height {
                            NumberAnimation { duration: 100 }
                        }
                        anchors.verticalCenter: parent.verticalCenter
                        color: Config.appLauncher.searchBarBackgroundColor
                        border.width: Config.appLauncher.searchBarBorderWidth
                        border.color: Config.appLauncher.searchBarBorderColor
                        InputTextField {
                            id: appSearchField
                            shouldShow: root.shouldShow
                            anchors.centerIn: parent
                        }
                    }

                    Rectangle {
                        id: randomTextContainer
                        color: "transparent"
                        width: parent.width * 0.7
                        anchors.left: parent.left
                        height: parent.height
                        clip: true
                        Loader {
                            asynchronous: true
                            anchors.fill: parent
                            sourceComponent: backgroundTextComponents
                        }
                        Component {
                            id: backgroundTextComponents
                            Repeater {
                                model: inputHandler.candidateApps
                                Item {
                                    id: item
                                    required property var modelData
                                    property real maxX: randomTextContainer.width * 0.75
                                    property int maxFontSize: {
                                        const threshold = Config.appLauncher.backgroundTextGrowThreshold;
                                        const step = Config.appLauncher.backgroundTextGrowStep;
                                        const plus = (threshold - Math.min(threshold, inputHandler.candidateApps.length)) * step;
                                        return Config.appLauncher.backgroundTextMinSize + plus;
                                    }
                                    DesktopEntryBackgroundText {
                                        maxHeight: randomTextContainer.height
                                        maxWidth: maxX
                                        text: modelData.categories.join(', ')
                                        maxFontSize: item.maxFontSize
                                    }
                                    DesktopEntryBackgroundText {
                                        maxHeight: randomTextContainer.height
                                        maxWidth: maxX
                                        text: modelData.genericName
                                        maxFontSize: item.maxFontSize
                                    }
                                    DesktopEntryBackgroundText {
                                        maxHeight: randomTextContainer.height
                                        maxWidth: maxX
                                        text: modelData.keywords.join(', ')
                                        maxFontSize: item.maxFontSize
                                    }
                                    DesktopEntryBackgroundText {
                                        maxHeight: randomTextContainer.height
                                        maxWidth: maxX
                                        text: modelData.comment
                                        maxFontSize: item.maxFontSize
                                    }
                                }
                            }
                        }
                    }
                    Rectangle {
                        id: appsListContainer
                        color: Config.appLauncher.appListBackgroundColor
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
                                font.pointSize: Config.appLauncher.appListTextSize
                                font.bold: isSelected
                                font.italic: isSelected
                                font.underline: isSelected
                                color: Config.appLauncher.appListTextColor
                            }
                        }
                    }
                }
            }
        }
    }
}

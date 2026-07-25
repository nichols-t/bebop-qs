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

Scope {
    id: root
    required property var modelData
    required property var shouldShow
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
                this.WlrLayershell.namespace = "calendar";
            }
        }

        // TODO unsure if it is needed
        HyprlandFocusGrab {
            id: grab
            windows: [appSearchField]
        }

        WrapperMouseArea {
            id: escMouseArea
            anchors.fill: parent
            onClicked: {
                root.shouldShow = false;
                // panel.visible = false
            }

            Rectangle {
                id: blackRect
                anchors.fill: parent
                color: "#AA000000"
                visible: true
                Keys.onPressed: event => {
                    // close: Escape
                    if (event.key === Qt.Key_Escape) {
                        event.accepted = true;
                        root.shouldShow = false;
                    }
                }

                Rectangle {
                    id: appLauncherRect
                    anchors.centerIn: parent
                    anchors.fill: parent
                    radius: 2
                    // All applications that we have. Note that this is NOT a list so reloading it
                    // maybe doesn't work? or we don't need separate apps and instead read direct
                    // from the TextField input
                    property ObjectModel allApps: DesktopEntries.applications
                    property ObjectModel candidateApps: allApps

                    // TODO I think don't quite center in parent herre - move it a bit left
                    TextField {
                        // TODO reset on close
                        id: appSearchField
                        anchors.centerIn: parent
                        focus: true
                        font.pixelSize: 24
                        font.family: Config.fontSerif.font.family
                        // horizontalAlignment: Text.AlignHCenter
                        // verticalAlignment: Text.AlignVCenter
                        background: Rectangle {
                            color: "transparent"
                        }
                        placeholderText: "Type to search"
                        text: panel.visible && ''
                    }
                    ColumnLayout {
                        id: appsColumn
                        anchors.right: parent.right
                        width: panel.width * 0.3
                        Repeater {
                            id: desktopEntries
                            model: appLauncherRect.candidateApps
                            Text {
                                id: desktopEntryItem
                                required property var modelData
                                property var application: modelData
                                property var app: desktopEntryItem.application
                                // Also have: ${app.keywords} ${app.genericName}  ${app.comment}  ${app.id}|${app.categories}
                                // TODO may want to move the "filtered apps list" up a level so that we can easily make fancy auxilliary text here
                                text: `${app.name}\n `
                                // Need to set both this and width explicitly to make it work inside a Layout
                                Layout.preferredWidth: width
                                wrapMode: Text.WordWrap
                                width: appsColumn.width
                                // TODO pick better font
                                font.family: Config.fontTypewriter.font.family
                                visible: {
                                    // TODO rofi algorithm is https://github.com/davatorium/rofi/blob/a6afacb8cec27b51606b59e0571f33fa9007fc70/source/helper.c#L1045
                                    // idk if the Quickshell heuristicLookup is comparable or not
                                    const appNameMatches = app.name.toLowerCase().includes(appSearchField.text.toLowerCase());
                                    const appKeywordsMatch = -1 < app.keywords.findIndex((keyword) => keyword.toLowerCase().includes(appSearchField.text.toLowerCase()))
                                    return appSearchField.text === '' || appNameMatches || appKeywordsMatch;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

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

        // TODO unsure if it is needed
        HyprlandFocusGrab {
            id: grab
            windows: [panel]
        }

        WrapperMouseArea {
            id: escMouseArea
            anchors.fill: parent
            onClicked: {
                root.shouldShow = false;
            }

            Rectangle {
                id: blackRect
                anchors.fill: parent
                color: "transparent"
                visible: true
                function _shiftTargetedApp(index: int) {
                    if (appLauncherRect.candidateApps.length > 0) {
                        const currIdx = appLauncherRect.candidateApps.findIndex((app) => app.name === appLauncherRect.targetedApp?.name);
                        const len = appLauncherRect.candidateApps.length;
                        appLauncherRect.targetedApp = appLauncherRect.candidateApps[((currIdx + index % len) + len) % len];
                    }
                }
                Keys.onPressed: event => {
                    // close: Escape
                    if (event.key === Qt.Key_Escape) {
                        event.accepted = true;
                        root.shouldShow = false;
                    }

                    // Key up = go to the previous item in the candidate apps list
                    if (event.key === Qt.Key_Down) {
                        _shiftTargetedApp(+1);
                        event.accepted = true;
                    }
                    // Key down = go to the next item in the candiate apps list
                    if (event.key === Qt.Key_Up) {
                        _shiftTargetedApp(-1);
                        event.accepted = true;
                    }

                    // Launch app if there's one selected
                    if (event.key === Qt.Key_Return) {
                        if (appLauncherRect.targetedApp) {
                            event.accepted = true;
                            appLauncherRect.targetedApp.execute();
                            appSearchField.text = "";
                            appLauncherRect.targetedApp = null;
                            root.shouldShow = false;
                        }
                    }
                }

                Rectangle {
                    id: appLauncherRect
                    anchors.centerIn: parent
                    anchors.fill: parent
                    color: "#CC000000"
                    radius: 2
                    // TODO some issue of not always launching.... maybe it is slow??
                    // TODO this stuff probably belongs at the higher level...
                    property list<DesktopEntry> allApps: DesktopEntries.applications.values
                    property list<DesktopEntry> candidateApps: []
                    property DesktopEntry targetedApp
                    property var targetedAppShownProperties: {
                        if (!targetedApp) {
                            return [];
                        }
                        return [targetedApp?.name, targetedApp?.comment, targetedApp?.keywords, targetedApp?.genericName, targetedApp?.categories].filter(datum => !!datum);
                    }

                    TextField {
                        id: appSearchField
                        anchors.centerIn: parent
                        focus: true
                        color: "white"
                        font.pixelSize: 96
                        font.bold: text === "" ? false : true
                        font.family: Config.fontSerif.font.family
                        // horizontalAlignment: Text.AlignHCenter
                        // verticalAlignment: Text.AlignVCenter
                        background: Rectangle {
                            color: "transparent"
                        }
                        placeholderText: "Search!"
                        placeholderTextColor: "#aaffffff"
                        text: {
                           root.shouldShow
                           return ''
                        }

                        onTextChanged: {
                            // Start with all entries
                            // TODO rofi algorithm is https://github.com/davatorium/rofi/blob/a6afacb8cec27b51606b59e0571f33fa9007fc70/source/helper.c#L1045
                            // idk if the Quickshell heuristicLookup is comparable or not
                            if (!text) {
                                appLauncherRect.targetedApp = null;
                                appLauncherRect.candidateApps = appLauncherRect.allApps;
                                return;
                            }

                            appLauncherRect.candidateApps = [];
                            for (let i = 0; i < appLauncherRect.allApps.length; i++) {
                                const entry = appLauncherRect.allApps[i];
                                const appNameMatches = entry.name.toLowerCase().includes(text.toLowerCase());
                                const appKeywordsMatch = -1 < entry.keywords.findIndex(keyword => keyword.toLowerCase().includes(text.toLowerCase()));
                                const visible = text === '' || appNameMatches || appKeywordsMatch;
                                if (visible) {
                                    appLauncherRect.candidateApps.push(entry);
                                }
                            }

                            if (appLauncherRect.candidateApps.length > 0) {
                                appLauncherRect.targetedApp = appLauncherRect.candidateApps[0];
                            } else {
                                // This means no search matched, so clear the selected entry
                                appLauncherRect.targetedApp = null;
                            }
                        }
                    }
                    Text {
                        id: selectedText
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: 100
                        anchors.horizontalCenterOffset: 100
                        font.family: Config.fontSerif.font.family
                        font.pixelSize: appSearchField.font.pixelSize
                        color: "white"
                        text: {
                            if (appSearchField.text !== '' && !!appLauncherRect.targetedApp) {
                                return `[${appLauncherRect.targetedApp.name}]`;
                            } else {
                                return '';
                            }
                        }
                    }

                    // TODO These need to be filtered based on list of ALL matching apps? Or not. Not sure,
                    // I think doing it as only the selected app probably makes it more usable?
                    RowLayout {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.topMargin: parent.height * 0.1
                        anchors.leftMargin: parent.width * 0.1
                        width: parent.width - appsColumn.width
                        Repeater {
                            property var properties: appLauncherRect.targetedAppShownProperties
                            model: properties.slice(0, Math.ceil(properties.length / 2))
                            LayerParts.BackgroundAccentText {
                                required property var modelData
                                text: modelData
                            }
                        }
                    }
                    RowLayout {
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: parent.height * 0.1
                        anchors.leftMargin: parent.width * 0.1
                        width: parent.width - appsColumn.width
                        Repeater {
                            property var properties: appLauncherRect.targetedAppShownProperties
                            model: properties.slice(Math.ceil(properties.length / 2))
                            LayerParts.BackgroundAccentText {
                                required property var modelData
                                text: modelData
                            }
                        }
                    }

                    ColumnLayout {
                        id: appsColumn
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        width: panel.width * 0.3

                        Repeater {
                            id: desktopEntries
                            model: appLauncherRect.candidateApps
                            LayerParts.DesktopEntryListText {
                                id: candidateAppInfo
                                required property var modelData
                                app: modelData
                                isSelected: appLauncherRect.targetedApp?.name === app.name
                                desiredWidth: appsColumn.width
                            }
                        }
                    }
                }
            }
        }
    }
}

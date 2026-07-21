import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls
import Quickshell.Hyprland
import ".."
import "../utils"

// TODO interactivity: What should happen when we click on a day?
// If we have an ics integration then this would have obvious use, but I am
// not 100% sure how trivial that's going to be
Scope {
    id: root
    // This is the screen from Quickshell.screens
    required property var modelData

    property int year: Qt.formatDateTime(Time.clock.date, 'yyyy')
    property int month: Qt.formatDateTime(Time.clock.date, 'MM') - 1
    property var locale: Qt.locale("en_US")
    property bool shouldShow
    PanelWindow {
        id: panel
        screen: root.modelData
        visible: root.shouldShow
        color: "transparent"
        Component.onCompleted: {
            if (this.WlrLayershell != null) {
                this.WlrLayershell.layer = WlrLayer.Top;
                this.WlrLayershell.namespace = "calendar";
            }
        }

        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        // TODO can put this back now maybe?
        //WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
        anchors {
            top: true
            left: true
            bottom: true
            right: true
        }
        HyprlandFocusGrab {
            id: grab
            windows: [rectangle]
        }

        Rectangle {
            id: rectangle
            //  anchors.fill: parent
            width: modelData.width
            height: modelData.height
            color: Config.calendar.backgroundColor
            visible: true

            MonthGrid {
                id: grid
                month: root.month
                year: root.year
                locale: root.locale
                anchors.centerIn: parent
                spacing: 10

                delegate: Rectangle {
                    id: dayRect
                    width: root.modelData.width / 12
                    height: root.modelData.width / 12
                    color: {
                        shouldShow; // flag it to re-randomize whenever it runs
                        if (grid.month !== month) {
                            return Config.calendar.backgroundColorDayOutOfRange;
                        }
                        // TODO not sure randomness here is interseting - maybe fix a pattern
                        const randIdx = Math.floor(Math.random() * Config.calendar.backgroundColorsDays.length);
                        return Config.calendar.backgroundColorsDays[randIdx];
                    }

                    Text {
                        property string monthName: {
                            const x = new Date(Time.clock.date);
                            const monthsDiff = month - Qt.formatDateTime(Time.clock.date, 'MM');
                            x.setMonth(x.getMonth() + monthsDiff);
                            return Qt.formatDateTime(x, 'MMM');
                        }
                        text: `${Qt.formatDateTime(date, 'ddd')} ${Qt.formatDateTime(date, 'MMM')} ${day}, ${year}`
                        font.bold: today
                        font.variableAxes: {
                            "wght": 700
                        }
                        font.letterSpacing: 2
                        font.family: Config.fontBlocky.font.family
                        font.pixelSize: Config.calendar.fontSizeDays
                        font.italic: shouldShow ? Math.random() > Config.calendar.fontDaysItalicThreshold : false
                        x: {
                            if (shouldShow) {
                                const range = Config.calendar.dayTextXOffsetRange;
                                return Math.random() * range - range/2;
                            } else {
                                return 0
                            }
                        }
                        y: {
                            if (shouldShow) {
                                const range = Config.calendar.dayTextYOffsetRange;
                                return Math.random() * range - range/2;
                            } else {
                                return 0
                            }
                        }
                        rotation: {
                            if (shouldShow) {
                                const range = Config.calendar.dayTextRotationRange;
                                return Math.random() * range - range/2;
                            } else {
                                return 0
                            }
                        }
                        z: dayRect.z + 1
                        color: "black"
                        anchors.top: parent
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.horizontalCenterOffset: {
                            if (shouldShow) {
                                const range = Config.calendar.dayTextXOffsetRange;
                                return Math.random() * range - range /2;
                            } else {
                                return 0
                            }
                        }
                    }
                }
            }

            // TODO mess with baseline per-letter for this? maybe not perfect 90 deg rotation?
            //  TODO use a different (thinner) font here maybe??
            Text {
                text: `${Qt.formatDateTime(Time.clock.date, 'MMMM')} ${Qt.formatDateTime(Time.clock.date, 'yyyy')}`
                rotation: 90
                anchors.right: parent.right
                font.pixelSize: modelData.width / 24
                font.family: Config.fontBlocky.font.family
                font.bold: true
                font.variableAxes: {
                    "wght": 700
                }
                y: implicitWidth
                color: "white"
            }

            // TODO this is really a failsafe so I don't accidentally boot up to an unkillable screen,
            // need a real esc/exit plan, and also need to add onClick to the calendar functions I think
            // would be cool to have real calendar integration with Proton or something but that may be hard
            // and less secure
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.shouldShow = false;
                    // panel.visible = false
                }
            }
        }
    }
}

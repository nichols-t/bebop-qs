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
import "./calendar" as LayerParts

// TODO interactivity: What should happen when we click on a day?
Scope {
    id: root
    // This is the screen from Quickshell.screens
    required property var modelData

    property int year: Qt.formatDateTime(Time.clock.date, 'yyyy')
    property int month: Qt.formatDateTime(Time.clock.date, 'MM') - 1
    property var locale: Qt.locale("en_US")
    property bool shouldShow

    function _reset() {
        dayView.reset();
    }

    onShouldShowChanged: {
        if (!shouldShow) {
            _reset();
        }
    }

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
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
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

            // Needs to be focused to get key press event
            focus: true
            Keys.onPressed: event => {
                // close: Escape
                if (event.key === Qt.Key_Escape) {
                    event.accepted = true;
                    root.shouldShow = false;
                }
            }

            LayerParts.DayView {
                id: dayView
                shouldShow: !!dayInfo && !!date
                screen: root.modelData
                onDayInfoChanged: {
                    shouldShow = !!dayInfo && !!date;
                }
                onDateChanged: {
                    shouldShow = !!dayInfo && !!date;
                }
                width: grid.width
                height: grid.height
            }

            MonthGrid {
                id: grid
                month: root.month
                year: root.year
                locale: root.locale
                anchors.centerIn: parent
                spacing: 10

                property string firstDay: ''
                property string lastDay: ''
                Component.onCompleted: {
                    CalendarData.firstDay = firstDay;
                    CalendarData.lastDay = lastDay;
                }
                // TODO: Should be its own file!!
                delegate: Rectangle {
                    id: dayRect
                    width: root.modelData.width / 12
                    height: root.modelData.width / 12
                    color: {
                        shouldShow; // flag it to re-randomize whenever it runs
                        if (grid.month !== month) {
                            return Config.calendar.backgroundColorDayOutOfRange;
                        }

                        const randIdx = Math.floor(Math.random() * Config.calendar.backgroundColorsDays.length);
                        return Config.calendar.backgroundColorsDays[randIdx];
                    }
                    // Text used when looking up data from the calendar
                    property string dateLookupText: Qt.formatDateTime(date, 'yyyy-MM-dd')
                    property date theDate: date
                    property int theIndex: index

                    Component.onCompleted: {
                        // ... This means it always shows six rows ... from
                        // https://doc.qt.io/qt-6/qml-qtquick-controls-monthgrid.html
                        if (index === 0) {
                            grid.firstDay = dateLookupText;
                        } else if (index === 41) {
                            grid.lastDay = dateLookupText;
                        }
                    }

                    MouseArea {
                        enabled: !dayView.shouldShow
                        id: dayMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            dayView.date = dateLookupText;
                            dayView.dayInfo = CalendarData.dayInfo[parent.theIndex];
                            dayView.backgroundColor = dayRect.color;
                        }
                        onEntered: {
                            backgroundMouseArea.enabled = false;
                            backgroundMouseArea.visible = false;
                            dayText.font.underline = true;
                        }
                        onExited: {
                            backgroundMouseArea.enabled = true;
                            backgroundMouseArea.visible = true;
                            dayText.font.underline = false;
                        }
                    }

                    Text {
                        id: dayText
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
                        font.pointSize: Config.calendar.daysTextSize
                        font.italic: shouldShow ? Math.random() > Config.calendar.fontDaysItalicThreshold : false
                        x: {
                            if (shouldShow) {
                                const range = Config.calendar.dayTextXOffsetRange;
                                return Math.random() * range - range / 2;
                            } else {
                                return 0;
                            }
                        }
                        y: {
                            if (shouldShow) {
                                const range = Config.calendar.dayTextYOffsetRange;
                                return Math.random() * range - range / 2;
                            } else {
                                return 0;
                            }
                        }
                        rotation: {
                            if (shouldShow) {
                                const range = Config.calendar.dayTextRotationRange;
                                return Math.random() * range - range / 2;
                            } else {
                                return 0;
                            }
                        }
                        z: dayRect.z + 1
                        color: "black"
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.horizontalCenterOffset: {
                            if (shouldShow) {
                                const range = Config.calendar.dayTextXOffsetRange;
                                return Math.random() * range - range / 2;
                            } else {
                                return 0;
                            }
                        }
                    }

                    ColumnLayout {
                        anchors.verticalCenter: dayRect.verticalCenter
                        Repeater {
                            model: CalendarData.dayInfo[index];
                            
                            // TODO I copied this from the above segment; put it into a proper component
                            // as like RandomText or something
                            // The ranges also are a bit weird for these particular event, needed to reduce them a lot
                            // and also they don't work in a layout the same way (but the above text should probably also be in a Layout)
                            Text {
                                required property var modelData
                                text: modelData.title

                                font.bold: today
                                font.family: Math.random() > 0.5 ? Config.fontTypewriter.font.family : Config.fontSerif.font.family
                                font.pointSize: Config.calendar.eventsTextSize
                                font.italic: shouldShow ? Math.random() > Config.calendar.fontDaysItalicThreshold : false
                                rotation: {
                                    if (shouldShow) {
                                        const range = Config.calendar.dayTextRotationRange / 2;
                                        return Math.random() * range - range / 2;
                                    } else {
                                        return 0;
                                    }
                                }
                                z: dayRect.z + 1
                                color: "black"
                                // Need to set both this and width explicitly to make it work inside a Layout
                                Layout.preferredWidth: width
                                wrapMode: Text.WordWrap
                                width: dayRect.width
                                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                            }
                        }
                    }
                }
            }

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

            // Additional failsafe to let you close menu via mouse
            // TODO need to add onClick submenu to each day
            MouseArea {
                id: backgroundMouseArea
                enabled: !dayView.shouldShow
                anchors.fill: parent
                onClicked: {
                    root.shouldShow = false;
                }
            }
        }
    }
}

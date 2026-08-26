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
import "./calendar"

Scope {
    id: root
    // This is the screen from Quickshell.screens
    required property var screen

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
        screen: root.screen
        visible: root.shouldShow
        color: "transparent"
        Component.onCompleted: {
            if (this.WlrLayershell != null) {
                this.WlrLayershell.layer = WlrLayer.Overlay;
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
            width: screen.width
            height: screen.height
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

            DayView {
                id: dayView
                shouldShow: !!dayInfo && !!date
                screen: root.screen
                onDayInfoChanged: {
                    shouldShow = !!dayInfo && !!date;
                }
                onDateChanged: {
                    shouldShow = !!dayInfo && !!date;
                }
                width: grid.width
                height: grid.height
                function onDayChanged(dateLookupText, index, color): void {
                    date = dateLookupText;
                    dayInfo = CalendarData.dayInfo[index];
                    backgroundColor = color;
                }
            }

            MonthGrid {
                id: grid
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

                delegate: MonthGridDelegate {
                    screen: root.screen
                    targetMonth: root.month
                    calendarOpen: root.shouldShow
                    Component.onCompleted: {
                        // ... This means it always shows six rows ... from
                        // https://doc.qt.io/qt-6/qml-qtquick-controls-monthgrid.html
                        if (index === 0) {
                            grid.firstDay = dateLookupText;
                        } else if (index === 41) {
                            grid.lastDay = dateLookupText;
                        }
                    }
                    dayViewOpen: dayView?.shouldShow || false
                    onClicked: dayView.onDayChanged
                }
            }

            MonthText {
                id: monthText
                date: Time.clock.date
                anchors.right: parent.right
                font.pixelSize: screen.width / 24
                rotation: 90
                visible: false
            }

            MultiEffect {
                source: monthText
                anchors.fill: monthText
                rotation: monthText.rotation
                blurEnabled: true
                blur: 1
                blurMax: 2
            }

            // Additional failsafe to let you close menu via mouse
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

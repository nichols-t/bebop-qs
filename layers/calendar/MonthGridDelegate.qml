import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

import "../.."
import "../../utils"

Rectangle {
    id: root
    required property var screen
    required property int index
    required property var today
    required property var date
    required property var day
    required property var month
    required property var targetMonth
    required property bool calendarOpen
    required property bool dayViewOpen
    width: screen.width / 12
    height: screen.width / 12
    radius: 2
    // Don't remember why I needed these, probably reactivity something or other
    property date theDate: date
    property int theIndex: index
    color: {
        calendarOpen; // flag it to re-randomize whenever it runs
        if (targetMonth !== month) {
            return Config.calendar.backgroundColorDayOutOfRange;
        }

        const randIdx = Math.floor(Math.random() * Config.calendar.backgroundColorsDays.length);
        return Config.calendar.backgroundColorsDays[randIdx];
    }
    // Text used when looking up data from the calendar
    property string dateLookupText: Qt.formatDateTime(date, 'yyyy-MM-dd')

    required property var onClicked

    Rectangle {
        width: dayMouseArea.containsMouse ? root.width : 0
        height: dayMouseArea.containsMouse ? root.height : 0
        anchors.centerIn: parent
        color: Config.calendar.backgroundColorHovered
        radius: parent.radius
    }

    MouseArea {
        id: dayMouseArea
        enabled: !dayViewOpen
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        preventStealing: false
        onClicked: {
            // Got a binding loop so had to do this. Didn't bother to track it down
            root.onClicked(dateLookupText, root.theIndex, root.color);
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
        z: root.z + 1
        color: Config.calendar.daysTextColor
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
        id: cols
        anchors.verticalCenter: root.verticalCenter
        Repeater {
            model: CalendarData.dayInfo[index]

            Text {
                id: text
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
                z: root.z + 1
                color: Config.calendar.eventsTextColor
                // Need to set both this and width explicitly to make it work inside a Layout
                Layout.preferredWidth: width
                wrapMode: Text.WordWrap
                width: root.width
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            }
        }
    }
}

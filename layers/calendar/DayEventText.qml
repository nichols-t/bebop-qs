import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland
import "../.."

Text {
    required property var event
    Layout.topMargin: root.height / 9
    Layout.fillWidth: true
    Layout.preferredWidth: width
    width: root.implicitWidth * 0.9
    horizontalAlignment: Qt.AlignHCenter
    Layout.alignment: Qt.AlignCenter
    font.family: Config.fontTypewriter.font.family
    font.pixelSize: root.height / 54
    wrapMode: Text.WrapAnywhere
    textFormat: Text.RichText
    rotation: {
        if (root.shouldShow) {
            const range = Config.calendar.dayTextRotationRange / 2;
            return Math.random() * range - range / 2;
        } else {
            return 0;
        }
    }
    //verticalAlignment: Qt.AlignTop
    text: {
        const currentDate = Qt.formatDateTime(root.date, 'yyyy-MM-dd');
        const isAllDay = event['all-day'] === 'True';
        const desc = event.description;
        const title = event.title;
        const startTime = event['start-time'];
        const endTime = event['end-time'];
        const duration = event.duration;
        const startDate = event['start-date'];
        const endDate = event['end-date'];

        let displayTime = `${startTime} to ${endTime}`;
        // This means event is not flagged as "all day event", but
        // its start and end span all of today.
        const endsToday = endDate === currentDate;
        const startsToday = startDate === currentDate;

        if (isAllDay) {
            displayTime = 'ALL DAY';
        } else if (!endsToday) {
            if (startsToday) {
                displayTime = `${startTime}; `;
            } else {
                displayTime = '';
            }
            displayTime += `ENDS ${endDate} at ${endTime}`;
        }

        return `${displayTime} - <b>${title}</b>`;
    }
}

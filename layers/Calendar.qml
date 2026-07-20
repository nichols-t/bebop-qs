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
          //  anchors.fill: parent
            width: modelData.width
            height: modelData.height
            id: rectangle
            color: "black"
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
                    // TODO theme this more interestingly and add it to the theme proper
                    color: {
                        if (grid.month !== month) {
                            return "#d2d6d3"
                        }
                        // TODO idiotic to put this definition in a repeated function call
                        // make it config property
                        const colors = [
                            "#3954f0",
                            "#d7dbf8",
                            "#fefefe",
                            "#b1bdf8",
                            "#a4aef8"
                        ];
                        // TODO not sure randomness here is interseting - maybe fix a pattern
                        const randIdx = Math.floor(Math.random() * colors.length);
                        return colors[randIdx];
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
                        font.variableAxes: { "wght": 700}
                        font.letterSpacing: 2
                        font.family: Config.fontBlocky.font.family
                        font.pixelSize: 22
                        font.italic: Math.random() > 0.5
                        x: Math.random() * 10 - 5
                        y: Math.random() * 10 - 5
                        rotation: Math.random() * 15 - 7.5
                        z: dayRect.z + 1
                        color: "black"
                        anchors.top: parent
                        anchors.horizontalCenter: parent.horizontalCenter
                        // TODO parameterize randomness better
                        anchors.horizontalCenterOffset: Math.floor(Math.random() * 50 - 25)
                    }
                }
            }

            // TODO mess with baseline per-letter for this? maybe not perfect 90 deg rotation?
            Text {
                text: `${Qt.formatDateTime(Time.clock.date, 'MMMM')} ${Qt.formatDateTime(Time.clock.date, 'yyyy')}`
                rotation: 90
                anchors.right: parent.right
                font.pixelSize: modelData.width / 24
                font.family: Config.fontBlocky.font.family
                font.bold: true
                font.variableAxes: { "wght": 900}
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
                    root.shouldShow = false
                    // panel.visible = false
                }
            }
        }
    }
}

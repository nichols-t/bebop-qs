// ClockWidget.qml
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import "../../utils"
import ".."
import "../.."

WrapperRectangle {
    id: root
    color: Config.taskbar.battery.backgroundColor

    Item {
        implicitHeight: Config.taskbar.taskbarHeight
        implicitWidth: 70 // TODO
        RowLayout {
          anchors.centerIn: parent
            ColumnLayout {
                id: batteryBars
                spacing: 1
                property int numBarsFilled: Math.ceil(SysInfo.power.batteryPercent / 25)
                Layout.alignment: Qt.AlignTop
                Repeater {
                    id: repeater
                    model: 4
                    Rectangle {
                      border.width: 1
                      border.color: Config.taskbar.battery.barsBorderColor
                        Layout.alignment: Qt.AlignHCenter
                        required property int index
                        width: {
                            if (index === 0) {
                                return 6;
                            } else {
                                return 10;
                            }
                        }
                        height: {
                            if (index === 0) {
                                return 3;
                            } else {
                                return 5;
                            }
                        }
                        radius: 2
                        color: {
                            if ((repeater.model - index - 1) < batteryBars.numBarsFilled) {
                                return Config.taskbar.battery.barsColor;
                            } else {
                                return "transparent";
                            }
                        }
                    }
                }
            }
            Text {
                id: battText
                text: {
                    if (SysInfo.power.hasBattery) {
                        return `${SysInfo.power.batteryPercent}%`
                    } else {
                        return 'AC'
                    }
                }
                font {
                    family: Config.fontTypewriter.font.family
                    pixelSize: 18
                    bold: true
                }
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignHCenter
                // TODO why is this extra margin needed?
                Layout.topMargin: 2
                color: Config.taskbar.battery.textColor
            }
        }
    }
}

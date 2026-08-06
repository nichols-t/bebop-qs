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
        implicitWidth: rows.width + 10 // TODO should be using a wrapper rect here, I think
        RowLayout {
            id: rows
          anchors.centerIn: parent
            ColumnLayout {
                id: batteryBars
                spacing: 1
                property int numBarsFilled: Math.ceil(SysInfo.power.batteryPercent / 25)
                Layout.alignment: Qt.AlignCenter
                Repeater {
                    id: repeater
                    model: 4
                    Rectangle {
                      border.width: 0
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
                        radius: 0
                        color: {
                            if ((repeater.model - index - 1) < batteryBars.numBarsFilled) {
                                return Config.taskbar.battery.barsFilledColor;
                            } else if (!SysInfo.power.hasBattery) {
                                return Config.taskbar.battery.barsFilledColor;
                            } else {
                                return Config.taskbar.battery.barsEmptyColor;
                            }
                        }
                    }
                }
            }
            Text {
                id: battText
                text: {
                    if (SysInfo.power.hasBattery) {
                        const str = SysInfo.power.pluggedIn ? 'CHARGE ' : ''
                        // TODO extra space is for layout issues - overall width
                        // of this widget should have a margin that can accommodate
                        // this
                        return `${str}${SysInfo.power.batteryPercent}% `
                    } else {
                        return 'AC'
                    }
                }
                font {
                    family: Config.fontBlocky.font.family
                    pixelSize: Config.taskbar.fontSize
                    bold: false
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

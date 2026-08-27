// ClockWidget.qml
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import "../../utils"
import ".."
import "../.."

WrapperMouseArea {
    id: root
    cursorShape: Qt.PointingHandCursor
    enabled: true
    hoverEnabled: true

    property ShutdownMenu shutdownMenu

    onClicked: {
        shutdownMenu.shouldShow = true;
    }

    WrapperRectangle {
        color: Config.taskbar.clock.backgroundColor
        RowLayout {
            implicitHeight: Config.taskbar.taskbarHeight

            Loader {
                id: profileImageLoader
                sourceComponent: SysInfo.user.homePath ? profileImage : null
                asynchronous: true
            }
            Text {
                id: text
                text: SysInfo.user.name
                font.family: Config.fontBlocky.font.family
                font.pointSize: Config.taskbar.fontSize
                font.bold: root.containsMouse
                font.italic: root.containsMouse
                font.underline: root.containsMouse
                Layout.alignment: Qt.AlignLeft
                color: Config.taskbar.clock.textColor
            }

            Component {
                id: profileImage
                Rectangle {
                    width: Config.taskbar.taskbarHeight
                    height: width
                    radius: width / 2
                    Image {
                        id: img
                        anchors.centerIn: parent
                        source: Qt.resolvedUrl(SysInfo.user.homePath + '/.face')
                        fillMode: Image.PreserveAspectFit
                        visible: false
                        sourceSize.width: Config.taskbar.taskbarHeight
                    }

                    MultiEffect {
                        anchors.fill: img
                        source: img
                        maskEnabled: true
                        maskInverted: false
                        maskThresholdMin: 0.5
                        maskSpreadAtMin: 1.0
                        contrast: root.containsMouse ? 1.0 : 0.0
                        saturation: root.containsMouse ? -1.0 : 0.0
                        opacity: 1
                        maskSource: ShaderEffectSource {
                            sourceItem: Rectangle {
                                width: Config.taskbar.taskbarHeight
                                height: width
                                color: 'black'
                                radius: width / 2
                            }
                        }
                    }
                }
            }
        }
    }
}

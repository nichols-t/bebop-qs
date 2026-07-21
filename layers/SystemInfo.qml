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

// TODO: Need to re-evaluate the "macro" formatting (i.e. "GPU block as a whole"), etc.
// as I think I need to place things a little bit differently
// TODO tweak text size and line thickness, maybe
// TODO Interactivity? Maybe if you click a metric it shows you more detail on the right?
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
        Connections {
            target: root
            function onShouldShowChanged() {
                SysInfo.active = root.shouldShow;
            }
        }

        Component.onCompleted: {
            if (this.WlrLayershell != null) {
                this.WlrLayershell.layer = WlrLayer.Top;
                this.WlrLayershell.namespace = "calendar";
            }
        }

        // TODO unsure if it is needed
        HyprlandFocusGrab {
            id: grab
            windows: [fullscreenRect]
        }

        Rectangle {
            id: fullscreenRect
            //  anchors.fill: parent
            width: modelData.width
            height: modelData.height
            color: Config.calendar.backgroundColor
            visible: true

            ColumnLayout {
                anchors.centerIn: parent
                WrapperRectangle {
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: -modelData.width * 0.2
                    anchors.verticalCenterOffset: -modelData.height * 0.4
                    border.width: 4
                    radius: 2
                    color: "transparent"
                    border.color: Config.systemInfo.textColor
                    Text {
                        rightPadding: 30 
                        leftPadding: 30
                        text: "SYSTEM STATISTICS "
                        color: Config.systemInfo.textColor
                        font.pixelSize: 50
                    }
                }
                WrapperRectangle {
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: -modelData.width * 0.3
                    anchors.verticalCenterOffset: -modelData.height * 0.3
                    border.width: 4
                    radius: 2
                    color: "transparent"
                    border.color: Config.systemInfo.textColor
                    Text {
                        rightPadding: 30 
                        leftPadding: 30
                        text: SysInfo.osName
                        color: Config.systemInfo.textColor
                        font.pixelSize: 50
                    }
                }
                WrapperRectangle {
                    border.width: 2
                    radius: 2
                    color: "transparent"
                    border.color: Config.systemInfo.textColor
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: -modelData.width * 0.25
                    anchors.verticalCenterOffset: -modelData.height * 0.1
                    RowLayout {
                        spacing: 0
                        anchors.centerIn: parent
                        WrapperRectangle {
                            color: "transparent"
                            border.color: Config.systemInfo.textColor
                            border.width: 1
                            Text {
                                rightPadding: 30 
                                leftPadding: 30
                                text: "CPU USAGE"
                                color: Config.systemInfo.textColor
                                font.pixelSize: 50
                            }
                        }
                        WrapperRectangle {
                            color: "transparent"
                            border.color: Config.systemInfo.textColor
                            border.width: 1
                            Text {
                                rightPadding: 30 
                                leftPadding: 30
                                text: SysInfo.cpuText
                                color: Config.systemInfo.textColor
                                font.pixelSize: 50
                            }
                        }
                    }
                }
                WrapperRectangle {
                    border.width: 2
                    radius: 2
                    color: "transparent"
                    border.color: Config.systemInfo.textColor
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: -modelData.width * 0.1
                    anchors.verticalCenterOffset: 0
                    RowLayout {
                        spacing: 0
                        anchors.centerIn: parent
                        WrapperRectangle {
                            color: "transparent"
                            border.color: Config.systemInfo.textColor
                            border.width: 1
                            Text {
                                rightPadding: 30 
                                leftPadding: 30
                                text: "RAM USAGE"
                                color: Config.systemInfo.textColor
                                font.pixelSize: 50
                            }
                        }
                        WrapperRectangle {
                            color: "transparent"
                            border.color: Config.systemInfo.textColor
                            border.width: 1
                            Text {
                                rightPadding: 30 
                                leftPadding: 30
                                text: SysInfo.memText
                                color: Config.systemInfo.textColor
                                font.pixelSize: 50
                            }
                        }
                    }
                }
                WrapperRectangle {
                    id: gpuTempWrapper
                    border.width: 2
                    radius: 2
                    color: "transparent"
                    border.color: Config.systemInfo.textColor
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: -modelData.width * 0.2
                    anchors.verticalCenterOffset: modelData.height * 0.1
                    RowLayout {
                        spacing: 0
                        anchors.centerIn: parent
                        WrapperRectangle {
                            color: "transparent"
                            border.color: Config.systemInfo.textColor
                            border.width: 1
                            Text {
                                rightPadding: 30 
                                leftPadding: 30
                                text: "GPU TEMP"
                                color: Config.systemInfo.textColor
                                font.pixelSize: 50
                            }
                        }
                        WrapperRectangle {
                            color: "transparent"
                            border.color: Config.systemInfo.textColor
                            border.width: 1
                            Text {
                                rightPadding: 30 
                                leftPadding: 30
                                text: SysInfo.gpuTempText
                                color: Config.systemInfo.textColor
                                font.pixelSize: 50
                            }
                        }
                    }
                }
                WrapperRectangle {
                    id: gpuDriverWrapper
                    border.width: 2
                    radius: 2
                    color: "transparent"
                    border.color: Config.systemInfo.textColor
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: -modelData.width * 0.2
                    anchors.verticalCenterOffset: modelData.height * 0.1 + gpuTempWrapper.height
                    RowLayout {
                        spacing: 0
                        anchors.centerIn: parent
                        WrapperRectangle {
                            color: "transparent"
                            border.color: Config.systemInfo.textColor
                            border.width: 1
                            Text {
                                rightPadding: 30 
                                leftPadding: 30
                                text: "GPU DRIVER VERSION"
                                color: Config.systemInfo.textColor
                                font.pixelSize: 50
                            }
                        }
                        WrapperRectangle {
                            color: "transparent"
                            border.color: Config.systemInfo.textColor
                            border.width: 1
                            Text {
                                rightPadding: 30 
                                leftPadding: 30
                                text: SysInfo.gpuDriver
                                color: Config.systemInfo.textColor
                                font.pixelSize: 50
                            }
                        }
                    }
                }
                WrapperRectangle {
                    border.width: 2
                    radius: 2
                    color: "transparent"
                    border.color: Config.systemInfo.textColor
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: -modelData.width * 0.2
                    anchors.verticalCenterOffset: modelData.height * 0.1 + gpuTempWrapper.height + gpuDriverWrapper.height
                    RowLayout {
                        spacing: 0
                        anchors.centerIn: parent
                        WrapperRectangle {
                            color: "transparent"
                            border.color: Config.systemInfo.textColor
                            border.width: 1
                            Text {
                                rightPadding: 30 
                                leftPadding: 30
                                text: "GPU MEM USAGE"
                                color: Config.systemInfo.textColor
                                font.pixelSize: 50
                            }
                        }
                        WrapperRectangle {
                            color: "transparent"
                            border.color: Config.systemInfo.textColor
                            border.width: 1
                            Text {
                                rightPadding: 30 
                                leftPadding: 30
                                text: SysInfo.gpuMemText
                                color: Config.systemInfo.textColor
                                font.pixelSize: 50
                            }
                        }
                    }
                }
                WrapperRectangle {
                    border.width: 2
                    radius: 2
                    color: "transparent"
                    border.color: Config.systemInfo.textColor
                    anchors.centerIn: parent
                    anchors.horizontalCenterOffset: -modelData.width * 0.23
                    anchors.verticalCenterOffset: modelData.height * 0.3
                    RowLayout {
                        spacing: 0
                        anchors.centerIn: parent
                        WrapperRectangle {
                            color: "transparent"
                            border.color: Config.systemInfo.textColor
                            border.width: 1
                            Text {
                                rightPadding: 30 
                                leftPadding: 30
                                text: "DISK USAGE"
                                color: Config.systemInfo.textColor
                                font.pixelSize: 50
                            }
                        }
                        WrapperRectangle {
                            color: "transparent"
                            border.color: Config.systemInfo.textColor
                            border.width: 1
                            Text {
                                rightPadding: 30 
                                leftPadding: 30
                                text: SysInfo.diskText
                                color: Config.systemInfo.textColor
                                font.pixelSize: 50
                            }
                        }
                    }
                }
            }

            Rectangle {
                id: yellowSideRect
                width: fullscreenRect.width * 0.4
                height: modelData.height
                anchors.right: parent.right
                color: Config.systemInfo.accentColor
            }

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

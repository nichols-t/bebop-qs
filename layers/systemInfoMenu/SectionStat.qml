
import Quickshell
import QtQuick
import Quickshell.Widgets
import QtQuick.Layouts
import "../.."

// Displays a single statistic as a divided rectangle
SectionStatRectangle {
    id: stat
    // The label for this stat
    required property string label
    // This stat's value
    required property string value
    RowLayout {
        spacing: 0
        WrapperRectangle {
            color: "transparent"
            border.color: Config.systemInfo.textColor
            border.width: 1
            SysInfoText {
                text: stat.label
            }
        }
        WrapperRectangle {
            color: "transparent"
            border.color: Config.systemInfo.textColor
            border.width: 1
            SysInfoText {
                text: stat.value
            }
        }
    }

    component SectionStatRectangle: WrapperRectangle {
        border.width: 4
        radius: 2
        color: "transparent"
        border.color: Config.systemInfo.textColor
        Layout.alignment: Qt.AlignRight
        Layout.rightMargin: -modelData.width * 0.1
    }
}


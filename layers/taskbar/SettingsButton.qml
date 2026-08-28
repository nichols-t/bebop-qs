import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Widgets
import "../../utils"
import ".."
import "../.."

WrapperMouseArea {
    id: root
    cursorShape: Qt.PointingHandCursor
    property Settings settings

    onClicked: {
        settings.show()// = true;
    }
    hoverEnabled: true
    margin: 0
    WrapperRectangle {
        color: Config.taskbar.clock.backgroundColor
        margin: 0
        Item {
            implicitHeight: Config.taskbar.taskbarHeight
            implicitWidth: icon.width

            Image {
                anchors.centerIn: parent
                id: icon
                fillMode: Image.PreserveAspectFit
                source: Qt.resolvedUrl("../../assets/settings-icon.svg")
                visible: false
                sourceSize.width: parent.height - 4
            }

            // Note that the icon is white so that we can recolor it based
            // on theme as needed.
             MultiEffect {
                colorizationColor: Config.taskbar.clock.textColor
                colorization: 1.0
                source: icon
                anchors.fill: icon
            }
        }
    }
}

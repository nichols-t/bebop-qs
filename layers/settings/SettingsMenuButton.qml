import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick

WrapperMouseArea {
    id: root
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true

    required property string text

    SettingsMenuText {
        id: text
        anchors.centerIn: parent
        text: root.text
        hovered: root.containsMouse
        implicitWidth: root.width
    }

}

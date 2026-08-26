import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick

WrapperMouseArea {
    id: root
    cursorShape: Qt.PointingHandCursor

    required property string text

    SettingsMenuText {
        id: text
        anchors.centerIn: parent
        text: root.text
        implicitWidth: root.width
    }

    hoverEnabled: true
    onEntered: {
        text.hovered = true;        
    }
    onExited: {
        text.hovered = false;
    }
}

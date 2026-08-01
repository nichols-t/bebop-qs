import Quickshell.Widgets
import QtQuick.Layouts

WrapperMouseArea {
    id: root
    cursorShape: Qt.PointingHandCursor
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignRight
    implicitWidth: panel.implicitWidth

    required property string text

    SettingsMenuText {
        id: text
        text: root.text
    }

    hoverEnabled: true
    onEntered: {
        text.hovered = true;        
    }
    onExited: {
        text.hovered = false;
    }
}

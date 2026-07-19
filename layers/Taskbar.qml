import Quickshell
import QtQuick
import QtQuick.Layouts
import ".."
import "./taskbar" as LayerParts

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      color: "transparent" // TODO theme
      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: Config.taskbar.taskbarHeight

      RowLayout {
        anchors.fill: parent
        // Widgets.WorkspacesWidget {
        //   anchors.left: parent
        // }

         Item { Layout.fillWidth: true }

        // RowLayout {
        //   Widgets.VolumeWidget {}
        // }

        // 
        // }

        LayerParts.Clock {
          // anchors.right: parent
          // implicitHeight: Config.taskbar.taskbarHeight
          // implicitWidth: 280
          // Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        }

      }

        // TODO: Not sure if this belongs here or separately
      //qWidgets.Notifications {}
    }
  }
}
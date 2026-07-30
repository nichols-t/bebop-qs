import Quickshell.Networking
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import ".."
import "../.."

// TODO some kind of image background or something?
// TODO not entirely happy with the text here
WrapperRectangle {
    color: Config.taskbar.battery.backgroundColor
    Item {
        anchors.centerIn: parent
        implicitHeight: Config.taskbar.taskbarHeight
        implicitWidth: netText.width // TODO should be using a wrapper rect here, I think
        Text {
            // TODO why is this extra margin needed?
            anchors.verticalCenterOffset: 2
            anchors.centerIn: parent
            id: netText
            text: {
                switch(Networking.connectivity) {
                    case NetworkConnectivity.Unknown:
                        return "UNKNOWN";
                        break;
                    case NetworkConnectivity.Portal:
                        return "CAPTIVE PORTAL";
                        break;
                    case NetworkConnectivity.LIMITED:
                        return "LIMITED";
                        break;
                    case NetworkConnectivity.None:
                        return "NONE";
                        break;
                    case NetworkConnectivity.Full:
                        return "FULL";
                        break;
                    default:
                        return "UNKNOWN";
                }
            }
            font {
                family: Config.fontTypewriter.font.family
                pixelSize: 18
                bold: true
            }
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignHCenter
            color: Config.taskbar.battery.textColor
        }
    }
}

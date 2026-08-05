import QtQuick
import QtQuick.VectorImage
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "../.."
import "../../utils"

// TODO: Some layout issues here because I'm trying to do proper layouts
Rectangle {
    id: root
    anchors.fill: parent
    color: "transparent"

    ColumnLayout {
        anchors.fill: parent
        anchors.top: parent.top
        spacing: 0
        // TODO make a battery image
        Image {
            id: diskImage
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: root.height * 0.1
            //anchors.verticalCenterOffset: -root.height * 0.2
            fillMode: Image.PreserveAspectFit
            source: Qt.resolvedUrl("../../assets/disk.svg")
            visible: true
            sourceSize.height: parent.height / 3
            z: 2
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.topMargin: -parent.height * 0.55
            DetailsInfoText {
                text: `Image above TBD!`
            }
            DetailsInfoText {
                text: `Charge remaining: ${SysInfo.power.batteryPercent}%`
            }
            DetailsInfoText {
                text: `Time to Empty: ${SysInfo.power.timeToBatteryEmpty}`
            }
        }
    }
}

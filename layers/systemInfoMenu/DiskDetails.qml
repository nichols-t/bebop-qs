import QtQuick
import QtQuick.VectorImage
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import "../.."
import "../../utils"

Rectangle {
    id: root
    anchors.fill: parent
    color: "transparent"

    // How long each half of the moving text sequence takes (base)
    // random val is +- from this to make things interesting!
    property int movingTextDuration: 100
    // font.pixelSize for the moving text streams
    property int movingTextSize: 20
    Image {
        id: diskImage
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -root.height *0.2
        fillMode: Image.PreserveAspectFit
        source: Qt.resolvedUrl("../../assets/disk.svg")
        visible: true
        sourceSize.height: parent.width / 2
        z: 2
    }
    Rectangle {
        color: "transparent"
        id: graphicsRect
        implicitWidth: parent.width
        height: parent.width / 2
        clip: true

        function randomBinary(len) {
            let str = '';
            for (let i = 0; i < len; i++) {
                str += Math.random() > 0.5 ? 1 : 0;
            }

            return str;
        }

        MovingText {
            anchors.centerIn: parent
            text: graphicsRect.randomBinary(1024)
        }
        MovingText {
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: movingTextSize
            text: graphicsRect.randomBinary(1024)
        }
        MovingText {
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: movingTextSize * 2
            text: graphicsRect.randomBinary(1024)
        }
        MovingText {
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: -movingTextSize
            text: graphicsRect.randomBinary(1024)
        }
        MovingText {
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: -movingTextSize * 2
            text: graphicsRect.randomBinary(1024)
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: parent.height * 0.1
        Repeater {
            model: SysInfo.diskUsage.systemInfoDetails
            DetailsInfoText {
                required property var modelData
                text: modelData
            }
        }
    }

    component MovingText: Item {
        id: self
        required property string text
        Text {
            id: primary
            wrapMode: Text.WrapAnywhere
            text: self.text
            color: Config.systemInfo.disk.movingTextColor
            font.pixelSize: root.movingTextSize
            font.family: Config.fontTypewriter.font.family
            width: font.pixelSize
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 0
        }

        property int animHalfDuration: {
            const rand = Math.floor(Math.random() * root.movingTextDuration - root.movingTextDuration / 2);
            return root.movingTextDuration + rand;
        }

        SequentialAnimation on anchors.verticalCenterOffset {
            loops: Animation.Infinite
            NumberAnimation {
                from: -parent.width / 10
                to: parent.width / 10
                duration: animHalfDuration
            }
            NumberAnimation {
                from: parent.width / 10
                to: -parent.width / 10
                duration: animHalfDuration
            }
        }
    }
}

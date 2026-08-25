import Quickshell.Networking
import QtQuick
import "../../.."

Text {
    required property NetworkDevice networkDevice
    text: {
        const netType = modelData.type === DeviceType.Wifi ? 'WiFi' : 'Ethernet';
        let state = 'Unknown State';
        if (modelData.state === ConnectionState.Connected) {
            state = 'Connected';
        } else if (modelData.state === ConnectionState.Disconnected) {
            state = 'Disconnected';
        } else if (modelData.state === ConnectionState.Disconnecting) {
            state = 'Disconnecting';
        } else if (modelData.state === ConnectionState.Connecting) {
            state = 'Connecting';
        }
        let chosenNetwork = modelData.networks.values.find(n => n.state === modelData.state);
        if (!chosenNetwork) {
            chosenNetwork = modelData.networks.values[0];
        }

        let name;
        if (modelData.connected && modelData.networks.values.length > 0) {
            name = chosenNetwork?.name || 'Unknown';
        } else if (!name) {
            name = 'Unknown'
        }

        const connId = chosenNetwork?.nmSettings.map(s => s.id) || 'Unknown ID';
        return `${netType}: ${name} (${state})\n${connId}`;
    }
    color: Config.networkSettings.deviceTextColor
    font.pointSize: Config.networkSettings.deviceTextSize
    font.family: Config.fontTypewriter.font.family
}

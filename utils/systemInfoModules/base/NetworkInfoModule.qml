import Quickshell
import Quickshell.Networking

SystemInfoModule {
    property string state: {
        switch(Networking.connectivity) {
            case NetworkConnectivity.Portal:
                return "CAPTIVE PORTAL";
            case NetworkConnectivity.Limited:
                return "LIMITED";
            case NetworkConnectivity.None:
                return "DISCONNECTED";
            case NetworkConnectivity.Full:
                return "CONNECTED";
            case NetworkConnectivity.Unknown:
            default:
                return 'UNKNOWN';   
        }
    }
}
import Quickshell
import Quickshell.Io

import "./base"

// Reads OS data from /etc/os-release
OsModule {
    id: root

    Process {
        id: osProc
        command: ["sh", "-c", ". /etc/os-release && echo $PRETTY_NAME"]
        running: true
        stdout: SplitParser {
            onRead: data => root.osName = data.trim()
        }

        onExited: (code) => {
            root.isSupported = code === 0
        }
    }
}
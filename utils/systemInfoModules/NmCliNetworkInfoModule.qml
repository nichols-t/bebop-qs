import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick
import "./base"

NetworkInfoModule {
    id: root
    
    property var read: () => {
        proc.running = true
    }

    property var info
    property list<var> conns
    systemInfoDetails: {
        const lines = [];
        if (info) {
            for (const stat of Object.keys(info)) {
                lines.push(`${stat}: ${info[stat]}`)
            }
        }
        
        if (conns) {
            for (let i = 0; i < conns.length; i++) {
                const conn = conns[i];
                if (conn.ACTIVE.toLowerCase() === 'yes') {
                    lines.push(`CONNECTION: ${conn.NAME}`);
                    lines.push(`    TYPE: ${conn.TYPE}`);
                    lines.push(`    DEVICE: ${conn.DEVICE}`);
                }
            }
        }

        return lines;
    }



    Process {
        id: overviewProc
        running: true
        command: ["nmcli", "-m", "multiline", "g"]
        stdout: SplitParser {
            id: overviewParser
            property var info
            onRead: data => {
                // First line = col names second = values
                const vals = data.split(' ').filter((v) => !!v);
                const stat = vals[0].split(':')[0];
                const val = vals.slice(1).join(' ');

                if (!info) {
                    info = {}
                }

                info[stat] = val
            }
        }
        onExited: {
            root.info = overviewParser.info
        }
    }

    Process {
        running: true
        command: ["nmcli", "-m", "multiline", "-g", "all", "c"]
        stdout: SplitParser {
            id: connsParser
            property list<var> conns
            onRead: data => {
                const vals = data.split(':').filter((v) => !!v);
                const stat = vals[0].split(':')[0];
                const val = vals.slice(1).join(':');

                if (!conns) {
                    conns = [];
                }

                if (stat === 'NAME') {
                    conns.push({ [stat]: val });
                } else {
                    conns[conns.length - 1][stat] = val
                }
            }
        }
        onExited: {
            root.conns = connsParser.conns
        }
    }
}
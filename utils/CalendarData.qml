pragma Singleton
import Quickshell
import QtQml
import QtQuick
import Quickshell.Io
import "./"

Singleton {
    id: root

    // TODO: We probably should clear stuff on close, but realistically I don't think this will matter
    // very much unless I implement a full calendar search
    function clear() {
    }

    // TODO probably use this for some user feedback or something
    // property bool loaded: false

    property string debug: ''
    property string firstDay: ''
    property string lastDay: ''
    property list<var> dayInfo: []
    onFirstDay: {
        loadCalendarProcess.running = true;
    }
    onLastDay: {
        loadCalendarProcess.running = true;
    }
    property string _data: ''

    // khal import --batch cal.ics
    //curl "<proton ics link>" | khal import --batch

    Process {
        id: loadCalendarProcess
        running: true
        // khal list --json all 2026-07-12 2026-07-12
        command: ["khal", "list", "--json", "all", root.firstDay, root.lastDay]
        stdout: SplitParser {
            onRead: data => {
                const events = JSON.parse(data.trim()).map((e) => e)
                root.dayInfo.push(events);

            }
            //data.trim())
        }
        stderr: SplitParser {
            onRead: data => root.debug += 'fail'
        }
        property bool success: false
        onExited: code => {
            root.debug += ' loaded ' + root.firstDay + '-' + root.lastDay 
        }
    }
}

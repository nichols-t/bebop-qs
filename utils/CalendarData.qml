pragma Singleton
import Quickshell
import QtQml
import Quickshell.Io
import "./"

Singleton {
    id: root

    property bool loaded: false
    
    function eventsOnDay(day: string): list<var> {
        const d = Date.parse(day);
        events.filter((event) => {
            if (sameDay(event.dtstart, d)) {
                return true;
            } else {
                return false;
            }
        });
    }

    // TODO: just use khal, which can import ics just fine
    // Just need to determine how to load the dates properly given that it is bunch of async commands
    // khal at --json all 2026-07-29 12:00 AM
    // khal import --batch cal.ics

    // ^ I think the way is to do a property exposed that controls what dates we look for, and
    // when those change we spawn a new process. This feels a little wrong but will probably work
}

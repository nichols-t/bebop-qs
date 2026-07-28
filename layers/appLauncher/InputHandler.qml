import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick

// Handles events involving arrow keys and input for the app launcher.
// Must provide a function (remember to use () => {} syntax, reactivity makes it ambiguous otherwise
// to onClose that is triggered whenever an app is launched or the launcher should be closed.
WrapperMouseArea {
    id: root
    anchors.fill: parent
    required property var onClose
    onClicked: () => onClose()
    required property string searchText


    function _shiftTargetedApp(index: int) {
        if (candidateApps.length > 0) {
            const currIdx = candidateApps.findIndex(app => app.name === targetedApp?.name);
            const len = candidateApps.length;
            targetedApp = candidateApps[((currIdx + index % len) + len) % len];
        }
    }

    Keys.onPressed: event => {
        // close: Escape
        if (event.key === Qt.Key_Escape) {
            event.accepted = true;
            root.onClose();
        }

        // Key up = go to the previous item in the candidate apps list
        if (event.key === Qt.Key_Down) {
            _shiftTargetedApp(+1);
            event.accepted = true;
        }
        // Key down = go to the next item in the candiate apps list
        if (event.key === Qt.Key_Up) {
            _shiftTargetedApp(-1);
            event.accepted = true;
        }

        // Launch app if there's one selected
        if (event.key === Qt.Key_Return) {
            if (targetedApp) {
                event.accepted = true;
                // TODO: This seems to launch on the other monitor, and not sure why
                targetedApp.execute();
                targetedApp = null;
                root.onClose();
            }
        }
    }

    property list<DesktopEntry> candidateApps: DesktopEntries.applications.values.filter(entry => {
        // Start with all entries
        // TODO rofi algorithm is https://github.com/davatorium/rofi/blob/a6afacb8cec27b51606b59e0571f33fa9007fc70/source/helper.c#L1045
        // idk if the Quickshell heuristicLookup is comparable or not
        if (!searchText) {
            return true;
        }

        const appNameMatches = entry.name.toLowerCase().includes(searchText.toLowerCase());
        const appKeywordsMatch = -1 < entry.keywords.findIndex(keyword => keyword.toLowerCase().includes(searchText.toLowerCase()));

        return appNameMatches || appKeywordsMatch;
    })

    onCandidateAppsChanged: {
        if (candidateApps.length > 0) {
            targetedApp = candidateApps[0];
        } else {
            // This means no search matched, so clear the selected entry
            targetedApp = null;
        }
    }

    property DesktopEntry targetedApp
}

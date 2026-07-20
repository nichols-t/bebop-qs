// Time.qml
pragma Singleton

import Quickshell
import QtQuick
// We use a singleton here to ensure consistency and save memory (I think)
Singleton {
  id: root
  // an expression can be broken across multiple lines using {}
  readonly property string time: {
    // The passed format string matches the default output of
    // the `date` command.
    Qt.formatDateTime(clock.date, "ddd MMM d hh:mm AP t yyyy")
  }

  readonly property var clock: SystemClock {
    id: clock
    // Minutes bc I'm not bothering to display seconds
    precision: SystemClock.Minutes
  }
}
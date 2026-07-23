// Time.qml
pragma Singleton

import Quickshell
import QtQuick
// We use a singleton here to ensure consistency and save memory (I think)
Singleton {
  id: root
  readonly property string time: clock.date

  readonly property var clock: SystemClock {
    id: clock
    // Minutes bc I'm not bothering to display seconds
    precision: SystemClock.Minutes
  }
}
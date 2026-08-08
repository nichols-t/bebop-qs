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

  function toHH_MM_SS(seconds): string {
    const h = Math.floor(seconds / 3600);
    seconds -= h * 3600;
    const m = Math.floor(seconds / 60);
    seconds -= m * 60;
    const s = Math.floor(seconds);

    const hh = h.toString().padStart(2, '0');
    const mm = m.toString().padStart(2, '0');
    const ss = s.toString().padStart(2, '0');

    let str = `${mm}:${ss}`;

    if (h > 0) {
      str = `${hh}:${str}`;
    }

    return str;
  }
}
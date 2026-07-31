pragma Singleton
import Quickshell

Singleton {
    readonly property list<DesktopEntry> entries: Array.from(DesktopEntries.applications.values)
        .sort((e1, e2) => e1.name.localeCompare(e2.name))

    // TODO: look at why the space here is needed
    readonly property var preppedNames: entries.map((entry) => ({
        name: FuzzySort.prepare(`${entry.name} `),
        entry: entry
    }))

    function fuzzySearch(text: string): var {
        return FuzzySort
            .search(text, preppedNames, { all: true, key: "name" })
            .map((searchResult) => searchResult.obj.entry);
    }

    // TODO: Linux Antiquity also has a way of getting icons, but I am not sure
    // if I plan to use icons. I may apply a shader to them. TBD
}
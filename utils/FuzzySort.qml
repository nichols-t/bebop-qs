pragma Singleton
import Quickshell
import "./fuzzysort.js" as FuzzySortJS

Singleton {
    function search(...args) {
        return FuzzySortJS.go(...args);
    }

    function prepare(...args) {
        return FuzzySortJS.prepare(...args);
    }
}
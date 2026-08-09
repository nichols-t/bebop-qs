import Quickshell

Scope {
    /**
    * Determine whether or not this module is supported by this machine.
    * May need to run some commands to figure this out
    */
    property bool isSupported: false
    /**
    * Run processes that this module needs to refresh its information
    */
    property var run: () => {}
}
import Quickshell

// TODO: I want these to be required but it complains at me for some reason
// I think it should work the way I want if I inherit this and set them?
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
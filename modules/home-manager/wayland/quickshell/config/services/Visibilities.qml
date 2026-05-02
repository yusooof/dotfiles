pragma Singleton
import QtQuick
import Quickshell

// One bool per togglable panel. Bar widgets read these; shortcuts flip them.
Singleton {
    property bool launcher: false
    property bool cheatsheet: false
    property bool powerMenu: false
    property bool clipboard: false
    property bool emoji: false
    property bool screenshot: false
    property bool colorPicker: false
    property bool overview: false
    property bool sidebar: false
    property bool bluetooth: false

    function closeAll() {
        launcher = false
        cheatsheet = false
        powerMenu = false
        clipboard = false
        emoji = false
        screenshot = false
        colorPicker = false
        overview = false
        sidebar = false
        bluetooth = false
    }

    function toggle(name) {
        const cur = this[name]
        this.closeAll()
        this[name] = !cur
    }
}

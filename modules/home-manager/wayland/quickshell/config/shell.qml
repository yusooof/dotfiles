//@ pragma Env QS_NO_RELOAD_POPUP=1
import Quickshell
import "shortcuts"
import "bar"
import "panels"

ShellRoot {
    settings.watchFiles: true

    Shortcuts {}

    Variants {
        model: Quickshell.screens
        delegate: Bar {
            required property var modelData
            screen: modelData
        }
    }

    Launcher {}
    Cheatsheet {}
    PowerMenu {}
    Clipboard {}
    Emoji {}
    Screenshot {}
    ColorPicker {}
    Overview {}
    Sidebar {}
    Bluetooth {}
    Notifications {}
    Osd {}
}

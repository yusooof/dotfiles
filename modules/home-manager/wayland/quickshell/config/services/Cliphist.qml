pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Wraps `cliphist` (already running via hyprland exec-once). Refreshes the
// list each time the picker opens, then exposes `entries` to the UI.
Singleton {
    id: root

    // Each entry = { id: "12345", preview: "the contents…" }
    property var entries: []

    function refresh() {
        listProc.running = false
        listProc.running = true
    }

    function paste(id) {
        decodeProc.command = ["sh", "-c", `cliphist decode ${id} | wl-copy`]
        decodeProc.running = false
        decodeProc.running = true
    }

    function remove(id) {
        rmProc.command = ["sh", "-c", `cliphist decode ${id} | cliphist delete`]
        rmProc.running = false
        rmProc.running = true
    }

    Process {
        id: listProc
        command: ["cliphist", "list"]
        stdout: StdioCollector {
            onStreamFinished: {
                const out = []
                const lines = String(this.text).split("\n")
                for (const ln of lines) {
                    if (!ln) continue
                    const tab = ln.indexOf("\t")
                    if (tab < 0) continue
                    out.push({
                        id: ln.slice(0, tab),
                        preview: ln.slice(tab + 1),
                    })
                }
                root.entries = out
            }
        }
    }

    Process { id: decodeProc }
    Process {
        id: rmProc
        onExited: root.refresh()
    }
}

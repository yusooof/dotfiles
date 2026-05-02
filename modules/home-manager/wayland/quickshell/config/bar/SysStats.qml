import QtQuick
import Quickshell.Io
import "../services" as S

// Polls /proc/stat + /proc/meminfo every 2s. Lightweight enough for a bar.
Row {
    id: root
    spacing: 8
    property real cpu: 0
    property real ram: 0

    // Track previous CPU sample to compute delta.
    property var _prev: null

    Process {
        id: cpuProc
        command: ["sh", "-c", "head -n1 /proc/stat; awk '/MemTotal|MemAvailable/ {print $2}' /proc/meminfo"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = String(this.text).trim().split("\n")
                if (lines.length < 3) return
                const parts = lines[0].split(/\s+/).slice(1).map(Number)
                const idle = parts[3] + parts[4]
                const total = parts.reduce((a, b) => a + b, 0)
                if (root._prev) {
                    const dT = total - root._prev.total
                    const dI = idle - root._prev.idle
                    if (dT > 0) root.cpu = (1 - dI / dT)
                }
                root._prev = { total, idle }
                const memTotal = parseInt(lines[1])
                const memAvail = parseInt(lines[2])
                if (memTotal > 0) root.ram = 1 - memAvail / memTotal
            }
        }
    }
    Timer { running: true; repeat: true; interval: 2000; triggeredOnStart: true; onTriggered: { cpuProc.running = false; cpuProc.running = true } }

    Text {
        text: "CPU " + Math.round(root.cpu * 100) + "%"
        color: root.cpu > 0.85 ? S.Theme.warn : S.Theme.fgDim
        font.family: S.Theme.fontFamily
        font.pixelSize: S.Theme.fontSizeSm
    }
    Text {
        text: "RAM " + Math.round(root.ram * 100) + "%"
        color: root.ram > 0.9 ? S.Theme.warn : S.Theme.fgDim
        font.family: S.Theme.fontFamily
        font.pixelSize: S.Theme.fontSizeSm
    }
}

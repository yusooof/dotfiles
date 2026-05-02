pragma Singleton
import QtQuick
import Quickshell

// Static list of keybinds, surfaced via the cheatsheet (Super+/).
// Keep in sync with modules/home-manager/wayland/hyprland.nix `bind`.
Singleton {
    readonly property var groups: [
        {
            name: "Launchers & shell",
            binds: [
                { keys: "Super R",         desc: "App launcher" },
                { keys: "Super /",         desc: "This cheatsheet" },
                { keys: "Super Escape",    desc: "Power menu" },
                { keys: "Super Tab",       desc: "Workspace overview" },
                { keys: "Super A",         desc: "Control center / sidebar" },
                { keys: "Super V",         desc: "Clipboard history" },
                { keys: "Super .",         desc: "Emoji picker" },
                { keys: "Super B",         desc: "Bluetooth picker" },
                { keys: "Super Shift S",   desc: "Screenshot menu" },
                { keys: "Super Shift C",   desc: "Color picker" },
            ],
        },
        {
            name: "Apps",
            binds: [
                { keys: "Super Return", desc: "Terminal (foot)" },
                { keys: "Super E",      desc: "File manager" },
                { keys: "Super Shift B",desc: "Browser" },
                { keys: "Super L",      desc: "Lock screen" },
            ],
        },
        {
            name: "Window",
            binds: [
                { keys: "Super Q",          desc: "Close window" },
                { keys: "Super F",          desc: "Toggle fullscreen" },
                { keys: "Super Space",      desc: "Toggle floating" },
                { keys: "Super P",          desc: "Pseudo-tile" },
                { keys: "Super J",          desc: "Toggle split" },
                { keys: "Super H/J/K/L",    desc: "Focus left/down/up/right" },
                { keys: "Super Shift H/J/K/L", desc: "Move window" },
                { keys: "Super LMB",        desc: "Drag window" },
                { keys: "Super RMB",        desc: "Resize window" },
            ],
        },
        {
            name: "Workspaces",
            binds: [
                { keys: "Super 1-9",         desc: "Switch workspace" },
                { keys: "Super Shift 1-9",   desc: "Move window to workspace" },
                { keys: "Super Scroll",      desc: "Cycle workspaces" },
            ],
        },
        {
            name: "System",
            binds: [
                { keys: "Super Shift E",        desc: "Exit Hyprland" },
                { keys: "Vol/Brightness keys",  desc: "Adjust volume / brightness" },
                { keys: "Media keys",           desc: "Play / pause / next / prev" },
            ],
        },
    ]
}

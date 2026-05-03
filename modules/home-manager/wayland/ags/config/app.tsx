import { createBinding, For, This } from "ags"
import GLib from "gi://GLib"
import app from "ags/gtk4/app"
import style from "./style.scss"
import Bar from "./widget/Bar"
import Clipboard from "./widget/Clipboard"
import EmojiPicker from "./widget/EmojiPicker"
import Launcher from "./widget/Launcher"
import Settings from "./widget/Settings"
import { NotificationCenter, NotificationToasts } from "./widget/Notifications"

app.start({
  css: style,
  gtkTheme: "Adwaita-dark",

  requestHandler(argv, res) {
    const parts = argv.join(" ").trim().split(/\s+/)
    const [cmd, ...args] = parts

    if (cmd === "toggle" && args[0]) {
      const win = app.get_window(args[0])
      if (win) {
        win.visible = !win.visible
        return res("ok")
      }
      return res(`no window: ${args[0]}`)
    }

    res("unknown command")
  },

  main() {
    GLib.chdir(GLib.getenv("HOME") || "/")
    const monitors = createBinding(app, "monitors")

    Launcher()
    Clipboard()
    EmojiPicker()
    Settings()
    NotificationCenter()
    NotificationToasts()

    return (
      <For each={monitors}>
        {(monitor) => (
          <This this={app}>
            <Bar gdkmonitor={monitor} />
          </This>
        )}
      </For>
    )
  },
})

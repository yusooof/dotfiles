import { createBinding, For, This } from "ags"
import app from "ags/gtk4/app"
import style from "./style.scss"
import Bar from "./widget/Bar"
import Clipboard from "./widget/Clipboard"
import EmojiPicker from "./widget/EmojiPicker"
import Screenshot from "./widget/Screenshot"

app.start({
  css: style,
  gtkTheme: "Adwaita-dark",

  requestHandler(request, res) {
    const parts = request.trim().split(/\s+/)
    const [cmd, ...args] = parts

    if (cmd === "toggle" && args[0]) {
      const win = app.get_window(args[0])
      if (win) {
        win.visible = !win.visible
        return res("ok")
      }
      return res(`no window: ${args[0]}`)
    }

    if (cmd === "show" && args[0]) {
      const win = app.get_window(args[0])
      if (win) {
        win.visible = true
        return res("ok")
      }
      return res(`no window: ${args[0]}`)
    }

    if (cmd === "hide" && args[0]) {
      const win = app.get_window(args[0])
      if (win) {
        win.visible = false
        return res("ok")
      }
      return res(`no window: ${args[0]}`)
    }

    res("unknown command")
  },

  main() {
    const monitors = createBinding(app, "monitors")

    Clipboard()
    EmojiPicker()
    Screenshot()

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

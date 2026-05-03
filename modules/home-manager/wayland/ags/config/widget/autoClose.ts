import Astal from "gi://Astal?version=4.0"
import app from "ags/gtk4/app"
import Gtk from "gi://Gtk?version=4.0"
import Gdk from "gi://Gdk?version=4.0"

export function closeOnUnfocus(win: Astal.Window) {
  const keyCtrl = new Gtk.EventControllerKey()
  keyCtrl.connect("key-pressed", (_ctrl: Gtk.EventControllerKey, keyval: number) => {
    if (keyval === Gdk.KEY_Escape) {
      win.visible = false
      return true
    }
    return false
  })
  win.add_controller(keyCtrl)

  const focusCtrl = new Gtk.EventControllerFocus()
  focusCtrl.connect("leave", () => {
    if (win.visible) {
      win.visible = false
    }
  })
  win.add_controller(focusCtrl)

  // Close when another window is toggled open
  app.connect("window-toggled", (_, w) => {
    if (w !== win && w.visible && win.visible) {
      win.visible = false
    }
  })
}

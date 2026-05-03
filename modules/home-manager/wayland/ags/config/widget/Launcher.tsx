import app from "ags/gtk4/app"
import Astal from "gi://Astal?version=4.0"
import Gtk from "gi://Gtk?version=4.0"
import AstalApps from "gi://AstalApps"
import { createState, For, onCleanup } from "ags"
import { closeOnUnfocus } from "./autoClose"

export default function Launcher() {
  let win: Astal.Window
  let entry: Gtk.Entry
  const apps = new AstalApps.Apps()
  const [query, setQuery] = createState("")

  const results = query((q) => {
    const needle = q.trim()
    const list = needle.length === 0 ? apps.get_list() : apps.fuzzy_query(needle)
    return list.slice(0, 30)
  })

  const close = () => {
    if (win) win.visible = false
  }

  const launch = (a: AstalApps.Application) => {
    close()
    a.launch()
  }

  onCleanup(() => win?.destroy())

  return (
    <window
      $={(self) => {
        win = self
        closeOnUnfocus(self)
        self.connect("notify::visible", () => {
          if (self.visible) {
            setQuery("")
            entry?.set_text("")
            entry?.grab_focus()
          }
        })
      }}
      name="launcher"
      namespace="ags-launcher"
      visible={false}
      keymode={Astal.Keymode.ON_DEMAND}
      anchor={Astal.WindowAnchor.TOP}
      marginTop={56}
      application={app}
      class="Popup Launcher"
    >
      <box
        orientation={Gtk.Orientation.VERTICAL}
        widthRequest={520}
        cssClasses={["PopupInner"]}
      >
        <box class="PopupHeader" spacing={8}>
          <image iconName="system-search-symbolic" />
          <entry
            $={(self) => (entry = self)}
            hexpand
            placeholderText="Search applications…"
            onNotifyText={(self) => setQuery(self.text)}
            onActivate={() => {
              const list = results.get()
              if (list.length > 0) launch(list[0])
            }}
          />
        </box>
        <Gtk.ScrolledWindow
          vexpand
          heightRequest={420}
          hscrollbarPolicy={Gtk.PolicyType.NEVER}
        >
          <box orientation={Gtk.Orientation.VERTICAL} spacing={2}>
            <For each={results}>
              {(item) => (
                <button
                  class="LauncherItem"
                  onClicked={() => launch(item)}
                >
                  <box spacing={12}>
                    <image iconName={item.iconName ?? "application-x-executable"} pixelSize={28} />
                    <box orientation={Gtk.Orientation.VERTICAL} hexpand valign={Gtk.Align.CENTER}>
                      <label xalign={0} label={item.name} />
                      <label
                        xalign={0}
                        class="dim"
                        maxWidthChars={60}
                        ellipsize={3}
                        label={item.description ?? ""}
                        visible={!!item.description}
                      />
                    </box>
                  </box>
                </button>
              )}
            </For>
          </box>
        </Gtk.ScrolledWindow>
      </box>
    </window>
  )
}

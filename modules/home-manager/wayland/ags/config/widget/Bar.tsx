import app from "ags/gtk4/app"
import GLib from "gi://GLib"
import Astal from "gi://Astal?version=4.0"
import Gtk from "gi://Gtk?version=4.0"
import Gdk from "gi://Gdk?version=4.0"
import AstalHyprland from "gi://AstalHyprland"
import AstalWp from "gi://AstalWp"
import AstalNetwork from "gi://AstalNetwork"
import AstalTray from "gi://AstalTray"
import AstalMpris from "gi://AstalMpris"
import AstalApps from "gi://AstalApps"
import { For, With, createBinding, onCleanup } from "ags"
import { createPoll } from "ags/time"
import { execAsync } from "ags/process"

function Workspaces() {
  const hypr = AstalHyprland.get_default()
  const workspaces = createBinding(hypr, "workspaces")
  const focused = createBinding(hypr, "focusedWorkspace")

  const sorted = (ws: Array<AstalHyprland.Workspace>) =>
    ws.filter((w) => w.id > 0).sort((a, b) => a.id - b.id)

  return (
    <box class="Workspaces" spacing={4}>
      <For each={workspaces(sorted)}>
        {(ws) => (
          <button
            class={focused((f) => (f?.id === ws.id ? "active" : ""))}
            onClicked={() => ws.focus()}
            tooltipText={`Workspace ${ws.id}`}
          >
            <label label={`${ws.id}`} />
          </button>
        )}
      </For>
    </box>
  )
}

function ActiveWindow() {
  const hypr = AstalHyprland.get_default()
  const focused = createBinding(hypr, "focusedClient")

  return (
    <box class="ActiveWindow">
      <With value={focused}>
        {(client) =>
          client && (
            <label
              maxWidthChars={50}
              ellipsize={3}
              label={createBinding(client, "title")}
            />
          )
        }
      </With>
    </box>
  )
}

function Clock() {
  const time = createPoll("", 1000, () =>
    GLib.DateTime.new_now_local().format("%a %b %-d  %H:%M")!
  )

  return (
    <menubutton class="Clock">
      <label label={time} />
      <popover>
        <Gtk.Calendar />
      </popover>
    </menubutton>
  )
}

function Mpris() {
  const mpris = AstalMpris.get_default()
  const apps = new AstalApps.Apps()
  const players = createBinding(mpris, "players")

  return (
    <menubutton class="Mpris" visible={players((p) => p.length > 0)}>
      <box spacing={6}>
        <For each={players}>
          {(player) => {
            const [a] = apps.exact_query(player.entry)
            return <image iconName={a?.iconName ?? "audio-x-generic-symbolic"} />
          }}
        </For>
      </box>
      <popover>
        <box spacing={4} orientation={Gtk.Orientation.VERTICAL}>
          <For each={players}>
            {(player) => (
              <box spacing={8} widthRequest={280}>
                <box overflow={Gtk.Overflow.HIDDEN} css="border-radius: 8px;">
                  <image
                    pixelSize={56}
                    file={createBinding(player, "coverArt")}
                  />
                </box>
                <box
                  valign={Gtk.Align.CENTER}
                  orientation={Gtk.Orientation.VERTICAL}
                  hexpand
                >
                  <label
                    xalign={0}
                    maxWidthChars={20}
                    ellipsize={3}
                    label={createBinding(player, "title")}
                  />
                  <label
                    xalign={0}
                    class="dim"
                    maxWidthChars={20}
                    ellipsize={3}
                    label={createBinding(player, "artist")}
                  />
                </box>
                <box halign={Gtk.Align.END}>
                  <button
                    onClicked={() => player.previous()}
                    visible={createBinding(player, "canGoPrevious")}
                  >
                    <image iconName="media-skip-backward-symbolic" />
                  </button>
                  <button
                    onClicked={() => player.play_pause()}
                    visible={createBinding(player, "canControl")}
                  >
                    <image
                      iconName={createBinding(
                        player,
                        "playbackStatus",
                      )((s) =>
                        s === AstalMpris.PlaybackStatus.PLAYING
                          ? "media-playback-pause-symbolic"
                          : "media-playback-start-symbolic",
                      )}
                    />
                  </button>
                  <button
                    onClicked={() => player.next()}
                    visible={createBinding(player, "canGoNext")}
                  >
                    <image iconName="media-skip-forward-symbolic" />
                  </button>
                </box>
              </box>
            )}
          </For>
        </box>
      </popover>
    </menubutton>
  )
}

function Tray() {
  const tray = AstalTray.get_default()
  const items = createBinding(tray, "items")

  const init = (btn: Gtk.MenuButton, item: AstalTray.TrayItem) => {
    btn.menuModel = item.menuModel
    btn.insert_action_group("dbusmenu", item.actionGroup)
    item.connect("notify::action-group", () => {
      btn.insert_action_group("dbusmenu", item.actionGroup)
    })
  }

  return (
    <box class="Tray" spacing={2}>
      <For each={items}>
        {(item) => (
          <menubutton $={(self) => init(self, item)}>
            <image gicon={createBinding(item, "gicon")} />
          </menubutton>
        )}
      </For>
    </box>
  )
}

function Wireless() {
  const network = AstalNetwork.get_default()
  const wifi = createBinding(network, "wifi")

  const sorted = (arr: Array<AstalNetwork.AccessPoint>) =>
    arr.filter((ap) => !!ap.ssid).sort((a, b) => b.strength - a.strength)

  async function connect(ap: AstalNetwork.AccessPoint) {
    try {
      await execAsync(`nmcli d wifi connect ${ap.bssid}`)
    } catch (error) {
      console.error(error)
    }
  }

  return (
    <box class="Network" visible={wifi(Boolean)}>
      <With value={wifi}>
        {(w) =>
          w && (
            <menubutton>
              <image iconName={createBinding(w, "iconName")} />
              <popover>
                <box orientation={Gtk.Orientation.VERTICAL} widthRequest={240}>
                  <For each={createBinding(w, "accessPoints")(sorted)}>
                    {(ap: AstalNetwork.AccessPoint) => (
                      <button onClicked={() => connect(ap)}>
                        <box spacing={6}>
                          <image iconName={createBinding(ap, "iconName")} />
                          <label
                            xalign={0}
                            hexpand
                            label={createBinding(ap, "ssid")}
                          />
                          <image
                            iconName="object-select-symbolic"
                            visible={createBinding(
                              w,
                              "activeAccessPoint",
                            )((active) => active === ap)}
                          />
                        </box>
                      </button>
                    )}
                  </For>
                </box>
              </popover>
            </menubutton>
          )
        }
      </With>
    </box>
  )
}

function AudioOutput() {
  const wp = AstalWp.get_default()
  if (!wp) return <box />
  const speaker = wp.defaultSpeaker

  return (
    <menubutton class="Volume">
      <image iconName={createBinding(speaker, "volumeIcon")} />
      <popover>
        <box widthRequest={240} spacing={6}>
          <button onClicked={() => speaker.set_mute(!speaker.mute)}>
            <image iconName={createBinding(speaker, "volumeIcon")} />
          </button>
          <slider
            hexpand
            onChangeValue={({ value }) => speaker.set_volume(value)}
            value={createBinding(speaker, "volume")}
          />
        </box>
      </popover>
    </menubutton>
  )
}

function QuickActions() {
  return (
    <box class="QuickActions" spacing={2}>
      <button
        tooltipText="Clipboard (Super+V)"
        onClicked={() => {
          const w = app.get_window("clipboard")
          if (w) w.visible = !w.visible
        }}
      >
        <image iconName="edit-paste-symbolic" />
      </button>
      <button
        tooltipText="Emoji (Super+.)"
        onClicked={() => {
          const w = app.get_window("emoji")
          if (w) w.visible = !w.visible
        }}
      >
        <image iconName="face-smile-symbolic" />
      </button>
      <button
        tooltipText="Screenshot (Shift+Super+S)"
        onClicked={() => {
          const w = app.get_window("screenshot")
          if (w) w.visible = !w.visible
        }}
      >
        <image iconName="camera-photo-symbolic" />
      </button>
    </box>
  )
}

export default function Bar({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
  let win: Astal.Window
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

  onCleanup(() => win?.destroy())

  return (
    <window
      $={(self) => (win = self)}
      visible
      name={`bar-${gdkmonitor.connector}`}
      namespace="ags-bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      application={app}
      class="Bar"
    >
      <centerbox cssClasses={["BarInner"]}>
        <box $type="start" spacing={6}>
          <Workspaces />
          <ActiveWindow />
        </box>

        <box $type="center" spacing={8}>
          <Clock />
          <Mpris />
        </box>

        <box $type="end" spacing={4}>
          <QuickActions />
          <Tray />
          <Wireless />
          <AudioOutput />
        </box>
      </centerbox>
    </window>
  )
}

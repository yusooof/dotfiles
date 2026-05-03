import app from "ags/gtk4/app"
import GLib from "gi://GLib"
import Astal from "gi://Astal?version=4.0"
import Gtk from "gi://Gtk?version=4.0"
import Gdk from "gi://Gdk?version=4.0"
import AstalHyprland from "gi://AstalHyprland"
import AstalTray from "gi://AstalTray"
import AstalNotifd from "gi://AstalNotifd"
import AstalMpris from "gi://AstalMpris"
import { For, createBinding, onCleanup } from "ags"
import { createPoll } from "ags/time"

const MONITOR_WORKSPACES: Record<string, number[]> = {
  "DP-3": [1, 2, 3, 4, 5],
  "DP-1": [6],
}

function Workspaces({ connector }: { connector: string }) {
  const hypr = AstalHyprland.get_default()
  const ids = MONITOR_WORKSPACES[connector] ?? [1, 2, 3, 4, 5]
  const workspaces = createBinding(hypr, "workspaces")
  const focused = createBinding(hypr, "focusedWorkspace")

  const attachScroll = (self: Gtk.Widget) => {
    const ctrl = new Gtk.EventControllerScroll({
      flags: Gtk.EventControllerScrollFlags.VERTICAL,
    })
    ctrl.connect("scroll", (_c, _dx, dy) => {
      hypr.dispatch("workspace", dy > 0 ? "e+1" : "e-1")
      return true
    })
    self.add_controller(ctrl)
  }

  return (
    <box class="Workspaces" spacing={6} $={attachScroll}>
      {ids.map((id) => (
        <button
          class={focused((f) => (f?.id === id ? "ws active" : "ws"))}
          visible={workspaces((all) => {
            const ws = all.find((w) => w.id === id)
            return ws !== undefined
          })}
          onClicked={() => hypr.dispatch("workspace", String(id))}
          tooltipText={`Workspace ${id}`}
          canFocus={false}
        >
          <box class="pill" />
        </button>
      ))}
    </box>
  )
}

function Clock() {
  const time = createPoll("", 1000, () =>
    GLib.DateTime.new_now_local().format("%-I:%M %p")!,
  )
  const date = createPoll("", 30_000, () =>
    GLib.DateTime.new_now_local().format("%a %b %-d")!,
  )
  const notifd = AstalNotifd.get_default()
  
  return (
    <button
      class="Clock"
      tooltipText="Notifications · Calendar"
      valign={Gtk.Align.CENTER}
      onClicked={() => {
        const w = app.get_window("notification-center")
        if (w) w.visible = !w.visible
      }}
    >
      <box
        spacing={8}
        valign={Gtk.Align.CENTER}
        halign={Gtk.Align.CENTER}
        baselinePosition={Gtk.BaselinePosition.CENTER}
      >
        <label
          class="dim"
          valign={Gtk.Align.BASELINE_FILL}
          label={date}
        />
        <label
          class="time"
          valign={Gtk.Align.BASELINE_FILL}
          label={time}
        />
        <image
          iconName={createBinding(notifd, "dontDisturb").as(dnd => 
            dnd ? "notifications-disabled-symbolic" : "preferences-system-notifications-symbolic"
          )}
          valign={Gtk.Align.CENTER}
          cssClasses={createBinding(notifd, "notifications").as(n => n.length > 0 && !notifd.dontDisturb ? ["active"] : [])}
        />
      </box>
    </button>
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

function SettingsButton() {
  return (
    <button
      class="SettingsButton"
      tooltipText="Settings (Super+S)"
      valign={Gtk.Align.CENTER}
      onClicked={() => {
        const w = app.get_window("settings")
        if (w) w.visible = !w.visible
      }}
    >
      <image
        iconName="open-menu-symbolic"
        valign={Gtk.Align.CENTER}
        halign={Gtk.Align.CENTER}
      />
    </button>
  )
}

function MediaCenter() {
  const mpris = AstalMpris.get_default()
  const players = createBinding(mpris, "players")

  return (
    <box class="MediaCenter" spacing={10}>
      <For each={players}>
        {(player) => (
          <box 
            visible={createBinding(player, "playbackStatus").as(s => s === AstalMpris.PlaybackStatus.PLAYING)}
            spacing={8}
          >
            <box
              class="cover"
              valign={Gtk.Align.CENTER}
              css={createBinding(player, "coverArt").as(art => 
                art ? `background-image: url('${art}'); background-size: cover; background-position: center; min-width: 28px; min-height: 28px; border-radius: 6px;` 
                    : `background-color: rgba(255,255,255,0.05); min-width: 28px; min-height: 28px; border-radius: 6px;`
              )}
            />
            <box orientation={Gtk.Orientation.VERTICAL} valign={Gtk.Align.CENTER} spacing={0}>
              <label
                class="title"
                ellipsize={3}
                maxWidthChars={30}
                xalign={0}
                css="font-weight: 600; font-size: 13px;"
                label={createBinding(player, "title").as(t => t || "Unknown")}
              />
              <label
                class="artist dim"
                ellipsize={3}
                maxWidthChars={30}
                xalign={0}
                css="font-size: 11px;"
                label={createBinding(player, "artist").as(t => t || "")}
                visible={createBinding(player, "artist").as(t => !!t)}
              />
            </box>
          </box>
        )}
      </For>
    </box>
  )
}

export default function Bar({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
  let win: Astal.Window
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor
  const mpris = AstalMpris.get_default()
  const isPlaying = createPoll(false, 1000, () => {
    return mpris.get_players().some(p => p.playbackStatus === AstalMpris.PlaybackStatus.PLAYING)
  })

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
        <box $type="start" spacing={8}>
          <Workspaces connector={gdkmonitor.connector} />
          <box visible={isPlaying}>
            <Clock />
          </box>
        </box>

        <box $type="center">
          <box visible={isPlaying((p) => !p)}>
            <Clock />
          </box>
          <box visible={isPlaying}>
            <MediaCenter />
          </box>
        </box>

        <box $type="end" spacing={6}>
          <Tray />
          <SettingsButton />
        </box>
      </centerbox>
    </window>
  )
}

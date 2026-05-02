import app from "ags/gtk4/app"
import Astal from "gi://Astal?version=4.0"
import Gtk from "gi://Gtk?version=4.0"
import { onCleanup } from "ags"
import { execAsync } from "ags/process"
import GLib from "gi://GLib"

const SCREENSHOT_DIR = `${GLib.get_home_dir()}/Pictures/Screenshots`

function timestamp() {
  return GLib.DateTime.new_now_local().format("%Y-%m-%d_%H-%M-%S")
}

async function ensureDir() {
  await execAsync(["mkdir", "-p", SCREENSHOT_DIR])
}

async function notify(summary: string, body: string, file?: string) {
  const args = ["notify-send", "-a", "Screenshot", summary, body]
  if (file) {
    args.push("-i", file)
  }
  try {
    await execAsync(args)
  } catch {
    /* notify-send may not be available */
  }
}

async function shotRegion() {
  await ensureDir()
  const path = `${SCREENSHOT_DIR}/region_${timestamp()}.png`
  try {
    await execAsync([
      "sh",
      "-c",
      `grim -g "$(slurp -d)" "${path}" && wl-copy < "${path}"`,
    ])
    await notify("Region captured", path, path)
  } catch (e) {
    console.error(e)
  }
}

async function shotWindow() {
  await ensureDir()
  const path = `${SCREENSHOT_DIR}/window_${timestamp()}.png`
  try {
    await execAsync([
      "sh",
      "-c",
      `geom=$(hyprctl activewindow -j | jq -r '"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])"') && grim -g "$geom" "${path}" && wl-copy < "${path}"`,
    ])
    await notify("Window captured", path, path)
  } catch (e) {
    console.error(e)
  }
}

async function shotFull() {
  await ensureDir()
  const path = `${SCREENSHOT_DIR}/full_${timestamp()}.png`
  try {
    await execAsync(["sh", "-c", `grim "${path}" && wl-copy < "${path}"`])
    await notify("Screen captured", path, path)
  } catch (e) {
    console.error(e)
  }
}

async function editRegion() {
  try {
    await execAsync(["sh", "-c", `grim -g "$(slurp -d)" - | swappy -f -`])
  } catch (e) {
    console.error(e)
  }
}

export default function Screenshot() {
  let win: Astal.Window
  const close = () => {
    if (win) win.visible = false
  }

  const launch = (fn: () => Promise<void>) => async () => {
    close()
    await fn()
  }

  onCleanup(() => win?.destroy())

  return (
    <window
      $={(self) => (win = self)}
      name="screenshot"
      namespace="ags-screenshot"
      visible={false}
      keymode={Astal.Keymode.ON_DEMAND}
      anchor={Astal.WindowAnchor.TOP}
      marginTop={48}
      application={app}
      class="Popup Screenshot"
    >
      <box
        orientation={Gtk.Orientation.VERTICAL}
        widthRequest={420}
        cssClasses={["PopupInner"]}
      >
        <box class="PopupHeader" spacing={8}>
          <image iconName="camera-photo-symbolic" />
          <label hexpand xalign={0} label="Take a screenshot" />
          <button onClicked={close} tooltipText="Close">
            <image iconName="window-close-symbolic" />
          </button>
        </box>

        <box class="ShotGrid" orientation={Gtk.Orientation.VERTICAL} spacing={6}>
          <button class="ShotItem" onClicked={launch(shotRegion)}>
            <box spacing={12}>
              <image iconName="select-rectangular-symbolic" pixelSize={28} />
              <box orientation={Gtk.Orientation.VERTICAL} hexpand>
                <label xalign={0} label="Region" />
                <label xalign={0} class="dim" label="Select an area, save & copy" />
              </box>
            </box>
          </button>

          <button class="ShotItem" onClicked={launch(shotWindow)}>
            <box spacing={12}>
              <image iconName="window-symbolic" pixelSize={28} />
              <box orientation={Gtk.Orientation.VERTICAL} hexpand>
                <label xalign={0} label="Active window" />
                <label xalign={0} class="dim" label="Capture focused window" />
              </box>
            </box>
          </button>

          <button class="ShotItem" onClicked={launch(shotFull)}>
            <box spacing={12}>
              <image iconName="video-display-symbolic" pixelSize={28} />
              <box orientation={Gtk.Orientation.VERTICAL} hexpand>
                <label xalign={0} label="Full screen" />
                <label xalign={0} class="dim" label="Capture the whole display" />
              </box>
            </box>
          </button>

          <button class="ShotItem" onClicked={launch(editRegion)}>
            <box spacing={12}>
              <image iconName="document-edit-symbolic" pixelSize={28} />
              <box orientation={Gtk.Orientation.VERTICAL} hexpand>
                <label xalign={0} label="Region → Editor" />
                <label xalign={0} class="dim" label="Open in swappy after select" />
              </box>
            </box>
          </button>
        </box>
      </box>
    </window>
  )
}

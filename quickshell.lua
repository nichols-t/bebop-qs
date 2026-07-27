-- qs -p shell.qml ipc --any-display call shutdownMenu showShutdownMenu

-- hyprctl -j monitors | jq '.[] | select(.focused == true) | .name'
hl.bind(
    "SUPER + CTRL + Q",
    -- Note here that we have to do this jq stuff because the IPC is per-monitor
    -- which is kinda awkward. Consequence of variants; there is probably a better
    -- way to do that but going to leave it for now
    hl.dsp.exec_cmd("qs ipc call root showShutdownMenu")
)

hl.bind(
  "SUPER + SPACE",
  hl.dsp.exec_cmd("qs ipc call root showAppLauncher")
)


hl.layer_rule({
  match = {
    class = "shutdownMenu"
  },
  animation = "fade"
})

-- NEED TO:
-- ln -s ~/.config/quickshell/quickshell.lua ~/.config/hypr/quickshell.lua
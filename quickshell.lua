-- NEED TO:
-- ln -s ~/.config/quickshell/quickshell.lua ~/.config/hypr/quickshell.lua
-- and then require it from your hyprland config

-- Keybind for the shutdown/power menu
hl.bind(
    "SUPER + CTRL + Q",
    hl.dsp.exec_cmd("qs ipc call root showShutdownMenu")
)

-- Keybind for the app launcher
hl.bind(
  "SUPER + SPACE",
  hl.dsp.exec_cmd("qs ipc call root showAppLauncher")
)

-- Animation rule for the shutdown menu
hl.layer_rule({
  match = {
    class = "shutdownMenu"
  },
  animation = "fade"
})

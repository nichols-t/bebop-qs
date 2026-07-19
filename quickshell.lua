-- qs -p shell.qml ipc --any-display call shutdownMenu showShutdownMenu

hl.bind(
    "SUPER + CTRL + Q",
    hl.dsp.exec_cmd("qs ipc --any-display call shutdownMenu showShutdownMenu")
)


hl.layer_rule({
  match = {
    class = "shutdownMenu"
  },
  animation = "fade"
})

-- NEED TO:
-- ln -s ~/.config/quickshell/quickshell.lua ~/.config/hypr/quickshell.lua
-- ~/.config/rex/init.lua
-- Managed via chezmoi. Conflict-free additions to Rex defaults.

--------------------------------------------------------------------------------
-- Pane Navigation
-- Cmd+Arrows move focus between panes, mirroring Alacritty + tmux bindings
-- (key_bindings.toml sends Ctrl-W + arrows for select-pane)
--------------------------------------------------------------------------------
rex.bind("cmd+left", "pane.focus", { direction = "left" })
rex.bind("cmd+down", "pane.focus", { direction = "down" })
rex.bind("cmd+up", "pane.focus", { direction = "up" })
rex.bind("cmd+right", "pane.focus", { direction = "right" })

--------------------------------------------------------------------------------
-- Pane Resizing
-- Uses Ctrl+Alt+Arrows so Rex's Shift+Cmd+Arrow directional splits remain intact
--------------------------------------------------------------------------------
rex.bind("ctrl+alt+left", "pane.resize", { direction = "left", amount = 10 })
rex.bind("ctrl+alt+down", "pane.resize", { direction = "down", amount = 10 })
rex.bind("ctrl+alt+up", "pane.resize", { direction = "up", amount = 10 })
rex.bind("ctrl+alt+right", "pane.resize", { direction = "right", amount = 10 })

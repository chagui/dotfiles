-- ~/.config/rex/init.lua
-- Managed via chezmoi. Conflict-free additions to Rex defaults.

--------------------------------------------------------------------------------
-- Pane Resizing
-- Uses Ctrl+Alt+Arrows so Rex's Shift+Cmd+Arrow directional splits remain intact
--------------------------------------------------------------------------------
rex.bind("ctrl+alt+left", "pane.resize", { direction = "left", amount = 10 })
rex.bind("ctrl+alt+down", "pane.resize", { direction = "down", amount = 10 })
rex.bind("ctrl+alt+up", "pane.resize", { direction = "up", amount = 10 })
rex.bind("ctrl+alt+right", "pane.resize", { direction = "right", amount = 10 })

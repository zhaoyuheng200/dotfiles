-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.color_scheme = "Tokyo Night Moon"
config.font = wezterm.font("MesloLGS NF")
-- config.font = wezterm.font("Cascadia Mono")

-- and finally, return the configuration to wezterm
return config

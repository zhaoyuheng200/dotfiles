-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.color_scheme = "Tokyo Night Moon"
config.font = wezterm.font("MesloLGS Nerd Font")
-- config.font = wezterm.font("Cascadia Mono")

-- Enable OSC 9 notifications (should be on by default, but explicit is good)
config.notification_handling = "AlwaysShow"

config.audible_bell = "SystemBeep"

-- Flash the screen for 300ms total
config.visual_bell = {
	fade_in_function = "Constant",
	fade_in_duration_ms = 0,
	fade_out_function = "EaseOut",
	fade_out_duration_ms = 500,
	target = "BackgroundColor",
}
config.colors = {
	visual_bell = "#444444", -- bright flash, try '#ff6600' for orange
}

-- Listen for the `kiro_done` user variable set by the remote SSH hook
-- (~/.kiro/hooks/notify-done.sh) and surface it locally: toast + sound + flash.
wezterm.on("user-var-changed", function(window, pane, name, value)
	if name == "kiro_done" then
		window:toast_notification("Kiro", "Done: " .. value, nil, 6000)
		wezterm.background_child_process({ "/usr/bin/afplay", "/System/Library/Sounds/Funk.aiff" })
		-- Flash background
		local overrides = window:get_config_overrides() or {}
		overrides.colors = { background = "#333333" }
		window:set_config_overrides(overrides)
		-- Reset after delay
		wezterm.time.call_after(0.3, function()
			overrides.colors = nil
			window:set_config_overrides(overrides)
		end)
	end
end)

-- and finally, return the configuration to wezterm
return config

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

-- Surface remote agent notifications locally (toast + sound + flash). The remote
-- SSH hooks set an iTerm2 user variable over tmux passthrough; WezTerm decodes the
-- base64 value before it reaches here.
--   kiro_done      <- ~/.kiro/hooks/notify-done.sh   (Kiro finished)
--   claude_done    <- ~/.claude/hooks/notify-claude.sh on Stop
--   claude_waiting <- ~/.claude/hooks/notify-claude.sh on Notification (needs input)
-- Each var gets a distinct title + macOS system sound so they're tell-apart-able.
local NOTIFY = {
	kiro_done = { title = "Kiro", sound = "/System/Library/Sounds/Funk.aiff" },
	claude_done = { title = "Claude", sound = "/System/Library/Sounds/Glass.aiff" },
	claude_waiting = { title = "Claude — needs you", sound = "/System/Library/Sounds/Ping.aiff" },
}

wezterm.on("user-var-changed", function(window, pane, name, value)
	local n = NOTIFY[name]
	if not n then
		return
	end
	window:toast_notification(n.title, value, nil, 6000)
	wezterm.background_child_process({ "/usr/bin/afplay", n.sound })
	-- Flash background briefly
	local overrides = window:get_config_overrides() or {}
	overrides.colors = { background = "#333333" }
	window:set_config_overrides(overrides)
	wezterm.time.call_after(0.3, function()
		overrides.colors = nil
		window:set_config_overrides(overrides)
	end)
end)

-- Shift+click opens the link span under the cursor. WezTerm's default catch-all
-- hyperlink rule allows a trailing ')' (for wiki-style URLs) and, because WezTerm
-- keeps the LONGEST matching candidate, it beats the built-in '(URL)' rule and
-- swallows the closing paren of URLs like (https://code.amazon.com/reviews/CR-.../1).
-- Drop ')' from the catch-all's trailing class, but re-add a rule that keeps URLs
-- ending in a balanced paren group so wiki links still work.
config.hyperlink_rules = wezterm.default_hyperlink_rules()

for i, rule in ipairs(config.hyperlink_rules) do
	if rule.regex:find(")/a-zA-Z0-9-]", 1, true) then
		rule.regex = [[\b\w+://\S+[/a-zA-Z0-9-]+]]
		table.insert(config.hyperlink_rules, i, {
			regex = [[\b\w+://\S*\([^\s()]*\)[/a-zA-Z0-9-]*]],
			format = "$0",
		})
		break
	end
end

-- and finally, return the configuration to wezterm
return config

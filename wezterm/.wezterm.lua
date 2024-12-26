local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.font = wezterm.font("JetBrains Mono")

config.color_scheme = "Tokyo Night"
config.hide_tab_bar_if_only_one_tab = true
config.font_size = 14

config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

-- Use the defaults as a base
config.hyperlink_rules = wezterm.default_hyperlink_rules()

keys = {
	-- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
	{ key = "LeftArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bb" }) },
	-- Make Option-Right equivalent to Alt-f; forward-word
	{ key = "RightArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bf" }) },
}

return config

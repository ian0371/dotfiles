-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Latte"

config.font = wezterm.font("CaskaydiaCove Nerd Font Mono")
config.font_size = 14
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.enable_kitty_keyboard = true -- enables newline (SHIFT ENTER) in claude code

config.audible_bell = "Disabled"

function tmux_select_pane_key(num)
	return wezterm.action.Multiple({
		wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
		wezterm.action.SendKey({ key = num }),
	})
end

config.keys = {
	{ key = "Space", mods = "CMD|SHIFT", action = wezterm.action.QuickSelect },
	{ key = "1", mods = "CMD", action = tmux_select_pane_key("1") },
	{ key = "2", mods = "CMD", action = tmux_select_pane_key("2") },
	{ key = "3", mods = "CMD", action = tmux_select_pane_key("3") },
	{ key = "4", mods = "CMD", action = tmux_select_pane_key("4") },
	{ key = "5", mods = "CMD", action = tmux_select_pane_key("5") },
	{ key = "6", mods = "CMD", action = tmux_select_pane_key("6") },
	{ key = "7", mods = "CMD", action = tmux_select_pane_key("7") },
	{ key = "8", mods = "CMD", action = tmux_select_pane_key("8") },
	{ key = "9", mods = "CMD", action = tmux_select_pane_key("9") },
}

config.unix_domains = {
	{
		name = "unix",
	},
}

local hyperlink_rules = wezterm.default_hyperlink_rules()
for i = #hyperlink_rules, 1, -1 do
	if hyperlink_rules[i].format and hyperlink_rules[i].format:match("^mailto:") then
		table.remove(hyperlink_rules, i)
	end
end

config.hyperlink_rules = hyperlink_rules

-- equivalent to `wezterm connect unix`
-- config.default_gui_startup_args = { "connect", "unix" }

-- and finally, return the configuration to wezterm
return config

local wezterm = require("wezterm")
local mappings = require("modules.mappings")

-- Show which key table is active in the status area
wezterm.on("update-right-status", function(window, pane)
	local name = window:active_key_table()
	if name then
		name = "TABLE: " .. name
	end
	window:set_right_status(name or "")
end)

return {
	--default_prog = { "/bin/zsh" },

	-- FONT CONFIGURATION
	font = wezterm.font_with_fallback({
		-- 1st choice: Your primary font
		{ family = "JetBrainsMono Nerd Font", weight = "Medium" },

		{ family = "Noto Sans Bengali" },

		-- 2nd choice: Fallback for Emojis
		{ family = "Noto Color Emoji" },

		-- 3rd choice: Fallback for Nerd Font Icons
		{ family = "Symbols Nerd Font Mono" },
	}),
	font_size = 10,
	line_height = 1.1,
	use_ime = true,

	-- This suppresses the "No fonts contain glyphs" warning window
	warn_about_missing_glyphs = false,

	-- CURSOR & COLORS
	default_cursor_style = "BlinkingBlock",
	colors = {
		background = "#292828",
		foreground = "#ebdbb2",
		cursor_bg = "#d4be98",
		cursor_fg = "#282828",
		ansi = { "#282828", "#cc241d", "#98971a", "#d79921", "#458588", "#b16286", "#689d6a", "#a89984" },
		brights = { "#928374", "#fb4934", "#b8bb26", "#fabd2f", "#83a598", "#d3869b", "#8ec07c", "#ebdbb2" },
	},

	-- WINDOW & TAB BAR
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = true,
	hide_tab_bar_if_only_one_tab = true,
	tab_max_width = 999999,
	window_padding = {
		left = 30,
		right = 30,
		top = 30,
		bottom = 30,
	},
	window_decorations = "RESIZE",
	inactive_pane_hsb = {
		brightness = 0.7,
	},

	-- KEYS
	send_composed_key_when_left_alt_is_pressed = false,
	send_composed_key_when_right_alt_is_pressed = true,
	leader = mappings.leader,
	keys = mappings.keys,
	key_tables = mappings.key_tables,
}

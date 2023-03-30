local status, lualine = pcall(require, "lualine")
if not status then
	return
end

-- get lualine nightfly theme
local lualine_theme = require("lualine.themes.onedark")
local palette = require("nightfox.palette").load("nightfox")

-- change nightlfy theme colors
lualine_theme.normal.a.bg = palette.blue.base
lualine_theme.insert.a.bg = palette.green.base
lualine_theme.visual.a.bg = palette.magenta.base
lualine_theme.command = {
	a = {
		gui = "bold",
		bg = palette.yellow.base,
		fg = "#000000", -- black
	},
}

lualine.setup({
	options = {
		theme = lualine_theme,
	},
})

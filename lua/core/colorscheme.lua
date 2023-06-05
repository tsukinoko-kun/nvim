local hour = tonumber(os.date("%H"))
if hour >= 6 and hour < 18 then
    pcall(vim.cmd.colorscheme, "catppuccin-latte")
else
    pcall(vim.cmd.colorscheme, "catppuccin-mocha")
end

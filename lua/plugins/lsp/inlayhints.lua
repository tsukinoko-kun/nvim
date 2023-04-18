local inlayhints = require("inlay-hints")
-- local inlayhints_status, inlayhints = pcall(require, "inlay-hints")
-- if not inlayhints_status then
--     return
-- end

inlayhints.setup({
    only_current_line = false,
    eol = {
        right_align = true,
    },
})

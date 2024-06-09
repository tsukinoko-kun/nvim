local function map(mode, lhs, rhs, opts)
    local options = {
        noremap = true,
        silent = true,
    }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

local function table_has(list, val)
    for _, value in ipairs(list) do
        if value == val then
            return true
        end
    end

    return false
end

local function table_set(list, value)
    if table_has(list, value) then
        return
    end
    table.insert(list, value)
end

local function file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

return {
    map = map,
    table_has = table_has,
    table_set = table_set,
    file_exists = file_exists,
}

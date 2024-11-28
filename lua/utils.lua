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

local function includes_one_of(str, list)
    for _, value in ipairs(list) do
        if string.find(str, value) then
            return true
        end
    end

    return false
end

local function get_appearance_mode()
    -- Run osascript to get the appearance
    local handle =
        io.popen("osascript -e 'tell application \"System Events\" to tell appearance preferences to return dark mode'")
    if not handle then
        return "error"
    end
    local result = handle:read("*a")
    handle:close()

    -- Trim result and convert to boolean
    result = result:match("^%s*(.-)%s*$")
    return result == "true" and "dark" or "light"
end

return {
    map = map,
    table_has = table_has,
    table_set = table_set,
    file_exists = file_exists,
    includes_one_of = includes_one_of,
    get_appearance_mode = get_appearance_mode,
}

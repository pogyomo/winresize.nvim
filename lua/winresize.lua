local M = {}

---Check whether the window have neighbor to 'dir' or not.
---@param win integer Window handle, or 0 for current window.
---@param dir "left" | "right" | "up" | "down" Direction to check.
---@return boolean # True if the window have neighbor to 'dir'.
local function have_neighbor_to(win, dir)
    local neighbor = vim.api.nvim_win_call(win, function()
        vim.cmd.wincmd(({
            left = "h",
            right = "l",
            up = "k",
            down = "j",
        })[dir])
        return vim.api.nvim_get_current_win()
    end)
    local n_winnr = vim.api.nvim_win_get_number(neighbor)
    local w_winnr = vim.api.nvim_win_get_number(win)
    return n_winnr ~= w_winnr
end

---Resize the window as normal (not float) window.
---@param win integer Window handle for resize. 0 for current window.
---@param diff_width integer How much to move when resize window width. Must be positive.
---@param diff_height integer How much to move when resize window height. Must be positive.
---@param key "left" | "right" | "up" | "down" Type of direction key to be used to resize.
local function resize_normal(win, diff_width, diff_height, key)
    local dir = (key == "left" or key == "right") and "width" or "height"
    local setter = vim.api["nvim_win_set_" .. dir]
    local getter = vim.api["nvim_win_get_" .. dir]

    if key == "left" or key == "right" then
        if have_neighbor_to(win, "right") then
            setter(win, getter(win) + (key == "right" and diff_height or -diff_height))
        else
            setter(win, getter(win) + (key == "right" and -diff_height or diff_height))
        end
    else
        if not have_neighbor_to(win, "down") and not have_neighbor_to(win, "up") then
            return
        end

        if have_neighbor_to(win, "down") then
            setter(win, getter(win) + (key == "down" and diff_width or -diff_width))
        else
            setter(win, getter(win) + (key == "down" and -diff_width or diff_width))
        end
    end
end

---Resize the window as floating window.
---@param win integer Window handle for resize. 0 for current window.
---@param diff_width integer How much to move when resize window width. Must be positive.
---@param diff_height integer How much to move when resize window height. Must be positive.
---@param key "left" | "right" | "up" | "down" Type of direction key to be used to resize.
local function resize_float(win, diff_width, diff_height, key)
    local dir = (key == "left" or key == "right") and "width" or "height"
    local setter = vim.api["nvim_win_set_" .. dir]
    local getter = vim.api["nvim_win_get_" .. dir]

    if key == "left" or key == "right" then
        setter(win, getter(win) + (key == "right" and diff_height or -diff_height))
    else
        setter(win, getter(win) + (key == "down" and diff_width or -diff_width))
    end
end

---Resize the window.
---@param win integer Window handle for resize. 0 for current window.
---@param diff_width integer How much to move when resize window width. Must be positive.
---@param diff_height integer How much to move when resize window height. Must be positive.
---@param key "left" | "right" | "up" | "down" Type of direction key to be used to resize.
function M.resize(win, diff_width, diff_height, key)
    if vim.api.nvim_win_get_config(win).relative ~= "" then
        resize_float(win, diff_width, diff_height, key)
        return
    end

    resize_normal(win, diff_width, diff_height, key)
end

return M

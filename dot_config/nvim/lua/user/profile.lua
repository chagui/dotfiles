local M = {}

local profiles = { minimal = 0, editor = 1, default = 2 }

local current = vim.env.NVIM_PROFILE or "default"
if profiles[current] == nil then
    current = "default"
end

--- Returns true when the active profile is at least `min_profile`.
---@param min_profile string
---@return boolean
function M.active(min_profile)
    return profiles[current] >= (profiles[min_profile] or 0)
end

return M

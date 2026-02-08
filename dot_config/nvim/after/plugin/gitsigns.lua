local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
    return
end

gitsigns.setup({
    current_line_blame = true,
    current_line_blame_opts = {
        ignore_whitespace = true,
    },
})

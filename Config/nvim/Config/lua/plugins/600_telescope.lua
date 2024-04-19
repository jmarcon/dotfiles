-- Load telescope plugin
-- Telescope is a plugin that allows you to search for files, text, and more.
-- It's a great tool for navigating your filesystem and finding files.
-- works great with fzf
-- (https://github.com/nvim-telescope/telescope-ui-select.nvim)

return {{"nvim-telescope/telescope-ui-select.nvim"}, {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {"nvim-lua/plenary.nvim"},
    config = function()
        local t = require("telescope")
        local b = require("telescope.builtin")

        t.setup({
            extensions = {
                ["ui-select"] = {require("telescope.themes").get_dropdown({})}
            }
        })

        t.load_extension("ui-select")

        vim.keymap.set("n", "<C-p>", b.find_files, {})
        vim.keymap.set("n", "<leader>fg", b.live_grep, {})
    end
}}
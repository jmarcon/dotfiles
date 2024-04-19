-- Load Git Plugins 
-- Gitsigns is a plugin that allows you to display git signs in the sign column.
-- It will allow you to see what lines have been added, modified, or removed.
-- (https://github.com/lewis6991/gitsigns.nvim)
-- Vim-fugitive is a plugin that allows you to use git commands within vim.
-- (https://github.com/tpope/vim-fugitive)

return {{
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup()
        vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", {})
        vim.keymap.set("n", "<leader>gb", ":Gitsigns toggel_current_line_blame<CR>", {})
    end
}, {"tpope/vim-fugitive"}}
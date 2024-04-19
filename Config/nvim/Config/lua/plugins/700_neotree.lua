-- Load the neotree plugin
-- Neotree is a file explorer plugin for neovim
-- (https://github.com/nvim-neo-tree/neo-tree.nvim)

return {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {"nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim"},
    config = function()
        vim.keymap.set("n", "<C-n>", ":Neotree filesystem toggle left<CR>", {})
    end
}
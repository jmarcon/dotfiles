-- Load Lualine and Trouble plugins

-- Lualine is a plugin that adds a statusline to Neovim 
-- (https://github.com/nvim-lualine/lualine.nvim)
-- Consider use the following theme: dracula or papercolor_dark

-- Trouble is a plugin that adds 'debug' to Neovim configuration 
-- (https://github.com/folke/trouble.nvim)

return {{
    "nvim-lualine/lualine.nvim",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    config = function()
        require("lualine").setup({
            options = {
                theme = "dracula"
            }
        })
    end
},
{
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
     -- your configuration comes here
     -- or leave it empty to use the default settings
    },
}}
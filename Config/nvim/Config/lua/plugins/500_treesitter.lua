-- Loads the treesitter plugin and sets it up
-- Treesitter is a plugin that loads a lot of different parsers for different languages
-- (https://github.com/nvim-treesitter/nvim-treesitter)

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local c = require("nvim-treesitter.configs")
        c.setup({
            auto_install = true,
            highlight = {
                enable = true
            },
            indent = {
                enable = true
            }
        })
    end
}
-- Load Styler plugin
-- Styler is a plugin that allows you to change the colorscheme of a buffer based on the filetype.
-- https://github.com/folke/styler.nvim

return {
    "folke/styler.nvim",
    config = function()
      require("styler").setup({
        themes = {
          yaml = { colorscheme = "kanagawa", background = "dark" },
          markdown = { colorscheme = "gruvbox" , background = "dark" },
          help = { colorscheme = "catppuccin-mocha", background = "dark" },
        },
      })
    end
  }
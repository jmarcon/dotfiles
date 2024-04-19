-- Load all themes here

return {{
    'uloco/bluloco.nvim',
    lazy = false,
    priority = 1000,
    dependencies = {'rktjmp/lush.nvim'}
}, {
    "rebelot/kanagawa.nvim",
    lazy = false
}, {
    "savq/melange-nvim",
    lazy = false
}, {
    'AlexvZyl/nordic.nvim',
    lazy = false,
    priority = 1000
}, {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false
}, {
    "ellisonleao/gruvbox.nvim",
    name = 'gruvbox',
    priority = 1000,
    config = true,
    opts = ...
}, {
    "folke/tokyonight.nvim",
    name = 'tokyonight',
    priority = 1000,
    lazy = false
}, {
    'dracula/vim',
    name = 'dracula',
    priority = 1000,
    lazy = false
}}

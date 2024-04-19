-- Load alpha-nvim plugin
-- Alpha is a lua based startpage for neovim
-- (https://github.com/goolord/alpha-nvim)

return {
    "goolord/alpha-nvim",
    config = function()
        local a = require("alpha")
        local d = require("alpha.themes.startify")
        -- d.section.header.val = {}
        a.setup(d.opts)
    end
}
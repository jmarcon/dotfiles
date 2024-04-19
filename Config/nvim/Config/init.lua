local p = vim.fn.stdpath('data') .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(p) then 
    vim.fn.system({
        "git", "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", 
        p
    })
end

vim.opt.rtp:prepend(p)

require('configuration')
require("lazy").setup("plugins")


vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Syntax and Identation
vim.opt.syntax = "on"
vim.opt.wrap = false 
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Accessibility
vim.opt.termguicolors = true
vim.opt.encoding = "utf-8"
vim.opt.history = 10000
vim.opt.autoread = true
vim.opt.visualbell = true

-- Keybindings and Mappings
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")
vim.wo.number = true

-- Folding
vim.opt.foldmethod = "syntax"
vim.opt.foldlevel = 99
vim.cmd("nnoremap <space> za")

-- Mouse and Cursor
vim.opt.mouse = "a"
vim.opt.ruler = true
vim.opt.number = true
vim.opt.numberwidth = 4
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Search
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true


-- Settings
--vim.cmd(":let g:loaded_perl_provider = 0")

return {}

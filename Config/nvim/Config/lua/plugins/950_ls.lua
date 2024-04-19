-- Load Language Server Protocol (LSP) plugins
-- Mason is a plugin that allows you to create and manage LSP configurations.
-- More like a package manager for LSP configurations.
-- (https://github.com/williamboman/mason.nvim)
-- Mason LSP Config is a plugin that allows you to configure LSP servers using Mason.
-- (https://github.com/williamboman/mason-lspconfig.nvim)
-- nvim-lspconfig is a plugin that allows you to configure LSP servers.
-- (https://github.com/neovim/nvim-lspconfig)

return {{
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
        require("mason").setup()
    end
}, {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
        auto_install = true
    }
}, {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local lspconfig = require("lspconfig")

        lspconfig.tsserver.setup {
            capabilities = capabilities
        }
        lspconfig.html.setup {
            capabilities = capabilities
        }
        lspconfig.lua_ls.setup {
            capabilities = capabilities
        }

        vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
        vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
        vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
    end
}}
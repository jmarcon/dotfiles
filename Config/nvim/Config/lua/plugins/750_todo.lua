-- Load the todo-comments plugin
-- todo-comments is a plugin that highlights TODO, FIXME, etc. comments within your code.
-- (https://github.com/folke/todo-comments.nvim)

return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
}
-- Load bufferline
-- Bufferline is a plugin that allows you to display your buffers in the tabline.
-- https://github.com/akinsho/bufferline.nvim

return {
    "akinsho/bufferline.nvim",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    config = function()
        require("bufferline").setup()
    end
}
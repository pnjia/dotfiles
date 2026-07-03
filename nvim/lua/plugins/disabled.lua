return {
  { "nvim-neo-tree/neo-tree.nvim", enabled = false }, -- Use yazi instead
  { "nvim-tree/nvim-tree.lua", enabled = false }, -- Disable nvim-tree if exists
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        enabled = false,
        replace_netrw = false,
      },
    },
  },
}

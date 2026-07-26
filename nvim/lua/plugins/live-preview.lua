return {
  "brianhuster/live-preview.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  opts = {
    picker = "telescope",
  },
  config = function(_, opts)
    require("livepreview.config").set(opts)
  end,
}

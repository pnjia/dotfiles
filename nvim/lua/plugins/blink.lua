return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.completion = opts.completion or {}
      opts.completion.menu = vim.tbl_deep_extend("force", opts.completion.menu or {}, {
        auto_show = false,
      })
      opts.completion.ghost_text = vim.tbl_deep_extend("force", opts.completion.ghost_text or {}, {
        enabled = false,
      })
      opts.keymap = opts.keymap or {}
      opts.keymap["<C-k>"] = { "scroll_documentation_up", "fallback" }
    end,
  },
}

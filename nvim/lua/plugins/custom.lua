-- Central configuration for all custom plugins and behavior
return {
  -- 1. Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "storm", -- options: storm, moon, night, day
      transparent = false,
      styles = {
        sidebars = "dark",
        floats = "dark",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },

  -- 2. UI Enhancements
  {
    "karb94/neoscroll.nvim",
    lazy = false,
    opts = {},
  },

  -- 3. Telescope & Live Grep Args
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    keys = {
      {
        "<leader>fg",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args()
        end,
        desc = "Grep (Args)",
      },
    },
    opts = function()
      -- This ensures extensions are loaded correctly
      require("telescope").load_extension("live_grep_args")
    end,
  },

  -- 4. Yazi
  {
    "mikavilpas/yazi.nvim",
    version = "*",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
    keys = {
      {
        "<leader>-",
        function()
          require("yazi").yazi()
        end,
        desc = "Yazi (File)",
      },
      {
        "<leader>cw",
        function()
          require("yazi").yazi(nil, vim.fn.getcwd())
        end,
        desc = "Yazi (Cwd)",
      },
      {
        "<c-up>",
        function()
          require("yazi").toggle()
        end,
        desc = "Yazi (Toggle)",
      },
    },
    opts = {
      open_for_directories = true,
      yazi_cmd = "/usr/bin/yazi",
    },
    init = function()
      vim.g.loaded_netrwPlugin = 1
      vim.g.loaded_netrw = 1
    end,
  },

  -- 5. Obsidian
  -- {
  --   "epwalsh/obsidian.nvim",
  --   version = "*",
  --   ft = "markdown",
  --   opts = {
  --     workspaces = {
  --       { name = "Second_Brain", path = "~/Documents/Second_Brain" },
  --     },
  --     legacy_commands = false,
  --   },
  -- },
  -- {
  --   "iamcco/markdown-preview.nvim",
  --   cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  --   build = "cd app && npm install",
  --   init = function()
  --     vim.g.mkdp_filetypes = { "markdown" }
  --   end,
  --   ft = { "markdown" },
  -- },
  --
  -- 6. Disable all markdown linters (nvim-lint)
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.markdown = {}
    end,
  },

  -- 7. Live Server
  {
    "barrettruth/live-server.nvim",
    cmd = { "LiveServerStart", "LiveServerStop", "LiveServerToggle" },
    opts = {},
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },

    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-mini/mini.icons",
    },

    init = function()
      vim.opt.conceallevel = 2
      vim.opt.concealcursor = "nc"
    end,

    opts = {
      log_level = "error",
      heading = {
        enabled = true,
        position = "inline",

        icons = {
          "󰎤 ",
          "󰎧 ",
          "󰎪 ",
          "󰎭 ",
          "󰎱 ",
          "󰎳 ",
        },
      },

      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
      },

      checkbox = {
        enabled = true,
        unchecked = {
          icon = "󰄱 ",
        },
        checked = {
          icon = "󰱒 ",
        },
      },

      quote = {
        enabled = true,
        icon = "▋",
      },

      code = {
        enabled = true,
        sign = false,
        width = "block",
      },

      pipe_table = {
        enabled = true,
      },

      callout = {
        note = {
          raw = "[!NOTE]",
          rendered = "󰋽 Note",
        },
        tip = {
          raw = "[!TIP]",
          rendered = "󰌶 Tip",
        },
        important = {
          raw = "[!IMPORTANT]",
          rendered = "󰅾 Important",
        },
        warning = {
          raw = "[!WARNING]",
          rendered = "󰀪 Warning",
        },
        caution = {
          raw = "[!CAUTION]",
          rendered = "󰳦 Caution",
        },
      },
    },
  },
}

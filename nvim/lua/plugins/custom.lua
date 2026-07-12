-- Central configuration for all custom plugins and behavior
return {
  -- 1. Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night", -- options: storm, moon, night, day
      transparent = true,
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

  -- 5. Obsidian (disabled: frontmatter update mengganggu workflow)
  -- {
  --   "epwalsh/obsidian.nvim",
  --   version = "*",
  --   ft = "markdown",
  --   opts = {
  --     workspaces = {
  --       { name = "Second_Brain", path = "~/Documents/Second_Brain" },
  --     },
  --     ui = { enabled = false },
  --     legacy_commands = false,
  --     templates = {
  --       subdir = "099_System/Templates",
  --       date_format = "%Y-%m-%d",
  --       time_format = "%H:%M",
  --     },
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
  -- 7. Bullets.vim
  {
    "bullets-vim/bullets.vim",
    ft = { "markdown", "text", "gitcommit" },
    init = function()
      vim.g.bullets_enabled_file_types = { "markdown", "text", "gitcommit" }
    end,
  },

  -- 8. SmoothCursor
  {
    "gen740/SmoothCursor.nvim",
    config = function()
      require("smoothcursor").setup({
        type = "default",
        fancy = {
          enable = true,
          head = { cursor = "▷", texthl = "SmoothCursor", linehl = nil },
          body = {
            { cursor = "●", texthl = "SmoothCursorOrange" },
            { cursor = "●", texthl = "SmoothCursorYellow" },
            { cursor = "●", texthl = "SmoothCursorGreen" },
            { cursor = "•", texthl = "SmoothCursorAqua" },
            { cursor = "•", texthl = "SmoothCursorBlue" },
            { cursor = ".", texthl = "SmoothCursorPurple" },
            { cursor = ".", texthl = "SmoothCursorBlue" },
          },
          tail = { cursor = nil, texthl = "SmoothCursor" },
        },
        speed = 25,
        intervals = 35,
        threshold = 3,
        timeout = 3000,
      })
    end,
  },

  -- 9. Tiny Glimmer
  {
    "rachartier/tiny-glimmer.nvim",
    event = "VeryLazy",
    opts = {
      overwrite = {
        auto_map = true,
        yank = {
          enabled = true,
          default_animation = {
            name = "fade",
            settings = {
              from_color = "#a6e3a1",
              max_duration = 400,
              min_duration = 200,
            },
          },
        },
        paste = {
          enabled = true,
          default_animation = {
            name = "reverse_fade",
            settings = {
              from_color = "#94e2d5",
              max_duration = 400,
              min_duration = 200,
            },
          },
        },
        undo = { enabled = false },
        redo = { enabled = false },
        search = {
          enabled = true,
          default_animation = {
            name = "pulse",
            settings = {
              from_color = "#f9e2af",
            },
          },
        },
      },
    },
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

  -- 10. Dashboard
  {
    "folke/snacks.nvim",
    opts = { dashboard = { enabled = false } },
  },
  {
    "nvimdev/dashboard-nvim",
    lazy = false,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
    opts = {
      theme = "hyper",
      config = {
        week_header = { enable = true },
        shortcut = {
          { desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
          { desc = " Files", group = "Label", action = "Telescope find_files", key = "f" },
          { desc = " Grep", group = "Number", action = "Telescope live_grep", key = "g" },
          { desc = "󰒲 Lazy", group = "DiagnosticHint", action = "Lazy", key = "l" },
        },
        packages = { enable = true },
        project = { enable = true, limit = 8 },
        mru = { enable = true, limit = 10 },
      },
    },
  },

  -- 11. vim-illuminate
  {
    "RRethy/vim-illuminate",
    event = "VeryLazy",
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = { providers = { "lsp" } },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },

  -- 12. nerdy.nvim
  {
    "2kabhishek/nerdy.nvim",
    cmd = "Nerdy",
    dependencies = {
      "folke/snacks.nvim",
    },
    opts = {},
    keys = {
      { "<leader>in", "<cmd>Nerdy<CR>", desc = "Nerd Icons" },
    },
  },

  -- 8. Override gd for marksman to support [[wiki-links]]
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          keys = {
            {
              "gd",
              function()
                local wiki = require("config.wiki_links")
                if not wiki.goto_wiki_link() then
                  vim.lsp.buf.definition()
                end
              end,
              desc = "Goto [[wiki-link]] / LSP definition",
              has = "definition",
            },
          },
        },
      },
    },
  },
}

return {
  -- 1. Import LazyVim's official Neo-tree configuration template
  -- This restores default integration configs, keymaps, and proper window layouts.
  { import = "lazyvim.plugins.extras.editor.neo-tree" },

  -- 2. Configure Neo-tree with custom overrides, Git tracking, LSP diagnostics, and Neon highlights
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = true,
    init = function()
      -- Inject custom highlight groups
      local highlights = {
        -- LSP Diagnostics: Vivid Neon Colors
        NeoTreeDiagnosticError = { fg = "#FF2A7A", bold = true }, -- Hot Pink/Magenta
        NeoTreeDiagnosticWarn = { fg = "#FFD200", bold = true }, -- Electric Cyber Yellow
        NeoTreeDiagnosticInfo = { fg = "#00F0FF" }, -- Neon Cyan
        NeoTreeDiagnosticHint = { fg = "#9D4EDD" }, -- Synthwave Purple

        -- Git Status Overrides: Custom Electric Accents
        NeoTreeGitAdded = { fg = "#A6E22E" }, -- Bright Lime Green
        NeoTreeGitModified = { fg = "#FF9F1C" }, -- Electric Sunset Amber
        NeoTreeGitDeleted = { fg = "#FF4A5A" }, -- Neon Coral Red
        NeoTreeGitRenamed = { fg = "#00D2FF" }, -- Cyan Streak
        NeoTreeGitUntracked = { fg = "#FF55FF", italic = true }, -- Hot Fuchsia
        NeoTreeGitIgnored = { fg = "#444B6A" }, -- Faded Subdued Deep Blue-Gray
        NeoTreeGitUnstaged = { fg = "#FF9E64" }, -- Unstaged Warning Orange
        NeoTreeGitStaged = { fg = "#73DACA" }, -- Clean Mint Green
        NeoTreeGitConflict = { fg = "#BB9AF7", bold = true }, -- Deep Purple Alert
      }

      for group, opts in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, opts)
      end
    end,

    -- Buffer/window movement
    opts = {
      close_if_last_window = true,
      enable_git_status = true,
      enable_diagnostics = true,
      window = {
        width = 30,
        mappings = {
          ["<C-cr>"] = function(state)
            local node = state.tree:get_node()
            if node.type == "file" then
              require("neo-tree.sources.filesystem.commands").open(state)
              require("neo-tree.command").execute({ action = "close" })
            end
          end,
        },
      },

      default_component_configs = {
        diagnostics = {
          symbols = {
            hint = "⛩",
            info = "",
            warn = "",
            error = "",
          },
          -- Tie the component directly to our new injected highlight names
          highlights = {
            hint = "NeoTreeDiagnosticHint",
            info = "NeoTreeDiagnosticInfo",
            warn = "NeoTreeDiagnosticWarn",
            error = "NeoTreeDiagnosticError",
          },
        },
        git_status = {
          symbols = {
            added = "",
            modified = "  ",
            deleted = "  ",
            renamed = "  ",
            untracked = "",
            ignored = "◌",
            unstaged = "  ",
            staged = "",
            conflict = "",
          },
        },
      },

      filesystem = {
        hijack_netrw_behavior = "disabled",

        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },

        filtered_items = {
          visible = false,
          hide_dotfiles = true,
          hide_gitignored = true,
          hide_by_name = {
            ".DS_Store",
            "node_modules",
            "dist",
            "build",
            ".next",
            ".turbo",
          },
          hide_by_pattern = {
            "**/__*",
          },
          always_show = {
            ".copilot*",
            ".claude*",
            ".env",
            ".env.local",
            ".env.production",
            ".gitignore",
          },
          always_show_by_pattern = {
            ".env*",
            "*.config.*",
          },
        },

        find_by_full_path_words = false,
        find_args = {
          fd = {
            "--exclude",
            ".git",
            "--exclude",
            "node_modules",
            "--exclude",
            "dist",
            "--exclude",
            "build",
            "--exclude",
            ".next",
            "--exclude",
            ".turbo",
            "--exclude",
            ".cache",
            "--exclude",
            "__*",
          },
        },
      },
    },
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
        end,
        desc = "Explorer Neo-tree (Root Dir)",
      },
      {
        "<leader>E",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "Explorer Neo-tree (Cwd)",
      },
    },
  },

  -- 3. Strip Explorer bindings away from Snacks so they don't fight over hotkeys
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- Fully disable snacks explorer so it never launches on startup
      explorer = { enabled = false },

      picker = {
        sources = {
          -- Set universal overrides for global file finding
          files = {
            hidden = false,
            ignored = false,
            exclude = { "**/node_modules", "**/dist", "**/.git", "**/cdk.out/**", "**/node_modules/**" },
          },
          -- Set universal overrides for live project grepping
          grep = {
            hidden = false,
            ignored = false,
            exclude = { "**/node_modules", "**/dist", "**/.git", "**/node_modules/**" },
          },
        },
      },
    },
    -- Define your global keymaps here
    keys = {
      -- Hard-disable standard snacks explorer bindings so they don't block neo-tree
      { "<leader>e", false },
      { "<leader>E", false },
      {
        "<leader>fF",
        function()
          Snacks.picker.files({
            title = "Clean Find Files",
            ignored = false,
            hidden = false,
          })
        end,
        desc = "Clean Find Files (No Gitignore/Node/Dist)",
      },
    },
  },

  -- 4. Keep your visual adjustments intact
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      stiffness = 0.8,
      trailing_stiffness = 0.5,
      distance_stop_animating = 0.5,
      hide_target_hack = false,
    },
  },

  -- 5. Add custom file type icon colors to match the neon cyberpunk theme
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
    priority = 999, -- Load right before Neo-tree builds its window assets
    opts = {
      color_icons = true, -- Ensure per-icon highlight color extraction is globally enabled
      override = {
        -- TypeScript & TSX: Hot Electric Cyan
        ts = { icon = "  ", color = "#00F0FF", name = "Ts" },
        tsx = { icon = "", color = "#00F0FF", name = "Tsx" },

        -- JavaScript & JSX: High-Impact Cyber Yellow
        js = { icon = "  ", color = "#FFD200", name = "Js" },
        jsx = { icon = "", color = "#FFD200", name = "Jsx" },

        -- JSON & Config manifests: Bright Mint Green
        json = { icon = "", color = "#73DACA", name = "Json" },
        toml = { icon = "", color = "#73DACA", name = "Toml" },
        yaml = { icon = "", color = "#73DACA", name = "Yaml" },

        -- Markdown & Text: Vivid Neon Sunset Amber
        md = { icon = "", color = "#FF9F1C", name = "Md" },
        txt = { icon = "  ", color = "#FF9F1C", name = "Txt" },

        -- Lockfiles & Dependencies: Faded Purple Alert
        lock = { icon = "", color = "#BB9AF7", name = "Lock" },
        ["pnpm-lock.yaml"] = { icon = "  ", color = "#BB9AF7", name = "PnpmLock" },

        -- Lua: Bright Synthwave Purple-Pink
        lua = { icon = "  ", color = "#FF55FF", name = "Lua" },

        -- C/C++: Electric Neon Coral Red
        c = { icon = "", color = "#FF4A5A", name = "C" },
        cpp = { icon = "", color = "#FF4A5A", name = "Cpp" },
      },
    },
    config = function(_, opts)
      -- This execution ensures our hex colors load securely ahead of other plugins
      require("nvim-web-devicons").setup(opts)
    end,
  },
}

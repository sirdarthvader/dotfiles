return {
  -- 1. Import LazyVim's official Neo-tree configuration template
  { import = "lazyvim.plugins.extras.editor.neo-tree" },

  -- 2. Configure Neo-tree with custom overrides, Git tracking, LSP diagnostics, and Neon highlights
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = true,
    init = function()
      -- Inject custom highlight groups matching your aesthetic palette
      local highlights = {
        NeoTreeDiagnosticError = { fg = "#FF2A7A", bold = true }, 
        NeoTreeDiagnosticWarn  = { fg = "#FFD200", bold = true }, 
        NeoTreeDiagnosticInfo  = { fg = "#00F0FF" },              
        NeoTreeDiagnosticHint  = { fg = "#9D4EDD" },              

        NeoTreeGitAdded     = { fg = "#A6E22E" }, 
        NeoTreeGitModified  = { fg = "#FF9F1C" }, 
        NeoTreeGitDeleted   = { fg = "#FF4A5A" }, 
        NeoTreeGitRenamed   = { fg = "#00D2FF" }, 
        NeoTreeGitUntracked = { fg = "#FF55FF", italic = true }, 
        NeoTreeGitIgnored   = { fg = "#444B6A" }, 
        NeoTreeGitUnstaged  = { fg = "#FF9E64" }, 
        NeoTreeGitStaged    = { fg = "#73DACA" }, 
        NeoTreeGitConflict  = { fg = "#BB9AF7", bold = true }, 
      }

      for group, opts in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, opts)
      end
    end,

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
            hint  = "⛩",
            info  = "",
            warn  = "",
            error = "",
          },
          highlights = {
            hint  = "NeoTreeDiagnosticHint",
            info  = "NeoTreeDiagnosticInfo",
            warn  = "NeoTreeDiagnosticWarn",
            error = "NeoTreeDiagnosticError",
          },
        },
        git_status = {
          symbols = {
            added     = "",
            modified  = "  ",
            deleted   = "  ",
            renamed   = "  ",
            untracked = "",
            ignored   = "◌",
            unstaged  = "  ",
            staged    = "",
            conflict  = "",
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
            ".DS_Store", "node_modules", "dist", "build", ".next", ".turbo",
          },
          hide_by_pattern = {
            "**/__*",
          },
          always_show = {
            ".copilot*", ".claude*", ".env", ".env.local", ".env.production", ".gitignore",
          },
          always_show_by_pattern = {
            ".env*", "*.config.*",
          },
        },

        find_by_full_path_words = false,
        find_args = {
          fd = {
            "--exclude", ".git", "--exclude", "node_modules", "--exclude", "dist",
            "--exclude", "build", "--exclude", ".next", "--exclude", ".turbo",
            "--exclude", ".cache", "--exclude", "__*",
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

  
  -- 3. Configure Snacks Pickers while forcing the dashboard back to life
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      explorer = { enabled = false }, 
      dashboard = { enabled = true }, 
      picker = {
        sources = {
          files = {
            hidden = false,
            ignored = false,
            exclude = { "**/node_modules", "**/dist", "**/.git", "**/cdk.out/**", "**/node_modules/**" },
          },
          grep = {
            hidden = false,
            ignored = false,
            exclude = { "**/node_modules", "**/dist", "**/.git", "**/node_modules/**" },
          },
        },
      },
    },
    -- Snacks shows the dashboard automatically when Neovim starts with no args.
    -- Because we disable the Snacks explorer (we use neo-tree), Snacks bails out of
    -- showing the dashboard when launched on a directory (`nvim .`). Handle that case
    -- ourselves: cd into the directory and show ONLY the dashboard, nothing else.
    init = function()
      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("dashboard_on_dir_start", { clear = true }),
        once = true,
        callback = function()
          -- Only act when launched with exactly one argument that is a directory.
          if vim.fn.argc(-1) ~= 1 then
            return
          end
          local arg = vim.fn.argv(0)
          if arg == "" or vim.fn.isdirectory(arg) ~= 1 then
            return
          end

          -- Work from that directory so <leader>e and pickers start there.
          vim.cmd.cd(arg)

          -- Render the dashboard into the real (non-floating) window, exactly like
          -- the no-args startup screen. Opening it as a float would cover the whole
          -- editor, so neo-tree (<leader>e) would open *behind* it and stay hidden.
          local win = vim.api.nvim_get_current_win()
          local dir_buf = vim.api.nvim_get_current_buf()
          local buf = vim.api.nvim_create_buf(false, true)
          vim.api.nvim_win_set_buf(win, buf)
          require("snacks").dashboard.open({ win = win, buf = buf })
          pcall(vim.api.nvim_buf_delete, dir_buf, { force = true })
        end,
      })
    end,
    keys = {
      { "<leader>e", false },
      { "<leader>E", false },
      { "<leader>fe", false }, 
      { "<leader>fE", false }, 
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
 

  -- 4. Smooth cursor transitions spec
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
    priority = 999, 
    opts = {
      color_icons = true, 
      override = {
        ts   = { icon = "  ", color = "#00F0FF", name = "Ts" },
        tsx  = { icon = "", color = "#00F0FF", name = "Tsx" },
        js   = { icon = "  ", color = "#FFD200", name = "Js" },
        jsx  = { icon = "", color = "#FFD200", name = "Jsx" },
        json = { icon = "", color = "#73DACA", name = "Json" },
        toml = { icon = "", color = "#73DACA", name = "Toml" },
        yaml = { icon = "", color = "#73DACA", name = "Yaml" },
        md   = { icon = "", color = "#FF9F1C", name = "Md" },
        txt  = { icon = "  ", color = "#FF9F1C", name = "Txt" },
        lock = { icon = "", color = "#BB9AF7", name = "Lock" },
        ["pnpm-lock.yaml"] = { icon = "  ", color = "#BB9AF7", name = "PnpmLock" },
        lua  = { icon = "  ", color = "#FF55FF", name = "Lua" },
        c    = { icon = "", color = "#FF4A5A", name = "C" },
        cpp  = { icon = "", color = "#FF4A5A", name = "Cpp" },
      },
    },
    config = function(_, opts)
      -- FIXED ENDPOINT LOOP HERE:
      require("nvim-web-devicons").setup(opts)
    end,
  },
}

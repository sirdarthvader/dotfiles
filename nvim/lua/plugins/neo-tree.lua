-- Neo-tree is enabled as a LazyVim extra (see lazyvim.json); this only overrides its options.
-- Its neon highlight groups live in colorscheme.lua so they survive theme reloads.
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = true,
      enable_git_status = true,
      enable_diagnostics = true,
      window = {
        width = 30,
        mappings = {
          -- Buffer-local: neo-tree binds <Esc> to "cancel" by default.
          ["<esc>"] = "close_window",
          -- Open the file and close the tree.
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
            info = "\u{f05a}", -- nf-fa-info_circle
            warn = "\u{f071}", -- nf-fa-warning
            error = "\u{f057}", -- nf-fa-times_circle
          },
          highlights = {
            hint = "NeoTreeDiagnosticHint",
            info = "NeoTreeDiagnosticInfo",
            warn = "NeoTreeDiagnosticWarn",
            error = "NeoTreeDiagnosticError",
          },
        },
        git_status = {
          symbols = {
            added = "\u{f067}", -- nf-fa-plus
            untracked = "\u{f128}", -- nf-fa-question
            ignored = "◌",
            staged = "\u{f046}", -- nf-fa-check_square_o
            conflict = "\u{e727}", -- nf-dev-git_merge
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
          -- Show hidden/gitignored items dimmed so you can see they exist; `H` hides them.
          -- This also makes the tree's `/` search include gitignored files, so find_args below excludes build output.
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = { "node_modules", "dist", "build", ".next", ".turbo" },
          never_show = { ".DS_Store" },
          hide_by_pattern = { "**/__*" },
          always_show = { ".copilot*", ".claude*", ".env", ".env.local", ".env.production", ".gitignore" },
          always_show_by_pattern = { ".env*", "*.config.*" },
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
            ".nx",
            "--exclude",
            "target",
            "--exclude",
            "cdk.out",
            "--exclude",
            "coverage",
            "--exclude",
            "__*",
          },
        },
      },
    },
  },
}

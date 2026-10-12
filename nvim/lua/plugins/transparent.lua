return {
  -- Kanagawa Wave — kept available (not active)
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = {
      theme = "wave",
      transparent = true,
    },
  },

  -- Tokyonight Night — vivid but balanced, first-class transparency
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        sidebars = "transparent",
        floats = "transparent",
      },
      on_highlights = function(hl, c)
        -- Punchier syntax + readable UI on a translucent background
        hl.Comment = { fg = "#7f86a8", italic = true }
        hl.LineNr = { fg = "#565f89" }
        hl.CursorLineNr = { fg = "#c0caf5", bold = true }
        hl.NormalFloat = { bg = "none" }
        hl.FloatBorder = { fg = c.blue, bg = "none" }
      end,
    },
  },

  -- Set tokyonight as the active colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },

  -- Universal transparency for all themes
  {
    "LazyVim/LazyVim",
    opts = function(_, _)
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("transparent_bg", { clear = true }),
        callback = function()
          local groups = {
            "Normal",
            "NormalNC",
            "NormalFloat",
            "SignColumn",
            "FloatBorder",
            "NeoTreeNormal",
            "NeoTreeNormalNC",
            "TreesitterContext",
            "NotifyBackground",
            "WhichKeyFloat",
            -- Snacks explorer transparency
            "SnacksExplorerNormal",
            "SnacksExplorerWinBar",
            "SnacksPicker",
            "SnacksPickerList",
            "SnacksPickerPreview",
            "SnacksPickerInput",
            "SnacksPickerBorder",
            -- Sidebar / split backgrounds
            "WinBar",
            "WinBarNC",
            "StatusLine",
            "StatusLineNC",
            "TabLine",
            "TabLineFill",
          }
          for _, group in ipairs(groups) do
            local hl = vim.api.nvim_get_hl(0, { name = group })
            hl.bg = nil
            vim.api.nvim_set_hl(0, group, hl)
          end

          -- Force readable explorer/tree colors on transparent bg (Tokyonight Night palette)
          vim.api.nvim_set_hl(0, "Directory", { fg = "#7aa2f7", bold = true })
          vim.api.nvim_set_hl(0, "SnacksExplorerNormal", { fg = "#c0caf5" })
          vim.api.nvim_set_hl(0, "SnacksExplorerDir", { fg = "#7aa2f7", bold = true })
          vim.api.nvim_set_hl(0, "SnacksExplorerFile", { fg = "#c0caf5" })
          vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#7aa2f7", bold = true })
          vim.api.nvim_set_hl(0, "SnacksPickerFile", { fg = "#c0caf5" })
          vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { fg = "#565f89" })
          vim.api.nvim_set_hl(0, "SnacksPickerGitStatusAdded", { fg = "#9ece6a" })
          vim.api.nvim_set_hl(0, "SnacksPickerGitStatusModified", { fg = "#e0af68" })
          vim.api.nvim_set_hl(0, "SnacksPickerGitStatusDeleted", { fg = "#f7768e" })
          vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUntracked", { fg = "#bb9af7" })
          vim.api.nvim_set_hl(0, "SnacksPickerGitStatusIgnored", { fg = "#565f89" })
        end,
      })
    end,
  },
}

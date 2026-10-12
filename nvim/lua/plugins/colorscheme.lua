-- Backgrounds cleared so the terminal's translucency shows through.
local transparent_groups = {
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
  "SnacksPicker",
  "SnacksPickerList",
  "SnacksPickerPreview",
  "SnacksPickerInput",
  "SnacksPickerBorder",
  "WinBar",
  "WinBarNC",
  "StatusLine",
  "StatusLineNC",
  "TabLine",
  "TabLineFill",
}

-- Neon accents used by neo-tree.lua and ui.lua (file icons).
local neon = {
  NeoTreeDiagnosticError = { fg = "#FF2A7A", bold = true },
  NeoTreeDiagnosticWarn = { fg = "#FFD200", bold = true },
  NeoTreeDiagnosticInfo = { fg = "#00F0FF" },
  NeoTreeDiagnosticHint = { fg = "#9D4EDD" },
  NeoTreeGitAdded = { fg = "#A6E22E" },
  NeoTreeGitModified = { fg = "#FF9F1C" },
  NeoTreeGitDeleted = { fg = "#FF4A5A" },
  NeoTreeGitRenamed = { fg = "#00D2FF" },
  NeoTreeGitUntracked = { fg = "#FF55FF", italic = true },
  NeoTreeGitIgnored = { fg = "#444B6A" },
  NeoTreeGitUnstaged = { fg = "#FF9E64" },
  NeoTreeGitStaged = { fg = "#73DACA" },
  NeoTreeGitConflict = { fg = "#BB9AF7", bold = true },

  NeonCyan = { fg = "#00F0FF" },
  NeonYellow = { fg = "#FFD200" },
  NeonTeal = { fg = "#73DACA" },
  NeonOrange = { fg = "#FF9F1C" },
  NeonPurple = { fg = "#BB9AF7" },
  NeonPink = { fg = "#FF55FF" },
  NeonRed = { fg = "#FF4A5A" },
}

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
    -- `init` runs before any colorscheme loads, so this applies to every theme, not just tokyonight.
    init = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("transparent_bg", { clear = true }),
        callback = function()
          for _, group in ipairs(transparent_groups) do
            local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
            hl.bg = nil
            vim.api.nvim_set_hl(0, group, hl)
          end
          for group, hl in pairs(neon) do
            vim.api.nvim_set_hl(0, group, hl)
          end
        end,
      })
    end,
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

        -- Readable picker/tree colours on a transparent background
        hl.Directory = { fg = c.blue, bold = true }
        hl.SnacksPickerDir = { fg = c.blue, bold = true }
        hl.SnacksPickerFile = { fg = c.fg }
        hl.SnacksPickerPathHidden = { fg = c.comment }
        hl.SnacksPickerGitStatusAdded = { fg = c.green }
        hl.SnacksPickerGitStatusModified = { fg = c.yellow }
        hl.SnacksPickerGitStatusDeleted = { fg = c.red }
        hl.SnacksPickerGitStatusUntracked = { fg = c.magenta }
        hl.SnacksPickerGitStatusIgnored = { fg = c.comment }
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
}

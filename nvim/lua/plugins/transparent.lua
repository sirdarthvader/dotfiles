return {
  -- Cyberdream — high-contrast, transparency-first theme
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      italic_comments = true,
      hide_fillchars = true,
      borderless_pickers = true,
      terminal_colors = true,
      highlights = {
        -- Readable line numbers
        LineNr = { fg = "#a0aab6" },
        LineNrAbove = { fg = "#a0aab6" },
        LineNrBelow = { fg = "#a0aab6" },
        CursorLineNr = { fg = "#ffffff", bold = true },

        -- Readable comments
        Comment = { fg = "#a0aab6", italic = true },
        ["@comment"] = { fg = "#a0aab6", italic = true },

        -- File explorer — directories & files
        Directory = { fg = "#5ef1ff", bold = true },

        -- Tree/explorer structure
        NvimTreeFolderName = { fg = "#5ef1ff", bold = true },
        NvimTreeOpenedFolderName = { fg = "#5ef1ff", bold = true },
        NvimTreeRootFolder = { fg = "#ff6e5a", bold = true },
        NvimTreeFileName = { fg = "#e0e0e0" },

        -- Git status in explorer
        NvimTreeGitDirty = { fg = "#ffbd5e" },
        NvimTreeGitNew = { fg = "#5eff6c" },
        NvimTreeGitDeleted = { fg = "#ff6e5a" },
        NvimTreeGitStaged = { fg = "#5eff6c" },
        NvimTreeGitIgnored = { fg = "#7b8496" },

        -- Snacks explorer specific
        SnacksExplorerDir = { fg = "#5ef1ff", bold = true },
        SnacksExplorerFile = { fg = "#e0e0e0" },
        SnacksExplorerGitModified = { fg = "#ffbd5e" },
        SnacksExplorerGitAdded = { fg = "#5eff6c" },
        SnacksExplorerGitDeleted = { fg = "#ff6e5a" },
      },
    },
  },

  -- Set cyberdream as the active colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "cyberdream",
    },
  },

  -- Tokyonight native transparency (kept as fallback)
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },

  -- Universal transparency for all themes
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
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

          -- Force readable explorer/tree colors on transparent bg
          vim.api.nvim_set_hl(0, "Directory", { fg = "#5ef1ff", bold = true })
          vim.api.nvim_set_hl(0, "SnacksExplorerNormal", { fg = "#e0e0e0" })
          vim.api.nvim_set_hl(0, "SnacksExplorerDir", { fg = "#5ef1ff", bold = true })
          vim.api.nvim_set_hl(0, "SnacksExplorerFile", { fg = "#e0e0e0" })
          vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#5ef1ff", bold = true })
          vim.api.nvim_set_hl(0, "SnacksPickerFile", { fg = "#e0e0e0" })
          vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { fg = "#7b8496" })
          vim.api.nvim_set_hl(0, "SnacksPickerGitStatusAdded", { fg = "#5eff6c" })
          vim.api.nvim_set_hl(0, "SnacksPickerGitStatusModified", { fg = "#ffbd5e" })
          vim.api.nvim_set_hl(0, "SnacksPickerGitStatusDeleted", { fg = "#ff6e5a" })
          vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUntracked", { fg = "#bd5eff" })
          vim.api.nvim_set_hl(0, "SnacksPickerGitStatusIgnored", { fg = "#7b8496" })
        end,
      })
    end,
  },
}

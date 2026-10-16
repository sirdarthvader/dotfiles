return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", vim.fn.stdpath("config") .. "/.markdownlint.jsonc", "-" },
        },
      },
    },
  },

  -- In-editor rendering. LazyVim ships it minimal (no heading icons, no checkboxes); turn those back on.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      heading = { icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " } },
      checkbox = { enabled = true },
      pipe_table = { preset = "round" },
    },
  },

  -- Images and ```mermaid blocks drawn inline (Ghostty graphics via tmux passthrough).
  -- Needs `magick` for non-PNG images and `mmdc` for mermaid; see :checkhealth snacks.
  {
    "folke/snacks.nvim",
    opts = { image = { enabled = true } },
  },
}

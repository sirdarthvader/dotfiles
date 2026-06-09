local headers = require("dashboard.headers")
local quotes = require("dashboard.quotes")
local ascii_art = require("dashboard.ascii_art")

-- Seed with a high-resolution, per-launch value so every new Neovim instance
-- (e.g. opening a different repo) gets a fresh header + quote, not once a day.
math.randomseed((vim.uv or vim.loop).hrtime())

local header = headers[math.random(#headers)]
local quote = quotes[math.random(#quotes)]
local art = ascii_art[math.random(#ascii_art)]

-- Split the quote into lines and give each line the same indent so they align.
local quote_lines = {}
for line in (quote .. "\n"):gmatch("([^\n]*)\n") do
  line = line:gsub("^%s+", ""):gsub("%s+$", "")
  table.insert(quote_lines, { "  " .. line, hl = "WarningMsg" })
  table.insert(quote_lines, { "\n" })
end

return {
  {
    "snacks.nvim",
    opts = {
      dashboard = {
        width = 55,
        pane_gap = 20,
        preset = {
          header = header,
          -- Customize the options list rendered by `section = "keys"`.
          -- Remove, reorder, or add entries here to taste.
          -- `action` can be a `:command` string, a keymap string, or a function.
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          -- RIGHT PANE — ASCII Art
          {
            pane = 2,
            text = {
              -- Left-align: ASCII art relies on its own internal spacing.
              -- Centering would re-center each line independently and distort it.
              { art, hl = "DiagnosticInfo", align = "left" },
            },
          },

          -- LEFT PANE — header + greeting + quote + keys
          { pane = 1, section = "header", padding = 2 },
          {
            pane = 1,
            text = { { "  ⚡ Welcome back, Ashish!", hl = "Special" } },
            padding = 1,
          },
          { pane = 1, section = "keys", gap = 1, padding = 1 },
          { pane = 1, section = "startup", padding = 2 },

          {
            pane = 1,
            text = quote_lines,
            padding = 1,
            gap = 3,
          },
        },
      },
    },
  },
}

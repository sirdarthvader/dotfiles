local headers = require("dashboard.headers")
local quotes = require("dashboard.quotes")
local ascii_art = require("dashboard.ascii_art")

local day = tonumber(os.date("%j"))
local header = headers[(day % #headers) + 1]
local quote = quotes[(day % #quotes) + 1]

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
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          -- RIGHT PANE — ASCII Art
          {
            pane = 2,
            text = {
              { ascii_art, hl = "DiagnosticInfo", align = "center" },
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
          { pane = 1, section = "startup", padding = 2,  },

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
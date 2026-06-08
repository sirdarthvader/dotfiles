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
        width = 68,
        pane_gap = 8,
        preset = {
          header = header,
        },
        sections = {
          -- RIGHT PANE — ASCII Art
          {
            pane = 2,
            text = {
              { ascii_art, hl = "DiagnosticInfo" },
            },
            padding = 2,
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
            gap = 2,
          },
        },
      },
    },
  },
}
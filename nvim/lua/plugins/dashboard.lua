local headers = require("dashboard.headers")
local quotes = require("dashboard.quotes")
local ascii_art = require("dashboard.ascii_art")

-- Seed with a high-resolution, per-launch value so every new Neovim instance
-- (e.g. opening a different repo) gets a fresh header + quote, not once a day.
math.randomseed((vim.uv or vim.loop).hrtime())

local header = headers[math.random(#headers)]
local quote = quotes[math.random(#quotes)]

local WIDTH, PANE_GAP = 55, 20

-- The dashboard only appears for `nvim` or `nvim <dir>`; don't advance the art carousel otherwise.
local argc = vim.fn.argc(-1)
local shows_dashboard = argc == 0 or (argc == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1)

-- Strip leading/trailing blank lines so arts don't add stray vertical gaps.
local function trim_vertical(s)
  local lines = {}
  for line in (s .. "\n"):gmatch("([^\n]*)\n") do
    lines[#lines + 1] = line
  end
  while lines[1] and lines[1]:match("^%s*$") do
    table.remove(lines, 1)
  end
  while lines[#lines] and lines[#lines]:match("^%s*$") do
    table.remove(lines)
  end
  return table.concat(lines, "\n")
end

local function art_size(s)
  local height, width = 0, 0
  for line in (s .. "\n"):gmatch("([^\n]*)\n") do
    height = height + 1
    local w = vim.fn.strdisplaywidth(line)
    if w > width then
      width = w
    end
  end
  return height, width
end

-- Only choose arts that fit the current window, so the dashboard stays
-- vertically centered instead of overflowing and pinning to the top.
-- Oversized arts are skipped (not deleted) — they'll show on bigger windows.
--
-- Selection works like a carousel: a shuffled "deck" of art indices is saved to
-- disk and dealt one card per launch. No art repeats until the whole deck has
-- been shown, then it reshuffles — and the reshuffle never starts with the art
-- you just saw, so you never get the same image twice in a row across restarts.
local STATE_PATH = vim.fn.stdpath("state") .. "/dashboard_art.json"

local function load_state()
  local f = io.open(STATE_PATH, "r")
  if not f then
    return {}
  end
  local content = f:read("*a")
  f:close()
  local ok, data = pcall(vim.json.decode, content)
  return (ok and type(data) == "table") and data or {}
end

local function save_state(state)
  local f = io.open(STATE_PATH, "w")
  if not f then
    return
  end
  f:write(vim.json.encode(state))
  f:close()
end

-- Fisher-Yates shuffle; if `avoid_first` is given, make sure the deck doesn't
-- start with that index (prevents a back-to-back repeat across reshuffles).
local function shuffle(list, avoid_first)
  for i = #list, 2, -1 do
    local j = math.random(i)
    list[i], list[j] = list[j], list[i]
  end
  if avoid_first and #list > 1 and list[1] == avoid_first then
    list[1], list[#list] = list[#list], list[1]
  end
  return list
end

local function pick_art(arts)
  local max_h = vim.o.lines - 4 -- leave room for cmdline/status + breathing space
  local max_w = vim.o.columns - WIDTH - PANE_GAP

  -- Trim + measure every art once; collect the indices that fit the window.
  local trimmed, fit_idx = {}, {}
  local smallest, smallest_h = nil, math.huge
  for i, raw in ipairs(arts) do
    local art = trim_vertical(raw)
    trimmed[i] = art
    local h, w = art_size(art)
    if h < smallest_h then
      smallest, smallest_h = art, h
    end
    if h <= max_h and w <= max_w then
      fit_idx[#fit_idx + 1] = i
    end
  end

  -- Tiny window where nothing fits: just show the most compact art.
  if #fit_idx == 0 then
    return smallest
  end

  -- Signature of the fitting set, so the deck rebuilds if a window resize
  -- changes which arts are eligible.
  local sig = table.concat(fit_idx, ",")

  local state = load_state()
  local order, pos, last = state.order, state.pos or 1, state.last

  -- Build a fresh shuffled deck of the fitting arts if the saved deck is
  -- missing, exhausted, or no longer matches the current fitting set.
  if state.sig ~= sig or type(order) ~= "table" or pos > #order then
    order = {}
    for _, idx in ipairs(fit_idx) do
      order[#order + 1] = idx
    end
    shuffle(order, last) -- never start a new cycle with the last shown art
    pos = 1
  end

  local chosen = order[pos]
  save_state({ order = order, pos = pos + 1, last = chosen, sig = sig })
  return trimmed[chosen]
end

local art = shows_dashboard and pick_art(ascii_art) or ""

return {
  {
    "snacks.nvim",
    -- Snacks skips the dashboard for `nvim <dir>`, so show it ourselves in that case.
    init = function()
      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("dashboard_on_dir_start", { clear = true }),
        once = true,
        callback = function()
          if vim.fn.argc(-1) ~= 1 then
            return
          end
          local arg = vim.fn.argv(0)
          if arg == "" or vim.fn.isdirectory(arg) ~= 1 then
            return
          end

          vim.cmd.cd(arg)

          -- Use the real window, not a float, so neo-tree (<leader>e) isn't hidden behind it.
          local win = vim.api.nvim_get_current_win()
          local dir_buf = vim.api.nvim_get_current_buf()
          local buf = vim.api.nvim_create_buf(false, true)
          vim.api.nvim_win_set_buf(win, buf)
          require("snacks").dashboard.open({ win = win, buf = buf })
          pcall(vim.api.nvim_buf_delete, dir_buf, { force = true })
        end,
      })
    end,
    opts = {
      dashboard = {
        width = WIDTH,
        pane_gap = PANE_GAP,
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
            text = { { quote, hl = "WarningMsg" } },
            padding = 1,
            gap = 3,
          },
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
        },
      },
    },
  },
}

-- AI workflow: the agent (claude / copilot CLI) lives in a tmux pane beside nvim,
-- managed by ~/.config/tmux/ai.sh. sidekick.nvim sends editor context to it;
-- claudecode.nvim lets Claude see the editor and show its edits as diffs here.
local ai_sh = vim.fn.expand("~/.config/tmux/ai.sh")

-- claudecode.nvim's port, so ai.sh pins the new Claude pane to this nvim.
local function ide_port()
  local ok, claudecode = pcall(require, "claudecode")
  return ok and claudecode.state.port and tostring(claudecode.state.port) or nil
end

local function ai(action)
  vim.system({ ai_sh, action, vim.env.TMUX_PANE }, { env = { CLAUDE_CODE_SSE_PORT = ide_port() } })
end

-- Send context to this project's AI pane (revealing it if hidden).
local function send(opts)
  if vim.env.TMUX then
    local filter = { started = true, cwd = true }
    if #require("sidekick.cli.state").get(filter) == 0 then
      vim.notify("No AI pane for this project. Open one with <leader>aa", vim.log.levels.WARN)
      return
    end
    opts.filter = filter
    ai("show")
  end
  require("sidekick.cli").send(opts)
end

return {
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        mux = { enabled = true, backend = "tmux", create = "split", split = { size = 0.4 } },
      },
    },
    -- stylua: ignore
    keys = {
      {
        "<leader>aa",
        function()
          if vim.env.TMUX then ai("toggle") else require("sidekick.cli").toggle() end
        end,
        desc = "AI pane (toggle)",
      },
      {
        "<leader>aA",
        function()
          local cmd = { "tmux", "display-popup", "-E", "-w", "40%", "-h", "30%" }
          local port = ide_port()
          if port then vim.list_extend(cmd, { "-e", "CLAUDE_CODE_SSE_PORT=" .. port }) end
          table.insert(cmd, ai_sh .. " pick " .. vim.env.TMUX_PANE)
          vim.system(cmd)
        end,
        desc = "AI pane: pick tool / resume",
      },
      { "<c-.>", function() ai("focus") end, mode = { "n", "t", "i", "x" }, desc = "Focus AI pane" },
      { "<leader>aw", function() ai("pop") end, desc = "AI pane: own window / dock back" },
      { "<leader>at", function() send({ msg = "{this}" }) end, mode = { "n", "x" }, desc = "Send This" },
      { "<leader>af", function() send({ msg = "{file}" }) end, desc = "Send File" },
      { "<leader>av", function() send({ msg = "{selection}" }) end, mode = "x", desc = "Send Selection" },
      {
        "<leader>ap",
        function()
          require("sidekick.cli").prompt(function(_, text)
            if text then send({ text = text }) end
          end)
        end,
        mode = { "n", "x" },
        desc = "Send Prompt",
      },
    },
  },

  {
    "coder/claudecode.nvim",
    event = "VeryLazy",
    opts = {
      -- Claude runs in the tmux pane (`claude --ide` connects to this nvim).
      terminal = { provider = "none" },
    },
    keys = {
      -- In the file tree / picker list: attach the file or folder under the cursor (Tab-marked items in snacks).
      {
        "<leader>ac",
        function()
          vim.cmd("ClaudeCodeTreeAdd")
          if vim.env.TMUX then ai("show") end
        end,
        ft = { "neo-tree", "snacks_picker_list" },
        desc = "Add file/folder to Claude",
      },
      { "<leader>ay", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
      { "<leader>an", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Reject Claude diff" },
    },
  },
}

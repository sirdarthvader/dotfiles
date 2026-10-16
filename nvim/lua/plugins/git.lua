-- Review everything that changed (e.g. after Claude's edits) side by side, like VS Code's Source Control view.
return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    opts = {
      keymaps = {
        view = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } } },
        file_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } } },
        file_history_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } } },
      },
    },
    keys = {
      {
        "<leader>gv",
        function()
          if require("diffview.lib").get_current_view() then
            vim.cmd("DiffviewClose")
          else
            vim.cmd("DiffviewOpen")
          end
        end,
        desc = "Review changes (diffview)",
      },
      { "<leader>gV", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (diffview)" },
      { "<leader>gm", "<cmd>DiffviewOpen origin/HEAD...HEAD<cr>", desc = "Review branch vs main (diffview)" },
    },
  },
}

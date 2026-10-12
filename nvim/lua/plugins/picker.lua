return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          -- Gitignored files are already skipped; these also cover folders outside git repos.
          files = { exclude = { "**/node_modules", "**/dist", "**/cdk.out" } },
          grep = { exclude = { "**/node_modules", "**/dist" } },
        },
      },
    },
  },
}

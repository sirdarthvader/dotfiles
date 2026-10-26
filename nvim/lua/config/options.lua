-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Root = git root, so monorepos search from the top instead of the package the LSP picked.
vim.g.root_spec = { { ".git" }, "lsp", "cwd" }

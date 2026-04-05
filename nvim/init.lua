-- ============================================================
-- NEOVIM CONFIG — JS/TS (from VS Code)
-- Place this file at: ~/.config/nvim/init.lua
-- Then open nvim — lazy.nvim will auto-install everything.
-- ============================================================

-- [[ LEADER KEY ]]
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ COMPATIBILITY SHIM ]]
if not vim.treesitter.language.ft_to_lang then
  vim.treesitter.language.ft_to_lang = vim.treesitter.language.get_lang
end

-- [[ CORE OPTIONS ]]
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.termguicolors = true

-- [[ BASIC KEYMAPS ]]
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Buffer management
vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Close current buffer" })
vim.keymap.set("n", "<leader>ba", "<cmd>%bd|e#|bd#<CR>", { desc = "Close all other buffers" })
vim.keymap.set("n", "<leader>bx", "<cmd>%bd<CR>", { desc = "Close ALL buffers" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- [[ DIAGNOSTICS ]]
vim.diagnostic.config({
  underline = true,
  virtual_text = { spacing = 4, prefix = "●" },
  signs = true,
  severity_sort = true,
  update_in_insert = false,
})

-- ============================================================
-- [[ PLUGIN MANAGER: lazy.nvim ]]
-- ============================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================
-- [[ PLUGINS ]]
-- ============================================================
require("lazy").setup({

  -- Theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({ flavour = "mocha" })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Which-key (shows keybind hints)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup()
      wk.add({
        { "<leader>f", group = "Find (Telescope)" },
        { "<leader>l", group = "LSP" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "Harpoon" },
        { "<leader>c", group = "Copilot" },
        { "<leader>a", group = "AI (Claude)" },
        { "<leader>b", group = "Buffers" },
        { "<leader>x", group = "Trouble (diagnostics)" },
      })
    end,
  },

  -- Telescope (fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git/", "dist/" },
        },
      })
      telescope.load_extension("fzf")

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Grep in project" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Open buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
      vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Symbols in file" })
      vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
      vim.keymap.set("n", "<leader>f.", builtin.resume, { desc = "Resume last search" })
    end,
  },

  -- Treesitter (syntax highlighting)
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "javascript", "typescript", "tsx", "html", "css", "json",
          "lua", "markdown", "bash", "vim", "vimdoc",
        },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "javascript", "typescript", "typescriptreact", "javascriptreact",
          "html", "css", "json", "lua", "markdown", "bash", "vim",
        },
        callback = function()
          local ok = pcall(vim.treesitter.start)
          if ok then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    lazy = false,
  },
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "ts_ls", "eslint", "html", "cssls", "jsonls" },
      })

      vim.lsp.config("*", {
        root_markers = { ".git", "package.json", "tsconfig.json" },
      })

      vim.lsp.enable({ "ts_ls", "eslint", "html", "cssls", "jsonls" })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
          end
          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gr", vim.lsp.buf.references, "Find references")
          map("gi", vim.lsp.buf.implementation, "Go to implementation")
          map("K", vim.lsp.buf.hover, "Hover docs")
          map("<leader>lr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>la", vim.lsp.buf.code_action, "Code action")
          map("<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
          map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
          map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
        end,
      })
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<C-e>"] = cmp.mapping.abort(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- Autopairs
  { "windwp/nvim-autopairs", event = "InsertEnter", config = true },

  -- Neo-tree (sidebar file explorer)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        filesystem = {
          follow_current_file = { enabled = true },
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = { "node_modules", ".git" },
          },
        },
        window = {
          width = 35,
          mappings = { ["<space>"] = "none" },
        },
        git_status = {
          symbols = {
            untracked = "",
            ignored   = "",
            unstaged  = "●",
            staged    = "✓",
            conflict  = "",
          },
        },
      })
      vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "File explorer" })
      vim.keymap.set("n", "<leader>o", "<cmd>Neotree reveal<CR>", { desc = "Reveal file in explorer" })
    end,
  },

  -- Oil (edit filesystem as buffer)
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup()
      vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open file explorer" })
    end,
  },

  -- Gitsigns
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
      vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>", { desc = "Git blame line" })
      vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({ options = { theme = "auto" } })
    end,
  },

  -- Harpoon (pin files)
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
      vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon: add file" })
      vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: menu" })
      vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
      vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
      vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
      vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })
    end,
  },

  -- Formatting (Prettier)
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          javascript = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          javascriptreact = { "prettier" },
          json = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          markdown = { "prettier" },
        },
        format_on_save = function(bufnr)
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          if bufname:match("node_modules") then return end
          return { timeout_ms = 3000, lsp_format = "fallback" }
        end,
        formatters = {
          prettier = { prepend_args = {}, require_cwd = true },
        },
      })
      vim.keymap.set("n", "<leader>lf", function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end, { desc = "Format file" })
    end,
  },

  -- Comment toggling
  { "numToStr/Comment.nvim", config = true },

  -- Indent guides
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", config = true },

  -- TODO comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup()
      vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find TODOs" })
    end,
  },

  -- Surround
  { "kylechui/nvim-surround", event = "VeryLazy", config = true },

  -- Trouble (diagnostics panel)
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup()
      vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "All diagnostics" })
      vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer diagnostics" })
    end,
  },

  -- LazyGit
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "LazyGit" })
    end,
  },

  -- GitHub Copilot (inline suggestions)
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.keymap.set("i", "<C-j>", 'copilot#Accept("<CR>")', {
        expr = true, replace_keycodes = false, desc = "Accept Copilot suggestion",
      })
    end,
  },

  -- Copilot Chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    config = function()
      require("CopilotChat").setup()
      vim.keymap.set("n", "<leader>cc", "<cmd>CopilotChatToggle<CR>", { desc = "Copilot Chat toggle" })
      vim.keymap.set("v", "<leader>ce", "<cmd>CopilotChatExplain<CR>", { desc = "Copilot explain" })
      vim.keymap.set("v", "<leader>cr", "<cmd>CopilotChatReview<CR>", { desc = "Copilot review" })
      vim.keymap.set("v", "<leader>cf", "<cmd>CopilotChatFix<CR>", { desc = "Copilot fix" })
    end,
  },

  -- Claude Code
  {
    "coder/claudecode.nvim",
    config = function()
      require("claudecode").setup()
      vim.keymap.set("n", "<leader>ac", "<cmd>ClaudeCode<CR>", { desc = "Claude Code toggle" })
      vim.keymap.set("v", "<leader>as", "<cmd>ClaudeCodeSend<CR>", { desc = "Send to Claude" })
    end,
  },

}, {
  checker = { enabled = true, notify = false },
})

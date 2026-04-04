-- ============================================================
-- NEOVIM STARTER CONFIG — JS/TS (from VS Code)
-- Place this file at: ~/.config/nvim/init.lua
-- Then open nvim — lazy.nvim will auto-install everything.
-- ============================================================

-- [[ LEADER KEY ]]
-- Space as leader — this is your "command prefix" for custom keybinds.
-- In VS Code terms, think of it like Ctrl+Shift+P but faster.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ COMPATIBILITY SHIM ]]
-- Neovim 0.11+ removed ft_to_lang, but some plugins still reference it.
-- This polyfill prevents "attempt to call field 'ft_to_lang' (a nil value)" errors.
if not vim.treesitter.language.ft_to_lang then
  vim.treesitter.language.ft_to_lang = vim.treesitter.language.get_lang
end

-- [[ CORE OPTIONS ]]
vim.opt.number = true         -- line numbers
vim.opt.relativenumber = true -- relative line numbers (makes j/k jumps easy: 12j)
vim.opt.mouse = "a"           -- mouse support (yes, it's ok to use it sometimes)
vim.opt.showmode = false       -- statusline plugin handles this
vim.opt.clipboard = "unnamedplus" -- use system clipboard (y and p work with Ctrl+C/V)
vim.opt.breakindent = true    -- wrapped lines respect indentation
vim.opt.undofile = true       -- persistent undo across sessions
vim.opt.ignorecase = true     -- case-insensitive search...
vim.opt.smartcase = true      -- ...unless you use a capital letter
vim.opt.signcolumn = "yes"    -- always show sign column (no layout shift)
vim.opt.updatetime = 250      -- faster CursorHold events
vim.opt.timeoutlen = 300      -- faster which-key popup
vim.opt.splitright = true     -- vertical splits open right
vim.opt.splitbelow = true     -- horizontal splits open below
vim.opt.inccommand = "split"  -- live preview of :s substitutions
vim.opt.cursorline = true     -- highlight current line
vim.opt.scrolloff = 10        -- keep 10 lines visible above/below cursor
vim.opt.tabstop = 2           -- JS/TS convention: 2 spaces
vim.opt.shiftwidth = 2
vim.opt.expandtab = true      -- spaces, not tabs
vim.opt.termguicolors = true  -- full color support

-- [[ BASIC KEYMAPS ]]
-- Clear search highlight with Escape
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Move selected lines up/down in visual mode (like Alt+Up/Down in VS Code)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor centered when scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keep cursor centered when jumping between search results
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Better window navigation (Ctrl+h/j/k/l instead of Ctrl-W then h/j/k/l)
vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")

-- Quick save
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })

-- Exit terminal mode with Esc (much more natural)
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Buffer management
vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Close current buffer" })
vim.keymap.set("n", "<leader>ba", "<cmd>%bd|e#|bd#<CR>", { desc = "Close all other buffers" })
vim.keymap.set("n", "<leader>bx", "<cmd>%bd<CR>", { desc = "Close ALL buffers" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- [[ DIAGNOSTICS ]]
-- Make errors clearly visible with underlines and inline text.
-- This replicates the red/yellow squiggly lines from VS Code.
vim.diagnostic.config({
  underline = true,           -- squiggly underlines on errors
  virtual_text = {
    spacing = 4,
    prefix = "●",             -- symbol shown before the error message
  },
  signs = true,               -- signs in the gutter (left column)
  severity_sort = true,       -- show errors before warnings
  update_in_insert = false,   -- don't update while you're typing (less noisy)
})

-- ============================================================
-- [[ PLUGIN MANAGER: lazy.nvim ]]
-- This auto-installs itself on first run. No manual steps needed.
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

  -- ── THEME ──────────────────────────────────────────────
  -- Catppuccin: easy on the eyes, great TS/JS highlighting
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({ flavour = "mocha" })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- ── WHICH-KEY ──────────────────────────────────────────
  -- Press <leader> and wait — shows all available keybinds.
  -- This is your training wheels. You'll memorize binds over time.
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

  -- ── TELESCOPE (fuzzy finder) ───────────────────────────
  -- This replaces VS Code's Ctrl+P (files), Ctrl+Shift+F (search), etc.
  -- Uses your installed fd and fzf for speed.
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
      telescope.load_extension("fzf") -- uses your installed fzf

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

  -- ── TREESITTER (syntax highlighting + code understanding) ─
  -- Makes JS/TS/JSX/TSX look beautiful and enables smart text objects.
  -- Must NOT be lazy-loaded.
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

      -- Enable treesitter-based highlighting for your filetypes
      -- Uses pcall so it silently skips if the parser isn't installed yet.
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

  -- ── LSP (Language Server Protocol) ─────────────────────
  -- This gives you: autocomplete, go-to-definition, hover docs,
  -- rename symbol, diagnostics — everything you had in VS Code.
  --
  -- nvim-lspconfig now just provides server config data.
  -- We use Neovim's built-in vim.lsp.config() + vim.lsp.enable().
  {
    "neovim/nvim-lspconfig",
    lazy = false, -- must load early so lsp/ configs are in the runtimepath
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

      -- Global LSP defaults (applied to all servers)
      vim.lsp.config("*", {
        root_markers = { ".git", "package.json", "tsconfig.json" },
      })

      -- Enable the servers — Neovim finds their configs from nvim-lspconfig's lsp/ dir
      vim.lsp.enable({ "ts_ls", "eslint", "html", "cssls", "jsonls" })

      -- LSP keymaps — set when a server attaches to a buffer
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

  -- ── AUTOCOMPLETION ─────────────────────────────────────
  -- nvim-cmp: the completion engine. Works like VS Code's IntelliSense.
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",    -- LSP completions
      "hrsh7th/cmp-buffer",       -- words from current buffer
      "hrsh7th/cmp-path",         -- file paths
      "L3MON4D3/LuaSnip",        -- snippet engine
      "saadparwaiz1/cmp_luasnip", -- snippet completions
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),      -- trigger completion
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- accept
          ["<Tab>"] = cmp.mapping.select_next_item(),  -- next suggestion
          ["<S-Tab>"] = cmp.mapping.select_prev_item(), -- prev suggestion
          ["<C-e>"] = cmp.mapping.abort(),             -- dismiss
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

  -- ── AUTOPAIRS ──────────────────────────────────────────
  -- Auto-close brackets, quotes, etc. Like VS Code does by default.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- ── FILE EXPLORER (sidebar like VS Code) ─────────────────
  -- Neo-tree: toggle a file tree sidebar on the left.
  -- Space+e to toggle, just like Ctrl+Shift+E in VS Code.
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- file icons
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        filesystem = {
          follow_current_file = { enabled = true }, -- auto-reveal current file
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = { "node_modules", ".git" },
          },
        },
        window = {
          width = 35,
          mappings = {
            ["<space>"] = "none", -- don't conflict with leader key
          },
        },
        git_status = {
          symbols = {
            -- Change these to "" to hide them entirely
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

  -- ── FILE EXPLORER (oil.nvim — edit filesystem as buffer) ─
  -- oil.nvim: edit your filesystem like a buffer. Feels very Vim-native.
  -- (You also have yazi for terminal-based file management!)
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup()
      vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open file explorer" })
    end,
  },

  -- ── GIT ────────────────────────────────────────────────
  -- Gitsigns: git blame, diff indicators in the gutter.
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
      vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>", { desc = "Git blame line" })
      vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
    end,
  },

  -- ── STATUSLINE ─────────────────────────────────────────
  -- Lualine: clean status bar at the bottom.
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({ options = { theme = "auto" } })
    end,
  },

  -- ── HARPOON (quick file switching) ──────────────────────
  -- Pin files you're actively working on, jump between them instantly.
  -- Perfect for monorepos where you bounce between packages.
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

  -- ── FORMATTING (Prettier + others) ──────────────────────
  -- conform.nvim runs formatters like Prettier on save.
  -- It looks for prettier in: node_modules/.bin/ first, then Mason, then global.
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
          -- Don't format if the file is too large or not in a project
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          if bufname:match("node_modules") then
            return
          end
          return {
            timeout_ms = 3000,
            lsp_format = "fallback",
          }
        end,
        formatters = {
          prettier = {
            -- Prefer the project-local prettier from node_modules
            prepend_args = {},
            require_cwd = true, -- only run if a prettier config is found
          },
        },
      })

      vim.keymap.set("n", "<leader>lf", function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end, { desc = "Format file" })
    end,
  },

  -- ── COMMENT TOGGLING ──────────────────────────────────
  -- gcc to toggle comment on a line, gc in visual mode.
  -- Replaces VS Code's Ctrl+/ 
  { "numToStr/Comment.nvim", config = true },

  -- ── INDENT GUIDES ──────────────────────────────────────
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", config = true },

  -- ── TODO COMMENTS ──────────────────────────────────────
  -- Highlights TODO, FIXME, HACK, NOTE etc. in your code.
  -- Space+ft to search all TODOs across your project.
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup()
      vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find TODOs" })
    end,
  },

  -- ── SURROUND ───────────────────────────────────────────
  -- Quickly add/change/delete surrounding characters.
  -- ysiw" → surround word with quotes
  -- cs"'  → change surrounding " to '
  -- ds"   → delete surrounding "
  -- In visual mode: S" → surround selection with "
  { "kylechui/nvim-surround", event = "VeryLazy", config = true },

  -- ── TROUBLE (better diagnostics list) ──────────────────
  -- A pretty list of all errors/warnings in your project.
  -- Like VS Code's "Problems" panel.
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup()
      vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "All diagnostics" })
      vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer diagnostics" })
    end,
  },

  -- ── LAZYGIT ────────────────────────────────────────────
  -- Full git UI inside Neovim. Stage, commit, push, resolve
  -- merge conflicts — all without leaving the editor.
  -- Requires: brew install lazygit (or your package manager)
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "LazyGit" })
    end,
  },

  -- ── GITHUB COPILOT (inline suggestions) ────────────────
  -- Ghost text appears as you type, press Tab to accept.
  -- First time: run :Copilot auth to sign in with your GitHub account.
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      -- Don't let Copilot map Tab if it conflicts with nvim-cmp
      vim.g.copilot_no_tab_map = true
      -- Use Ctrl-j to accept Copilot suggestions instead
      vim.keymap.set("i", "<C-j>", 'copilot#Accept("<CR>")', {
        expr = true,
        replace_keycodes = false,
        desc = "Accept Copilot suggestion",
      })
      -- Ctrl-] to dismiss, Alt-] for next suggestion, Alt-[ for previous
    end,
  },

  -- ── COPILOT CHAT ───────────────────────────────────────
  -- Chat with Copilot about your code. Select code + ask questions.
  -- Usage: <leader>cc to toggle chat, <leader>ce to explain selection
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
      vim.keymap.set("v", "<leader>ce", "<cmd>CopilotChatExplain<CR>", { desc = "Copilot explain selection" })
      vim.keymap.set("v", "<leader>cr", "<cmd>CopilotChatReview<CR>", { desc = "Copilot review selection" })
      vim.keymap.set("v", "<leader>cf", "<cmd>CopilotChatFix<CR>", { desc = "Copilot fix selection" })
    end,
  },

  -- ── CLAUDE CODE ────────────────────────────────────────
  -- Connects Neovim to Claude Code CLI so Claude can see and edit
  -- your files directly. Run :ClaudeCode to open Claude in a split.
  -- Requires: Claude Code CLI installed (npm install -g @anthropic-ai/claude-code)
  {
    "coder/claudecode.nvim",
    config = function()
      require("claudecode").setup()
      vim.keymap.set("n", "<leader>ac", "<cmd>ClaudeCode<CR>", { desc = "Claude Code toggle" })
      vim.keymap.set("v", "<leader>as", "<cmd>ClaudeCodeSend<CR>", { desc = "Send selection to Claude" })
    end,
  },

}, {
  -- lazy.nvim options
  checker = { enabled = true, notify = false }, -- auto-check for plugin updates
})
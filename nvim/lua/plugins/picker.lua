-- Build/dependency folders to skip even when gitignored files are included.
local junk =
  { "**/node_modules", "**/dist", "**/build", "**/cdk.out", "**/coverage", "**/.next", "**/.turbo", "**/.cache" }

-- Pick a folder under the repo root and reveal it in neo-tree.
local function find_dirs()
  local root = LazyVim.root()
  local args = { "--type", "d", "--hidden", "--color", "never", "-E", ".git" }
  for _, e in ipairs(junk) do
    vim.list_extend(args, { "-E", e })
  end
  Snacks.picker.pick({
    title = "Folders",
    cwd = root,
    format = "file",
    finder = function(opts, ctx)
      return require("snacks.picker.source.proc").proc(
        ctx:opts({
          cmd = "fd",
          args = args,
          transform = function(item)
            item.cwd = root
            item.file = item.text:gsub("/$", "") -- fd adds a trailing slash to dirs
            item.dir = true
          end,
        }),
        ctx
      )
    end,
    confirm = function(picker, item)
      picker:close()
      if item then
        require("neo-tree.command").execute({
          source = "filesystem",
          dir = root,
          reveal_file = vim.fs.joinpath(root, item.file),
          reveal_force_cwd = true,
        })
      end
    end,
  })
end

return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          -- Gitignored files are already skipped; these also cover folders outside git repos.
          -- hidden: show dotfiles like .env.template and .github/ (.git itself stays excluded).
          files = { hidden = true, exclude = { "**/node_modules", "**/dist", "**/cdk.out" } },
          grep = { hidden = true, exclude = { "**/node_modules", "**/dist" } },
        },
      },
    },
    keys = {
      {
        "<leader>fP",
        function()
          Snacks.picker.files({ cwd = vim.fs.root(0, "package.json") or LazyVim.root() })
        end,
        desc = "Find Files (current package)",
      },
      {
        "<leader>fi",
        function()
          Snacks.picker.files({ cwd = LazyVim.root(), ignored = true, exclude = junk })
        end,
        desc = "Find Files (incl. gitignored, e.g. .env.local)",
      },
      { "<leader>fd", find_dirs, desc = "Find Folder (reveal in tree)" },
    },
  },
}

# dotfiles

The best OG dot files setup of all time!

A terminal-first setup on macOS: **Ghostty → tmux → Neovim (LazyVim) + Claude Code**, with zsh, lazygit,
fzf, bat, eza, zoxide and yazi around it. One tmux session per project, one Claude per task, and git
worktrees so parallel tasks never touch each other.

Every key and command is listed in **[`nvim/CHEATSHEET.md`](nvim/CHEATSHEET.md)** (start with its
"Start here" section).

## What's in here

`setup.sh` links each folder to where the tool looks for it, so editing either path edits the repo.

| Folder | Linked to | What |
| --- | --- | --- |
| `zsh/zshrc` | `~/.zshrc` | oh-my-zsh, starship, aliases, fzf/bat/eza/zoxide, `wt` / `wtrm` worktree functions |
| `tmux/` | `~/.config/tmux`, `~/.tmux.conf` | Config (prefix `Ctrl+a`), project sessionizer, AI pane, scratch popup, close-project cleanup |
| `nvim/` | `~/.config/nvim` | LazyVim config + the cheatsheet |
| `ghostty/` | `~/.config/ghostty` | Theme, keys, auto-attach to tmux, shuffled wallpaper |
| `starship/` | `~/.config/starship` | Prompt |
| `bat/` | `~/.config/bat` | Tokyo Night theme (bat and delta) |
| `claude/hooks/`, `claude/statusline.sh` | `~/.claude/hooks`, `~/.claude/statusline.sh` | Git guardrail hook, status line |
| `claude/settings.json` | merged into `~/.claude/settings.json` | Status line, hooks, permission allowlist (the rest of your settings stay) |

`setup.sh` also installs the tools with Homebrew, oh-my-zsh and its two plugins, TPM and Claude Code. It sets
git's diff display to delta, and adds two lines to the global git ignore (`~/.config/git/ignore`):
`**/.claude/worktrees/` and `**/.claude/settings.local.json`.

## Set up a new machine

1. **Install git** (it comes with the Xcode command line tools): `xcode-select --install`.
2. **Clone to the same path** as on the first machine (the git identity rule below relies on it):
   ```sh
   mkdir -p ~/Documents/personal && cd ~/Documents/personal
   git clone https://github.com/sirdarthvader/dotfiles.git && cd dotfiles
   ```
3. **Run the setup**: `./setup.sh`. You can run it again; an existing real file or folder is
   moved to `<name>.backup-<date>` before it's replaced by a link, and `~/.claude/settings.json` is backed up
   to `settings.json.backup` before the merge.
4. **Open Ghostty.** It starts tmux. Press `Ctrl+a` then `I` (capital i) to install the tmux plugins.
5. **Open `nvim` once** so the plugins install, then `:Copilot auth`.
6. **Sign in to Claude**: `claude auth login`, then `/mcp` inside Claude to connect Jira and GitHub.

### Not in this repo (on purpose; do these by hand)

The repo is public, so it holds nothing personal, secret or work-internal.

- **Git identity**: `git config --global user.name "…"` and `user.email`. The first machine also has
  `[includeIf "gitdir:~/Documents/personal/"] path = ~/.gitconfig-personal` for a personal email in that folder.
- **Runtimes through mise** (`~/.config/mise/config.toml`): node, pnpm, and Java for nvim's Java support:
  `mise use -g java@corretto-21` (projects build on it) and `mise install java@corretto-25` (jdtls runs on it).
  Work registries and mirrors (npm, Maven) go in this file and in `~/.npmrc`, not here.
- **Wallpapers**: put `.png` / `.jpg` files in `~/Wallpapers` (`Cmd+Shift+B` in Ghostty picks the next one).
  Without that folder, Ghostty just has no background image.
- **Other apps' hooks**: iTerm2, Orca and similar tools add their own hooks to `~/.claude/settings.json`
  when you install them. They are left alone by the merge.
- **Rancher Desktop** writes its own block into `zsh/zshrc` (`MANAGED BY RANCHER DESKTOP`); leave it as is.

### Check it worked

In a new Ghostty window:

```sh
whence -w wt wtrm t        # wt: function, wtrm: function, t: alias
readlink ~/.zshrc ~/.config/tmux ~/.config/nvim ~/.config/starship   # all point into this repo
git config --global core.pager                                        # delta
grep worktrees ~/.config/git/ignore                                   # **/.claude/worktrees/
```

Then `t` (or `Ctrl+a` `f`) opens the project picker, and `Ctrl+a` `a` opens Claude beside nvim.

## Parallel tasks with git worktrees

One task = one worktree = one branch = one tmux session = one Claude. They can't see each other's files.

1. In a shell in the repo: **`wt <name>`**. This
   - creates `<repo>/.claude/worktrees/<name>` on a new branch `worktree-<name>`, off origin's default branch
     (the same layout `claude -w <name>` uses);
   - copies the gitignored files a fresh checkout lacks: `.env*`, `.claude/settings.local.json`, and anything
     listed in the repo's `.worktreeinclude` (gitignore syntax, the same file `claude -w` reads);
   - opens tmux session `<repo>@<name>` (windows `code`, `run`, `shell`) with `pnpm install` in `run`.
2. `Ctrl+a` `a` opens Claude in it. Switch tasks with `Ctrl+a` `f` (picker) or `Ctrl+a` `S` (last session).
   A `●` (needs input) or `✓` (finished) shows on the status bar when another session's Claude wants you.
3. When the PR is up, from the main repo: **`wtrm <name>`**. It removes the worktree (git refuses if there
   are uncommitted changes, and then nothing else happens), closes its sessions and hidden Claude pane, and
   deletes the branch only if it's merged.

Still shared between worktrees: dev server ports (run one at a time, or `PORT=3001`), anything outside the
repo (`~/.claude`, Docker, local services), and the pnpm store (that part is good: installs are fast).

Nested worktrees are safe in Nx monorepos: Nx respects the global git ignore, so it doesn't see a worktree's
projects as duplicates.

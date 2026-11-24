# CLAUDE.md

These are the user's dotfiles for macOS (Ghostty, tmux, Neovim, zsh, Claude Code).

**Setting up a new machine?** Follow "Set up a new machine" in `README.md` step by step, then run the
commands under "Check it worked" and report what passed. Steps 4–6 there (tmux plugins, nvim plugins,
sign-ins) need the user at the keyboard: tell them what to press, don't try to do it yourself.

Rules:

- `setup.sh` can be run again. Read it before running it, and tell the user what it will install.
- This repo is **public**. Never commit secrets, tokens, email addresses, internal hostnames or registry
  URLs; those belong in the machine-local files listed under "Not in this repo".
- Configs are linked into place, so edit them here (not through `~/.config/...` copies) and keep
  `README.md` and `nvim/CHEATSHEET.md` in step when a key, command or setup step changes.

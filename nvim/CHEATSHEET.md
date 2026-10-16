# Dev Cheat Sheet (Ghostty + tmux + Neovim/LazyVim + lazygit)

`<Space>` is the **leader** key. `<C-x>` means Ctrl+x, `<A-x>` means Alt/Option+x (left Option key), `<S-x>` means Shift+x.

> Lost? Press `<Space>` and wait: a popup lists every shortcut. `<Space>sk` searches all keymaps.

## 0. Daily workflow

1. Open Ghostty: you land in tmux automatically (your last session, or a new one called `main`).
2. `<C-a> f` (or `t` in a shell): pick a project. The first time, this creates a session named after the repo with three windows:
   - `1 code`: nvim, already open
   - `2 run`: `pnpm dev`, `pnpm jest --watch`, builds
   - `3 shell`: one-off commands (`pnpm i`, `pc`, `gcnb`...)
3. Code in nvim. Check the server or tests with `<C-a> 2`, and come back with `<C-a> Space`.
   - Need AI? `<Space>aa` opens Claude on the right. Select code + `<Space>av` to hand it over, `<C-.>` to type, `<C-h>` back. Hide it with `<Space>aa` again (see section 14).
4. Commit: `<Space>gg` in nvim (or `<C-a> g` from any window) opens lazygit; `q` returns.
5. Another repo: `<C-a> f` again. `<C-a> S` toggles between the last two projects.
6. End of day: just close Ghostty. Everything keeps running. tmux saves the layout every 15 min, so it also survives a reboot (then press `<Space>qs` in nvim to reopen your files).

**Rules:** no Ghostty tabs or splits (tmux does that). Don't quit nvim to run a command; switch tmux window instead. Files go in nvim splits; processes go in tmux windows.

## 1. Modes

| Key                 | Mode                                                   |
| ------------------- | ------------------------------------------------------ |
| `Esc`               | Back to **Normal** mode (also clears search highlight) |
| `i` / `a`           | Insert before / after cursor                           |
| `I` / `A`           | Insert at start / end of line                          |
| `o` / `O`           | New line below / above, in insert mode                 |
| `v` / `V` / `<C-v>` | Visual: characters / lines / block (columns)           |
| `:`                 | Command line                                           |

## 2. Survival

| Key                 | Action                                          |
| ------------------- | ----------------------------------------------- |
| `<C-s>`             | Save (works in any mode)                        |
| `:w` / `:q` / `:wq` | Save / close window / save and close            |
| `:q!`               | Close without saving                            |
| `<Space>qq`         | Quit everything                                 |
| `u` / `<C-r>`       | Undo / redo                                     |
| `<Space>su`         | Undo tree (browse every past state)             |
| `.`                 | Repeat last change (the most useful key in Vim) |

## 3. Moving around

| Key                   | Action                                                                     |
| --------------------- | -------------------------------------------------------------------------- |
| `h j k l`             | Left, down, up, right                                                      |
| `w` / `b` / `e`       | Next word / previous word / end of word                                    |
| `0` / `^` / `$`       | Line start / first non-blank / line end                                    |
| `gg` / `G` / `42G`    | Top / bottom / line 42                                                     |
| `<C-d>` / `<C-u>`     | Half page down / up                                                        |
| `%`                   | Jump to matching bracket                                                   |
| `{` / `}`             | Previous / next paragraph or block                                         |
| `f<char>` / `t<char>` | Jump to / just before next `<char>` on the line (`;` repeats)              |
| `s`                   | **Flash**: type 2 letters, then the label shown to jump anywhere on screen |
| `S`                   | Flash Treesitter: select a whole function/block                            |
| `<C-o>` / `<C-i>`     | Jump back / forward (works across files)                                   |
| `ma` / `` `a ``       | Set mark `a` / jump to mark `a`                                            |

## 4. Editing: operator + motion

Vim edits are **verb + object**. Learn a few of each and combine them.

| Verb        |                          | Object         |                          |
| ----------- | ------------------------ | -------------- | ------------------------ |
| `d`         | delete                   | `w`            | word                     |
| `c`         | change (delete + insert) | `iw` / `aw`    | inner / around word      |
| `y`         | yank (copy)              | `i"` / `a"`    | inside / around quotes   |
| `>` / `<`   | indent / dedent          | `i(` `i{` `i[` | inside brackets          |
| `gc`        | comment                  | `it`           | inside HTML/JSX tag      |
| `gU` / `gu` | upper / lower case       | `if` / `af`    | inside / around function |
|             |                          | `ic` / `ac`    | inside / around class    |
|             |                          | `ia`           | argument                 |

Examples: `ciw` change word, `di"` delete inside quotes, `yaf` copy whole function, `gcc` toggle comment on line, `dd` delete line, `yy` copy line, `>>` indent line.

| Key               | Action                                                                 |
| ----------------- | ---------------------------------------------------------------------- |
| `p` / `P`         | Paste after / before                                                   |
| `[y` / `]y`       | After pasting: cycle through older yanks (yanky)                       |
| `<Space>p`        | Yank history picker                                                    |
| `x`               | Delete character                                                       |
| `r<char>`         | Replace one character                                                  |
| `J`               | Join line below onto this one                                          |
| `<A-j>` / `<A-k>` | Move line/selection down / up (left Option key)                        |
| `<C-a>` / `<C-x>` | Increment / decrement number, bool, date (in tmux press `<C-a>` twice) |
| `gco` / `gcO`     | Add comment below / above                                              |

## 5. Search and replace

| Key                              | Action                                                     |
| -------------------------------- | ---------------------------------------------------------- |
| `/text` / `?text`                | Search forward / backward, then `n` / `N`                  |
| `*`                              | Search word under cursor                                   |
| `:%s/old/new/g`                  | Replace in whole file (add `c` at the end to confirm each) |
| `*` then `cgn`, then `.` `.` `.` | Change next match, repeat for each next match              |
| `<Space>sr`                      | Search and replace across the project (grug-far)           |

## 6. Finding files and text

| Key              | Action                                       |
| ---------------- | -------------------------------------------- |
| `<Space><Space>` | Find files (project root)                    |
| `<Space>/`       | Grep text in project                         |
| `<Space>,`       | Open buffers                                 |
| `<Space>fr`      | Recent files                                 |
| `<Space>fc`      | Find a Neovim config file                    |
| `<Space>sw`      | Grep word under cursor (or visual selection) |
| `<Space>sb`      | Search lines in current file                 |
| `<Space>sR`      | Resume last picker                           |
| `<Space>sh`      | Search help pages                            |

**Inside a picker:**

| Key               | Action                              |
| ----------------- | ----------------------------------- |
| `<C-j>` / `<C-k>` | Move down / up                      |
| `Enter`           | Open                                |
| `<C-v>` / `<C-s>` | Open in vertical / horizontal split |
| `<C-t>`           | Open in new tab                     |
| `<Tab>`           | Select multiple                     |
| `<C-q>`           | Send results to quickfix list       |
| `<A-h>` / `<A-i>` | Toggle hidden / gitignored files    |
| `Esc`             | Close                               |

## 7. File explorer (Neo-tree)

| Key                       | Action                              |
| ------------------------- | ----------------------------------- |
| `<Space>e`                | Toggle explorer (project root)      |
| `<Space>E`                | Toggle explorer (current directory) |
| `<Space>ge` / `<Space>be` | Git status view / open buffers view |

**Inside the tree:**

| Key               | Action                                                     |
| ----------------- | ---------------------------------------------------------- |
| `l` / `Enter`     | Open file / expand folder                                  |
| `h`               | Collapse folder                                            |
| `<C-Enter>`       | Open file **and close the tree** (custom)                  |
| `Esc` / `q`       | Close the tree (custom `Esc`)                              |
| `s` / `S` / `t`   | Open in vertical split / horizontal split / tab            |
| `a` / `A`         | New file / new folder (end name with `/` to make a folder) |
| `r` / `d`         | Rename / delete                                            |
| `c` / `m`         | Copy / move                                                |
| `y` / `x` / `p`   | Copy / cut / paste files                                   |
| `Y`               | Copy path to clipboard                                     |
| `O`               | Open with macOS default app                                |
| `P`               | Preview file                                               |
| `H`               | Show hidden files                                          |
| `/`               | Filter                                                     |
| `.` / `Backspace` | Make folder the root / go up                               |
| `?`               | Show all tree keys                                         |

## 8. Buffers (open files, shown as tabs at the top)

| Key               | Action                  |
| ----------------- | ----------------------- |
| `<S-h>` / `<S-l>` | Previous / next buffer  |
| `<Space>bb`       | Toggle to last buffer   |
| `<Space>bj`       | Pick a buffer by letter |
| `<Space>bd`       | Close buffer            |
| `<Space>bo`       | Close all other buffers |
| `<Space>bp`       | Pin buffer              |

## 9. Splits (windows)

**Create**

| Key                      | Action                                           |
| ------------------------ | ------------------------------------------------ |
| `<Space>\|`              | Split right (vertical)                           |
| `<Space>-`               | Split below (horizontal)                         |
| `:vsp file` / `:sp file` | Open a file in a new vertical / horizontal split |
| `<C-v>` / `<C-s>`        | From a picker: open in split                     |
| `s` / `S`                | From Neo-tree: open in split                     |

**Move between**

| Key                             | Action                               |
| ------------------------------- | ------------------------------------ |
| `<C-h>` `<C-j>` `<C-k>` `<C-l>` | Go to left / down / up / right split (or tmux pane) |
| `<C-w>w`                        | Cycle through splits                 |
| `<C-w>p`                        | Go to previous split                 |

**Resize and arrange**

| Key                      | Action                                        |
| ------------------------ | --------------------------------------------- |
| `<C-Left>` / `<C-Right>` | Narrower / wider                              |
| `<C-Up>` / `<C-Down>`    | Taller / shorter                              |
| `<C-w>=`                 | Make all splits equal                         |
| `<Space>wm`              | Zoom current split (toggle)                   |
| `<C-w>x`                 | Swap with next split                          |
| `<C-w>H` `J` `K` `L`     | Move split to far left / bottom / top / right |
| `<C-w>T`                 | Move split into its own tab                   |

**Close**

| Key                     | Action                 |
| ----------------------- | ---------------------- |
| `<Space>wd` or `<C-w>q` | Close current split    |
| `<C-w>o`                | Close all other splits |

> `<Space>w` + key is the same as `<C-w>` + key.

**Tabs** (a tab holds a whole split layout): `<Space><Tab><Tab>` new, `<Space><Tab>]` / `[` next / prev, `<Space><Tab>d` close.

## 10. Code (LSP)

| Key                     | Action                                      |
| ----------------------- | ------------------------------------------- |
| `gd`                    | Go to definition                            |
| `gr`                    | References                                  |
| `gI` / `gy`             | Implementation / type definition            |
| `gD`                    | (TS) Go to source definition                |
| `gR`                    | (TS) References to this file                |
| `K`                     | Hover docs (press again to enter the popup) |
| `gK` / `<C-k>` (insert) | Signature help                              |
| `<Space>ca`             | Code action (quick fix)                     |
| `<Space>cr`             | Rename symbol everywhere                    |
| `<Space>cR`             | Rename file (updates imports)               |
| `<Space>cf`             | Format file or selection                    |
| `<Space>co`             | Organize imports                            |
| `<Space>cM`             | (TS) Add missing imports                    |
| `<Space>cD`             | (TS) Fix all diagnostics                    |
| `<Space>cs`             | Symbols outline                             |
| `<Space>ss`             | Jump to symbol in file                      |
| `<Space>cp`             | Markdown preview in the browser (in `.md` files) |
| `<Space>um`             | Toggle in-editor markdown rendering         |

**Reading markdown in nvim:** `.md` files render in place: headings, tables, checkboxes, callouts, code blocks, and (in Ghostty) images and ```` ```mermaid ```` diagrams drawn inline. The line under the cursor shows raw text, and insert mode shows it all raw for editing. For long docs: `<Space>uz` zen mode, `<Space>us` to hide spell-check squiggles.

**Completion (insert mode):** `<C-n>` / `<C-p>` move, `Enter` accept, `<C-space>` open menu, `<C-e>` close. Copilot ghost text: `Tab` to accept.

## 11. Diagnostics (errors and warnings)

| Key                       | Action                           |
| ------------------------- | -------------------------------- |
| `]d` / `[d`               | Next / previous diagnostic       |
| `]e` / `[e`               | Next / previous error            |
| `<Space>cd`               | Show diagnostic for current line |
| `<Space>xx`               | All diagnostics list (Trouble)   |
| `<Space>xX`               | Current file diagnostics         |
| `<Space>xt` / `<Space>st` | TODO / FIXME comments            |
| `]q` / `[q`               | Next / previous quickfix item    |

## 12. Git

| Key                         | Action                                                     |
| --------------------------- | ---------------------------------------------------------- |
| `<Space>gg`                 | **Lazygit** (stage, commit, push, branches, all in one UI) |
| `]h` / `[h`                 | Next / previous changed hunk                               |
| `<Space>ghs` / `<Space>ghr` | Stage / reset hunk                                         |
| `<Space>ghp`                | Preview hunk                                               |
| `<Space>gb`                 | Blame current line                                         |
| `<Space>gf`                 | History of current file                                    |
| `<Space>gs`                 | Git status picker                                          |
| `<Space>gd`                 | Diff hunks picker                                          |
| `<Space>gv`                 | **Review all changes** side by side (diffview; again or `q` closes) — use after Claude edits |
| `<Space>gm`                 | Review this branch vs main (what the PR will contain)      |
| `<Space>gV`                 | Current file's history, commit by commit                   |
| `<Space>gp` / `<Space>gi`   | GitHub PRs / issues                                        |

## 13. Terminal

| Key          | Action                                                   |
| ------------ | -------------------------------------------------------- |
| `<C-/>`      | Toggle floating terminal (works inside the terminal too) |
| `<Space>ft`  | Terminal at project root                                 |
| `<C-\><C-n>` | Leave terminal insert mode (to scroll/copy)              |

## 14. AI (Claude / Copilot CLI)

The agent runs in a tmux pane on the right of the current window (one per window). Hiding it keeps the conversation running.

| Key                                | Action                                                        |
| ---------------------------------- | ------------------------------------------------------------- |
| `<Space>aa` / `<C-a> a`            | Toggle the AI pane (opens `claude --ide` the first time)      |
| `<Space>aA` / `<C-a> A`            | Pick tool: claude / copilot, new / continue / resume           |
| `<C-.>`                            | Jump to the AI pane (`<C-h>` back to nvim)                    |
| `<Space>aw` / `<C-a> W`            | Move the AI pane to its own `ai` window, and back (same conversation) |
| `<Space>af`                        | Send current file (`@path`)                                   |
| `<Space>at`                        | Send cursor position (`@path#L42`), or selection in visual    |
| `<Space>av` (visual)               | Send selection                                                |
| `<Space>ap`                        | Pick a prompt: explain, fix, tests, review, diagnostics...    |
| `<Space>ac` (neo-tree / explorer)  | Attach file or folder under cursor to Claude (`Tab` marks several in the explorer) |
| `<A-a>` (in any picker)            | Send the picked / `Tab`-marked files to the AI pane           |
| `<Space>as`                        | Choose which running AI session sends go to                   |
| `<Space>ay` / `<Space>an`          | Accept / reject Claude's proposed diff (or `:w` / `:q`)       |
| `Tab` (insert)                     | Accept Copilot inline suggestion                              |
| `Tab` (normal)                     | Jump to / apply Copilot next-edit suggestion (`<Space>uN` toggles) |

- Claude opened with `<Space>aa` is pinned to *this* nvim: it sees your open file, live selection and LSP diagnostics, and shows edits as diffs in nvim. Opened any other way (`<C-a> a` from a shell pane, or nvim restarted since), it falls back to `--ide`, which gives up when VS Code or a second nvim has the same repo open; type `/ide` in Claude and pick Neovim.
- Inside the Claude prompt: `@` fuzzy-attaches any file or folder, `Ctrl+V` pastes a screenshot from the clipboard (`Cmd+Ctrl+Shift+4` to grab one), dragging an image file onto the pane attaches it, `!` runs a shell command into context.
- Next-edit suggestions: make a change (e.g. rename a variable), leave insert mode, pause. A diff appears where the follow-up edit belongs; `Tab` jumps there, `Tab` again applies. Uses the same Copilot login as ghost text, nothing to install.
- Status bar: `●` = AI needs input, `✓` = AI finished, on that window's tab. Other projects show as `● name` bottom-right. A macOS notification fires when Ghostty isn't in front. (Copilot CLI only beeps + macOS notification, no `●`/`✓`.)
- Hidden AI panes live in a session called `_ai` (scratch popups in `_popup_*`); ignore them in `<C-a> s`.
- Status line under Claude's prompt: model │ folder  branch (`*` = uncommitted) │ `ctx N%` — green, yellow from 50%, red from 80% (time to `/compact` or `/clear`).
- Claude runs tests, lint, type checks, builds and read-only git/gh commands without asking (allowlist in `claude/settings.json`). It is **blocked** from force-push, `reset --hard`, `clean -f`, `branch -D`, `checkout .`/`restore .` and `stash drop|clear`; normal `git push` still asks.
- Jira / GitHub: run `/mcp` once in Claude and log in to both, then e.g. "implement PROJ-123, then open a PR".
- Parallel agents: `wt <name>` per task (shell section), one Claude in each session; `<C-a> s` to hop between them.

## 15. Toggles (`<Space>u`)

| Key                       | Toggle                             |
| ------------------------- | ---------------------------------- |
| `<Space>uw`               | Line wrap                          |
| `<Space>us`               | Spell check                        |
| `<Space>ul` / `<Space>uL` | Line numbers / relative numbers    |
| `<Space>uh`               | Inlay type hints                   |
| `<Space>uf`               | Format on save                     |
| `<Space>ud`               | Diagnostics                        |
| `<Space>uz`               | Zen mode (distraction-free)        |
| `<Space>uC`               | Try colorschemes with live preview |

> **Alt/Option keys on macOS:** `<A-j>`, `<A-k>`, `<A-h>`, `<A-i>` use the **left** Option key (`macos-option-as-alt = left` in `ghostty/config`).

## 16. Sessions, scratch and history

| Key         | Action                                             |
| ----------- | -------------------------------------------------- |
| `<Space>qs` | Restore last session for this folder               |
| `<Space>qS` | Pick a session                                     |
| `<Space>.`  | Scratch buffer (quick notes, not saved to project) |
| `<Space>n`  | Notification history                               |
| `<Space>:`  | Command history                                    |

## 17. Productivity techniques

**Macros:** record once, replay many times.
`qa` start recording into `a` → do the edit → `q` stop → `@a` replay → `@@` replay again → `10@a` replay 10 times.

**Edit many lines at once (visual block):**
`<C-v>` → select down with `j` → `I` → type → `Esc`. Text is inserted on every line. Use `A` to append at the end instead (`$A` for ragged lines).

**Run a command on matching lines:**
`:g/console.log/d` deletes every line containing `console.log`.
`:g/TODO/normal A !` appends ` !` to every line with TODO.

**Project-wide replace (the Vim way):**
`<Space>/` grep → `<C-q>` send to quickfix → `:cdo s/old/new/g | update`.

**Change surrounding quotes/brackets fast:** `ci"`, `ci(`, `cit` work from anywhere inside them, not only on the character.

**Repeat smarter:** make the edit once, then `n` + `.` to apply it to the next match.

**Registers:** `"ayy` copy line into register `a`, `"ap` paste it. `"+y` copies to the macOS clipboard (already the default here). `<Space>s"` shows all registers.

**Increment a column of numbers:** select lines with `V`, then `g<C-a>` makes them 1, 2, 3...

## 18. tmux (prefix is `<C-a>`)

Ghostty opens straight into tmux. One **session per project**, each with windows `1 code` (nvim), `2 run` (dev server / tests), `3 shell`.

| Key                       | Action                                                  |
| ------------------------- | ------------------------------------------------------- |
| `<C-a> f` / `t` in shell  | Pick a project → switch to / create its session (`t .` = current dir) |
| `<C-a> s`                 | Session list                                            |
| `<C-a> S`                 | Last session                                            |
| `<C-a> 1` `2` `3`         | Go to window                                            |
| `<C-a> Space`             | Last window                                             |
| `<C-a> c` / `<C-a> ,`     | New window / rename window                              |
| `<C-a> g`                 | Lazygit popup                                           |
| `<C-a> t` / `` Ctrl+` ``  | Scratch shell popup for this project (stays alive; same key hides it) |
| `<C-a> a` / `<C-a> A`     | Toggle AI pane / pick AI tool (see section 14)          |
| `<C-a> W`                 | AI pane ↔ its own window                                |
| `<C-a> \|` / `<C-a> -`    | Split pane right / below                                |
| `<C-h> <C-j> <C-k> <C-l>` | Move between panes and nvim splits (no prefix)          |
| `<C-a> H J K L`           | Resize pane (repeatable)                                |
| `<C-a> z`                 | Zoom pane                                               |
| `<C-a> x` / `<C-a> X`     | Kill pane / window                                      |
| `<C-a> [`                 | Copy mode (`v` select, `y` copy)                        |
| `<C-a> d`                 | Detach (everything keeps running)                       |
| `<C-a> r`                 | Reload tmux config                                      |

> The session pill (bottom-left) turns yellow while the prefix is active. After a reboot tmux restores windows; in nvim press `<Space>qs` to restore buffers.

## 19. Lazygit (`<Space>gg` in nvim, `<C-a> g` in tmux, `lg` in shell)

| Key                 | Action                                         |
| ------------------- | ---------------------------------------------- |
| `1`-`5` / `[` `]`   | Jump to panel (status, files, branches, commits, stash) / switch tab |
| `j` / `k`           | Move                                           |
| `Space`             | Stage / unstage file (or hunk/line in the diff view) |
| `a`                 | Stage / unstage all                            |
| `Enter`             | Open file diff to stage individual hunks/lines |
| `c`                 | Commit                                         |
| `A`                 | Amend last commit                              |
| `P` / `p`           | Push / pull                                    |
| `n` (branches)      | New branch                                     |
| `Space` (branches)  | Checkout branch                                |
| `d`                 | Discard changes                                |
| `s`                 | Stash                                          |
| `e`                 | Edit file in nvim                              |
| `?`                 | All keys for the current panel                 |
| `q` / `Esc`         | Quit / back                                    |

## 20. Shell (zsh)

**tmux and tools**

| Command        | Action                                                         |
| -------------- | -------------------------------------------------------------- |
| `t` / `t .`    | Pick a project / use the current dir → tmux session (code/run/shell) |
| `wt <name>`    | Parallel task: fresh worktree off main + its own session `<repo>@<name>` (`.env` copied, `pnpm install` in run). Open Claude there with `<Space>aa` |
| `tls`          | List tmux sessions                                             |
| `lg`           | Lazygit                                                        |
| `z <name>`     | Jump to a frequently used directory (zoxide)                   |
| `y`            | Yazi file manager; quitting `cd`s into the last dir            |
| `ls` `ll` `lt` `llg` | eza: list / long list / tree / long list with git status |
| `cat file`     | bat (syntax-highlighted)                                       |

**Fuzzy finding (fzf)**

| Key / command  | Action                                       |
| -------------- | -------------------------------------------- |
| `<C-t>`        | Insert a file path into the command line     |
| `<C-r>`        | Search shell history                         |
| `<A-c>`        | `cd` into a subdirectory (left Option + c)   |
| `fe [query]`   | Find a file and open it in nvim              |
| `fcd [query]`  | `cd` into a subdirectory                     |
| `rgs <text>`   | Search file contents, open the match in nvim at that line |
| `fh`           | Pick a history command and copy it           |
| `fkill`        | Pick a process and kill it                   |
| `<C-/>` in fzf | Toggle preview                               |

**Git**

| Alias               | Command                                                 |
| ------------------- | ------------------------------------------------------- |
| `zz` / `gd`         | `git status` / `git diff`                               |
| `gl`                | Short graph log (last 10)                               |
| `gco` / `gcb`       | Checkout / checkout new branch                          |
| `gb` / `gc`         | `git branch` / `git commit --verbose`                   |
| `gac [msg]`         | Stage all and commit (default message `WIP`)            |
| `gcane`             | Amend last commit without editing message               |
| `gp` / `gpb` / `gpfb` | Push / push current branch / force-with-lease current branch |
| `gpo <branch>`      | Pull from origin                                        |
| `gcnb <name>`       | Update main, then create a new branch                   |
| `gum` / `gur`       | Update main, then merge / rebase it into current branch |
| `gss` / `gsp` / `gsl` | Stash save / pop / list                               |
| `gbc`               | Delete merged local branches                            |

**Project (pnpm / CDF):** `i` install, `pb` build, `pbs` build without nx cache, `bnp` build + pack, `pj` jest, `pc` changeset, `cdfup` / `cdfrst` CDF upgrade / reset deps, `killport <port>`.

## 21. Ghostty

| Key / setting   | What it does                                                          |
| --------------- | --------------------------------------------------------------------- |
| New window      | Opens straight into tmux (attaches the last session)                  |
| Left Option     | Sends Alt (`<A-c>`, `<A-j>`...); right Option still types special characters |
| `<Cmd-S-,>`     | Reload `ghostty/config`                                               |
| `` Ctrl+` ``    | Scratch shell popup (sends `<C-a> t` to tmux)                         |
| `<Cmd-+>` / `<Cmd-->` / `<Cmd-0>` | Font bigger / smaller / reset                       |

Theme is **TokyoNight Night** everywhere: Ghostty, tmux, nvim, bat and delta (git diffs).

## 22. Maintenance

| Command                  | What it does                                             |
| ------------------------ | -------------------------------------------------------- |
| `<C-a> I`                | Install tmux plugins (first run on a new machine)        |
| `<C-a> U`                | Update tmux plugins                                      |
| `<C-a> r`                | Reload tmux config                                       |
| `sz`                     | Reload `~/.zshrc`                                        |
| `bat cache --build`      | Rebuild bat themes after adding one to `bat/themes`      |
| `:Lazy`                  | Plugin manager (`U` update, `S` sync, `X` clean)         |
| `:Lazy restore`          | Reinstall exact versions from `lazy-lock.json`           |
| `:LazyExtras`            | Enable/disable language packs and features (`x` toggles) |
| `:Mason`                 | Install language servers, formatters, linters            |
| `:checkhealth`           | Diagnose problems                                        |
| `:LspInfo` / `<Space>cl` | Which language servers are attached                      |
| `:messages`              | Show recent errors and messages                          |
| `:Tutor`                 | Interactive Vim tutorial                                 |

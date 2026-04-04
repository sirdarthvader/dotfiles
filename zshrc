# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"


### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/ashish.singh/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)



# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time
# Better styled auto completion
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="%F{yellow}Waiting sucks...%f"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"
# Larger history file and better sharing between sessions
HISTSIZE=10000
SAVEHIST=10000
setopt share_history

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions fast-syntax-highlighting zsh-autocomplete)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor
export EDITOR='nvim'
# export EDITOR='code'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

. /opt/homebrew/opt/asdf/libexec/asdf.sh
export PATH="$HOME/.cargo/bin:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



# DENO CONFIG
export DENO_INSTALL="/Users/ashish.singh/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"


# Custome Alias

## NPM
alias nrc='open ~/.npmrc'

## CDF
alias dockerclean='docker system prune -a --volumes'
alias i='pnpm i'
alias cdfup='pnpm cdf-upgrade'
alias cdfrst='pnpm reset-cdf-dependencies'
alias pb='pnpm build'
alias bnp='pnpm build && pnpm pack'
alias pbs='pnpm build --skip-nx-cache'
alias pj='pnpm jest'
alias cdh='cd ~/Documents'






## Git shortcuts
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate --all -10'
alias gcb='git checkout -b'
alias gsl='git stash list'
alias gsp='git stash pop'
alias gss='git stash save'

# Git Branching Shortcuts
alias gmm='git merge main'
alias gco='git checkout'
alias gpo='git pull origin'
alias gcpom='gco main && gpo main'
alias gcane='git commit --amend --no-edit'

# Update local main branch and merge with current branch
alias gum='git branch --show-current | grep -v "^main$" > /tmp/current_branch && gcpom && gco $(cat /tmp/current_branch) && gmm'

# Update lcoal main branch and rebase with current branch
alias gur='git branch --show-current | grep -v "^main$" > /tmp/current_branch && gcpom && gco $(cat /tmp/current_branch) && git rebase main'

# Update changeset
alias pc='pnpm changeset'

# Enhacned git method to stage all changes and commit with a message, if provided, else default to "WIP"
gac() {
  local message="${1:-WIP}"
  git add .
  git commit -m "$message"
}

# Configurable nx run generator command
genrun() {
  local generatorName="$1"
  pnpm nx generate @cvent/cdf:"$generatorName"
}



# Remove merged branches
alias gbc='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'

# Enhanced git push (push current branch only)
gpb() {
  git push origin $(git symbolic-ref --short HEAD)
}
# Safe force push (force push current branch only)
gpfb() {
  git push --force-with-lease origin $(git symbolic-ref --short HEAD)
}
# Enhanced git reset (reset current branch to HEAD)
gpsr() {
  local commits="${1:-1}"
  git reset --soft HEAD~$commits
}

# Update  main and create a new branch
gcnb() {
  local branch_name="$1"
  if [ -z "$branch_name" ]; then
    echo "Missing branch name"
    echo "Usage: gcnb <branch_name>"
    return 1
  fi
  gco main && gpo main && gco -b "$branch_name"

}


# Build and run CDK deployments
bnd() {
  local env="${1:-sandbox}"
  pnpm build && pnpm deploy:$env
}

# Project navigation
alias cdfm='cd /Users/ashish.singh/Documents/EventCloud/framework-monorepo'
alias cddf='cd /Users/ashish.singh/Documents/development-framework'
alias cdtest='cd /Users/ashish.singh/Documents/cdf-test-planner-app'

# ZSHRC edit and reload
alias oz='code ~/.zshrc'
alias sz='source ~/.zshrc'
alias cl='clear'


# Quickly find and kill process using a port
killport() {
  lsof -i tcp:$1 | awk 'NR!=1 {print $2}' | xargs kill
}

## End of custom aliases


## PNPM path setup
export PNPM_HOME="/Users/ashish.singh/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
## PNPM end

# AsyncAPI CLI Autocomplete

ASYNCAPI_AC_ZSH_SETUP_PATH=/Users/ashish.singh/Library/Caches/@asyncapi/cli/autocomplete/zsh_setup && test -f $ASYNCAPI_AC_ZSH_SETUP_PATH && source $ASYNCAPI_AC_ZSH_SETUP_PATH; # asyncapi autocomplete setup



# Anthropic — regenerate certs at most once per day
CUSTOM_CERTS="$HOME/.custom-certs.pem"
if [[ ! -f "$CUSTOM_CERTS" || $(( $(date +%s) - $(stat -f %m "$CUSTOM_CERTS") )) -gt 86400 ]]; then
  security find-certificate -a -p /System/Library/Keychains/SystemRootCertificates.keychain /Library/Keychains/System.keychain > "$CUSTOM_CERTS" 2>/dev/null
fi
export {AWS_CA_BUNDLE,NODE_EXTRA_CA_CERTS,REQUESTS_CA_BUNDLE,SSL_CERT_FILE}="$CUSTOM_CERTS" && export DENO_TLS_CA_STORE='system'
export NODE_USE_SYSTEM_CA=1
export PATH="$HOME/.local/bin:$PATH"

# ============================================================
# FZF + BAT + FD — Integrated file exploration & navigation
# ============================================================

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Use fd instead of default find for fzf (respects .gitignore, much faster)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# fzf default options: bat preview, sensible layout
export FZF_DEFAULT_OPTS="
  --height 60%
  --layout=reverse
  --border rounded
  --info=inline
  --preview 'bat --color=always --style=numbers --line-range=:300 {} 2>/dev/null || echo {}'
  --preview-window=right:50%:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-u:preview-half-page-up'
  --bind 'ctrl-d:preview-half-page-down'
"

# CTRL-T preview with bat
export FZF_CTRL_T_OPTS="
  --preview 'bat --color=always --style=numbers --line-range=:300 {} 2>/dev/null || echo {}'
"

# ALT-C preview with tree-like listing via fd
export FZF_ALT_C_OPTS="
  --preview 'fd --max-depth 2 --color always . {}'
"

# bat config: default theme and style
export BAT_THEME="TwoDark"
export BAT_STYLE="numbers,changes,header"

# Use bat as the man pager for colorized man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# ---- Aliases: drop-in replacements ----
alias cat='bat --paging=never'
alias catp='bat --plain --paging=never'

# ---- Functions: fzf-powered workflows ----

# fe: fuzzy-find a file and open it in $EDITOR
fe() {
  local file
  file=$(fd --type f --hidden --follow --exclude .git | fzf --query="$1" --select-1 --exit-0) && ${EDITOR:-code} "$file"
}

# fcd: fuzzy cd into any subdirectory
fcd() {
  local dir
  dir=$(fd --type d --hidden --follow --exclude .git | fzf --query="$1" --select-1 --exit-0) && cd "$dir"
}

# fsearch: fuzzy search file contents then open at the matching line
fsearch() {
  local result file line
  result=$(grep -rn --color=never "${1:-.}" . 2>/dev/null | fzf --delimiter=: --preview 'bat --color=always --highlight-line {2} {1}' --preview-window=right:60%:+{2}-10) || return
  file=$(echo "$result" | cut -d: -f1)
  line=$(echo "$result" | cut -d: -f2)
  ${EDITOR:-code} --goto "$file:$line"
}

# fh: fuzzy search shell history and copy to clipboard
fh() {
  local cmd
  cmd=$(fc -l 1 | awk '{$1=""; print substr($0,2)}' | fzf --tac --no-sort --query="$1") && echo "$cmd" | pbcopy && echo "Copied: $cmd"
}

# fkill: fuzzy kill a process
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m --header='Select process to kill' | awk '{print $2}')
  if [ -n "$pid" ]; then
    echo "$pid" | xargs kill -${1:-9}
  fi
}

# ftree: fd-powered tree view (better than tree, respects .gitignore)
ftree() {
  local depth="${1:-3}"
  fd --max-depth "$depth" --color always | sed 's|[^/]*/|  │ |g'
}

# fbat: fuzzy find and preview with bat (read-only exploration)
fbat() {
  fd --type f --hidden --follow --exclude .git | fzf --query="$1" \
    --preview 'bat --color=always --style=numbers {}' \
    --preview-window=right:65%:wrap \
    --bind 'enter:execute(bat --paging=always {})'
}

# ============================================================
# EZA — modern ls replacement
# ============================================================
alias ls='eza --icons --group-directories-first'
alias ll='eza --icons --group-directories-first -la'
alias lt='eza --icons --group-directories-first --tree --level=2'
alias lta='eza --icons --group-directories-first --tree --level=2 -a'
alias lg='eza --icons --group-directories-first -la --git'

# ============================================================
# ZOXIDE — smarter cd
# ============================================================
eval "$(zoxide init zsh --cmd z)"

# ============================================================
# RIPGREP — fastest grep
# ============================================================
# rg is ready out of the box, but add a fuzzy variant
# rgs: ripgrep + fzf + bat preview, open result in editor
rgs() {
  local result file line
  result=$(rg --color=always --line-number --no-heading "${1:-.}" 2>/dev/null |
    fzf --ansi --delimiter=: \
      --preview 'bat --color=always --highlight-line {2} --line-range $(( {2} > 10 ? {2}-10 : 1 )):$(( {2}+10 )) {1}' \
      --preview-window=right:60%:+{2}-10) || return
  file=$(echo "$result" | cut -d: -f1)
  line=$(echo "$result" | cut -d: -f2)
  ${EDITOR:-code} --goto "$file:$line"
}

# ============================================================
# DELTA — beautiful git diffs
# ============================================================
# Delta config — run once outside .zshrc:
#   git config --global core.pager delta
#   git config --global interactive.diffFilter 'delta --color-only'
#   git config --global delta.navigate true
#   git config --global delta.side-by-side true
#   git config --global delta.line-numbers true
#   git config --global delta.syntax-theme TwoDark
#   git config --global merge.conflictstyle zdiff3

# ============================================================
# YAZI — terminal file manager
# ============================================================
# y: open yazi and cd into the directory you were in when you quit
y() {
  local tmp
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd "$cwd"
  fi
  rm -f "$tmp"
}

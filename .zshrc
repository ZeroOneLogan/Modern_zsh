# ============================================================================
# Modern Zsh Configuration for macOS
# ============================================================================
# A blazing fast, feature-rich zsh configuration optimized for macOS
# Repository: https://github.com/ZeroOneLogan/Modern_zsh

# ============================================================================
# Performance Monitoring (Optional - Enable for debugging)
# ============================================================================
# Uncomment to measure startup time
# zmodload zsh/zprof

# ============================================================================
# Helper Functions
# ============================================================================
has() { command -v "$1" >/dev/null 2>&1; }
safe_source() { [[ -r "$1" ]] && source "$1"; }
is_ssh() { [[ -n ${SSH_CONNECTION:-} ]] || [[ -n ${SSH_CLIENT:-} ]] || [[ -n ${SSH_TTY:-} ]]; }

# Enable extended glob early (needed for compinit check)
setopt EXTENDED_GLOB

# ============================================================================
# Environment Variables
# ============================================================================
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR='vim'
export VISUAL='vim'

# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Theme / UI
export BAT_THEME="Catppuccin Mocha"
export STARSHIP_CACHE="$XDG_CACHE_HOME/starship"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"

# History Configuration
HISTFILE="${XDG_STATE_HOME}/zsh/history"
mkdir -p "${HISTFILE:h}"
HISTSIZE=50000
SAVEHIST=50000

# ============================================================================
# PATH Configuration
# ============================================================================
typeset -gU path PATH
path_prepend() { [[ -d "$1" ]] && path=("$1" $path); }

path_prepend "$HOME/.local/bin"

# PNPM
if [[ -z ${PNPM_HOME:-} ]]; then
  if [[ "$OSTYPE" == "darwin"* ]] && [[ -d "$HOME/Library/pnpm" ]]; then
    export PNPM_HOME="$HOME/Library/pnpm"
  elif [[ -d "$HOME/.local/share/pnpm" ]]; then
    export PNPM_HOME="$HOME/.local/share/pnpm"
  fi
fi

[[ -n ${PNPM_HOME:-} ]] && path_prepend "$PNPM_HOME"

# ============================================================================
# Completion Paths
# ============================================================================
typeset -gU fpath
mkdir -p "$XDG_DATA_HOME/zsh/completions"
fpath=("$XDG_DATA_HOME/zsh/completions" $fpath)

if has brew; then
  fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)
fi

# ============================================================================
# Mise (Version Manager)
# ============================================================================
if has mise; then
  eval "$(mise activate zsh 2>/dev/null)" || true
fi

# Homebrew (macOS package manager) - must be early for proper PATH setup
if [[ -d "/opt/homebrew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -d "/usr/local/Homebrew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# ============================================================================
# Zinit Plugin Manager Installation
# ============================================================================
# Install zinit if not present
ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"

if [[ ! -d "$ZINIT_HOME" ]]; then
    print -P "%F{yellow}Installing zinit...%f"
    command mkdir -p "${ZINIT_HOME:h}"
    if command git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"; then
        print -P "%F{green}✓ Zinit installed successfully%f"
    else
        print -P "%F{red}✗ Failed to install zinit%f"
        return 1
    fi
fi

source "${ZINIT_HOME}/zinit.zsh"

# ============================================================================
# Zsh Options
# ============================================================================
# History
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file
setopt HIST_VERIFY               # Do not execute immediately upon history expansion
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks from each command line
setopt SHARE_HISTORY             # Share history between all sessions

# Directory Navigation
setopt AUTO_CD                   # If command is a directory, cd into it
setopt AUTO_PUSHD                # Make cd push the old directory onto the directory stack
setopt PUSHD_IGNORE_DUPS         # Don't push multiple copies of the same directory
setopt PUSHD_SILENT              # Do not print the directory stack after pushd or popd
setopt PUSHD_TO_HOME             # Push to home directory when no argument is given

# Correction
setopt CORRECT                   # Spelling correction for commands

# Other
setopt INTERACTIVE_COMMENTS      # Allow comments in interactive mode
setopt NO_BEEP                   # Disable beep
setopt GLOB_DOTS                 # Include dotfiles in globbing
setopt MULTIOS                   # Perform implicit tees or cats when multiple redirections are attempted
setopt PROMPT_SUBST              # Enable parameter expansion, command substitution, and arithmetic expansion in prompts
setopt NOTIFY                    # Report status of background jobs immediately
setopt NO_FLOW_CONTROL           # Disable start/stop characters in shell editor

# ============================================================================
# Zinit Plugins
# ============================================================================

# Completions
zinit light zsh-users/zsh-completions

# Autosuggestions
zinit light zsh-users/zsh-autosuggestions
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_USE_ASYNC=1

# History substring search
zinit light zsh-users/zsh-history-substring-search

# Oh-My-Zsh plugins (turbo loaded)
zinit wait lucid for \
  OMZP::git \
  OMZP::colored-man-pages \
  OMZP::extract \
  OMZP::sudo

# Syntax highlighting - MUST be last
zinit light zdharma-continuum/fast-syntax-highlighting

# ============================================================================
# Completion System
# ============================================================================
autoload -Uz compinit

# Initialize completion system with cache (faster startup)
_zcompdump="${XDG_CACHE_HOME}/zsh/.zcompdump"
mkdir -p "${_zcompdump:h}"

if [[ ! -f "$_zcompdump" ]] || [[ -n "$_zcompdump"(#qN.mh+24) ]]; then
  compinit -d "$_zcompdump"
else
  compinit -C -d "$_zcompdump"
fi
unset _zcompdump

zinit cdreplay -q

# Completion styling
mkdir -p "$XDG_CACHE_HOME/zsh/zcompcache"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
[[ -n ${LS_COLORS:-} ]] && zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{cyan}--- %d ---%f'
zstyle ':completion:*:warnings' format '%F{red}No matches%f'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

# ============================================================================
# Key Bindings
# ============================================================================
# Use emacs key bindings
bindkey -e

# History substring search key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Additional key bindings
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[3~'   delete-char
bindkey '^[[H'    beginning-of-line
bindkey '^[[F'    end-of-line

# Edit command line
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Ctrl-Z toggle
function ctrl-z-toggle() {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
  fi
}
zle -N ctrl-z-toggle
bindkey '^Z' ctrl-z-toggle

# ============================================================================
# Tool Initialization
# ============================================================================

# FZF (fuzzy finder)
if has fzf; then
    # Set up fzf key bindings and fuzzy completion
    if fzf --zsh >/dev/null 2>&1; then
        eval "$(fzf --zsh)"
    elif [[ -r "$HOME/.fzf.zsh" ]]; then
        source "$HOME/.fzf.zsh"
    elif has brew && [[ -r "$(brew --prefix)/opt/fzf/shell/completion.zsh" ]]; then
        source "$(brew --prefix)/opt/fzf/shell/completion.zsh"
        source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
    fi
    
    # FZF configuration with Catppuccin Mocha theme
    export FZF_DEFAULT_OPTS="--height=80% --layout=reverse --border=rounded\
 --color=fg:#cdd6f4,bg:#1e1e2e,hl:#f38ba8\
 --color=fg+:#cdd6f4,bg+:#313244,hl+:#f9e2af\
 --color=info:#89b4fa,prompt:#89dceb,pointer:#f5c2e7\
 --color=marker:#a6e3a1,spinner:#f5e0dc,header:#94e2d5\
 --preview-window=right:55%:wrap\
 --bind='ctrl-/:toggle-preview'"
    
    # Use fd for fzf if available
    if has fd; then
        export FZF_DEFAULT_COMMAND='fd --hidden --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
    fi
    
    # Enhanced previews with bat and eza
    if has bat && has eza; then
        export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {} 2>/dev/null || cat {}'"
        export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always --icons=always {} 2>/dev/null || ls -la {}'"
    fi
fi

# Zoxide (smarter cd command)
has zoxide && eval "$(zoxide init zsh --cmd cd)"

# Direnv (load directory-specific environment variables)
has direnv && eval "$(direnv hook zsh)"

# Thefuck (correct previous console command)
has thefuck && eval "$(thefuck --alias)"

# Node Version Manager (NVM) - Lazy loaded for performance
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    nvm() {
        unset -f nvm
        source "$NVM_DIR/nvm.sh"
        nvm "$@"
    }
fi

# GPG TTY for commit signing
export GPG_TTY=$(tty)

# ============================================================================
# SSH Agent
# ============================================================================
if ! is_ssh && [[ -z ${SSH_AUTH_SOCK:-} ]]; then
  if has ssh-agent && ([[ -f "$HOME/.ssh/id_ed25519" ]] || [[ -f "$HOME/.ssh/id_rsa" ]]); then
    eval "$(ssh-agent -s 2>/dev/null)" >/dev/null
  fi
fi

# ============================================================================
# Custom Configuration
# ============================================================================

# Load external files
safe_source "$HOME/.zsh_aliases"
safe_source "$HOME/.zsh_functions"
safe_source "$HOME/.secrets"

# Load custom aliases if they exist
safe_source "$HOME/.config/zsh/aliases.zsh"

# Load custom functions if they exist
safe_source "$HOME/.config/zsh/functions.zsh"

# Load custom local configuration if it exists
safe_source "$HOME/.zshrc.local"

# ============================================================================
# Atuin (Shell History)
# ============================================================================
has atuin && eval "$(atuin init zsh)"

# ============================================================================
# Prompt Configuration - Starship
# ============================================================================
# Install starship prompt: https://starship.rs/
# curl -sS https://starship.rs/install.sh | sh
has starship && eval "$(starship init zsh)"

# ============================================================================
# Performance Profiling (Optional)
# ============================================================================
# Uncomment to see startup time breakdown
# zprof

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

# History Configuration
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=50000

# ============================================================================
# Zinit Plugin Manager Installation
# ============================================================================
# Install zinit if not present
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [[ ! -d "$ZINIT_HOME" ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing ZINIT Plugin Manager...%f"
    command mkdir -p "$(dirname $ZINIT_HOME)"
    command git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" && \
        print -P "%F{34}▓▒░ %F{34}Installation successful.%f" || \
        print -P "%F{160}▓▒░ The clone has failed.%f"
fi

source "${ZINIT_HOME}/zinit.zsh"

# ============================================================================
# Zsh Options
# ============================================================================
# History
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits
setopt SHARE_HISTORY             # Share history between all sessions
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file
setopt HIST_VERIFY               # Do not execute immediately upon history expansion
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks from each command line

# Directory Navigation
setopt AUTO_CD                   # If command is a directory, cd into it
setopt AUTO_PUSHD                # Make cd push the old directory onto the directory stack
setopt PUSHD_IGNORE_DUPS         # Don't push multiple copies of the same directory
setopt PUSHD_SILENT              # Do not print the directory stack after pushd or popd

# Completion
setopt ALWAYS_TO_END             # Move cursor to end if word had one match
setopt AUTO_MENU                 # Show completion menu on successive tab press
setopt AUTO_LIST                 # Automatically list choices on ambiguous completion
setopt COMPLETE_IN_WORD          # Complete from both ends of a word
setopt MENU_COMPLETE             # Automatically highlight first element of completion menu
unsetopt FLOW_CONTROL            # Disable start/stop characters in shell editor

# Correction
setopt CORRECT                   # Spelling correction for commands
setopt CORRECT_ALL               # Spelling correction for all arguments

# Other
setopt INTERACTIVE_COMMENTS      # Allow comments in interactive mode
setopt MULTIOS                   # Perform implicit tees or cats when multiple redirections are attempted

# ============================================================================
# Zinit Plugins
# ============================================================================

# Turbo mode (load plugins asynchronously for faster startup)
# annexes (extensions for zinit)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# OMZ Library snippets (useful functions)
zinit snippet OMZL::git.zsh
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZL::theme-and-appearance.zsh

# OMZ Plugins
zinit snippet OMZP::git
zinit snippet OMZP::docker
zinit snippet OMZP::kubectl
zinit snippet OMZP::brew
zinit snippet OMZP::macos
zinit snippet OMZP::colored-man-pages

# Fast-syntax-highlighting (must be loaded before autosuggestions)
zinit ice wait lucid atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
zinit light zdharma-continuum/fast-syntax-highlighting

# Zsh-autosuggestions
zinit ice wait lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

# Zsh-completions
zinit ice wait lucid blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

# History substring search
zinit ice wait lucid
zinit light zsh-users/zsh-history-substring-search

# Forgit (interactive git with fzf)
zinit ice wait lucid
zinit light wfxr/forgit

# Fzf-tab (replace zsh default completion with fzf)
zinit ice wait lucid
zinit light Aloxaf/fzf-tab

# Zsh-autopair (auto-close brackets and quotes)
zinit ice wait lucid
zinit light hlissner/zsh-autopair

# Zsh-vi-mode (better vi mode for zsh)
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

# ============================================================================
# Completion System
# ============================================================================
autoload -Uz compinit

# Initialize completion system with cache (faster startup)
# Check if compdump is older than 24 hours
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' file-sort modification
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Fzf-tab configuration
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'
zstyle ':fzf-tab:*' switch-group ',' '.'

# ============================================================================
# Key Bindings
# ============================================================================
# Use emacs key bindings (or vi for vi mode)
bindkey -e  # Change to `bindkey -v` for vi mode

# History substring search key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ============================================================================
# Prompt Configuration - Starship
# ============================================================================
# Install starship prompt: https://starship.rs/
# curl -sS https://starship.rs/install.sh | sh
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
else
    # Fallback prompt if starship is not installed
    PROMPT='%F{blue}%~%f %F{green}❯%f '
fi

# ============================================================================
# Aliases
# ============================================================================

# Load custom aliases if they exist
[[ -f "$HOME/.config/zsh/aliases.zsh" ]] && source "$HOME/.config/zsh/aliases.zsh"

# Essential aliases
alias reload='source ~/.zshrc'
alias zshconfig='${EDITOR} ~/.zshrc'

# ls aliases (use eza if available, otherwise fallback to ls)
if command -v eza &> /dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -l --icons --group-directories-first'
    alias la='eza -la --icons --group-directories-first'
    alias lt='eza --tree --level=2 --icons'
    alias llt='eza -l --tree --level=2 --icons'
else
    alias ls='ls -G'
    alias ll='ls -lh'
    alias la='ls -lAh'
fi

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Git aliases
alias g='git'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'
alias gst='git status'
alias gp='git push'
alias gpl='git pull'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'
alias gla='git log --oneline --graph --decorate --all'

# Modern tools (if installed)
if command -v bat &> /dev/null; then
    alias cat='bat'
fi

if command -v rg &> /dev/null; then
    alias grep='rg'
fi

# Note: fd is not aliased to 'find' since they have different syntax
# Use fd directly for better performance: fd -t f -H ".DS_Store"

# macOS specific aliases
alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
alias cleanup='command find . -type f -name "*.DS_Store" -ls -delete'
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

# Docker aliases
alias d='docker'
alias dc='docker compose'
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs -f'

# Kubernetes aliases
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kl='kubectl logs -f'
alias kex='kubectl exec -it'

# Python aliases
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'

# Network
alias myip='curl ifconfig.me'
alias localip='ipconfig getifaddr en0'
alias ports='lsof -i -P -n | grep LISTEN'

# System
alias update='brew update && brew upgrade && brew cleanup'

# ============================================================================
# Functions
# ============================================================================

# Load custom functions if they exist
[[ -f "$HOME/.config/zsh/functions.zsh" ]] && source "$HOME/.config/zsh/functions.zsh"

# Create a new directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Quick note taking
note() {
    local note_file="$HOME/notes/$(date +%Y-%m-%d).md"
    mkdir -p "$HOME/notes"
    if [ $# -eq 0 ]; then
        ${EDITOR} "$note_file"
    else
        echo "- $(date +%H:%M:%S) - $*" >> "$note_file"
    fi
}

# Weather function
weather() {
    local location="${1:-}"
    curl "wttr.in/${location}"
}

# Create a backup of a file
backup() {
    cp "$1" "${1}.backup-$(date +%Y%m%d-%H%M%S)"
}

# Show most used commands
histtop() {
    history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n${1:-10}
}

# ============================================================================
# Tool Initialization
# ============================================================================

# FZF (fuzzy finder)
if command -v fzf &> /dev/null; then
    # Set up fzf key bindings and fuzzy completion
    if [ -f ~/.fzf.zsh ]; then
        source ~/.fzf.zsh
    elif [ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]; then
        source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
        source /opt/homebrew/opt/fzf/shell/completion.zsh
    fi
    
    # FZF configuration
    export FZF_DEFAULT_OPTS="
        --height 40%
        --layout=reverse
        --border
        --inline-info
        --color=fg:#d0d0d0,bg:#121212,hl:#5f87af
        --color=fg+:#d0d0d0,bg+:#262626,hl+:#5fd7ff
        --color=info:#afaf87,prompt:#d7005f,pointer:#af5fff
        --color=marker:#87ff00,spinner:#af5fff,header:#87afaf
    "
    
    # Use fd for fzf if available
    if command -v fd &> /dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    fi
fi

# Direnv (load directory-specific environment variables)
if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

# Zoxide (smarter cd command)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
    alias cd='z'
fi

# Thefuck (correct previous console command)
if command -v thefuck &> /dev/null; then
    eval "$(thefuck --alias)"
fi

# Node Version Manager (NVM)
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    # Lazy load nvm to improve startup time
    nvm() {
        unset -f nvm
        [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
        nvm "$@"
    }
fi

# Homebrew (macOS package manager)
if [[ -d "/opt/homebrew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -d "/usr/local/Homebrew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# ============================================================================
# macOS Specific Configuration
# ============================================================================

# Set PATH for macOS
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# Add user bin directory
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# GPG TTY for commit signing
export GPG_TTY=$(tty)

# ============================================================================
# Custom Configuration
# ============================================================================

# Load custom local configuration if it exists
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# ============================================================================
# Performance Profiling (Optional)
# ============================================================================
# Uncomment to see startup time breakdown
# zprof

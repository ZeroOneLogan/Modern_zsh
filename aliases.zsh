# ============================================================================
# Additional Aliases for Modern Zsh Configuration
# ============================================================================
# Place this file at: ~/.config/zsh/aliases.zsh
# It will be automatically sourced by .zshrc

# ============================================================================
# Development Aliases
# ============================================================================

# Node.js & JavaScript
alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nr='npm run'
alias ns='npm start'
alias nt='npm test'
alias nb='npm run build'
alias nrd='npm run dev'
alias nc='npm run clean'
# Use 'npxni' for npx with --no-install, regular 'npx' works normally
alias npxni='npx --no-install'

# Yarn
alias y='yarn'
alias ya='yarn add'
alias yad='yarn add --dev'
alias yr='yarn remove'
alias yi='yarn install'
alias ys='yarn start'
alias yt='yarn test'
alias yb='yarn build'

# Python
alias python='python3'
alias pip='pip3'
alias pipi='pip install'
alias pipu='pip install --upgrade'
alias pipun='pip uninstall'
alias pipl='pip list'
alias pipo='pip list --outdated'

# Ruby
alias be='bundle exec'
alias bi='bundle install'
alias bu='bundle update'

# Go
alias got='go test ./...'
alias gob='go build'
alias gor='go run'
alias gom='go mod'

# Rust
alias cb='cargo build'
alias cr='cargo run'
alias ct='cargo test'
alias cc='cargo check'
alias cu='cargo update'

# ============================================================================
# Editor Aliases
# ============================================================================

# VSCode
if command -v code &> /dev/null; then
    alias c='code'
    alias c.='code .'
fi

# Vim/Neovim
if command -v nvim &> /dev/null; then
    alias vim='nvim'
    alias vi='nvim'
    alias v='nvim'
fi

# ============================================================================
# File Operations
# ============================================================================

# Safe operations
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias mkdir='mkdir -pv'

# Disk usage
alias du='du -h'
alias df='df -h'

# Tree view
if command -v tree &> /dev/null; then
    alias tree='tree -C'
    alias tree1='tree -L 1'
    alias tree2='tree -L 2'
    alias tree3='tree -L 3'
fi

# ============================================================================
# Process Management
# ============================================================================

# Top alternatives
if command -v htop &> /dev/null; then
    alias top='htop'
fi

if command -v btop &> /dev/null; then
    alias top='btop'
fi

# Process search
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'

# ============================================================================
# Network & Security
# ============================================================================

# Ping
alias ping='ping -c 5'
alias fastping='ping -c 100 -i 0.2'

# HTTP requests
alias get='curl -O -L'
alias header='curl -I'

# SSL
alias sslcheck='openssl s_client -connect'

# ============================================================================
# System Maintenance (macOS)
# ============================================================================

# Homebrew maintenance
alias brewup='brew update && brew upgrade && brew autoremove && brew cleanup && brew doctor'
alias brewlist='brew leaves'

# Clean up
alias cleands='find . -type f -name "*.DS_Store" -delete'
alias cleanpyc='find . -type f -name "*.pyc" -delete'
alias cleanswp='find . -type f -name "*.swp" -delete'
alias cleanall='cleands && cleanpyc && cleanswp'

# Flush DNS
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

# ============================================================================
# Terminal & Shell
# ============================================================================

# Clear screen
alias c='clear'
alias cls='clear'

# Reload shell
alias reload='source ~/.zshrc'
alias zshrc='${EDITOR} ~/.zshrc'
alias zshalias='${EDITOR} ~/.config/zsh/aliases.zsh'
alias zshfunc='${EDITOR} ~/.config/zsh/functions.zsh'

# History
alias h='history'
alias hgrep='history | grep'

# ============================================================================
# Fun & Utilities
# ============================================================================

# Random password
alias randpass='openssl rand -base64 32'

# Date & Time
alias now='date +"%Y-%m-%d %H:%M:%S"'
alias timestamp='date +%s'

# Quick web server
alias serve='python3 -m http.server'
alias serve8080='python3 -m http.server 8080'

# JSON formatting
alias json='python3 -m json.tool'

# URL encode/decode
alias urlencode='python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'
alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'

# ============================================================================
# Git Advanced Aliases
# ============================================================================

# Status & Info
alias gss='git status -sb'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gt='git tag'

# Add & Commit
alias gap='git add -p'
alias gca='git commit --amend'
alias gcane='git commit --amend --no-edit'

# Diff & Log
alias gds='git diff --staged'
alias gdw='git diff --word-diff'
alias glo='git log --oneline'
alias glg='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'

# Branch management
alias gm='git merge'
alias gma='git merge --abort'
alias gr='git rebase'
alias gri='git rebase -i'
alias gra='git rebase --abort'
alias grc='git rebase --continue'

# Remote
alias gf='git fetch'
alias gfa='git fetch --all'
alias gpo='git push origin'
alias gpom='git push origin main'
alias gplo='git pull origin'
alias gplom='git pull origin main'

# Stash
alias gsh='git stash'
alias gshp='git stash pop'
alias gshl='git stash list'
alias gshd='git stash drop'

# Reset & Clean
alias grh='git reset HEAD'
alias grhh='git reset HEAD --hard'
alias gclean='git clean -fd'

# Worktree
alias gwt='git worktree'
alias gwta='git worktree add'
alias gwtl='git worktree list'
alias gwtr='git worktree remove'

# ============================================================================
# Docker Advanced Aliases
# ============================================================================

# Container management
alias drun='docker run -it --rm'
alias dst='docker stop'
alias drm='docker rm'
alias drma='docker rm $(docker ps -aq)'
alias dstart='docker start'

# Image management
alias drmi='docker rmi'
alias dpull='docker pull'
alias dpush='docker push'
alias dbuild='docker build'
alias dtag='docker tag'

# System
alias dsys='docker system df'
alias dprune='docker system prune -af'
alias dvprune='docker volume prune -f'
alias dnprune='docker network prune -f'

# Docker Compose
alias dcup='docker compose up'
alias dcupd='docker compose up -d'
alias dcdown='docker compose down'
alias dcrestart='docker compose restart'
alias dcbuild='docker compose build'
alias dclogs='docker compose logs -f'
alias dcps='docker compose ps'

# ============================================================================
# Kubernetes Advanced Aliases
# ============================================================================

# Context & Config
alias kctx='kubectl config current-context'
alias kctxs='kubectl config get-contexts'
alias kuse='kubectl config use-context'
alias kns='kubectl config set-context --current --namespace'

# Get Resources
alias kgn='kubectl get nodes'
alias kgi='kubectl get ingress'
alias kgc='kubectl get configmap'
alias kgsec='kubectl get secret'
alias kgpvc='kubectl get pvc'

# Describe
alias kdp='kubectl describe pod'
alias kds='kubectl describe service'
alias kdd='kubectl describe deployment'

# Delete
alias kdel='kubectl delete'
alias kdelp='kubectl delete pod'
alias kdels='kubectl delete service'
alias kdeld='kubectl delete deployment'

# Apply & Create
alias ka='kubectl apply -f'
alias kc='kubectl create'

# Port Forward
alias kpf='kubectl port-forward'

# Top
alias ktop='kubectl top nodes'
alias ktopp='kubectl top pods'

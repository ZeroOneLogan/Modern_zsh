# ============================================================================
# Useful Functions for Modern Zsh Configuration
# ============================================================================
# Place this file at: ~/.config/zsh/functions.zsh
# It will be automatically sourced by .zshrc

# ============================================================================
# Navigation & File Management
# ============================================================================

# Create directory and cd into it
mkcd() {
    if [ $# -eq 0 ]; then
        echo "Usage: mkcd <directory>"
        return 1
    fi
    mkdir -p "$1" && cd "$1"
}

# Go up n directories
up() {
    local count=${1:-1}
    local path=""
    for ((i=0; i<count; i++)); do
        path="../$path"
    done
    cd "$path" || return
}

# Create a temporary directory and cd into it
tmpd() {
    local dir
    dir=$(mktemp -d)
    cd "$dir" || return
    echo "Created and moved to: $dir"
}

# ============================================================================
# File Operations
# ============================================================================

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
            *.deb)       ar x "$1"        ;;
            *.tar.xz)    tar xf "$1"      ;;
            *.tar.zst)   tar xf "$1"      ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Compress files/directories
compress() {
    if [ $# -lt 2 ]; then
        echo "Usage: compress <archive.tar.gz> <file/directory>"
        return 1
    fi
    tar czf "$1" "${@:2}"
}

# Create a backup of a file or directory
backup() {
    if [ $# -eq 0 ]; then
        echo "Usage: backup <file/directory>"
        return 1
    fi
    local timestamp=$(date +%Y%m%d-%H%M%S)
    cp -r "$1" "${1}.backup-${timestamp}"
    echo "Backup created: ${1}.backup-${timestamp}"
}

# Find files by name
ff() {
    if [ $# -eq 0 ]; then
        echo "Usage: ff <filename>"
        return 1
    fi
    if command -v fd &> /dev/null; then
        fd --type f --hidden --follow --exclude .git "$1"
    else
        find . -type f -iname "*$1*"
    fi
}

# Find directories by name
fdir() {
    if [ $# -eq 0 ]; then
        echo "Usage: fdir <dirname>"
        return 1
    fi
    if command -v fd &> /dev/null; then
        fd --type d --hidden --follow --exclude .git "$1"
    else
        find . -type d -iname "*$1*"
    fi
}

# ============================================================================
# Text Processing & Search
# ============================================================================

# Find and replace in files (requires ripgrep)
findreplace() {
    if [ $# -lt 2 ]; then
        echo "Usage: findreplace <find> <replace> [path]"
        return 1
    fi
    local find="$1"
    local replace="$2"
    local path="${3:-.}"
    
    if command -v rg &> /dev/null; then
        rg "$find" "$path" -l | xargs sed -i '' "s/$find/$replace/g"
    else
        grep -rl "$find" "$path" | xargs sed -i '' "s/$find/$replace/g"
    fi
}

# Search for text in files
search() {
    if [ $# -eq 0 ]; then
        echo "Usage: search <pattern> [path]"
        return 1
    fi
    local pattern="$1"
    local path="${2:-.}"
    
    if command -v rg &> /dev/null; then
        rg "$pattern" "$path"
    else
        grep -rn "$pattern" "$path"
    fi
}

# Count lines of code in a directory
loc() {
    local path="${1:-.}"
    find "$path" -name '*.py' -o -name '*.js' -o -name '*.jsx' -o -name '*.ts' -o -name '*.tsx' -o -name '*.go' -o -name '*.rs' -o -name '*.java' -o -name '*.c' -o -name '*.cpp' -o -name '*.h' -o -name '*.sh' | xargs wc -l | sort -rn
}

# ============================================================================
# Git Functions
# ============================================================================

# Git clone and cd into the repository
gcl() {
    if [ $# -eq 0 ]; then
        echo "Usage: gcl <repository-url> [directory]"
        return 1
    fi
    git clone "$1" "$2" && cd "$(basename "$1" .git)" || return
}

# Git commit with conventional commit format
gccm() {
    if [ $# -lt 2 ]; then
        echo "Usage: gccm <type> <message>"
        echo "Types: feat, fix, docs, style, refactor, test, chore"
        return 1
    fi
    git commit -m "$1: $2"
}

# Create a new git branch and switch to it
gnb() {
    if [ $# -eq 0 ]; then
        echo "Usage: gnb <branch-name>"
        return 1
    fi
    git checkout -b "$1"
}

# Show git log with file changes
glog() {
    git log --stat --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit "${@:-HEAD~10..HEAD}"
}

# Git undo last commit but keep changes
gundo() {
    git reset --soft HEAD~1
}

# Git diff with delta or diff-so-fancy if available
gdiff() {
    if command -v delta &> /dev/null; then
        git diff "$@" | delta
    elif command -v diff-so-fancy &> /dev/null; then
        git diff "$@" | diff-so-fancy
    else
        git diff "$@"
    fi
}

# ============================================================================
# Development Functions
# ============================================================================

# Create a new project directory structure
newproject() {
    if [ $# -eq 0 ]; then
        echo "Usage: newproject <project-name>"
        return 1
    fi
    
    local project="$1"
    mkdir -p "$project"/{src,tests,docs}
    cd "$project" || return
    
    # Initialize git
    git init
    
    # Create README
    echo "# $project" > README.md
    
    # Create .gitignore
    cat > .gitignore << 'EOF'
# OS
.DS_Store
Thumbs.db

# Editor
.vscode/
.idea/
*.swp
*.swo

# Dependencies
node_modules/
vendor/
venv/
.env

# Build
dist/
build/
*.pyc
__pycache__/
EOF
    
    echo "Project '$project' created successfully!"
}

# Start a simple HTTP server with specified port
serve() {
    local port="${1:-8000}"
    echo "Starting HTTP server on port $port..."
    python3 -m http.server "$port"
}

# Test a port to see if it's in use
port-check() {
    if [ $# -eq 0 ]; then
        echo "Usage: port-check <port>"
        return 1
    fi
    lsof -i :"$1"
}

# Kill process on a specific port
port-kill() {
    if [ $# -eq 0 ]; then
        echo "Usage: port-kill <port>"
        return 1
    fi
    lsof -ti :"$1" | xargs kill -9
}

# ============================================================================
# System & Network Functions
# ============================================================================

# Show disk usage of current directory
duh() {
    du -sh "${1:-.}"/* 2>/dev/null | sort -rh | head -n ${2:-20}
}

# Show largest directories
largest() {
    local count="${1:-10}"
    du -h "${2:-.}" | sort -rh | head -n "$count"
}

# Get my public IP
myip() {
    curl -s ifconfig.me
    echo ""
}

# Get my local IP
localip() {
    ipconfig getifaddr en0 || ipconfig getifaddr en1
}

# Show all open ports
ports() {
    lsof -i -P -n | grep LISTEN
}

# Ping a host until it responds
wait-for-host() {
    if [ $# -eq 0 ]; then
        echo "Usage: wait-for-host <hostname>"
        return 1
    fi
    echo "Waiting for $1 to respond..."
    until ping -c1 "$1" >/dev/null 2>&1; do
        echo -n "."
        sleep 1
    done
    echo ""
    echo "$1 is now reachable!"
}

# Download a file with resume support
download() {
    if [ $# -eq 0 ]; then
        echo "Usage: download <url> [output-filename]"
        return 1
    fi
    curl -L -C - -o "${2:-$(basename "$1")}" "$1"
}

# ============================================================================
# Productivity Functions
# ============================================================================

# Quick note taking
note() {
    local note_file="$HOME/notes/$(date +%Y-%m-%d).md"
    mkdir -p "$HOME/notes"
    
    if [ $# -eq 0 ]; then
        ${EDITOR} "$note_file"
    else
        echo "- $(date +%H:%M:%S) - $*" >> "$note_file"
        echo "Note added to $note_file"
    fi
}

# Create a todo item
todo() {
    local todo_file="$HOME/notes/todo.md"
    mkdir -p "$HOME/notes"
    
    if [ $# -eq 0 ]; then
        ${EDITOR} "$todo_file"
    else
        echo "- [ ] $*" >> "$todo_file"
        echo "Todo added to $todo_file"
    fi
}

# Timer function
timer() {
    if [ $# -eq 0 ]; then
        echo "Usage: timer <seconds>"
        return 1
    fi
    local seconds="$1"
    local message="${2:-Timer finished!}"
    
    echo "Timer set for $seconds seconds..."
    sleep "$seconds"
    echo "$message"
    
    # Try to send a notification (macOS)
    if command -v osascript &> /dev/null; then
        osascript -e "display notification \"$message\" with title \"Timer\""
    fi
}

# Pomodoro timer
pomodoro() {
    local work_time="${1:-25}"
    local break_time="${2:-5}"
    
    echo "🍅 Pomodoro: Work for $work_time minutes"
    timer $((work_time * 60)) "Work session complete! Take a break."
    
    echo "☕ Break time: $break_time minutes"
    timer $((break_time * 60)) "Break over! Back to work."
}

# ============================================================================
# Information & Statistics
# ============================================================================

# Show most used commands
histtop() {
    local count="${1:-10}"
    history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n "$count"
}

# Show directory statistics
dirstats() {
    local path="${1:-.}"
    echo "Directory Statistics for: $path"
    echo "================================"
    echo "Total files: $(find "$path" -type f | wc -l)"
    echo "Total directories: $(find "$path" -type d | wc -l)"
    echo "Total size: $(du -sh "$path" | cut -f1)"
    echo ""
    echo "Largest files:"
    find "$path" -type f -exec ls -lh {} \; | sort -k5 -hr | head -n 5 | awk '{print $5 "\t" $9}'
}

# System information
sysinfo() {
    echo "System Information"
    echo "=================="
    echo "Hostname: $(hostname)"
    echo "OS: $(sw_vers -productName) $(sw_vers -productVersion)"
    echo "Kernel: $(uname -r)"
    echo "Uptime: $(uptime | awk '{print $3,$4}' | sed 's/,//')"
    echo "CPU: $(sysctl -n machdep.cpu.brand_string)"
    echo "Memory: $(sysctl -n hw.memsize | awk '{print $1/1024/1024/1024 " GB"}')"
    echo "Disk Usage:"
    df -h / | tail -1 | awk '{print "  Used: " $3 " / " $2 " (" $5 ")"}'
}

# ============================================================================
# Utility Functions
# ============================================================================

# Generate a random password
genpass() {
    local length="${1:-32}"
    openssl rand -base64 "$length" | tr -d '\n' && echo
}

# Encode/decode base64
encode64() {
    if [ $# -eq 0 ]; then
        echo "Usage: encode64 <string>"
        return 1
    fi
    echo -n "$1" | base64
}

decode64() {
    if [ $# -eq 0 ]; then
        echo "Usage: decode64 <base64-string>"
        return 1
    fi
    echo -n "$1" | base64 -d
}

# Calculate
calc() {
    echo "$*" | bc -l
}

# Weather information
weather() {
    local location="${1:-}"
    curl "wttr.in/${location}"
}

# QR code generator (requires qrencode)
qr() {
    if [ $# -eq 0 ]; then
        echo "Usage: qr <text>"
        return 1
    fi
    
    if command -v qrencode &> /dev/null; then
        echo "$1" | qrencode -t UTF8
    else
        echo "qrencode is not installed. Install it with: brew install qrencode"
    fi
}

# ============================================================================
# macOS Specific Functions
# ============================================================================

# Toggle hidden files visibility in Finder
showhidden() {
    defaults write com.apple.finder AppleShowAllFiles YES
    killall Finder
}

hidehidden() {
    defaults write com.apple.finder AppleShowAllFiles NO
    killall Finder
}

# Empty trash
emptytrash() {
    echo "Emptying trash..."
    rm -rf ~/.Trash/*
    echo "Trash emptied!"
}

# Spotlight search from terminal
spotlight() {
    if [ $# -eq 0 ]; then
        echo "Usage: spotlight <search-term>"
        return 1
    fi
    mdfind "$1"
}

# Open current directory in Finder
f() {
    open "${1:-.}"
}

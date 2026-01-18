# Common Workflows & Tips 💡

This guide provides practical examples and workflows for using your modern Zsh configuration effectively.

## Table of Contents
- [Git Workflows](#git-workflows)
- [Development Workflows](#development-workflows)
- [File Management](#file-management)
- [System Administration](#system-administration)
- [Docker & Kubernetes](#docker--kubernetes)
- [Productivity Tips](#productivity-tips)

## Git Workflows

### Starting a New Feature

```bash
# Create and switch to a new branch
gnb feature/awesome-feature

# Make changes, then stage and commit
gaa                    # git add .
gcm "Add awesome feature"  # git commit -m

# Push to remote
gpo feature/awesome-feature
```

### Reviewing Changes

```bash
# Check status
gst                    # git status (short)

# View changes
gd                     # git diff
gds                    # git diff --staged

# View history
gl                     # pretty log
glog                   # detailed log with stats
```

### Working with Branches

```bash
# List branches
gb                     # local branches
gba                    # all branches

# Switch branches
gco main

# Delete branch
gbd feature/old-feature
```

### Fixing Mistakes

```bash
# Undo last commit (keep changes)
gundo

# Amend last commit
gca                    # commit --amend
gcane                  # commit --amend --no-edit

# Discard local changes
grhh                   # reset HEAD --hard
```

### Stashing Work

```bash
# Stash changes
gsh                    # git stash

# List stashes
gshl                   # git stash list

# Apply stash
gshp                   # git stash pop
```

## Development Workflows

### Starting a New Project

```bash
# Create project structure
newproject my-awesome-app

# Or manually
mkcd my-awesome-app
git init
```

### Node.js Project

```bash
# Initialize
npm init -y

# Install dependencies
ni express          # npm install express
nid jest            # npm install --save-dev jest

# Run scripts
nr dev              # npm run dev
nt                  # npm test
nb                  # npm run build
```

### Python Project

```bash
# Create virtual environment
venv

# Activate
activate

# Install dependencies
pipi flask requests

# Run
py app.py
```

### Hot Reload Development

```bash
# Node.js with watch
nr dev              # npm run dev

# Python with auto-reload
# In separate terminals:
# Terminal 1
py app.py

# Terminal 2 - monitor for changes
watch -n 1 'py test.py'
```

### Port Management

```bash
# Check what's running on a port
port-check 3000

# Kill process on port
port-kill 3000

# View all listening ports
ports
```

## File Management

### Quick Navigation

```bash
# Smart directory jumping with zoxide
z project           # Jump to project directory
z doc              # Jump to documents

# Traditional navigation
..                 # Up one level
...                # Up two levels
....               # Up three levels

# Go up multiple levels
up 3               # Go up 3 directories
```

### File Search & Operations

```bash
# Find files by name
ff config          # Find files with 'config' in name
fd node_modules    # Find directories

# Search in files
search "TODO"      # Search for text in files
rg "import.*React" # With ripgrep

# Fuzzy finding
fzf                # Interactive file finder
Ctrl+T             # Fuzzy find file (in command)
Alt+C              # Fuzzy find directory (cd)
```

### Archive Operations

```bash
# Extract any archive
extract file.zip
extract project.tar.gz

# Create archive
compress backup.tar.gz folder/

# Backup file
backup important.txt
# Creates: important.txt.backup-20260118-120000
```

### File Viewing

```bash
# View with syntax highlighting
cat script.js      # Using bat

# Modern directory listing
ls                 # With eza
ll                 # Detailed list
la                 # Include hidden files
lt                 # Tree view
```

## System Administration

### System Information

```bash
# Full system info
sysinfo

# Public IP
myip

# Local IP
localip

# Disk usage
duh                # Current directory
duh ~/Downloads    # Specific directory

# Largest directories
largest 10
```

### Maintenance

```bash
# Update everything
update             # brew update && upgrade && cleanup

# Clean up
cleanup            # Remove .DS_Store files
cleanall           # Remove .DS_Store, .pyc, .swp

# Flush DNS
flushdns
```

### Process Management

```bash
# Find process
psg nginx          # ps aux | grep nginx

# Top alternatives
top                # Uses htop or btop if installed
```

### Network Operations

```bash
# Test connectivity
ping google.com

# Download file
download https://example.com/file.zip

# Check SSL
sslcheck example.com:443

# Get headers
header https://example.com
```

## Docker & Kubernetes

### Docker Workflows

```bash
# Build and run
dbuild -t myapp .
drun myapp

# Manage containers
dps                # Running containers
dpa                # All containers
dst container_id   # Stop
drm container_id   # Remove

# Docker Compose
dcup               # docker compose up
dcupd              # docker compose up -d (detached)
dcdown             # docker compose down
dclogs             # docker compose logs -f

# Cleanup
dprune             # Remove all unused containers, networks, images
```

### Kubernetes Workflows

```bash
# Context management
kctx               # Current context
kctxs              # List contexts
kuse prod          # Switch context

# Resource viewing
kgp                # Get pods
kgs                # Get services
kgd                # Get deployments

# Logs and debugging
kl pod-name        # Follow logs
kex pod-name       # Exec into pod

# Apply changes
ka deployment.yaml
```

## Productivity Tips

### Quick Notes

```bash
# Add quick note
note "Remember to review PR #123"

# Open today's notes
note

# Add todo
todo "Fix bug in authentication"
```

### Timers & Reminders

```bash
# Simple timer
timer 300          # 5 minutes
timer 1800 "Meeting time!"

# Pomodoro technique
pomodoro           # 25 min work, 5 min break
pomodoro 45 10     # 45 min work, 10 min break
```

### Command History

```bash
# Search history
Ctrl+R             # Interactive search

# Most used commands
histtop            # Top 10
histtop 20         # Top 20

# Search in history
h | grep docker
hgrep docker
```

### Shell Shortcuts

```bash
# Clear screen
Ctrl+L
c                  # alias

# Reload config
reload

# Edit configs
zshconfig          # Main config
zshalias           # Aliases
zshfunc            # Functions
```

### Fuzzy Finding

```bash
# Find and edit file
vim $(fzf)

# Find and cd
cd $(fd --type d | fzf)

# Search command history
Ctrl+R

# Kill process interactively
kill $(ps aux | fzf | awk '{print $2}')
```

### Working with Multiple Projects

```bash
# Quick project access
# Add to ~/.zshrc.local:
alias work='cd ~/Projects/work'
alias personal='cd ~/Projects/personal'

# Then just:
work
personal
```

### Batch Operations

```bash
# Convert all PNG to JPG
for img in *.png; do
    convert "$img" "${img%.png}.jpg"
done

# Rename multiple files
for file in *.txt; do
    mv "$file" "${file%.txt}.md"
done

# Mass git pull
for dir in */; do
    (cd "$dir" && git pull)
done
```

### Environment Switching

```bash
# Quick environment switch
# Add to ~/.zshrc.local:
dev() {
    export API_URL="http://localhost:3000"
    export DATABASE_URL="postgresql://localhost/dev"
}

prod() {
    export API_URL="https://api.example.com"
    export DATABASE_URL="postgresql://prod.example.com/prod"
}
```

### Clipboard Operations (macOS)

```bash
# Copy to clipboard
echo "Hello" | pbcopy
cat file.txt | pbcopy

# Paste from clipboard
pbpaste
pbpaste > newfile.txt

# Copy current directory path
pwd | pbcopy
```

### Quick Server Setup

```bash
# Start HTTP server
serve              # Port 8000
serve 3000         # Port 3000

# Python API server
py -m flask run

# Node.js
nr start
```

## Pro Tips

1. **Use `z` for navigation**: After a few uses, `z project` is faster than `cd ~/Projects/project`

2. **Leverage auto-suggestions**: Start typing a previous command and press → to accept

3. **Use `!!` for last command**: 
   ```bash
   apt install package  # Permission denied
   sudo !!              # Runs with sudo
   ```

4. **Command substitution with fzf**:
   ```bash
   vim $(fzf)           # Select file to edit
   cd $(fd -t d | fzf)  # Select directory to cd into
   ```

5. **Quick edits**:
   ```bash
   fc                   # Edit last command in $EDITOR
   ```

6. **Directory stack**:
   ```bash
   cd /path/one
   pushd /path/two      # Push and cd
   popd                 # Return to previous
   ```

7. **Brace expansion**:
   ```bash
   mkdir -p project/{src,tests,docs}
   touch file{1..10}.txt
   ```

8. **Parameter expansion**:
   ```bash
   filename="script.sh"
   echo ${filename%.sh}  # Outputs: script
   ```

9. **Use aliases in functions**:
   ```bash
   deploy() {
       gb && \           # Check branch
       nt && \           # Run tests
       nb && \           # Build
       gp                # Push
   }
   ```

10. **Create command chains**:
    ```bash
    mkcd project && git init && npm init -y
    ```

---

**Master these workflows to boost your productivity! 🚀**

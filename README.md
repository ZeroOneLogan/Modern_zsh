# Modern Zsh Configuration for macOS 🚀

A blazing fast, feature-rich, and beautiful Zsh configuration optimized for macOS developers. This setup includes modern CLI tools, intelligent plugins, and a gorgeous prompt that makes your terminal experience exceptional.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg)
![Zsh](https://img.shields.io/badge/shell-zsh-green.svg)

## ✨ Features

### 🎨 Beautiful & Fast Prompt
- **[Starship](https://starship.rs/)** - Minimal, blazing-fast, and highly customizable prompt
- Shows git status, programming language versions, and execution time
- Optimized configuration for faster rendering
- Nerd Font icons for a modern look

### 🔌 Intelligent Plugin Management
- **[Zinit](https://github.com/zdharma-continuum/zinit)** - Fast and flexible plugin manager
- Turbo mode for async loading (sub-second startup time)
- Lazy loading for heavy tools (NVM, etc.)

### 🛠️ Essential Plugins
- **Syntax highlighting** - Real-time command validation
- **Auto-suggestions** - Fish-like autosuggestions based on history
- **Tab completions** - Enhanced completion system
- **History substring search** - Search through command history
- **Fzf integration** - Fuzzy finding with Catppuccin Mocha theme

### 📦 Modern CLI Tools Integration
- **[eza](https://github.com/eza-community/eza)** - Modern replacement for `ls`
- **[bat](https://github.com/sharkdp/bat)** - `cat` with syntax highlighting
- **[ripgrep](https://github.com/BurntSushi/ripgrep)** - Blazing fast grep alternative
- **[fd](https://github.com/sharkdp/fd)** - Simple, fast alternative to `find`
- **[fzf](https://github.com/junegunn/fzf)** - Command-line fuzzy finder
- **[zoxide](https://github.com/ajeetdsouza/zoxide)** - Smarter cd command
- **[thefuck](https://github.com/nvbn/thefuck)** - Corrects previous console command

### 🎯 Productivity Features
- Carefully curated aliases for common tasks
- Safe, well-tested custom functions for development
- Git aliases and functions for efficient workflow
- Docker and Kubernetes shortcuts
- macOS-specific optimizations
- Smart history management (50,000 entries)
- Directory navigation helpers

### 🔧 Developer-Friendly
- Core language support (Node.js, Python, Go, Rust, Java, Ruby)
- Environment-aware with version detection
- Project scaffolding functions
- Safe port management utilities
- Modern find/replace with confirmation prompts

## 📋 Prerequisites

- **macOS** (10.15 Catalina or later)
- **Zsh** (usually pre-installed on macOS)
- **Git** (for installation and updates)
- **Homebrew** (optional but recommended)

## 🚀 Quick Installation

### One-Line Install

```bash
curl -fsSL https://raw.githubusercontent.com/ZeroOneLogan/Modern_zsh/main/install.sh | bash
```

### Manual Installation

1. **Clone the repository:**
```bash
git clone https://github.com/ZeroOneLogan/Modern_zsh.git ~/Modern_zsh
cd ~/Modern_zsh
```

2. **Run the installation script:**
```bash
./install.sh
```

3. **Restart your terminal** or run:
```bash
source ~/.zshrc
```

## 📁 File Structure

```
Modern_zsh/
├── .zshrc              # Main configuration file
├── aliases.zsh         # Collection of useful aliases
├── functions.zsh       # Custom shell functions
├── starship.toml       # Starship prompt configuration
├── install.sh          # Installation script
└── README.md           # This file
```

### Installation Layout

After installation, your files will be organized as:
```
~/
├── .zshrc                          # Main config
├── .zshrc.local                    # Your personal config (optional)
└── .config/
    ├── zsh/
    │   ├── aliases.zsh            # Aliases
    │   └── functions.zsh          # Functions
    └── starship.toml              # Prompt config
```

## 🎨 Customization

### Personal Configuration

Create `~/.zshrc.local` for your personal settings that won't be overwritten:

```bash
# ~/.zshrc.local
# Your personal aliases
alias myalias='my command'

# Your environment variables
export MY_VAR="value"

# Your custom functions
my_function() {
    echo "Hello!"
}
```

### Starship Prompt

Edit `~/.config/starship.toml` to customize your prompt appearance. See [Starship documentation](https://starship.rs/config/) for options.

### Aliases & Functions

- Edit `~/.config/zsh/aliases.zsh` for custom aliases
- Edit `~/.config/zsh/functions.zsh` for custom functions

### Key Bindings

The default configuration uses **Emacs** key bindings. To switch to **Vi** mode, edit `~/.zshrc`:

```bash
# Change this line:
bindkey -e  # Emacs mode (default)

# To this:
bindkey -v  # Vi mode
```

## 📚 Usage Guide

### Essential Commands

```bash
# Reload configuration
reload

# Edit main config
zshconfig

# Edit aliases
zshalias

# Edit functions
zshfunc
```

### Directory Navigation

```bash
# Smart cd with zoxide
z project         # Jump to frequently used directories

# Go up directories
..                # cd ..
...               # cd ../..
....              # cd ../../..

# Create and enter directory
mkcd new-project

# Open current directory in Finder
f
```

### File Operations

```bash
# Modern ls with eza
ls                # List files with icons
ll                # List with details
la                # List including hidden
lt                # Tree view

# Better cat with bat
cat file.txt      # Syntax highlighted output

# Extract any archive
extract file.zip
```

### Git Shortcuts

```bash
# Common operations
g                 # git
gst               # git status
ga                # git add
gc                # git commit
gp                # git push
gpl               # git pull

# Branch management
gnb feature       # Create and checkout new branch
gb                # List branches

# Advanced
glog              # Beautiful log
gdiff             # Enhanced diff
gcl <url>         # Clone and cd into repo
```

### Development

```bash
# Node.js
nr dev            # npm run dev
ni package        # npm install package

# Python
py script.py      # python3
venv              # Create virtual environment
activate          # Activate venv

# Docker
d                 # docker
dc                # docker compose
dps               # docker ps
dex container     # docker exec -it

# Kubernetes
k                 # kubectl
kgp               # kubectl get pods
kex pod           # kubectl exec -it
```

### System Utilities

```bash
# Network
myip              # Get public IP
localip           # Get local IP
ports             # Show open ports
port-kill 8080    # Kill process on port

# System info
sysinfo           # Show system information
duh               # Disk usage, sorted

# Productivity
note "My note"    # Quick note-taking
todo "Task"       # Add todo item
weather london    # Check weather
timer 300         # 5-minute timer
```

## 🔧 Recommended Tools

Install these tools for the best experience:

### Via Homebrew

```bash
# Essential tools
brew install eza bat ripgrep fd fzf zoxide starship

# Additional tools  
brew install git-delta htop tree jq wget curl sd

# Optional but useful
brew install neovim tmux gh lazygit lazydocker
```

### Nerd Fonts

For icons to display correctly, install a Nerd Font:

```bash
brew tap homebrew/cask-fonts
brew install --cask font-fira-code-nerd-font
```

Then configure your terminal to use the font.

## ⚙️ Configuration Options

### Performance Tuning

The configuration is optimized for speed with:
- Async plugin loading with Zinit turbo mode
- Lazy loading for heavy tools (NVM)
- Completion caching with daily refresh
- Streamlined prompt with essential info only
- Disabled cloud provider modules by default

To measure startup time:
```bash
# Add to .zshrc
zmodload zsh/zprof
# ... rest of config ...
zprof  # At the end
```

### Disabling Features

To disable specific features, edit `~/.zshrc`:

```bash
# Disable vi mode plugin
# Comment out or remove:
# zinit light jeffreytse/zsh-vi-mode

# Disable auto-corrections
unsetopt CORRECT
unsetopt CORRECT_ALL
```

## 🆘 Troubleshooting

### Slow Startup

1. Check which plugins take longest:
```bash
zmodload zsh/zprof
source ~/.zshrc
zprof
```

2. Disable heavy plugins or enable lazy loading

### Icons Not Showing

- Install a Nerd Font
- Configure your terminal to use it
- Ensure terminal supports Unicode

### Completions Not Working

```bash
# Rebuild completion cache
rm ~/.zcompdump*
source ~/.zshrc
```

### Permission Issues

```bash
# Fix permissions
compaudit | xargs chmod g-w,o-w
```

## 🔄 Updating

### Update Configuration

```bash
cd ~/Modern_zsh
git pull
./install.sh
```

### Update Plugins

Zinit updates automatically. To manually update:
```bash
zinit update --all
```

### Update Tools

```bash
update  # Alias for brew update && upgrade && cleanup
```

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest new features
- Submit pull requests
- Share your custom functions

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

This configuration stands on the shoulders of giants:

- [Zinit](https://github.com/zdharma-continuum/zinit) - Plugin manager
- [Starship](https://starship.rs/) - Prompt
- [Oh My Zsh](https://ohmyz.sh/) - Inspiration and snippets
- [Modern Unix](https://github.com/ibraheemdev/modern-unix) - Tool recommendations
- The Zsh community for amazing plugins

## 📧 Support

- **Issues**: [GitHub Issues](https://github.com/ZeroOneLogan/Modern_zsh/issues)
- **Discussions**: [GitHub Discussions](https://github.com/ZeroOneLogan/Modern_zsh/discussions)

## 🌟 Star History

If you find this project useful, please consider giving it a star! ⭐

---

**Made with ❤️ for the macOS developer community**
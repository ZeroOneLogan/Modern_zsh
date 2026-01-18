# Quick Start Guide 🚀

## Installation

### Fastest Way
```bash
curl -fsSL https://raw.githubusercontent.com/ZeroOneLogan/Modern_zsh/main/install.sh | bash
```

Restart your terminal and you're done! 🎉

## First Steps

### 1. Install Modern Tools (Optional but Recommended)
```bash
brew install eza bat ripgrep fd fzf zoxide starship
```

### 2. Install a Nerd Font (For Icons)
```bash
brew tap homebrew/cask-fonts
brew install --cask font-fira-code-nerd-font
```

Configure your terminal app to use "FiraCode Nerd Font"

### 3. Test Your Setup

Try these commands:
```bash
# Modern ls with icons
ls

# Navigate to a directory (zoxide)
z downloads

# Search files
fzf

# Check git status with beautiful output
gst
```

## Essential Commands

### Configuration
- `reload` - Reload zsh config
- `zshconfig` - Edit main config
- `zshalias` - Edit aliases
- `zshfunc` - Edit functions

### Navigation
- `..` - Go up one directory
- `...` - Go up two directories  
- `z project` - Jump to frequently used directory
- `mkcd dirname` - Create and enter directory

### Git
- `gst` - Git status
- `ga .` - Git add all
- `gcm "message"` - Git commit with message
- `gp` - Git push
- `gl` - Git log (beautiful)

### Development
- `nr dev` - npm run dev
- `py` - python3
- `serve` - Start HTTP server
- `port-kill 8080` - Kill process on port

## Customization

### Add Your Own Aliases
```bash
echo 'alias myalias="my command"' >> ~/.zshrc.local
```

### Add Your Own Functions
```bash
cat >> ~/.zshrc.local << 'EOF'
myfunction() {
    echo "Hello from my function!"
}
EOF
```

### Customize Prompt
Edit `~/.config/starship.toml`

## Getting Help

### Show Available Aliases
```bash
alias | grep "^g"     # Show git aliases
alias | grep "^k"     # Show kubectl aliases
alias | grep "^d"     # Show docker aliases
```

### Show Available Functions
```bash
# List all functions
print -l ${(ok)functions}
```

### Read Full Documentation
See [README.md](./README.md) for complete documentation

## Tips & Tricks

1. **Use Tab Completion**: Start typing and press Tab
2. **Search History**: Press Ctrl+R and start typing
3. **Auto-suggestions**: Start typing a previous command
4. **Fuzzy Find Files**: Ctrl+T
5. **Fuzzy Find Directories**: Alt+C (Mac: Option+C)

## Troubleshooting

### Icons not showing?
Install a Nerd Font and configure your terminal to use it

### Slow startup?
Run `zprof` after adding this to your `.zshrc`:
```bash
zmodload zsh/zprof
```

### Need to revert?
Your old config was backed up to `~/.zsh_backup_*`

## What's Next?

- Explore the [full documentation](./README.md)
- Learn more about [Starship](https://starship.rs/)
- Customize your [aliases](./aliases.zsh) and [functions](./functions.zsh)
- Share your improvements!

---

**Enjoy your modern shell! 🎉**

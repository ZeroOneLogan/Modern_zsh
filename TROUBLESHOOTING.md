# Troubleshooting Guide 🔧

Common issues and their solutions for Modern Zsh configuration.

## Table of Contents
- [Installation Issues](#installation-issues)
- [Performance Issues](#performance-issues)
- [Display Issues](#display-issues)
- [Plugin Issues](#plugin-issues)
- [Compatibility Issues](#compatibility-issues)
- [macOS-Specific Issues](#macos-specific-issues)

## Installation Issues

### Problem: Installation script fails

**Symptoms:**
```bash
curl: (7) Failed to connect to raw.githubusercontent.com
```

**Solution:**
1. Check internet connection
2. Try downloading manually:
```bash
git clone https://github.com/ZeroOneLogan/Modern_zsh.git
cd Modern_zsh
./install.sh
```

### Problem: Permission denied when running install.sh

**Symptoms:**
```bash
-bash: ./install.sh: Permission denied
```

**Solution:**
```bash
chmod +x install.sh
./install.sh
```

### Problem: Homebrew not found

**Symptoms:**
```bash
brew: command not found
```

**Solution:**
Install Homebrew first:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# For Apple Silicon (M1/M2/M3)
eval "$(/opt/homebrew/bin/brew shellenv)"

# For Intel Macs
eval "$(/usr/local/bin/brew shellenv)"
```

## Performance Issues

### Problem: Slow startup time

**Diagnosis:**
Add to top of `.zshrc`:
```bash
zmodload zsh/zprof
```

Add to bottom of `.zshrc`:
```bash
zprof
```

Then restart terminal to see timing breakdown.

**Solutions:**

1. **Disable unused plugins:**
   Comment out plugins in `.zshrc`:
   ```bash
   # zinit light some-slow-plugin
   ```

2. **Lazy load heavy tools:**
   NVM is already lazy-loaded, but you can do this for other tools:
   ```bash
   # Instead of sourcing directly
   # source ~/.rvm/scripts/rvm
   
   # Lazy load
   rvm() {
       unset -f rvm
       source ~/.rvm/scripts/rvm
       rvm "$@"
   }
   ```

3. **Clean completion cache:**
   ```bash
   rm -f ~/.zcompdump*
   rm -rf "$XDG_CACHE_HOME/zsh/.zcompcache"
   ```

4. **Update plugins:**
   ```bash
   zinit update --all
   ```

### Problem: Commands feel sluggish

**Check if it's zsh or the command:**
```bash
time ls  # See how long command takes
```

**Solutions:**
1. Disable syntax highlighting temporarily:
   ```bash
   # Comment in .zshrc
   # zinit light zdharma-continuum/fast-syntax-highlighting
   ```

2. Reduce history size in `.zshrc`:
   ```bash
   export HISTSIZE=10000
   export SAVEHIST=10000
   ```

## Display Issues

### Problem: Icons not showing (squares/question marks)

**Symptoms:**
```
╭─ᴥ ~/Projects  main 
```
Shows as:
```
╭─□ ~/Projects □ main 
```

**Solution:**
1. Install a Nerd Font:
   ```bash
   brew tap homebrew/cask-fonts
   brew install --cask font-fira-code-nerd-font
   ```

2. Configure your terminal:
   - **Terminal.app**: Preferences → Profiles → Font → Select "FiraCode Nerd Font"
   - **iTerm2**: Preferences → Profiles → Text → Font → Select "FiraCode Nerd Font"
   - **Alacritty**: Edit `~/.config/alacritty/alacritty.yml`:
     ```yaml
     font:
       normal:
         family: "FiraCode Nerd Font"
     ```

3. Restart terminal

### Problem: Colors look wrong

**Solution:**
1. Check terminal supports 256 colors:
   ```bash
   echo $TERM
   # Should show: xterm-256color or similar
   ```

2. Set in terminal preferences or add to `.zshrc`:
   ```bash
   export TERM=xterm-256color
   ```

3. For iTerm2, enable: Preferences → Profiles → Terminal → Report Terminal Type: `xterm-256color`

### Problem: Prompt is too long/wraps

**Solution:**
Edit `~/.config/starship.toml`:
```toml
# Shorten directory display
[directory]
truncation_length = 2  # Show fewer directory levels

# Remove right prompt
right_format = ""  # Comment out or empty

# Simplify format
format = """
$directory\
$git_branch\
$character"""
```

## Plugin Issues

### Problem: zinit not installing

**Symptoms:**
```bash
zinit: command not found
```

**Solution:**
```bash
# Remove and reinstall
rm -rf "${XDG_DATA_HOME:-${HOME}/.local/share}/zinit"
source ~/.zshrc  # Will auto-install
```

### Problem: Completions not working

**Symptoms:**
Tab completion doesn't show suggestions or shows errors.

**Solutions:**

1. **Rebuild completion cache:**
   ```bash
   rm -f ~/.zcompdump*
   autoload -Uz compinit && compinit
   ```

2. **Fix permissions:**
   ```bash
   compaudit | xargs chmod g-w,o-w
   # Or if you trust the directories:
   compaudit | xargs chmod g-w
   ```

3. **Reinstall completions:**
   ```bash
   zinit delete zsh-users/zsh-completions
   zinit load zsh-users/zsh-completions
   ```

### Problem: Auto-suggestions not appearing

**Solution:**
1. Check if plugin is loaded:
   ```bash
   zinit list | grep autosuggestions
   ```

2. Adjust suggestion color if invisible:
   Add to `.zshrc`:
   ```bash
   ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
   ```

3. Reinstall plugin:
   ```bash
   zinit delete zsh-users/zsh-autosuggestions
   source ~/.zshrc
   ```

## Compatibility Issues

### Problem: Command not found after installation

**Example:**
```bash
eza: command not found
```

**Solution:**
Install the missing tool:
```bash
brew install eza

# For all recommended tools:
brew install eza bat ripgrep fd fzf zoxide
```

Or use fallback aliases - they're already configured!

### Problem: Conflicting with existing configuration

**Symptoms:**
- Duplicate PATH entries
- Functions not working
- Aliases overridden

**Solution:**
1. Check for conflicting configs:
   ```bash
   grep -r "export PATH" ~/.zsh* ~/.bash* 2>/dev/null
   ```

2. Remove or rename old configs:
   ```bash
   mv ~/.bash_profile ~/.bash_profile.bak
   mv ~/.bashrc ~/.bashrc.bak
   ```

3. Check `.zshenv` for conflicts:
   ```bash
   cat ~/.zshenv
   ```

### Problem: NVM not working

**Solution:**
1. Ensure NVM is installed:
   ```bash
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
   ```

2. NVM is lazy-loaded. Use it once to initialize:
   ```bash
   nvm --version
   ```

3. Or load immediately by adding to `.zshrc.local`:
   ```bash
   [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
   ```

## macOS-Specific Issues

### Problem: Homebrew path not found

**Solution:**

For Apple Silicon (M1/M2/M3):
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc
```

For Intel Macs:
```bash
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zshrc
source ~/.zshrc
```

### Problem: Command line tools not installed

**Symptoms:**
```bash
xcrun: error: invalid active developer path
```

**Solution:**
```bash
xcode-select --install
```

### Problem: Git signing fails

**Solution:**
```bash
# Ensure GPG TTY is set (already in .zshrc, but verify)
export GPG_TTY=$(tty)

# Test signing
echo "test" | gpg --clearsign
```

### Problem: Can't change default shell to zsh

**Solution:**
```bash
# Check if zsh is in allowed shells
cat /etc/shells

# If not, add it:
sudo sh -c "echo $(which zsh) >> /etc/shells"

# Change shell
chsh -s $(which zsh)

# Log out and log back in
```

## General Debugging

### Enable debug mode

Add to top of `.zshrc`:
```bash
set -x  # Enable debug output
```

Remove or comment out after debugging.

### Check for errors

```bash
# Source config and check for errors
zsh -f -c 'source ~/.zshrc'
```

### Reset to default

If all else fails:
```bash
# Restore backup (find the most recent backup directory first)
mv ~/.zshrc ~/.zshrc.broken
cp $(ls -td ~/.zsh_backup_* | head -1)/.zshrc ~/.zshrc

# Or reinstall
mv ~/.zshrc ~/.zshrc.broken
curl -fsSL https://raw.githubusercontent.com/ZeroOneLogan/Modern_zsh/main/install.sh | bash
```

## Getting Help

### Before asking for help, gather information:

```bash
# System info
sw_vers

# Zsh version
zsh --version

# Installed tools
brew list

# Check config
head -20 ~/.zshrc

# Recent errors
tail -50 ~/.zsh_history | grep -i error
```

### Where to get help:

1. **GitHub Issues**: [Modern_zsh Issues](https://github.com/ZeroOneLogan/Modern_zsh/issues)
2. **Documentation**: Re-read README.md and QUICKSTART.md
3. **Community**: GitHub Discussions

### Providing useful bug reports:

Include:
1. macOS version
2. Zsh version
3. Steps to reproduce
4. Expected vs actual behavior
5. Relevant config sections
6. Error messages (full output)

## Preventive Maintenance

### Regular updates

```bash
# Update Homebrew and packages
brew update && brew upgrade && brew cleanup

# Update zinit plugins
zinit update --all

# Update zinit itself
zinit self-update
```

### Clean cache periodically

```bash
# Once a month
rm -f ~/.zcompdump*
rm -rf "$XDG_CACHE_HOME/zsh/.zcompcache"
```

### Backup your config

```bash
# Backup your custom settings
cp ~/.zshrc.local ~/Dropbox/backups/  # Or your backup location
```

## Tips for Smooth Operation

1. **Start Fresh**: When troubleshooting, try in a new terminal window
2. **Test Incrementally**: Add one change at a time
3. **Read Error Messages**: They usually tell you what's wrong
4. **Check Versions**: Keep tools updated
5. **Backup First**: Always backup before major changes
6. **Use .zshrc.local**: Keep personal changes separate
7. **Document Changes**: Comment your custom configurations

---

**Still having issues? Open an issue on GitHub with details!**

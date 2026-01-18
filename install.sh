#!/usr/bin/env bash

# ============================================================================
# Modern Zsh Configuration - Installation Script
# ============================================================================
# This script will install and configure a modern zsh setup for macOS
#
# Usage: curl -fsSL https://raw.githubusercontent.com/ZeroOneLogan/Modern_zsh/main/install.sh | bash
# Or: ./install.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ============================================================================
# Helper Functions
# ============================================================================

print_header() {
    echo -e "${PURPLE}"
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                                                                ║"
    echo "║           Modern Zsh Configuration for macOS                  ║"
    echo "║                                                                ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "${BLUE}▓▒░${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${CYAN}ℹ${NC} $1"
}

# ============================================================================
# Checks
# ============================================================================

check_os() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "This script is designed for macOS only."
        exit 1
    fi
    print_success "Running on macOS"
}

check_zsh() {
    if ! command -v zsh &> /dev/null; then
        print_error "Zsh is not installed. Please install it first."
        exit 1
    fi
    print_success "Zsh is installed: $(zsh --version)"
}

check_homebrew() {
    if ! command -v brew &> /dev/null; then
        print_warning "Homebrew is not installed."
        read -p "Would you like to install Homebrew? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_step "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            
            # Add Homebrew to PATH for Apple Silicon Macs
            if [[ $(uname -m) == 'arm64' ]]; then
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
            
            print_success "Homebrew installed successfully"
        else
            print_warning "Skipping Homebrew installation. Some features may not work."
        fi
    else
        print_success "Homebrew is installed: $(brew --version | head -n1)"
    fi
}

# ============================================================================
# Backup
# ============================================================================

backup_existing_config() {
    print_step "Backing up existing configuration..."
    
    local backup_dir="$HOME/.zsh_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    if [[ -f "$HOME/.zshrc" ]]; then
        cp "$HOME/.zshrc" "$backup_dir/"
        print_success "Backed up .zshrc to $backup_dir"
    fi
    
    if [[ -f "$HOME/.zshenv" ]]; then
        cp "$HOME/.zshenv" "$backup_dir/"
        print_success "Backed up .zshenv to $backup_dir"
    fi
    
    if [[ -d "$HOME/.config/zsh" ]]; then
        cp -r "$HOME/.config/zsh" "$backup_dir/"
        print_success "Backed up .config/zsh to $backup_dir"
    fi
}

# ============================================================================
# Installation
# ============================================================================

install_config_files() {
    print_step "Installing configuration files..."
    
    # Create config directory
    mkdir -p "$HOME/.config/zsh"
    
    # Download or copy .zshrc
    if [[ -f ".zshrc" ]]; then
        cp ".zshrc" "$HOME/.zshrc"
    else
        curl -fsSL "https://raw.githubusercontent.com/ZeroOneLogan/Modern_zsh/main/.zshrc" -o "$HOME/.zshrc"
    fi
    print_success "Installed .zshrc"
    
    # Download or copy aliases
    if [[ -f "aliases.zsh" ]]; then
        cp "aliases.zsh" "$HOME/.config/zsh/aliases.zsh"
    else
        curl -fsSL "https://raw.githubusercontent.com/ZeroOneLogan/Modern_zsh/main/aliases.zsh" -o "$HOME/.config/zsh/aliases.zsh"
    fi
    print_success "Installed aliases.zsh"
    
    # Download or copy functions
    if [[ -f "functions.zsh" ]]; then
        cp "functions.zsh" "$HOME/.config/zsh/functions.zsh"
    else
        curl -fsSL "https://raw.githubusercontent.com/ZeroOneLogan/Modern_zsh/main/functions.zsh" -o "$HOME/.config/zsh/functions.zsh"
    fi
    print_success "Installed functions.zsh"
    
    # Download or copy starship config
    if [[ -f "starship.toml" ]]; then
        cp "starship.toml" "$HOME/.config/starship.toml"
    else
        curl -fsSL "https://raw.githubusercontent.com/ZeroOneLogan/Modern_zsh/main/starship.toml" -o "$HOME/.config/starship.toml"
    fi
    print_success "Installed starship.toml"
}

install_starship() {
    if ! command -v starship &> /dev/null; then
        print_step "Installing Starship prompt..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y
        print_success "Starship installed successfully"
    else
        print_success "Starship is already installed: $(starship --version)"
    fi
}

install_modern_tools() {
    print_step "Installing modern CLI tools (optional)..."
    
    if command -v brew &> /dev/null; then
        read -p "Would you like to install modern CLI tools? (eza, bat, ripgrep, fd, fzf, zoxide) (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            local tools=("eza" "bat" "ripgrep" "fd" "fzf" "zoxide" "thefuck")
            
            for tool in "${tools[@]}"; do
                if ! command -v "$tool" &> /dev/null; then
                    print_step "Installing $tool..."
                    brew install "$tool" || print_warning "Failed to install $tool"
                else
                    print_info "$tool is already installed"
                fi
            done
            
            print_success "Modern CLI tools installation complete"
        fi
    fi
}

install_fonts() {
    print_step "Installing Nerd Fonts (recommended for icons)..."
    
    read -p "Would you like to install a Nerd Font for icons? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if command -v brew &> /dev/null; then
            brew tap homebrew/cask-fonts
            
            echo "Choose a font:"
            echo "1) FiraCode Nerd Font (recommended)"
            echo "2) Meslo Nerd Font"
            echo "3) JetBrains Mono Nerd Font"
            echo "4) Hack Nerd Font"
            echo "5) Skip"
            read -p "Enter choice [1-5]: " font_choice
            
            case $font_choice in
                1) brew install --cask font-fira-code-nerd-font ;;
                2) brew install --cask font-meslo-lg-nerd-font ;;
                3) brew install --cask font-jetbrains-mono-nerd-font ;;
                4) brew install --cask font-hack-nerd-font ;;
                *) print_info "Skipping font installation" ;;
            esac
            
            print_success "Font installation complete"
            print_info "Remember to configure your terminal to use the installed Nerd Font"
        fi
    fi
}

set_zsh_default() {
    if [[ "$SHELL" != */zsh ]]; then
        print_step "Setting Zsh as default shell..."
        chsh -s "$(which zsh)"
        print_success "Zsh set as default shell"
        print_warning "Please log out and log back in for the change to take effect"
    else
        print_success "Zsh is already the default shell"
    fi
}

# ============================================================================
# Main Installation
# ============================================================================

main() {
    print_header
    
    print_step "Starting installation..."
    echo
    
    # Checks
    check_os
    check_zsh
    check_homebrew
    echo
    
    # Backup
    backup_existing_config
    echo
    
    # Install
    install_config_files
    echo
    
    install_starship
    echo
    
    install_modern_tools
    echo
    
    install_fonts
    echo
    
    set_zsh_default
    echo
    
    # Final message
    echo -e "${GREEN}"
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                                                                ║"
    echo "║              Installation Complete! 🎉                         ║"
    echo "║                                                                ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo
    print_info "To start using your new configuration:"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. Configure your terminal to use a Nerd Font for best experience"
    echo "  3. Customize ~/.zshrc.local for personal settings"
    echo
    print_info "Useful commands:"
    echo "  - 'reload' to reload the configuration"
    echo "  - 'zshconfig' to edit the main config"
    echo "  - 'zshalias' to edit aliases"
    echo "  - 'zshfunc' to edit functions"
    echo
    print_info "Documentation: https://github.com/ZeroOneLogan/Modern_zsh"
    echo
}

# Run main function
main

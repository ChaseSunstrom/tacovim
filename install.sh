#!/bin/bash

# TacoVim Installation Script
# A deliciously powerful Neovim configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Emojis for better UX
TACO="🌮"
ROCKET="🚀"
CHECK="✅"
CROSS="❌"
WARNING="⚠️"
INFO="ℹ️"
GEAR="⚙️"
SPARKLES="✨"

# Configuration
TACOVIM_REPO="https://github.com/your-username/tacovim.git"
TACOVIM_BRANCH="main"
NVIM_CONFIG_DIR="$HOME/.config/nvim"
NVIM_DATA_DIR="$HOME/.local/share/nvim"
BACKUP_DIR="$HOME/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)"

# Helper functions
print_header() {
    echo -e "${WHITE}"
    echo "  ████████╗ █████╗  ██████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗"
    echo "  ╚══██╔══╝██╔══██╗██╔════╝██╔═══██╗██║   ██║██║████╗ ████║"
    echo "     ██║   ███████║██║     ██║   ██║██║   ██║██║██╔████╔██║"
    echo "     ██║   ██╔══██║██║     ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║"
    echo "     ██║   ██║  ██║╚██████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║"
    echo "     ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝"
    echo -e "${NC}"
    echo -e "${CYAN}${TACO} A deliciously powerful Neovim configuration${NC}"
    echo -e "${WHITE}═══════════════════════════════════════════════════════════${NC}"
}

print_step() {
    echo -e "${BLUE}${GEAR} $1${NC}"
}

print_success() {
    echo -e "${GREEN}${CHECK} $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}${WARNING} $1${NC}"
}

print_error() {
    echo -e "${RED}${CROSS} $1${NC}"
}

print_info() {
    echo -e "${CYAN}${INFO} $1${NC}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check system requirements
check_requirements() {
    print_step "Checking system requirements..."
    
    local missing_deps=()
    
    # Check Neovim
    if command_exists nvim; then
        local nvim_version=$(nvim --version | head -n1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)
        local required_version="0.9.0"
        
        if [ "$(printf '%s\n' "$required_version" "$nvim_version" | sort -V | head -n1)" = "$required_version" ]; then
            print_success "Neovim $nvim_version found"
        else
            print_error "Neovim $nvim_version is too old. Please upgrade to $required_version or newer."
            exit 1
        fi
    else
        missing_deps+=("neovim")
    fi
    
    # Check Git
    if command_exists git; then
        print_success "Git found"
    else
        missing_deps+=("git")
    fi
    
    # Check Node.js (optional but recommended)
    if command_exists node; then
        local node_version=$(node --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
        print_success "Node.js $node_version found"
    else
        print_warning "Node.js not found - some LSP servers may not work"
    fi
    
    # Check Python (optional but recommended)
    if command_exists python3; then
        local python_version=$(python3 --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
        print_success "Python $python_version found"
    else
        print_warning "Python3 not found - Python LSP support may not work"
    fi
    
    # Check for package managers
    local package_manager=""
    if command_exists apt-get; then
        package_manager="apt-get"
    elif command_exists pacman; then
        package_manager="pacman"
    elif command_exists brew; then
        package_manager="brew"
    elif command_exists dnf; then
        package_manager="dnf"
    elif command_exists zypper; then
        package_manager="zypper"
    fi
    
    # Install missing dependencies
    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_warning "Missing dependencies: ${missing_deps[*]}"
        echo -e "${YELLOW}Please install the missing dependencies and run this script again.${NC}"
        
        if [ -n "$package_manager" ]; then
            echo -e "\n${INFO} Installation commands for your system:"
            case $package_manager in
                apt-get)
                    echo -e "${WHITE}sudo apt-get update && sudo apt-get install ${missing_deps[*]}${NC}"
                    ;;
                pacman)
                    echo -e "${WHITE}sudo pacman -S ${missing_deps[*]}${NC}"
                    ;;
                brew)
                    echo -e "${WHITE}brew install ${missing_deps[*]}${NC}"
                    ;;
                dnf)
                    echo -e "${WHITE}sudo dnf install ${missing_deps[*]}${NC}"
                    ;;
                zypper)
                    echo -e "${WHITE}sudo zypper install ${missing_deps[*]}${NC}"
                    ;;
            esac
        fi
        exit 1
    fi
    
    print_success "All requirements satisfied!"
}

# Check for Nerd Font
check_nerd_font() {
    print_step "Checking for Nerd Font..."
    
    if fc-list | grep -i "nerd\|powerline\|fira\|hack\|source\|meslo" > /dev/null; then
        print_success "Nerd Font detected"
    else
        print_warning "No Nerd Font detected"
        echo -e "${YELLOW}TacoVim uses icons that require a Nerd Font for proper display.${NC}"
        echo -e "${INFO} Download from: https://www.nerdfonts.com/"
        echo -e "${INFO} Recommended fonts: FiraCode Nerd Font, Hack Nerd Font, JetBrains Mono Nerd Font"
        
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Backup existing configuration
backup_existing_config() {
    if [ -d "$NVIM_CONFIG_DIR" ]; then
        print_step "Backing up existing Neovim configuration..."
        
        if mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"; then
            print_success "Backup created at $BACKUP_DIR"
        else
            print_error "Failed to backup existing configuration"
            exit 1
        fi
    fi
    
    if [ -d "$NVIM_DATA_DIR" ]; then
        print_step "Backing up Neovim data directory..."
        if mv "$NVIM_DATA_DIR" "${NVIM_DATA_DIR}.backup.$(date +%Y%m%d_%H%M%S)"; then
            print_success "Data directory backed up"
        else
            print_warning "Failed to backup data directory - continuing anyway"
        fi
    fi
}

# Clone TacoVim repository
install_tacovim() {
    print_step "Installing TacoVim..."
    
    if git clone --depth 1 --branch "$TACOVIM_BRANCH" "$TACOVIM_REPO" "$NVIM_CONFIG_DIR"; then
        print_success "TacoVim cloned successfully"
    else
        print_error "Failed to clone TacoVim repository"
        exit 1
    fi
}

# Post-installation setup
post_install_setup() {
    print_step "Setting up TacoVim..."
    
    # Create user config if it doesn't exist
    local user_config="$NVIM_CONFIG_DIR/lua/user_config.lua"
    if [ ! -f "$user_config" ]; then
        print_info "Creating default user configuration..."
        cat > "$user_config" << 'EOF'
-- ~/.config/nvim/lua/user_config.lua
-- Your personal TacoVim configuration

return {
  -- UI Preferences
  ui = {
    theme = "catppuccin-mocha",  -- Available: catppuccin-*, tokyonight-*, gruvbox-*, etc.
    transparent = false,         -- Enable transparent background
    animations = true,           -- Enable smooth animations
    icons = true,               -- Show file and UI icons
  },
  
  -- Editor Settings
  editor = {
    line_numbers = true,        -- Show line numbers
    relative_numbers = true,    -- Show relative line numbers  
    wrap = false,              -- Enable line wrapping
    auto_save = false,         -- Auto-save files on focus loss
    auto_format = true,        -- Auto-format files on save
    indent_size = 2,           -- Default indentation size
  },
  
  -- LSP Settings
  lsp = {
    auto_install = true,       -- Auto-install LSP servers
    format_on_save = true,     -- Format files on save
    diagnostics = true,        -- Show diagnostics
    inlay_hints = false,       -- Show inlay hints (if supported)
  },
  
  -- Completion Settings  
  completion = {
    enable = true,             -- Enable completion
    auto_select = false,       -- Auto-select first completion item
    documentation = true,      -- Show documentation window
    max_items = 20,           -- Maximum completion items
  },
  
  -- Git Integration
  git = {
    signs = true,             -- Show git signs
    blame = false,            -- Show git blame
    diff_view = true,         -- Enable diff view
    auto_stage = false,       -- Auto-stage changes
  },
  
  -- Terminal Settings
  terminal = {
    direction = "horizontal", -- Default terminal direction
    size = 15,               -- Terminal size
    shell = vim.o.shell,     -- Default shell
    close_on_exit = true,    -- Close terminal on exit
  },
  
  -- Plugin Settings
  plugins = {
    -- Enable/disable built-in plugins
    treesitter = true,
    telescope = true,
    neotree = true,
    which_key = true,
    bufferline = true,
    lualine = true,
    gitsigns = true,
    comment = true,
    autopairs = true,
    surround = true,
    
    -- Additional user plugins (will be loaded automatically)
    additional = {
      -- Example: Add your own plugins here
      -- { "user/plugin-name", config = function() end },
    },
  },
  
  -- Keymap Settings
  keymaps = {
    leader = " ",            -- Leader key
    localleader = " ",       -- Local leader key
    disable_defaults = false, -- Disable default keymaps
    
    -- Custom keymaps (will be loaded automatically)
    custom = {
      -- Example: Add your own keymaps here
      -- { "n", "<leader>xx", ":command<cr>", { desc = "Custom command" } },
    },
  },
  
  -- File Type Settings
  filetypes = {
    -- Custom file type configurations
    -- Example:
    -- lua = { indent_size = 2, auto_format = true },
    -- python = { indent_size = 4, auto_format = true },
  },
  
  -- Project Settings
  projects = {
    auto_cd = true,          -- Auto change directory to project root
    auto_session = true,     -- Auto-save/restore sessions
    recent_limit = 10,       -- Max recent projects
  },
  
  -- Debug Settings
  debug = {
    enabled = true,          -- Enable debugging
    auto_open_ui = true,     -- Auto-open debug UI
    auto_close_ui = true,    -- Auto-close debug UI
  },
}
EOF
        print_success "User configuration created"
    fi
    
    print_success "TacoVim setup complete!"
}

# Final instructions
show_final_instructions() {
    echo -e "\n${WHITE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}${SPARKLES} TacoVim Installation Complete! ${SPARKLES}${NC}"
    echo -e "${WHITE}═══════════════════════════════════════════════════════════${NC}"
    
    echo -e "\n${CYAN}${ROCKET} Quick Start:${NC}"
    echo -e "${WHITE}1. Launch Neovim:${NC} nvim"
    echo -e "${WHITE}2. Wait for plugins to install automatically${NC}"
    echo -e "${WHITE}3. Choose a theme:${NC} <Space>ut"
    echo -e "${WHITE}4. Create a project:${NC} <Space>pm then n"
    echo -e "${WHITE}5. Explore keymaps:${NC} <Space>uk"
    
    echo -e "\n${CYAN}${INFO} Essential Keybindings:${NC}"
    echo -e "${WHITE}<Space>pm${NC}  - Project manager"
    echo -e "${WHITE}<Space>ff${NC}  - Find files"
    echo -e "${WHITE}<Space>fs${NC}  - Search in project"
    echo -e "${WHITE}<Space>ee${NC}  - File explorer"
    echo -e "${WHITE}<Space>uc${NC}  - Edit user config"
    echo -e "${WHITE}<Space>uk${NC}  - Keymap manager"
    
    echo -e "\n${CYAN}${INFO} Configuration:${NC}"
    echo -e "${WHITE}• User config:${NC} ~/.config/nvim/lua/user_config.lua"
    echo -e "${WHITE}• Keymap guide:${NC} ~/.config/nvim/KEYMAP_GUIDE.md"
    echo -e "${WHITE}• Edit config:${NC} <Space>uc"
    echo -e "${WHITE}• Reload config:${NC} <Space>uR"
    
    if [ -d "$BACKUP_DIR" ]; then
        echo -e "\n${YELLOW}${WARNING} Your previous configuration was backed up to:${NC}"
        echo -e "${WHITE}$BACKUP_DIR${NC}"
    fi
    
    echo -e "\n${CYAN}${INFO} Need help?${NC}"
    echo -e "${WHITE}• Documentation:${NC} https://github.com/your-username/tacovim"
    echo -e "${WHITE}• Issues:${NC} https://github.com/your-username/tacovim/issues"
    echo -e "${WHITE}• Health check:${NC} :checkhealth"
    
    echo -e "\n${GREEN}${TACO} Enjoy your deliciously powerful Neovim experience! ${TACO}${NC}"
}

# Main installation function
main() {
    print_header
    
    echo -e "${CYAN}This script will install TacoVim - a comprehensive Neovim configuration.${NC}"
    echo -e "${YELLOW}Your existing Neovim configuration will be backed up.${NC}\n"
    
    read -p "Do you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Installation cancelled.${NC}"
        exit 1
    fi
    
    echo
    check_requirements
    check_nerd_font
    backup_existing_config
    install_tacovim
    post_install_setup
    show_final_instructions
}

# Handle interruption
trap 'echo -e "\n${RED}Installation interrupted.${NC}"; exit 1' INT

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Please do not run this script as root"
    exit 1
fi

# Run main function
main "$@" 
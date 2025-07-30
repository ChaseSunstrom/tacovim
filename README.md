# 🌮 TacoVim - Professional Full-Stack Development IDE

![TacoVim Banner](https://img.shields.io/badge/TacoVim-Professional%20IDE-orange?style=for-the-badge&logo=neovim)

**A deliciously powerful Neovim configuration designed for modern full-stack development.**

TacoVim transforms Neovim into a complete IDE experience with intelligent defaults, comprehensive tooling, and a focus on developer productivity. Whether you're building web applications, system software, or mobile apps, TacoVim provides everything you need in one cohesive package.

## ✨ Features

### 🚀 **Core IDE Features**
- **🎯 Smart Project Management** - Create, manage, and switch between projects seamlessly
- **🔧 Comprehensive LSP Integration** - Full language server support for 25+ languages
- **🐛 Advanced Debugging** - VS Code-style debugging with DAP support
- **🧪 Integrated Testing** - Neotest integration for running and managing tests
- **🎨 Beautiful UI** - Modern interface with statusline, bufferline, and file explorer
- **⚡ Lightning Fast** - Optimized startup time and responsive performance

### 🛠️ **Development Tools**
- **📝 Intelligent Code Completion** - nvim-cmp with multiple sources
- **🔍 Powerful Search & Replace** - Telescope + Spectre for project-wide operations
- **🎯 Syntax Highlighting** - Treesitter with support for 50+ languages
- **✨ Auto-formatting** - Conform.nvim with language-specific formatters
- **📐 Linting & Diagnostics** - Real-time error detection and suggestions
- **🔗 Git Integration** - Neogit, Gitsigns, and Diffview for version control

### 🌍 **Multi-Language Support**
- **Web Development**: TypeScript/JavaScript, React, Vue, Svelte, HTML/CSS
- **Systems Programming**: Rust, C/C++, Go, Zig
- **Backend Development**: Python, Java, C#, Elixir, PHP
- **Functional Languages**: Haskell, Clojure, OCaml
- **Data Science**: Python, R, Julia, Jupyter Notebooks
- **Mobile Development**: React Native, Flutter/Dart
- **And many more...**

### 🎨 **Customization & Themes**
- **🎭 15+ Built-in Themes** - Catppuccin, Tokyo Night, Gruvbox, and more
- **⚙️ User Configuration System** - Easy customization without modifying core files
- **🎹 Interactive Keymap Manager** - Add, modify, and manage keybindings through UI
- **🔧 Plugin Management** - Easy installation and configuration of additional plugins

## 📦 Installation

### Prerequisites
- **Neovim 0.9.0+** (recommended: latest stable)
- **Git** for cloning repositories
- **A Nerd Font** for icons and symbols
- **Node.js** (for LSP servers)
- **Python 3** (for Python LSP support)

### Quick Install

Run our installation script to set up TacoVim automatically:

```bash
# Clone and install TacoVim
curl -fsSL https://raw.githubusercontent.com/your-username/tacovim/main/install.sh | bash
```

### Manual Installation

1. **Backup existing Neovim configuration:**
```bash
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
```

2. **Clone TacoVim:**
```bash
git clone https://github.com/your-username/tacovim.git ~/.config/nvim
```

3. **Start Neovim:**
```bash
nvim
```

TacoVim will automatically install all plugins and LSP servers on first launch.

## 🚀 Quick Start

### First Steps
1. **Launch Neovim** - TacoVim will auto-install everything
2. **Choose a theme** - Press `<Space>ut` to browse themes
3. **Create a project** - Press `<Space>pm` then `n` for new project
4. **Explore keymaps** - Press `<Space>uk` for keymap manager

### Essential Keybindings
| Key | Action | Description |
|-----|--------|-------------|
| `<Space>` | Leader key | All TacoVim commands start here |
| `<Space>pm` | Project manager | Create, open, manage projects |
| `<Space>ff` | Find files | Telescope file finder |
| `<Space>fs` | Search project | Live grep in project |
| `<Space>ee` | File explorer | Toggle Neo-tree file explorer |
| `<Space>uc` | User config | Edit your custom configuration |
| `<Space>uk` | Keymap manager | Interactive keymap management |

## 📂 Project Templates

TacoVim includes 30+ project templates for rapid development:

### Web Development
- HTML/CSS/JS Website
- React App (Vite)
- React App (Next.js)
- Vue.js App
- Svelte App
- Angular App
- Astro App

### Backend APIs
- Node.js API
- Express.js API
- Python FastAPI
- Python Flask/Django
- Go HTTP Server
- Rust Axum API

### Systems Programming
- Rust Binary/Library
- C++ CMake Project
- C Project
- Zig Application

### Mobile Development
- React Native App
- Flutter App

### Data Science
- Python Data Science
- Jupyter Notebook
- R Project

[See complete list in documentation](./KEYMAP_GUIDE.md)

## 🎹 Keybinding System

TacoVim uses a logical, discoverable keybinding system organized into groups:

### Main Groups
- **`<Space>f`** - **File operations** (find, recent, etc.)
- **`<Space>s`** - **Search operations** (grep, replace, etc.)
- **`<Space>p`** - **Project management** (open, create, switch)
- **`<Space>b`** - **Buffer operations** (switch, close, etc.)
- **`<Space>w`** - **Window management** (split, resize, etc.)
- **`<Space>c`** - **Code operations** (actions, diagnostics, etc.)
- **`<Space>l`** - **LSP operations** (definitions, references, etc.)
- **`<Space>g`** - **Git operations** (status, commits, branches)
- **`<Space>d`** - **Debug operations** (breakpoints, step, etc.)
- **`<Space>t`** - **Terminal operations** (toggle, run commands)
- **`<Space>r`** - **Run/Build operations** (build, test, clean)
- **`<Space>u`** - **UI/Utility operations** (themes, settings, etc.)

### Project Management Subcategories
- **`<Space>pm`** - **Project management** (new, open, delete)
- **`<Space>pf`** - **Project files** (find, search, browse)
- **`<Space>pn`** - **Project navigation** (marks, jumps)

### Visual Studio Style Debugging
- **`<F5>`** - Start/Continue debugging
- **`<Shift-F5>`** - Stop debugging
- **`<F9>`** - Toggle breakpoint
- **`<F10>`** - Step over
- **`<F11>`** - Step into

[Complete keymap reference](./KEYMAP_GUIDE.md)

## ⚙️ Configuration & Customization

### User Configuration System

TacoVim includes a powerful user configuration system that allows you to customize everything without modifying core files:

```bash
# Edit your user configuration
<Space>uc

# Reload configuration
<Space>uR
```

### Configuration Structure
```lua
-- ~/.config/nvim/lua/user_config.lua
return {
  -- UI Preferences
  ui = {
    theme = "catppuccin-mocha",
    transparent = false,
    animations = true,
  },
  
  -- Editor Settings
  editor = {
    auto_save = false,
    auto_format = true,
    indent_size = 2,
  },
  
  -- Custom Plugins
  plugins = {
    additional = {
      { "your/plugin", config = function() end },
    },
  },
  
  -- Custom Keymaps
  keymaps = {
    custom = {
      { "n", "<leader>xx", ":command<cr>", { desc = "Custom command" } },
    },
  },
}
```

### Theme Switching
TacoVim includes 15+ beautiful themes:
- Catppuccin (Mocha, Macchiato, Frappé, Latte)
- Tokyo Night (Night, Storm, Day)
- Gruvbox (Dark, Light)
- Rose Pine (Main, Moon, Dawn)
- And more...

Switch themes instantly with `<Space>ut`.

## 🔧 Plugin Ecosystem

TacoVim is built on a carefully curated selection of plugins:

### Core Plugins
- **lazy.nvim** - Modern plugin manager
- **telescope.nvim** - Fuzzy finder and search
- **neo-tree.nvim** - File explorer
- **which-key.nvim** - Keymap discovery
- **nvim-treesitter** - Syntax highlighting

### Language Support
- **nvim-lspconfig** - LSP client configuration
- **mason.nvim** - LSP/formatter/linter installer
- **nvim-cmp** - Completion engine
- **conform.nvim** - Formatting
- **nvim-lint** - Linting

### Development Tools
- **nvim-dap** - Debug Adapter Protocol
- **neotest** - Testing framework
- **gitsigns.nvim** - Git integration
- **trouble.nvim** - Diagnostics
- **undotree** - Undo history

### UI Enhancements
- **lualine.nvim** - Statusline
- **bufferline.nvim** - Buffer tabs
- **noice.nvim** - Command line and notifications
- **dressing.nvim** - Better UI elements

[Complete plugin list with configurations](./docs/PLUGINS.md)

## 🐛 Debugging

TacoVim provides a complete debugging experience:

### Supported Languages
- Python (debugpy)
- Node.js/JavaScript (node-debug2)
- Rust (codelldb)
- C/C++ (codelldb)
- Go (delve)
- Java (java-debug)
- And more...

### Debug Features
- Visual breakpoints
- Step through code
- Variable inspection
- Call stack navigation
- Debug console/REPL
- Conditional breakpoints
- Exception handling

### Debug Controls
```
F5     - Start/Continue
Shift+F5 - Stop
F9     - Toggle breakpoint
F10    - Step over
F11    - Step into
Shift+F11 - Step out
```

## 🧪 Testing

Integrated testing with Neotest:

### Supported Frameworks
- Jest (JavaScript/TypeScript)
- pytest (Python)
- cargo test (Rust)
- go test (Go)
- JUnit (Java)
- PHPUnit (PHP)
- And more...

### Test Features
- Run individual tests
- Run test files
- Run test suites
- Watch mode
- Test output panel
- Coverage reports
- Debug tests

## 📊 Performance

TacoVim is optimized for performance:

- **Fast startup** - Typically under 50ms
- **Lazy loading** - Plugins load only when needed
- **Efficient caching** - Reduced disk I/O
- **Memory optimization** - Minimal memory footprint
- **Async operations** - Non-blocking UI

## 🆘 Troubleshooting

### Common Issues

**LSP not working?**
```bash
# Check LSP status
:LspInfo

# Install missing servers
:Mason
```

**Plugins not loading?**
```bash
# Check plugin manager
:Lazy

# Update plugins
:Lazy update
```

**Performance issues?**
```bash
# Check startup time
:Lazy profile

# Health check
:checkhealth
```

### Debug Commands
- `:TacoDebugStatus` - Check debug session status
- `:TacoDebugReload` - Reload debug configuration
- `:TacoDebugTerminate` - Force terminate debug session

### Configuration Commands
- `:TacoConfig` - Edit user configuration
- `:TacoReload` - Reload user configuration
- `:TacoSearch` - Advanced search interface

## 🤝 Contributing

We welcome contributions! Here's how to get started:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Make your changes** and test thoroughly
4. **Commit your changes**: `git commit -m 'Add amazing feature'`
5. **Push to your branch**: `git push origin feature/amazing-feature`
6. **Open a Pull Request**

### Development Setup
```bash
# Clone your fork
git clone https://github.com/yourusername/tacovim.git

# Create a development environment
cp -r ~/.config/nvim ~/.config/nvim.backup
ln -s $(pwd) ~/.config/nvim-dev

# Test with development config
NVIM_APPNAME=nvim-dev nvim
```

## 📚 Documentation

- **[Keymap Guide](./KEYMAP_GUIDE.md)** - Complete keybinding reference
- **[Plugin Documentation](./docs/PLUGINS.md)** - Plugin configurations and features
- **[Customization Guide](./docs/CUSTOMIZATION.md)** - Advanced customization options
- **[Troubleshooting](./docs/TROUBLESHOOTING.md)** - Common issues and solutions
- **[Contributing Guide](./docs/CONTRIBUTING.md)** - How to contribute

## 🙏 Acknowledgments

TacoVim is built on the shoulders of giants. Special thanks to:

- The **Neovim** team for the amazing editor
- All the **plugin authors** who create these fantastic tools
- The **Neovim community** for inspiration and support
- **Contributors** who help make TacoVim better

## 📄 License

TacoVim is open source software licensed under the [MIT License](./LICENSE).

## 🌟 Star History

If you find TacoVim useful, please consider giving it a star! ⭐

---

<div align="center">

**🌮 TacoVim - A deliciously powerful Neovim configuration**

[🏠 Home](https://github.com/your-username/tacovim) • 
[📚 Docs](./docs/) • 
[🐛 Issues](https://github.com/your-username/tacovim/issues) • 
[💬 Discussions](https://github.com/your-username/tacovim/discussions)

Made with ❤️ and 🌮 by the TacoVim community

</div> 
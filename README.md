# 🌮 TacoVim - Professional Full-Stack Development IDE

```
                                ░░░░░▒░░                             
                           ░░░░░░░░░░░▒▒▒░░ ░░                        
                        ░░▒▒▒░▒▒  ░▓▒▓▓▒░░▒▓▒░ ░░                     
                      ░░░ ░░▒▓▓▒▒▒▒▓▓▓▒░░░░░░░░░░░░░                  
                    ░▒▓▓▒▒▒▒▒▓▓▓█▓▓▓░░░▒░░░░░░░░░░░░░░░               
                   ░▒▒▓▓▒▒▓▓░▒▒▒▒▒░▒░░░░░░░░░░░░▒▒▒░░░░░░░            
                  ░░▒▒▓▓▓▓██▓▓▒░░░░░░░░░░░░░░░░▒░░░░░░░░              
                  ▒▓▓▓██▓▓▓▓▒░░░░░░░░░░░░░░▒░░░░░░░                   
                 ░▒▓█▓▓▓█▓░▒░░░░▒░▒░░░▒░░░░░░                         
                ░▒▓▓▓▓██▓▒░░░░░░░░▒░░░░░░░                            
                ░▓▒▓██▓░░░░░░░░░░░░                                   
                 ▒▓▓▓░░░▒░░░                                          
                  ░▒░                                                 

      🌮 ████████╗ █████╗  ██████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ 🌮
         ╚══██╔══╝██╔══██╗██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
            ██║   ███████║██║     ██║   ██║██║   ██║██║██╔████╔██║
            ██║   ██╔══██║██║     ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
            ██║   ██║  ██║╚██████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
            ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝

            🚀 Professional Full-Stack Development IDE 🚀
                      Built with ❤️  for developers
```

> A comprehensive, modern Neovim configuration designed for professional full-stack development across multiple programming languages and frameworks.

## ✨ Features

### 🎯 **Core Features**
- **Professional IDE Experience** - Complete development environment out of the box
- **Multi-Language Support** - Full support for 25+ programming languages
- **Intelligent Project Management** - Automated project templates and detection
- **Advanced Build System** - Language-aware building, testing, and debugging
- **Visual Studio-like Debugging** - Professional debugging with DAP integration
- **Smart Theme Management** - 15+ premium themes with persistent switching
- **Session Management** - Save and restore your workspace sessions

### 🛠️ **Development Tools**
- **LSP Integration** - Native Language Server Protocol support
- **Advanced Autocompletion** - Intelligent code completion with snippets
- **Powerful Search** - Fuzzy finding, symbol search, and live grep
- **Git Integration** - Built-in Git support with LazyGit and DiffView
- **Terminal Integration** - Floating and persistent terminal windows
- **Code Formatting** - Automatic formatting with Conform.nvim
- **Linting** - Real-time code analysis and error detection

### 🎨 **User Experience**
- **Beautiful Dashboard** - Custom TacoVim splash screen with quick actions
- **Enhanced UI** - Modern interface with Catppuccin theme by default
- **Smart Navigation** - Advanced movement with Flash, Leap, and Aerial
- **Multi-Cursor Editing** - Efficient text manipulation
- **Code Folding** - Intelligent folding with UFO
- **Bookmarks & Marks** - Advanced bookmark management

### 🌍 **Language Support**

#### Web Development
- **Frontend**: HTML, CSS, JavaScript, TypeScript, React, Vue, Svelte, Angular, Astro
- **Backend**: Node.js, Express, Fastify, Python (FastAPI/Flask/Django)

#### Systems Programming
- **Native**: Rust, C/C++, Zig, Go
- **JVM**: Java, Kotlin, Scala
- **.NET**: C#, F#

#### Scripting & Data
- **Scripting**: Python, Bash, Lua, Ruby
- **Data Science**: R, Julia, Jupyter Notebooks
- **Functional**: Haskell, Clojure, Elixir

#### Mobile & Others
- **Mobile**: React Native, Flutter, Dart
- **Config**: YAML, TOML, JSON, Dockerfile

## 🚀 Installation

### Prerequisites
- **Neovim** >= 0.9.0
- **Git** for plugin management
- **Node.js** (for LSP servers)
- **Python 3** (for Python development)
- **Cargo** (for Rust development)
- **A Nerd Font** (recommended: JetBrains Mono Nerd Font)

### Quick Install

```bash
# Backup existing Neovim configuration
mv ~/.config/nvim ~/.config/nvim.backup

# Clone TacoVim
git clone https://github.com/ChaseSunstrom/tacovim ~/.config/nvim

# Start Neovim - plugins will install automatically
nvim
```

### Manual Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/ChaseSunstrom/tacovim ~/.config/nvim
   ```

2. **Launch Neovim:**
   ```bash
   nvim
   ```

3. **Wait for plugins to install** - Lazy.nvim will automatically install all plugins

4. **Run health check:**
   ```
   :TacoVimHealth
   ```

5. **Install LSP servers:**
   ```
   :Mason
   ```

## 📚 Usage Guide

### 🎯 Getting Started

After installation, you'll see the TacoVim dashboard. Use these quick actions:

- `f` - Find files
- `n` - New file  
- `p` - Create new project
- `r` - Recent files
- `s` - Search text
- `t` - Switch themes
- `c` - Open configuration

### 🗂️ Project Management

TacoVim includes an intelligent project management system:

#### Create New Project
```
<Space>pn  # Opens project template selector
```

**Available Templates:**
- **Web**: React (Vite/Next.js), Vue, Svelte, Angular, Astro
- **Backend**: Node.js, Python (FastAPI/Flask/Django), Go, Rust
- **Systems**: C++/CMake, Rust, Zig, Java, C#
- **Mobile**: React Native, Flutter
- **Data**: Python Data Science, Jupyter, R, Julia

#### Project Operations
```
<Space>po  # Open recent projects
<Space>fp  # Find projects with Telescope
```

### 🔨 Build System

TacoVim automatically detects your project type and provides appropriate build commands:

```bash
<Space>rb  # Build project
<Space>rr  # Run project  
<Space>rt  # Test project
<Space>rc  # Clean project
<Space>rd  # Debug project
```

**Supported Build Systems:**
- **Rust**: Cargo
- **C/C++**: CMake, Make
- **Zig**: Zig build system
- **Node.js**: npm/yarn scripts
- **Python**: Poetry, pip
- **Java**: Maven, Gradle
- **.NET**: dotnet CLI
- **Go**: Go toolchain

### 🐛 Debugging

Professional debugging experience with Visual Studio-like keybindings:

```bash
<F5>        # Start/Continue debugging
<Shift+F5>  # Stop debugging
<Ctrl+Shift+F5>  # Restart debugging
<F9>        # Toggle breakpoint
<F10>       # Step over
<F11>       # Step into
<Shift+F11> # Step out
```

**Advanced Debugging:**
```bash
<Space>dB   # Conditional breakpoint
<Space>dL   # Log point
<Space>du   # Toggle debug UI
<Space>dr   # Debug console
<Space>dv   # Variables window
```

## ⌨️ Key Bindings

### Essential Keys
```bash
<Space>     # Leader key
jk / kj     # Exit insert mode
<Ctrl+s>    # Save file
<Ctrl+\>    # Toggle terminal
```

### File Operations
```bash
<Space>ff   # Find files
<Space>fr   # Recent files
<Space>fg   # Live grep
<Space>fb   # Buffers
<Space>fe   # Emoji picker
<Space>e    # File explorer
```

### Code Navigation
```bash
gd          # Go to definition
gr          # Go to references
gi          # Go to implementation
K           # Show hover info
<Space>ca   # Code actions
<Space>rn   # Rename symbol
<Space>cf   # Format code
```

### Symbol Search
```bash
<Space>fs   # Document symbols
<Space>fS   # Workspace symbols
<Space>fi   # Implementations
<Space>fd   # Definitions
<Space>fR   # References
```

### Window Management
```bash
<Ctrl+h/j/k/l>  # Navigate windows
<Space>wv       # Split vertically
<Space>wh       # Split horizontally
<Space>wx       # Close window
<Space>we       # Equal window sizes
<Space>wr       # Resize mode
```

### Advanced Features
```bash
<Space>cs   # Symbol outline
<Space>sr   # Search and replace
<Ctrl+n>    # Multi-cursor
s / S       # Flash jump
ga          # Align text
<Space>z    # Zen mode
```

## 🎨 Theme Management

TacoVim includes 15+ premium themes:

```bash
<Space>ut   # Theme switcher
```

**Available Themes:**
- Catppuccin (Mocha/Latte)
- Tokyo Night (Night/Storm)
- Rose Pine
- Kanagawa
- Nightfox
- Gruvbox (Material/Classic)
- Everforest
- Dracula
- One Dark
- Nord
- Material
- Nightfly

Themes are automatically saved and restored between sessions.

## 💾 Session Management

Save and restore your workspace:

```bash
<Space>qs   # Save session
<Space>ql   # Load last session
```

Sessions include:
- Open buffers and windows
- Current directory
- Window layouts
- Tab pages

## 🛠️ Customization

### Adding New Languages

1. **Add LSP server to Mason:**
   ```lua
   -- In init.lua, find ensure_installed table
   ensure_installed = {
     "your_language_server",
     -- ... other servers
   }
   ```

2. **Add Treesitter support:**
   ```lua
   -- In Treesitter config
   ensure_installed = {
     "your_language",
     -- ... other languages  
   }
   ```

3. **Add formatting:**
   ```lua
   -- In conform.nvim config
   formatters_by_ft = {
     your_language = { "your_formatter" },
   }
   ```

### Custom Keybindings

Add custom keybindings after the existing keymap definitions:

```lua
-- Your custom keybindings
keymap("n", "<leader>my", "<cmd>YourCommand<cr>", { desc = "My custom command" })
```

### Project Templates

Add custom project templates in the `create_project` function:

```lua
local project_templates = {
  { name = "My Custom Template", type = "custom", tech = "my-tech" },
  -- ... existing templates
}
```

## 🧪 Testing & Health

### Health Check
```bash
:TacoVimHealth  # Run comprehensive health check
:checkhealth    # Standard Neovim health check
```

### Statistics
```bash
<Space>us       # Show TacoVim statistics
:TacoVim        # Display logo and stats
```

## 🤝 Contributing

We welcome contributions! Here's how to get started:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes**
4. **Test thoroughly**
5. **Submit a pull request**

### Development Guidelines

- **Code Style**: Follow existing Lua conventions
- **Documentation**: Update README for new features
- **Testing**: Test with multiple file types
- **Performance**: Profile changes with `:TacoVim` stats

## 🐛 Troubleshooting

### Common Issues

#### LSP Not Working
```bash
:Mason          # Install/update LSP servers
:LspInfo        # Check LSP status
:TacoVimHealth  # Run health check
```

#### Slow Startup
```bash
:Lazy profile   # Check plugin load times
<Space>us       # View startup statistics
```

#### Missing Icons
- Install a Nerd Font: [Nerd Fonts](https://www.nerdfonts.com/)
- Set your terminal to use the Nerd Font

#### Build System Not Detected
- Ensure project files exist (package.json, Cargo.toml, etc.)
- Check `:echo TacoVim.BuildSystem.detect_project_type()`

### Getting Help

1. **Check the health**: `:TacoVimHealth`
2. **Review logs**: `:messages`
3. **Check LSP logs**: `:LspLog`
4. **Open an issue** with detailed information

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

TacoVim is built on the shoulders of giants. Special thanks to:

- [Neovim](https://neovim.io/) - The editor that makes it all possible
- [Lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin management
- [Catppuccin](https://github.com/catppuccin/nvim) - Beautiful theming
- [Telescope](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finding
- [Mason](https://github.com/williamboman/mason.nvim) - LSP management
- All plugin authors who make Neovim amazing

---

<div align="center">

**Made with 🌮 and ❤️ for the developer community**

[⭐ Star this repo](https://github.com/ChaseSunstrom/tacovim) • [🐛 Report Bug](https://github.com/ChaseSunstrom/tacovim/issues) • [💡 Request Feature](https://github.com/ChaseSunstrom/tacovim/issues)

</div>

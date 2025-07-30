# 🌮 TacoVim Enhanced Keymap Guide

## 📖 Overview
This guide covers the newly organized and enhanced keymaps in TacoVim. All conflicts have been resolved and keymaps are now logically grouped for maximum productivity.

## 🎯 Leader Key
- **Leader**: `<Space>`
- **Local Leader**: `<Space>`

## 🔧 Core Navigation

### **Basic Movement**
| Key | Action | Description |
|-----|--------|-------------|
| `jk` / `kj` | `<ESC>` | Exit insert mode |
| `j` / `k` | Smart movement | Respects line wrapping |
| `<Esc>` | Clear search | Clear search highlighting |
| `n` / `N` | Centered search | Search results centered on screen |

### **Enhanced Navigation**
| Key | Action | Description |
|-----|--------|-------------|
| `<C-d>` / `<C-u>` | Half page | Centered half-page movement |
| `J` | Smart join | Join lines keeping cursor position |

## 💾 File Operations

| Key | Action | Description |
|-----|--------|-------------|
| `<C-s>` | Save file | Works in all modes |
| `<leader>w` | Save file | Normal mode save |
| `<leader>W` | Save all | Save all files |
| `<leader>x` | Make executable | chmod +x current file |
| `<leader><leader>` | Source file | Reload current file |

## 🪟 Window Management

### **Navigation**
| Key | Action | Description |
|-----|--------|-------------|
| `<C-h/j/k/l>` | Navigate windows | Move between splits |
| `<C-Arrow>` | Resize windows | Arrow keys for resizing |

### **Window Operations**
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>wv` | Split vertical | Create vertical split |
| `<leader>wh` | Split horizontal | Create horizontal split |
| `<leader>we` | Equal splits | Equalize window sizes |
| `<leader>wx` | Close split | Close current split |
| `<leader>wo` | Close others | Close all other windows |
| `<leader>wr` | Resize mode | Interactive resize mode |

## 🗂️ Buffer Management

| Key | Action | Description |
|-----|--------|-------------|
| `<Tab>` / `<S-Tab>` | Buffer cycle | Next/previous buffer |
| `<leader>bd` | Delete buffer | Close current buffer |
| `<leader>bD` | Force delete | Force close buffer |
| `<leader>bo` | Close others | Close all other buffers |
| `<leader>bb` | Switch buffer | Toggle between buffers |
| `<leader>bn` | New buffer | Create new buffer |
| `<leader>bp` | Pin buffer | Toggle buffer pin |
| `[b` / `]b` | Navigate | Previous/next buffer |

## 📑 Tab Management

| Key | Action | Description |
|-----|--------|-------------|
| `<leader><tab>o` | New tab | Create new tab |
| `<leader><tab>x` | Close tab | Close current tab |
| `<leader><tab>n/p` | Navigate | Next/previous tab |
| `<leader><tab>f/l` | Jump | First/last tab |

## ✂️ Text Manipulation

### **Movement**
| Key | Action | Description |
|-----|--------|-------------|
| `<A-j/k>` | Move lines | Move lines up/down (all modes) |
| `<leader>D` | Duplicate | Duplicate line/selection |

### **Indentation**
| Key | Action | Description |
|-----|--------|-------------|
| `<` / `>` | Indent | Keep selection in visual mode |

### **Smart Operations**
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>+/-` | Numbers | Increment/decrement |
| `Q` | Macro replay | Replay macro 'q' |
| `dD` / `cC` | Smart delete | Enhanced delete/change |

## 📋 Clipboard Operations

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>y/Y` | Yank | Copy to system clipboard |
| `<leader>p/P` | Paste | Paste from system clipboard |
| `<leader>d` | Delete | Delete to void register |
| `<leader>a` | Select all | Select entire buffer |
| `p` (visual) | Smart paste | Paste without yanking |

## 🔍 Enhanced Search & Replace

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>sr` | Replace word | Smart replace word under cursor |
| `<leader>sR` | Global replace | Global search and replace with confirmation |
| `<leader>si` | Case-insensitive | Case-insensitive replacement |
| `<leader>sg` | Search word | Search current word in project |
| `<leader>sG` | Replace in files | Replace word in all project files |
| `<leader>ss` | Search project | Telescope live grep |
| `<leader>sf` | Find files | Telescope find files |
| `<leader>sb` | Search buffers | Search open buffers |
| `<leader>sh` | Search help | Search help documentation |
| `<leader>sk` | Search keymaps | Search available keymaps |
| `<leader>sc` | Search commands | Search available commands |

## 🚀 Project Management

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>pn` | New project | Create new project |
| `<leader>po` | Open project | Browse projects |
| `<leader>pr` | Recent projects | Recent project list |
| `<leader>pa` | Add current | Add current directory to recent projects |
| `<leader>pf` | Find files | Telescope find files |
| `<leader>pg` | Live grep | Search in project |

## 🏗️ Build & Run

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>rb` | Build | Build project |
| `<leader>rr` | Run | Run project |
| `<leader>rt` | Test | Run tests |
| `<leader>rc` | Clean | Clean project |
| `<leader>rd` | Debug | Debug project |
| `<leader>rR` | Run task | Overseer run |
| `<leader>rT` | Task list | Toggle task list |

## 🐛 Debugging (VS Code Style)

### **Primary Controls**
| Key | Action | Description |
|-----|--------|-------------|
| `<F5>` | Start/Continue | Start or continue debugging |
| `<S-F5>` | Stop | Stop debugging |
| `<C-S-F5>` | Restart | Restart debugging session |
| `<F9>` | Breakpoint | Toggle breakpoint |
| `<F10>` | Step over | Step over function |
| `<F11>` | Step into | Step into function |
| `<S-F11>` | Step out | Step out of function |

### **Advanced Debugging**
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>dB` | Conditional BP | Conditional breakpoint |
| `<leader>dL` | Log point | Log point message |
| `<leader>dC` | Clear BPs | Clear all breakpoints |
| `<leader>du` | Debug UI | Toggle debug interface |
| `<leader>dr` | Debug console | Open REPL |
| `<leader>dl` | Run last | Repeat last debug |
| `<leader>dh` | Hover | Hover variables |

## 🎨 UI & Utilities

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>ut` | Switch theme | Change colorscheme |
| `<leader>uT` | Transparency | Toggle transparency |
| `<leader>ud` | Diagnostics | Toggle diagnostics |
| `<leader>uf` | Format on save | Toggle auto-format |
| `<leader>ul` | Line numbers | Toggle line numbers |
| `<leader>uw` | Word wrap | Toggle line wrap |
| `<leader>us` | Statistics | Show TacoVim stats |
| `<leader>uh` | Health check | Run health check |
| `<leader>ur` | Reload config | Reload configuration |
| `<leader>uk` | Keymap manager | Interactive keymap management UI |
| `<leader>uz` | Zen mode | Toggle zen mode |
| `<leader>uF` | Focus mode | Toggle focus mode |

## 🔗 Git Operations

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>gg` | Neogit | Open Neogit interface |
| `<leader>gs` | Git status | Show git status |
| `<leader>gc` | Git commits | Browse commits |
| `<leader>gb` | Git branches | Browse branches |

## 🔧 Code & LSP

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>cd` | Diagnostics | Show line diagnostics |
| `<leader>cD` | All diagnostics | Workspace diagnostics |
| `[d` / `]d` | Navigate | Previous/next diagnostic |
| `<leader>co/cc` | Quickfix | Open/close quickfix |
| `[q` / `]q` | Navigate | Navigate quickfix items |
| `<leader>lo/lc` | Location list | Open/close location list |
| `[l` / `]l` | Navigate | Navigate location items |

## 🗂️ Folding

| Key | Action | Description |
|-----|--------|-------------|
| `zR` | Open all | Open all folds |
| `zM` | Close all | Close all folds |
| `zr` | Open except | Open folds except kinds |
| `zm` | Close with | Close folds with |
| `zp` | Peek | Peek folded content |

## 🔌 Plugin Management

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>L` | Lazy | Open Lazy plugin manager |
| `<leader>M` | Mason | Open Mason LSP manager |

## 💾 Session Management
> **Note**: Session management is handled by the persistence plugin

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>qs` | Save session | Save current session |
| `<leader>ql` | Load session | Load last session |
| `<leader>qd` | Stop session | Don't save on exit |
| `<leader>qq` | Quit | Quit all |
| `<leader>qQ` | Force quit | Force quit all |

## 🖥️ Terminal

| Key | Action | Description |
|-----|--------|-------------|
| `<Esc>` (terminal) | Exit | Exit terminal mode |
| `<C-h/j/k/l>` (terminal) | Navigate | Move between windows |

## 💡 Productivity Tips

1. **Resize Mode**: Use `<leader>wr` to enter interactive window resize mode
2. **Smart Paste**: In visual mode, `p` doesn't change your register
3. **Quick Macros**: Use `Q` to quickly replay the 'q' macro
4. **Center Everything**: Navigation commands automatically center important movements
5. **Smart Quit**: `<leader>qq` will prompt to save modified buffers
6. **Buffer Switching**: `<leader>bb` quickly switches between current and alternate buffer

## 🎯 Which-Key Groups

Press `<leader>` and wait to see available key groups:
- `b` - Buffer operations
- `c` - Code/quickfix operations  
- `d` - Debug operations
- `f` - File/find operations
- `g` - Git operations
- `l` - LSP/location operations
- `p` - Project operations
- `q` - Quit/session operations
- `r` - Run/build operations
- `s` - Search operations
- `t` - Terminal/test operations
- `u` - UI/utility operations
- `w` - Window operations
- `<tab>` - Tab operations

## 🎹 Keymap Manager

TacoVim includes a powerful interactive keymap management system accessible via `<leader>uk`:

### Features:
- **📋 View All Keymaps**: Browse all TacoVim keymaps in a searchable table
- **🔍 Search Keymaps**: Find keymaps by key, action, or description
- **➕ Add New Keymap**: Interactively create new keymaps with UI prompts
- **📁 Export/Import**: Save and share keymap configurations
- **⚙️ Modify Existing**: Change existing keymap behaviors

### Usage:
1. Press `<leader>uk` to open the keymap manager
2. Select an action from the menu
3. Follow the interactive prompts
4. Changes can be temporary or saved permanently

Custom keymaps are saved to `lua/tacovim/custom_keymaps.lua` and loaded automatically.

## 🔥 Advanced Features

- **Error-safe**: All plugin-dependent keymaps use pcall for safety
- **Context-aware**: Keymaps adapt to available plugins
- **Consistent**: Similar operations use similar key patterns
- **Discoverable**: Which-key integration shows available options
- **Efficient**: No overlapping keymaps, optimized for speed
- **Interactive Management**: Full UI for keymap customization
- **Modern Which-Key**: Clean, organized interface with icons and descriptions

---
> 🌮 **TacoVim** - A deliciously powerful Neovim configuration 
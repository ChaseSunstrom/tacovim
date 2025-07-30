-- ~/.config/nvim/lua/tacovim/core/options.lua
-- TacoVim Core Options and Settings

local opt = vim.opt
local g = vim.g

-- Disable netrw (we use neo-tree)
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- Disable unused providers for faster startup
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0

-- Editor appearance
opt.number = true                    -- Show line numbers
opt.relativenumber = true            -- Show relative line numbers
opt.cursorline = true               -- Highlight current line
opt.termguicolors = true            -- Enable true color support
opt.background = "dark"             -- Dark background
opt.signcolumn = "yes"              -- Always show signcolumn
opt.cmdheight = 1                   -- Command line height
opt.pumheight = 10                  -- Popup menu height
opt.pumwidth = 30                   -- Popup menu width
opt.laststatus = 3                  -- Global statusline
opt.showtabline = 2                 -- Always show tabline

-- Indentation
opt.tabstop = 2                     -- Number of spaces tabs count for
opt.shiftwidth = 2                  -- Size of an indent
opt.expandtab = true                -- Use spaces instead of tabs
opt.autoindent = true               -- Autoindent new lines
opt.smartindent = true              -- Smart autoindenting

-- Text wrapping
opt.wrap = false                    -- Disable line wrap
opt.linebreak = true                -- Wrap at word boundaries

-- Search behavior
opt.ignorecase = true               -- Ignore case in search
opt.smartcase = true                -- Smart case sensitivity
opt.hlsearch = false                -- Don't highlight search results
opt.incsearch = true                -- Incremental search

-- Window splitting
opt.splitright = true               -- Split vertically to the right
opt.splitbelow = true               -- Split horizontally below
opt.splitkeep = "screen"            -- Keep text on screen when splitting

-- File handling
opt.swapfile = false                -- Disable swap files
opt.backup = false                  -- Disable backup files
opt.undofile = true                 -- Enable persistent undo
opt.undodir = vim.fn.stdpath("data") .. "/undodir"

-- Scrolling and cursor
opt.scrolloff = 8                   -- Keep 8 lines above/below cursor
opt.sidescrolloff = 8               -- Keep 8 columns left/right of cursor

-- Timing
opt.updatetime = 50                 -- Faster completion (default: 4000ms)
opt.timeoutlen = 300                -- Time to wait for mapped sequence

-- Mouse and clipboard
opt.mouse = "a"                     -- Enable mouse in all modes
opt.mousemoveevent = true           -- Enable mouse move events
opt.clipboard = "unnamedplus"       -- Use system clipboard

-- Window appearance
opt.winminwidth = 5                 -- Minimum window width
opt.winminheight = 1                -- Minimum window height
opt.equalalways = false             -- Don't automatically resize windows

-- Folding (enhanced with nvim-ufo)
opt.foldcolumn = "1"                -- Show fold column
opt.foldlevel = 99                  -- High fold level
opt.foldlevelstart = 99             -- Start with all folds open
opt.foldenable = true               -- Enable folding
opt.fillchars = {
  eob = " ",                        -- Empty lines
  fold = " ",
  foldopen = "▾",
  foldsep = " ",
  foldclose = "▸",
}

-- Completion behavior
opt.completeopt = { "menu", "menuone", "noselect" }
opt.shortmess:append("c")           -- Don't show completion messages
opt.shortmess:append("I")           -- Don't show intro message

-- Better formatting
opt.formatoptions:remove({ "c", "r", "o" }) -- Don't auto-comment new lines

-- Enhanced word boundaries
opt.iskeyword:append("-")           -- Treat dash as part of word

-- Concealment for better reading
opt.conceallevel = 2                -- Hide markup characters

-- Better diff algorithm
opt.diffopt:append("algorithm:patience")
opt.diffopt:append("indent-heuristic")

-- Performance improvements
opt.lazyredraw = false              -- Don't redraw during macros (disabled for noice.nvim)
opt.ttyfast = true                  -- Fast terminal connection
opt.redrawtime = 10000              -- Allow more time for syntax highlighting

-- Better wildmenu
opt.wildmode = { "longest:full", "full" }
opt.wildoptions = "pum"

-- Session options
opt.sessionoptions = {
  "buffers",
  "curdir", 
  "tabpages",
  "winsize",
  "help",
  "globals",
  "skiprtp",
  "folds"
}

-- Enhanced grep
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case --follow"
  opt.grepformat = "%f:%l:%c:%m"
end

-- Better error format
opt.errorformat:prepend("%f:%l:%c: %m")

-- Initialize global TacoVim settings
g.tacovim = {
  transparent_enabled = false,
  diagnostics_enabled = true,
  auto_format = true,
  auto_save = false,
  theme = "catppuccin-mocha",
  icons = {
    diagnostics = {
      Error = " ",
      Warn = " ",
      Hint = "󰠠 ",
      Info = " ",
    },
    git = {
      added = " ",
      modified = " ",
      removed = " ",
    },
    kinds = {
      Text = " ",
      Method = " ",
      Function = " ",
      Constructor = " ",
      Field = " ",
      Variable = " ",
      Class = " ",
      Interface = " ",
      Module = " ",
      Property = " ",
      Unit = " ",
      Value = " ",
      Enum = " ",
      Keyword = " ",
      Snippet = " ",
      Color = " ",
      File = " ",
      Reference = " ",
      Folder = " ",
      EnumMember = " ",
      Constant = " ",
      Struct = " ",
      Event = " ",
      Operator = " ",
      TypeParameter = " ",
    },
  },
}

-- Disable some built-in plugins for faster startup
local disabled_built_ins = {
  "gzip",
  "tarPlugin", 
  "tohtml",
  "tutor",
  "zipPlugin",
  "netrwPlugin",
  "matchit",
  "matchparen",
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "rrhelper",
  "spellfile_plugin",
  "logiPat",
}

for _, plugin in pairs(disabled_built_ins) do
  g["loaded_" .. plugin] = 1
end

-- Enhanced diagnostic configuration
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    source = "if_many",
    spacing = 4,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
    max_width = 80,
    max_height = 20,
  },
})

-- Define diagnostic signs
local signs = g.tacovim.icons.diagnostics
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Disable deprecation warnings for plugins we've replaced
g.ultest_deprecation_notice = 0  -- vim-ultest is deprecated, we use neotest

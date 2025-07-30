-- ~/.config/nvim/lua/tacovim/config/user_config.lua
-- TacoVim User Configuration System
-- This file allows users to customize TacoVim with their own settings

local M = {}

-- =============================================================================
-- USER CONFIGURATION STRUCTURE
-- =============================================================================

-- Default user configuration
M.default_config = {
  -- UI Preferences
  ui = {
    theme = "catppuccin-mocha",  -- Theme name
    transparent = false,         -- Transparent background
    animations = true,           -- Enable animations
    icons = true,               -- Show icons
    winbar = true,              -- Show winbar
    statusline = true,          -- Show statusline
  },
  
  -- Editor Settings
  editor = {
    line_numbers = true,        -- Show line numbers
    relative_numbers = true,    -- Show relative line numbers
    wrap = false,              -- Line wrapping
    auto_save = false,         -- Auto-save files
    auto_format = true,        -- Auto-format on save
    indent_size = 2,           -- Default indentation
    show_whitespace = false,   -- Show whitespace characters
  },
  
  -- LSP Settings
  lsp = {
    auto_install = true,       -- Auto-install LSP servers
    diagnostics = true,        -- Show diagnostics
    hover = true,              -- Show hover information
    signature_help = true,     -- Show signature help
    code_lens = true,          -- Show code lens
    inlay_hints = false,       -- Show inlay hints
  },
  
  -- Completion Settings
  completion = {
    auto_complete = true,      -- Enable auto-completion
    ghost_text = true,         -- Show ghost text
    snippet_support = true,    -- Enable snippets
    max_items = 15,           -- Max completion items
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
    auto_install = true,     -- Auto-install debug adapters
    virtual_text = true,     -- Show debug virtual text
    signs = true,           -- Show debug signs
  },
}

-- =============================================================================
-- USER CONFIGURATION LOADING
-- =============================================================================

-- Load user configuration
function M.load_user_config()
  local user_config_path = vim.fn.stdpath("config") .. "/lua/user_config.lua"
  local user_config = {}
  
  -- Check if user config file exists
  if vim.fn.filereadable(user_config_path) == 1 then
    local ok, config = pcall(require, "user_config")
    if ok and type(config) == "table" then
      user_config = config
      vim.notify("✅ Loaded user configuration", vim.log.levels.INFO)
    else
      vim.notify("❌ Error loading user configuration: " .. tostring(config), vim.log.levels.ERROR)
    end
  else
    -- Create default user config file
    M.create_default_user_config()
  end
  
  -- Merge with default config
  return vim.tbl_deep_extend("force", M.default_config, user_config)
end

-- Create default user configuration file
function M.create_default_user_config()
  local config_content = [[
-- ~/.config/nvim/lua/user_config.lua
-- Your Personal TacoVim Configuration
-- Customize TacoVim to your liking by modifying the settings below

return {
  -- =============================================================================
  -- UI PREFERENCES
  -- =============================================================================
  ui = {
    theme = "catppuccin-mocha",  -- Available: catppuccin-*, tokyonight-*, gruvbox-*, etc.
    transparent = false,         -- Enable transparent background
    animations = true,           -- Enable smooth animations
    icons = true,               -- Show file and UI icons
  },
  
  -- =============================================================================
  -- EDITOR SETTINGS
  -- =============================================================================
  editor = {
    line_numbers = true,        -- Show line numbers
    relative_numbers = true,    -- Show relative line numbers  
    wrap = false,              -- Enable line wrapping
    auto_save = false,         -- Auto-save files on focus loss
    auto_format = true,        -- Auto-format files on save
    indent_size = 2,           -- Default indentation size
  },
  
  -- =============================================================================
  -- CUSTOM PLUGINS
  -- =============================================================================
  plugins = {
    additional = {
      -- Add your own plugins here
      -- Example:
      -- { "folke/zen-mode.nvim", cmd = "ZenMode" },
      -- { "tpope/vim-fugitive", event = "VeryLazy" },
    },
  },
  
  -- =============================================================================
  -- CUSTOM KEYMAPS
  -- =============================================================================
  keymaps = {
    custom = {
      -- Add your own keymaps here
      -- Format: { mode, key, command, options }
      -- Example:
      -- { "n", "<leader>xx", ":lua print('Hello World!')<cr>", { desc = "Say Hello" } },
    },
  },
  
  -- =============================================================================
  -- FILE TYPE SPECIFIC SETTINGS
  -- =============================================================================
  filetypes = {
    -- Example:
    -- python = { indent_size = 4, auto_format = true },
    -- javascript = { indent_size = 2, auto_format = true },
  },
  
  -- =============================================================================
  -- ADVANCED SETTINGS
  -- =============================================================================
  
  -- Override any TacoVim setting here
  -- This is for advanced users who want to completely customize behavior
  overrides = {
    -- Example:
    -- vim_options = {
    --   ["opt.relativenumber"] = false,
    --   ["opt.wrap"] = true,
    -- },
  },
}
]]
  
  local user_config_path = vim.fn.stdpath("config") .. "/lua/user_config.lua"
  vim.fn.writefile(vim.split(config_content, "\n"), user_config_path)
  vim.notify("📝 Created default user configuration at: " .. user_config_path, vim.log.levels.INFO)
end

-- =============================================================================
-- CONFIGURATION MANAGEMENT FUNCTIONS
-- =============================================================================

-- Apply user configuration
function M.apply_config(config)
  -- Apply UI settings
  if config.ui then
    if config.ui.theme then
      pcall(vim.cmd.colorscheme, config.ui.theme)
    end
    
    if config.ui.transparent then
      TacoVim.Utilities.enable_transparency()
    end
  end
  
  -- Apply editor settings
  if config.editor then
    if config.editor.line_numbers ~= nil then
      vim.opt.number = config.editor.line_numbers
    end
    
    if config.editor.relative_numbers ~= nil then
      vim.opt.relativenumber = config.editor.relative_numbers
    end
    
    if config.editor.wrap ~= nil then
      vim.opt.wrap = config.editor.wrap
    end
    
    if config.editor.indent_size then
      vim.opt.tabstop = config.editor.indent_size
      vim.opt.shiftwidth = config.editor.indent_size
    end
  end
  
  -- Apply custom keymaps
  if config.keymaps and config.keymaps.custom then
    for _, keymap in ipairs(config.keymaps.custom) do
      if type(keymap) == "table" and #keymap >= 3 then
        vim.keymap.set(keymap[1], keymap[2], keymap[3], keymap[4] or {})
      end
    end
  end
  
  -- Apply custom plugins (will be handled by lazy.nvim)
  if config.plugins and config.plugins.additional then
    for _, plugin in ipairs(config.plugins.additional) do
      table.insert(require("lazy.nvim").plugins, plugin)
    end
  end
  
  -- Apply overrides
  if config.overrides then
    if config.overrides.vim_options then
      for option, value in pairs(config.overrides.vim_options) do
        local ok, _ = pcall(function()
          -- Handle different option types
          if option:match("^opt%.") then
            vim.opt[option:sub(5)] = value
          elseif option:match("^g%.") then
            vim.g[option:sub(3)] = value
          end
        end)
        if not ok then
          vim.notify("❌ Failed to set option: " .. option, vim.log.levels.WARN)
        end
      end
    end
  end
end

-- =============================================================================
-- CONFIGURATION UTILITIES
-- =============================================================================

-- Open user configuration file
function M.edit_user_config()
  local user_config_path = vim.fn.stdpath("config") .. "/lua/user_config.lua"
  vim.cmd("edit " .. user_config_path)
end

-- Reload user configuration
function M.reload_user_config()
  -- Clear module cache
  package.loaded["user_config"] = nil
  
  -- Reload configuration
  local config = M.load_user_config()
  M.apply_config(config)
  
  vim.notify("🔄 User configuration reloaded", vim.log.levels.INFO)
end

-- Validate user configuration
function M.validate_config(config)
  local errors = {}
  
  -- Validate structure
  if type(config) ~= "table" then
    table.insert(errors, "Configuration must be a table")
    return false, errors
  end
  
  -- Validate keymaps
  if config.keymaps and config.keymaps.custom then
    for i, keymap in ipairs(config.keymaps.custom) do
      if type(keymap) ~= "table" or #keymap < 3 then
        table.insert(errors, "Invalid keymap at index " .. i)
      end
    end
  end
  
  return #errors == 0, errors
end

-- =============================================================================
-- INITIALIZATION
-- =============================================================================

-- Initialize user configuration system
function M.init()
  -- Load and apply user configuration
  local config = M.load_user_config()
  local is_valid, errors = M.validate_config(config)
  
  if is_valid then
    M.apply_config(config)
    
    -- Store configuration globally for access
    _G.TacoVim = _G.TacoVim or {}
    _G.TacoVim.user_config = config
  else
    vim.notify("❌ Invalid user configuration: " .. table.concat(errors, ", "), vim.log.levels.ERROR)
  end
  
  -- Create user commands
  vim.api.nvim_create_user_command("TacoConfig", M.edit_user_config, { desc = "Edit TacoVim user configuration" })
  vim.api.nvim_create_user_command("TacoReload", M.reload_user_config, { desc = "Reload TacoVim user configuration" })
end

return M 
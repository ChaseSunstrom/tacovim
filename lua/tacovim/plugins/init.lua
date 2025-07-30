-- ~/.config/nvim/lua/tacovim/plugins/init.lua
-- TacoVim Plugin Manager

-- Install lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specifications organized by category
local plugin_modules = {
  -- Core functionality
  "tacovim.plugins.colorschemes",    -- Theme management
  "tacovim.plugins.ui",             -- UI components
  "tacovim.plugins.editor",         -- Editor enhancements
  "tacovim.plugins.navigation",     -- File/project navigation
  "tacovim.plugins.search",         -- Search and replace
  
  -- Development tools
  "tacovim.plugins.lsp",            -- Language server protocol
  "tacovim.plugins.completion",     -- Auto completion
  "tacovim.plugins.treesitter",     -- Syntax highlighting
  "tacovim.plugins.debugging",      -- Debug support
  "tacovim.plugins.testing",        -- Testing framework
  "tacovim.plugins.formatting",     -- Code formatting
  
  -- Git and version control
  "tacovim.plugins.git",            -- Git integration
  
  -- Terminal and tasks
  "tacovim.plugins.terminal",       -- Terminal integration
  "tacovim.plugins.tasks",          -- Task running
  
  -- AI and productivity
  "tacovim.plugins.ai",             -- AI assistance
  "tacovim.plugins.productivity",   -- Productivity tools
  
  -- Language specific
  "tacovim.plugins.languages",      -- Language specific tools
}

-- Collect all plugins from modules
local plugins = {}

for _, module_name in ipairs(plugin_modules) do
  local ok, module_plugins = pcall(require, module_name)
  if ok then
    if type(module_plugins) == "table" then
      vim.list_extend(plugins, module_plugins)
    else
      vim.notify(
        string.format("Plugin module '%s' should return a table", module_name),
        vim.log.levels.WARN
      )
    end
  else
    vim.notify(
      string.format("Failed to load plugin module '%s': %s", module_name, module_plugins),
      vim.log.levels.ERROR
    )
  end
end

-- Lazy.nvim configuration
local lazy_config = {
  -- Installation settings
  root = vim.fn.stdpath("data") .. "/lazy", -- directory where plugins will be installed
  
  -- UI settings
  ui = {
    size = { width = 0.8, height = 0.8 },
    wrap = true,
    border = "rounded",
    backdrop = 60,
    title = "🌮 TacoVim Plugin Manager",
    title_pos = "center",
    icons = {
      cmd = " ",
      config = "",
      event = "",
      ft = " ",
      init = " ",
      import = " ",
      keys = " ",
      lazy = "󰒲 ",
      loaded = "●",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      require = "󰢱 ",
      source = " ",
      start = "",
      task = "✔ ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
  },
  
  -- Plugin management
  install = {
    missing = true,        -- install missing plugins on startup
    colorscheme = { "catppuccin-mocha", "habamax" }, -- try to load one of these colorschemes when starting an installation during startup
  },
  
  -- Checker settings
  checker = {
    enabled = true,        -- automatically check for plugin updates
    concurrency = nil,     -- set to 1 to check for updates very slowly
    notify = false,        -- get a notification when new updates are found
    frequency = 3600,      -- check for updates every hour
  },
  
  -- Change detection
  change_detection = {
    enabled = true,        -- automatically check for config file changes and reload the ui
    notify = false,        -- get a notification when changes are found
  },
  
  -- Performance optimizations
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true, -- reset the package path to improve startup time
    rtp = {
      reset = true,        -- reset the runtime path to $VIMRUNTIME and your config directory
      paths = {},          -- add any custom paths here that you want to includes in the rtp
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen", 
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
  
  -- Development settings
  dev = {
    path = "~/projects", -- directory where you store your local plugin projects
    patterns = {},       -- For example {"folke"}
    fallback = false,    -- Fallback to git when local plugin doesn't exist
  },
  
  -- Profiling
  profiling = {
    loader = false,
    require = false,
  },
  
  -- Git settings
  git = {
    log = { "-8" },      -- show commits from the last 8 days
    timeout = 120,       -- timeout for git operations
    url_format = "https://github.com/%s.git",
    filter = true,
  },
  
  -- Package manager settings
  pkg = {
    enabled = true,      -- enable the package manager
    cache = vim.fn.stdpath("cache") .. "/lazy/pkg-cache.lua",
    sources = {
      "lazy",
      "rockspec",
      "packspec",
    },
  },
  
  -- Rocks.nvim integration (for Lua packages)
  rocks = {
    enabled = true,
    root = vim.fn.stdpath("data") .. "/lazy-rocks",
    server = "https://nvim-neorocks.github.io/rocks-binaries/",
  },
}

-- Setup lazy.nvim with collected plugins
require("lazy").setup(plugins, lazy_config)

-- Post-setup configurations
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    -- Trigger TacoVim ready event
    vim.api.nvim_exec_autocmds("User", { pattern = "TacoVimReady" })
  end,
})

-- Plugin management commands
vim.api.nvim_create_user_command("TacoVimPlugins", function()
  require("lazy").show()
end, { desc = "Show TacoVim plugin manager" })

vim.api.nvim_create_user_command("TacoVimUpdate", function()
  require("lazy").update()
end, { desc = "Update all TacoVim plugins" })

vim.api.nvim_create_user_command("TacoVimClean", function()
  require("lazy").clean()
end, { desc = "Clean unused TacoVim plugins" })

vim.api.nvim_create_user_command("TacoVimProfile", function()
  require("lazy").profile()
end, { desc = "Show TacoVim plugin profile" })

vim.api.nvim_create_user_command("TacoVimHealth", function()
  require("lazy").health()
end, { desc = "Check TacoVim plugin health" })

-- Plugin utilities
TacoVim.Plugins = {
  -- Check if a plugin is loaded
  is_loaded = function(plugin_name)
    return require("lazy.core.config").plugins[plugin_name] ~= nil
  end,
  
  -- Get plugin configuration
  get_config = function(plugin_name)
    return require("lazy.core.config").plugins[plugin_name]
  end,
  
  -- Load plugin on demand
  load = function(plugin_name)
    require("lazy").load({ plugins = { plugin_name } })
  end,
  
  -- Get all loaded plugins
  get_loaded = function()
    local loaded = {}
    for name, plugin in pairs(require("lazy.core.config").plugins) do
      if plugin._.loaded then
        table.insert(loaded, name)
      end
    end
    return loaded
  end,
  
  -- Get startup stats
  get_stats = function()
    return require("lazy").stats()
  end,
}

return plugins

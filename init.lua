-- ~/.config/nvim/init.lua
-- TacoVim - Professional Full-Stack Development IDE
-- A comprehensive Neovim configuration for modern development

-- Bootstrap TacoVim
local tacovim_path = vim.fn.stdpath("config") .. "/lua/tacovim"
if not vim.loop.fs_stat(tacovim_path) then
  vim.notify("TacoVim configuration not found. Please ensure lua/tacovim/ directory exists.", vim.log.levels.ERROR)
  return
end

-- Initialize TacoVim global namespace
_G.TacoVim = {
  ProjectManager = {},
  BuildSystem = {},
  ThemeManager = {},
  SessionManager = {},
  Utilities = {},
  LSP = {},
  Debug = {},
}

-- Set leader keys early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load TacoVim modules
local modules = {
  "tacovim.core.options",     -- Core Neovim options
  "tacovim.core.keymaps",     -- Key mappings
  "tacovim.core.autocmds",    -- Auto commands
  "tacovim.plugins",          -- Plugin management
  "tacovim.utils.init",       -- Utility functions
}

-- Load each module with error handling
for _, module in ipairs(modules) do
  local ok, err = pcall(require, module)
  if not ok then
    vim.notify(
      string.format("Failed to load module '%s': %s", module, err),
      vim.log.levels.ERROR,
      { title = "TacoVim" }
    )
  end
end

-- Welcome message
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    local stats = require("lazy").stats()
    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
    local version = vim.version()

    vim.notify(
      "🚀 TacoVim IDE Ready!\n" ..
      "⚡ Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms\n" ..
      "🎯 Neovim v" .. version.major .. "." .. version.minor .. "." .. version.patch .. "\n" ..
      "📦 Press <Space>pn to create a project\n" ..
      "🎨 Press <Space>ut to switch themes\n" ..
      "📚 Press <Space>us for statistics",
      vim.log.levels.INFO,
      { title = "TacoVim Professional IDE" }
    )
  end,
})

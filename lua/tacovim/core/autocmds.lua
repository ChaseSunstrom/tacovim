-- ~/.config/nvim/lua/tacovim/core/autocmds.lua
-- TacoVim Auto Commands

local function augroup(name)
  return vim.api.nvim_create_augroup("TacoVim_" .. name, { clear = true })
end

-- =============================================================================
-- EDITOR BEHAVIOR
-- =============================================================================

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({ 
      timeout = 200,
      higroup = "IncSearch",
    })
  end,
  desc = "Highlight selection on yank",
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("remove_trailing_whitespace"),
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    pcall(function() vim.cmd([[%s/\s\+$//e]]) end)
    vim.fn.setpos(".", save_cursor)
  end,
  desc = "Remove trailing whitespace on save",
})

-- Auto format on save (if enabled)
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_format"),
  pattern = "*",
  callback = function()
    if vim.g.tacovim.auto_format then
      require("conform").format({ async = true, lsp_fallback = true })
    end
  end,
  desc = "Auto format on save",
})

-- Auto save when leaving insert mode or text changes (if enabled)
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = augroup("auto_save"),
  pattern = "*",
  callback = function()
    if vim.g.tacovim.auto_save and vim.bo.modifiable and not vim.bo.readonly then
      vim.cmd("silent! update")
    end
  end,
  desc = "Auto save on text change",
})

-- =============================================================================
-- WINDOW AND BUFFER MANAGEMENT
-- =============================================================================

-- Close certain filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "help",
    "lspinfo", 
    "man",
    "notify",
    "qf",
    "query",
    "startuptime",
    "checkhealth",
    "tsplayground",
    "neotest-output",
    "neotest-summary",
    "neotest-output-panel",
    "fugitive",
    "git",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { 
      buffer = event.buf, 
      silent = true,
      desc = "Close window"
    })
  end,
  desc = "Close special buffers with q",
})

-- Auto create directories when writing files
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then 
      return 
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
  desc = "Auto create directories on save",
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function() 
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
  desc = "Resize splits on window resize",
})

-- Equalize window sizes when opening/closing windows
vim.api.nvim_create_autocmd({ "WinNew", "WinClosed" }, {
  group = augroup("equalize_splits"),
  callback = function()
    vim.schedule(function()
      vim.cmd("wincmd =")
    end)
  end,
  desc = "Equalize splits on window changes",
})

-- =============================================================================
-- NAVIGATION AND CURSOR BEHAVIOR
-- =============================================================================

-- Go to last location when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_location"),
  callback = function(event)
    local exclude_ft = { "gitcommit", "gitrebase", "svn", "hgcommit" }
    local buf = event.buf
    
    if vim.tbl_contains(exclude_ft, vim.bo[buf].filetype) or vim.b[buf].last_location then
      return
    end
    
    vim.b[buf].last_location = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Go to last location when opening buffer",
})

-- Don't auto comment new lines
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("no_auto_comment"),
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Disable auto comment on new lines",
})

-- =============================================================================
-- FILETYPE SPECIFIC SETTINGS
-- =============================================================================

-- Set specific options for certain filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("filetype_settings"),
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.linebreak = true
  end,
  desc = "Enable wrap and spell for text files",
})

-- Set indent for specific filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("indent_settings"),
  pattern = { "python", "yaml", "yml" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
  desc = "4-space indent for Python and YAML",
})

-- Enable cursorline in active window only
vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained" }, {
  group = augroup("cursorline_active"),
  callback = function()
    if vim.wo.number then
      vim.wo.cursorline = true
    end
  end,
  desc = "Enable cursorline in active window",
})

vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
  group = augroup("cursorline_inactive"),
  callback = function()
    vim.wo.cursorline = false
  end,
  desc = "Disable cursorline in inactive window",
})

-- =============================================================================
-- LSP AND DIAGNOSTICS
-- =============================================================================

-- LSP attachment autocommand
vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup("lsp_attach"),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local bufnr = event.buf
    local opts = { buffer = bufnr, silent = true }

    -- Enhanced LSP keymaps
    local keymap_set = function(mode, lhs, rhs, description)
      vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = description }))
    end

    -- Navigation
    keymap_set("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
    keymap_set("n", "gd", vim.lsp.buf.definition, "Go to definition")
    keymap_set("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
    keymap_set("n", "gr", vim.lsp.buf.references, "Go to references")
    keymap_set("n", "<leader>D", vim.lsp.buf.type_definition, "Type definition")
    
    -- Hover and signature help
    keymap_set("n", "K", vim.lsp.buf.hover, "Show hover")
    keymap_set("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
    keymap_set("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
    
    -- Code actions and refactoring
    keymap_set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    keymap_set("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    keymap_set("n", "<leader>cf", function() 
      vim.lsp.buf.format({ async = true }) 
    end, "Format document")
    
    -- Workspace symbols
    keymap_set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace symbols")
    keymap_set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
    keymap_set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
    keymap_set("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "List workspace folders")

    -- Document highlight
    if client and client.server_capabilities.documentHighlightProvider then
      local group = augroup("lsp_document_highlight")
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = group,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end

    -- Inlay hints if supported
    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      keymap_set("n", "<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, "Toggle inlay hints")
    end
  end,
  desc = "LSP keymaps and features",
})

-- =============================================================================
-- TERMINAL AND EXTERNAL TOOLS
-- =============================================================================

-- Terminal setup
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup("terminal_setup"),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd("startinsert")
  end,
  desc = "Terminal setup",
})

-- =============================================================================
-- PERSISTENCE AND SESSIONS
-- =============================================================================

-- Load saved theme on startup
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup("load_theme"),
  callback = function()
    local config_path = vim.fn.stdpath("data") .. "/tacovim_theme.txt"
    if vim.fn.filereadable(config_path) == 1 then
      local saved_theme = vim.fn.readfile(config_path)[1]
      if saved_theme then
        pcall(vim.cmd.colorscheme, saved_theme)
      end
    end
  end,
  desc = "Load saved theme",
})

-- Auto-save session on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = augroup("auto_session"),
  callback = function()
    if vim.g.tacovim.auto_session then
      local session_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
      require("persistence").save({ name = session_name })
    end
  end,
  desc = "Auto save session on exit",
})

-- =============================================================================
-- GIT AND VERSION CONTROL
-- =============================================================================

-- Refresh git signs when entering buffer
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
  group = augroup("gitsigns_refresh"),
  pattern = "*",
  callback = function()
    vim.schedule(function()
      if package.loaded["gitsigns"] then
        require("gitsigns").refresh()
      end
    end)
  end,
  desc = "Refresh git signs",
})

-- =============================================================================
-- PERFORMANCE OPTIMIZATIONS
-- =============================================================================

-- Large file handling
vim.api.nvim_create_autocmd("BufReadPre", {
  group = augroup("large_file"),
  callback = function(event)
    local file_size = vim.loop.fs_stat(event.match)
    if file_size and file_size.size > 1024 * 1024 then -- 1MB
      vim.b.large_file = true
      vim.opt_local.swapfile = false
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.undolevels = -1
      vim.opt_local.undoreload = 0
      vim.opt_local.list = false
      vim.api.nvim_create_autocmd("BufReadPost", {
        once = true,
        buffer = event.buf,
        callback = function()
          vim.opt_local.syntax = ""
          return true
        end,
      })
    end
  end,
  desc = "Optimize for large files",
})

-- =============================================================================
-- USER INTERFACE
-- =============================================================================

-- Update folds when saving
vim.api.nvim_create_autocmd("BufWritePost", {
  group = augroup("update_folds"),
  callback = function()
    if vim.wo.foldmethod == "expr" then
      vim.cmd("normal! zx")
    end
  end,
  desc = "Update folds after save",
})

-- Check if file needs to be reloaded
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
  desc = "Check for file changes",
})

-- Show cursor line only in focused window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  group = augroup("auto_cursorline_show"),
  callback = function(event)
    if vim.bo[event.buf].buftype == "" then
      vim.opt_local.cursorline = true
    end
  end,
  desc = "Show cursor line in focused window",
})

vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  group = augroup("auto_cursorline_hide"),
  callback = function()
    vim.opt_local.cursorline = false
  end,
  desc = "Hide cursor line when not focused",
})

-- =============================================================================
-- CUSTOM EVENTS
-- =============================================================================

-- TacoVim ready event
vim.api.nvim_create_autocmd("User", {
  pattern = "TacoVimReady",
  callback = function()
    -- Custom initialization logic can go here
    vim.notify("TacoVim is ready!", vim.log.levels.INFO, { title = "TacoVim" })
  end,
  desc = "TacoVim ready event",
})

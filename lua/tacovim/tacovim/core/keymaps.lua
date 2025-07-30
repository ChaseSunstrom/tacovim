-- ~/.config/nvim/lua/tacovim/core/keymaps.lua
-- TacoVim Core Keymaps - Clean Professional Edition

local keymap = vim.keymap.set
local opts = { silent = true }

-- =============================================================================
-- LEADER KEY CONFIGURATION
-- =============================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- =============================================================================
-- GENERAL KEYMAPS (Non-leader)
-- =============================================================================

-- Better escape sequences
keymap("i", "jk", "<ESC>", { desc = "Exit insert mode" })
keymap("i", "kj", "<ESC>", { desc = "Exit insert mode" })

-- Clear search highlighting
keymap({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Clear search and escape" })

-- Better navigation (respects line wrapping)
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })

-- Better join lines (keeps cursor position)
keymap("n", "J", "mzJ`z", { desc = "Join lines" })

-- Center movements
keymap("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
keymap("n", "n", "nzzzv", { desc = "Next search result" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result" })

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize windows with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize up" })
keymap("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize down" })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize left" })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize right" })

-- Better indenting (keeps selection)
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- Move lines up/down
keymap("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
keymap("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
keymap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
keymap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
keymap("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move lines down" })
keymap("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move lines up" })

-- Better paste (don't lose register)
keymap("x", "p", [["_dP]], { desc = "Paste without yanking" })

-- Save operations
keymap({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Buffer navigation
keymap("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
keymap("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
keymap("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
keymap("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Quick macro replay
keymap("n", "Q", "@q", { desc = "Replay macro q" })

-- Diagnostics navigation
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })

-- Terminal mode
keymap("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
keymap("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal left" })
keymap("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal down" })
keymap("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal up" })
keymap("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal right" })

-- =============================================================================
-- LEADER KEYMAPS - ORGANIZED BY GROUPS WITH SUBCATEGORIES
-- =============================================================================

-- FILE OPERATIONS GROUP (<leader>f)
-- =============================================================================
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })
keymap("n", "<leader>fw", "<cmd>Telescope grep_string<cr>", { desc = "Find word under cursor" })
keymap("n", "<leader>fs", "<cmd>w<cr>", { desc = "Save file" })
keymap("n", "<leader>fS", "<cmd>wa<cr>", { desc = "Save all files" })
keymap("n", "<leader>fn", function()
  vim.ui.input({ prompt = "New file name: " }, function(name)
    if name and name ~= "" then
      vim.cmd("edit " .. vim.fn.fnameescape(name))
    end
  end)
end, { desc = "New file" })
keymap("n", "<leader>fd", function()
  local file = vim.fn.expand("%:p")
  if file and file ~= "" then
    local choice = vim.fn.confirm("Delete file: " .. vim.fn.fnamemodify(file, ":t") .. "?", "&Yes\n&No", 2)
    if choice == 1 then
      vim.fn.delete(file)
      vim.cmd("bdelete")
      vim.notify("File deleted: " .. vim.fn.fnamemodify(file, ":t"), vim.log.levels.INFO)
    end
  end
end, { desc = "Delete current file" })
keymap("n", "<leader>fy", function()
  local file = vim.fn.expand("%:p")
  if file and file ~= "" then
    vim.fn.setreg("+", file)
    vim.notify("File path copied: " .. file, vim.log.levels.INFO)
  end
end, { desc = "Copy file path" })
keymap("n", "<leader>fR", function()
  local old_name = vim.fn.expand("%:p")
  if old_name and old_name ~= "" then
    vim.ui.input({ 
      prompt = "Rename file to: ", 
      default = vim.fn.fnamemodify(old_name, ":t")
    }, function(new_name)
      if new_name and new_name ~= "" then
        local new_path = vim.fn.fnamemodify(old_name, ":h") .. "/" .. new_name
        vim.fn.rename(old_name, new_path)
        vim.cmd("edit " .. vim.fn.fnameescape(new_path))
        vim.cmd("bdelete " .. vim.fn.bufnr(old_name))
        vim.notify("File renamed to: " .. new_name, vim.log.levels.INFO)
      end
    end)
  end
end, { desc = "Rename current file" })

-- SEARCH OPERATIONS GROUP (<leader>s)
-- =============================================================================

-- Basic search operations
keymap("n", "<leader>ss", "<cmd>Telescope live_grep<cr>", { desc = "Search in project" })
keymap("n", "<leader>sf", "<cmd>Telescope find_files<cr>", { desc = "Search files" })
keymap("n", "<leader>sb", "<cmd>Telescope buffers<cr>", { desc = "Search buffers" })
keymap("n", "<leader>sw", "<cmd>Telescope grep_string<cr>", { desc = "Search word under cursor" })
keymap("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "Search help" })
keymap("n", "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "Search keymaps" })
keymap("n", "<leader>sc", "<cmd>Telescope commands<cr>", { desc = "Search commands" })
keymap("n", "<leader>so", "<cmd>Telescope vim_options<cr>", { desc = "Search options" })
keymap("n", "<leader>sm", "<cmd>Telescope marks<cr>", { desc = "Search marks" })
keymap("n", "<leader>sj", "<cmd>Telescope jumplist<cr>", { desc = "Search jumplist" })
keymap("n", "<leader>st", "<cmd>Telescope treesitter<cr>", { desc = "Search treesitter symbols" })
keymap("n", "<leader>sd", "<cmd>Telescope diagnostics<cr>", { desc = "Search diagnostics" })

-- Enhanced file search
keymap("n", "<leader>sH", function()
  require('telescope.builtin').find_files({
    hidden = true,
    no_ignore = true,
    follow = true,
  })
end, { desc = "Search all files (including hidden)" })

keymap("n", "<leader>sG", function()
  require('telescope.builtin').live_grep({
    additional_args = function(opts)
      return {"--hidden", "--no-ignore"}
    end,
  })
end, { desc = "Search in all files (including hidden)" })

-- Advanced search with preview
keymap("n", "<leader>sp", function()
  require('telescope.builtin').live_grep({
    grep_open_files = true,
  })
end, { desc = "Search in open files" })

keymap("n", "<leader>sP", function()
  local word = vim.fn.expand("<cword>")
  if word ~= "" then
    require('telescope.builtin').live_grep({
      default_text = word,
    })
  else
    require('telescope.builtin').live_grep()
  end
end, { desc = "Search word in project with preview" })

-- Search with specific file types
keymap("n", "<leader>sl", function()
  require('telescope.builtin').live_grep({
    type_filter = "lua",
  })
end, { desc = "Search in Lua files" })

keymap("n", "<leader>sy", function()
  require('telescope.builtin').live_grep({
    type_filter = "py",
  })
end, { desc = "Search in Python files" })

keymap("n", "<leader>sz", function()
  require('telescope.builtin').live_grep({
    type_filter = "zig",
  })
end, { desc = "Search in Zig files" })

-- Replace operations with enhanced functionality
keymap("n", "<leader>sr", function()
  local word = vim.fn.expand("<cword>")
  if word == "" then
    vim.notify("No word under cursor", vim.log.levels.WARN)
    return
  end
  local replace = vim.fn.input("Replace '" .. word .. "' with: ")
  if replace ~= "" then
    vim.cmd(":%s/\\<" .. word .. "\\>/" .. replace .. "/gc")
  end
end, { desc = "Replace word under cursor" })

keymap("n", "<leader>sR", function()
  local search = vim.fn.input("Search for: ")
  if search == "" then return end
  local replace = vim.fn.input("Replace with: ")
  if replace == "" then return end
  
  -- Properly escape special characters for search and replace
  local escaped_search = vim.fn.escape(search, '/\\.*[]~^$')
  local escaped_replace = vim.fn.escape(replace, '/\\&~')
  
  vim.cmd(":%s/" .. escaped_search .. "/" .. escaped_replace .. "/gc")
end, { desc = "Global search and replace" })

-- Visual mode search and replace
keymap("v", "<leader>sr", function()
  -- Enter command mode with the visual range already set
  vim.api.nvim_feedkeys(":", "n", false)
  vim.api.nvim_feedkeys("'<,'>s/", "n", false)
end, { desc = "Replace in visual selection" })

keymap("v", "<leader>sR", function()
  -- Get the visually selected text
  local old_pos = vim.fn.getpos('.')
  vim.api.nvim_feedkeys('<Esc>', 'nx', false)
  
  -- Get visual selection
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  
  if start_pos[2] == end_pos[2] then
    -- Single line selection
    local line = vim.fn.getline(start_pos[2])
    local selected_text = string.sub(line, start_pos[3], end_pos[3])
    
    if selected_text ~= "" then
      local replace = vim.fn.input("Replace '" .. selected_text .. "' with: ")
      if replace ~= "" then
        local escaped_search = vim.fn.escape(selected_text, '/\\.*[]~^$')
        local escaped_replace = vim.fn.escape(replace, '/\\&~')
        vim.cmd("'<,'>s/" .. escaped_search .. "/" .. escaped_replace .. "/gc")
      end
    end
  else
    -- Multi-line selection - just open substitute command
    vim.api.nvim_feedkeys(":", "n", false)
    vim.api.nvim_feedkeys("'<,'>s/", "n", false)
  end
end, { desc = "Replace selected text" })

-- Case-sensitive and case-insensitive search
keymap("n", "<leader>si", function()
  local word = vim.fn.expand("<cword>")
  if word == "" then
    vim.notify("No word under cursor", vim.log.levels.WARN)
    return
  end
  local replace = vim.fn.input("Replace '" .. word .. "' with (case-insensitive): ")
  if replace ~= "" then
    local escaped_word = vim.fn.escape(word, '/\\.*[]~^$')
    local escaped_replace = vim.fn.escape(replace, '/\\&~')
    vim.cmd(":%s/\\<" .. escaped_word .. "\\>/" .. escaped_replace .. "/gci")
  end
end, { desc = "Case-insensitive replace" })

-- Project-wide search and replace with confirmation
keymap("n", "<leader>sW", function()
  local word = vim.fn.expand("<cword>")
  if word == "" then
    vim.notify("No word under cursor", vim.log.levels.WARN)
    return
  end
  
  local replace = vim.fn.input("Replace '" .. word .. "' in all project files with: ")
  if replace ~= "" then
    -- Use telescope to show files that contain the word first
    require('telescope.builtin').live_grep({
      default_text = word,
      prompt_title = "Files containing '" .. word .. "' - Select files to replace",
    })
    
    vim.notify("After selecting files, run :cfdo %s/\\<" .. word .. "\\>/" .. replace .. "/gc | update", vim.log.levels.INFO)
  end
end, { desc = "Project-wide replace with preview" })

-- Advanced grep with ripgrep options
keymap("n", "<leader>sA", function()
  local pattern = vim.fn.input("Advanced grep pattern: ")
  if pattern ~= "" then
    require('telescope.builtin').live_grep({
      default_text = pattern,
      additional_args = function(opts)
        return {"--smart-case", "--hidden", "--follow"}
      end,
    })
  end
end, { desc = "Advanced grep search" })

-- Interactive search interface
keymap("n", "<leader>sI", "<cmd>lua TacoVim.Search.interactive_search_replace()<cr>", { desc = "Interactive search menu" })

-- Quick search shortcuts
keymap("n", "<leader>sT", function()
  require('telescope.builtin').live_grep({
    default_text = "TODO\\|FIXME\\|HACK\\|NOTE\\|BUG",
    additional_args = {"--regex"}
  })
end, { desc = "Search TODOs and FIXMEs" })

-- PROJECT OPERATIONS GROUP (<leader>p) - WITH SUBCATEGORIES
-- =============================================================================

-- Project Management Subcategory (<leader>pm)
keymap("n", "<leader>pmn", "<cmd>lua TacoVim.ProjectManager.create_project()<cr>", { desc = "New project" })
keymap("n", "<leader>pmo", "<cmd>Telescope projects<cr>", { desc = "Open project" })
keymap("n", "<leader>pmr", "<cmd>lua TacoVim.ProjectManager.recent_projects()<cr>", { desc = "Recent projects" })
keymap("n", "<leader>pma", "<cmd>lua TacoVim.ProjectManager.add_current_to_recent()<cr>", { desc = "Add current to recent" })
keymap("n", "<leader>pms", "<cmd>lua TacoVim.ProjectManager.switch_project()<cr>", { desc = "Switch project" })
keymap("n", "<leader>pmd", "<cmd>lua TacoVim.ProjectManager.delete_project()<cr>", { desc = "Delete project" })

-- Project File Operations (<leader>pf)
keymap("n", "<leader>pff", "<cmd>Telescope find_files<cr>", { desc = "Find files in project" })
keymap("n", "<leader>pfs", "<cmd>Telescope live_grep<cr>", { desc = "Search in project" })
keymap("n", "<leader>pfr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent project files" })
keymap("n", "<leader>pfb", "<cmd>Telescope buffers<cr>", { desc = "Project buffers" })
keymap("n", "<leader>pft", "<cmd>Telescope git_files<cr>", { desc = "Git files" })

-- Project Navigation/Portal (<leader>pn)
keymap("n", "<leader>pno", "<cmd>Portal jumplist backward<cr>", { desc = "Portal jump backward" })
keymap("n", "<leader>pni", "<cmd>Portal jumplist forward<cr>", { desc = "Portal jump forward" })
keymap("n", "<leader>pnm", "<cmd>Telescope marks<cr>", { desc = "Navigate to marks" })
keymap("n", "<leader>pnj", "<cmd>Telescope jumplist<cr>", { desc = "Navigate jumplist" })

-- BUFFER OPERATIONS GROUP (<leader>b)
-- =============================================================================
keymap("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to other buffer" })
keymap("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
keymap("n", "<leader>bD", "<cmd>bdelete!<cr>", { desc = "Force delete buffer" })
keymap("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New buffer" })
keymap("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close other buffers" })
keymap("n", "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", { desc = "Toggle buffer pin" })
keymap("n", "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Delete non-pinned buffers" })
keymap("n", "<leader>bl", "<cmd>Telescope buffers<cr>", { desc = "List buffers" })
keymap("n", "<leader>bs", "<cmd>w<cr>", { desc = "Save buffer" })
keymap("n", "<leader>bS", "<cmd>wa<cr>", { desc = "Save all buffers" })

-- WINDOW OPERATIONS GROUP (<leader>w)
-- =============================================================================
keymap("n", "<leader>wv", "<C-w>v", { desc = "Split vertically" })
keymap("n", "<leader>wh", "<C-w>s", { desc = "Split horizontally" })
keymap("n", "<leader>we", "<C-w>=", { desc = "Equal window splits" })
keymap("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close split" })
keymap("n", "<leader>wo", "<C-w>o", { desc = "Close other windows" })
keymap("n", "<leader>ww", "<C-w>w", { desc = "Switch windows" })
keymap("n", "<leader>wT", "<C-w>T", { desc = "Break out into new tab" })
keymap("n", "<leader>wr", function()
  local function resize_mode()
    print("🔧 Resize Mode: h/l=width, j/k=height, ==equal, q=quit")
    while true do
      local key = vim.fn.getchar()
      local char = vim.fn.nr2char(key)

      if char == 'h' then
        vim.cmd("vertical resize -2")
      elseif char == 'l' then
        vim.cmd("vertical resize +2")
      elseif char == 'j' then
        vim.cmd("resize -1")
      elseif char == 'k' then
        vim.cmd("resize +1")
      elseif char == '=' then
        vim.cmd("wincmd =")
      elseif char == 'q' or char == '\27' then -- 'q' or Escape
        break
      end
    end
    print("")
  end
  resize_mode()
end, { desc = "Enter resize mode" })

-- CODE OPERATIONS GROUP (<leader>c)
-- =============================================================================
keymap("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
keymap("n", "<leader>cD", "<cmd>Telescope diagnostics<cr>", { desc = "Workspace diagnostics" })
keymap("n", "<leader>cf", function() vim.lsp.buf.format { async = true } end, { desc = "Format document" })
keymap("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
keymap("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
keymap("n", "<leader>ch", vim.lsp.buf.hover, { desc = "Hover documentation" })
keymap("n", "<leader>cs", vim.lsp.buf.signature_help, { desc = "Signature help" })
keymap("n", "<leader>ci", "<cmd>Telescope lsp_implementations<cr>", { desc = "Go to implementations" })
keymap("n", "<leader>cR", "<cmd>Telescope lsp_references<cr>", { desc = "Show references" })
keymap("n", "<leader>co", "<cmd>copen<cr>", { desc = "Open quickfix list" })
keymap("n", "<leader>cc", "<cmd>cclose<cr>", { desc = "Close quickfix list" })

-- LSP OPERATIONS GROUP (<leader>l)
-- =============================================================================
keymap("n", "<leader>ld", "<cmd>Telescope lsp_definitions<cr>", { desc = "Go to definition" })
keymap("n", "<leader>lD", "<cmd>Telescope lsp_type_definitions<cr>", { desc = "Go to type definition" })
keymap("n", "<leader>li", "<cmd>Telescope lsp_implementations<cr>", { desc = "Go to implementations" })
keymap("n", "<leader>lr", "<cmd>Telescope lsp_references<cr>", { desc = "Show references" })
keymap("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document symbols" })
keymap("n", "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "Workspace symbols" })
keymap("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code actions" })
keymap("n", "<leader>ln", vim.lsp.buf.rename, { desc = "Rename symbol" })
keymap("n", "<leader>lf", function() vim.lsp.buf.format { async = true } end, { desc = "Format document" })
keymap("n", "<leader>lh", vim.lsp.buf.hover, { desc = "Hover documentation" })
keymap("n", "<leader>lI", "<cmd>LspInfo<cr>", { desc = "LSP info" })
keymap("n", "<leader>lR", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })

-- GIT OPERATIONS GROUP (<leader>g)
-- =============================================================================
keymap("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open Neogit" })
keymap("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Git status" })
keymap("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Git commits" })
keymap("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Git branches" })
keymap("n", "<leader>gf", "<cmd>Telescope git_files<cr>", { desc = "Git files" })
keymap("n", "<leader>gS", "<cmd>Telescope git_stash<cr>", { desc = "Git stash" })
keymap("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Open diff view" })
keymap("n", "<leader>gD", "<cmd>DiffviewClose<cr>", { desc = "Close diff view" })
keymap("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "File history" })
keymap("n", "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", { desc = "Current file history" })

-- TERMINAL OPERATIONS GROUP (<leader>t)
-- =============================================================================
keymap("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
keymap("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Float terminal" })
keymap("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Horizontal terminal" })
keymap("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "Vertical terminal" })
keymap("n", "<leader>tn", "<cmd>lua _NODE_TOGGLE()<cr>", { desc = "Node terminal" })
keymap("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<cr>", { desc = "Python terminal" })
keymap("n", "<leader>tg", "<cmd>lua _LAZYGIT_TOGGLE()<cr>", { desc = "LazyGit terminal" })
keymap("n", "<leader>tr", "<cmd>lua _RANGER_TOGGLE()<cr>", { desc = "Ranger terminal" })
keymap("n", "<leader>ta", "<cmd>ToggleTermToggleAll<cr>", { desc = "Toggle all terminals" })

-- RUN/BUILD OPERATIONS GROUP (<leader>r)
-- =============================================================================
keymap("n", "<leader>rr", "<cmd>lua TacoVim.BuildSystem.run()<cr>", { desc = "Run project" })
keymap("n", "<leader>rb", "<cmd>lua TacoVim.BuildSystem.build()<cr>", { desc = "Build project" })
keymap("n", "<leader>rt", "<cmd>lua TacoVim.BuildSystem.test()<cr>", { desc = "Test project" })
keymap("n", "<leader>rc", "<cmd>lua TacoVim.BuildSystem.clean()<cr>", { desc = "Clean project" })
keymap("n", "<leader>rd", "<cmd>lua TacoVim.BuildSystem.debug()<cr>", { desc = "Debug project" })
keymap("n", "<leader>rR", "<cmd>OverseerRun<cr>", { desc = "Run task" })
keymap("n", "<leader>rT", "<cmd>OverseerToggle<cr>", { desc = "Toggle task list" })
keymap("n", "<leader>ra", "<cmd>OverseerTaskAction<cr>", { desc = "Task actions" })

-- QUIT/SESSION OPERATIONS GROUP (<leader>q)
-- =============================================================================
keymap("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
keymap("n", "<leader>qQ", "<cmd>qa!<cr>", { desc = "Force quit all" })
keymap("n", "<leader>qs", "<cmd>lua require('persistence').save()<cr>", { desc = "Save session" })
keymap("n", "<leader>ql", "<cmd>lua require('persistence').load()<cr>", { desc = "Load session" })
keymap("n", "<leader>qd", "<cmd>lua require('persistence').stop()<cr>", { desc = "Stop session" })
keymap("n", "<leader>qr", "<cmd>lua require('persistence').load({ last = true })<cr>", { desc = "Restore last session" })

-- EXPLORER OPERATIONS GROUP (<leader>e)
-- =============================================================================
keymap("n", "<leader>ee", "<cmd>Neotree toggle<cr>", { desc = "Toggle explorer" })
keymap("n", "<leader>ef", "<cmd>Neotree reveal<cr>", { desc = "Reveal current file" })
keymap("n", "<leader>eg", "<cmd>Neotree git_status<cr>", { desc = "Git status explorer" })
keymap("n", "<leader>eb", "<cmd>Neotree buffers<cr>", { desc = "Buffer explorer" })
keymap("n", "<leader>es", "<cmd>Neotree document_symbols<cr>", { desc = "Symbol explorer" })
keymap("n", "<leader>eF", "<cmd>Neotree focus<cr>", { desc = "Focus explorer" })
keymap("n", "<leader>eh", function()
  vim.cmd("Neotree filesystem " .. vim.fn.expand("~"))
end, { desc = "Explorer home directory" })
keymap("n", "<leader>er", "<cmd>Neotree filesystem reveal<cr>", { desc = "Explorer reveal file" })
keymap("n", "<leader>eR", "<cmd>Neotree filesystem close<cr><cmd>Neotree filesystem reveal<cr>", { desc = "Refresh explorer" })

-- TAB OPERATIONS GROUP (<leader><tab>)
-- =============================================================================
keymap("n", "<leader><tab>n", "<cmd>tabnew<CR>", { desc = "New tab" })
keymap("n", "<leader><tab>x", "<cmd>tabclose<CR>", { desc = "Close tab" })
keymap("n", "<leader><tab>]", "<cmd>tabnext<CR>", { desc = "Next tab" })
keymap("n", "<leader><tab>[", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
keymap("n", "<leader><tab>f", "<cmd>tabfirst<CR>", { desc = "First tab" })
keymap("n", "<leader><tab>l", "<cmd>tablast<CR>", { desc = "Last tab" })
keymap("n", "<leader><tab>o", "<cmd>tabonly<CR>", { desc = "Close other tabs" })

-- UI/UTILITIES GROUP (<leader>u)
-- =============================================================================
keymap("n", "<leader>ut", "<cmd>lua TacoVim.ThemeManager.switch_theme()<cr>", { desc = "Switch theme" })
keymap("n", "<leader>uT", "<cmd>lua TacoVim.Utilities.toggle_transparency()<cr>", { desc = "Toggle transparency" })
keymap("n", "<leader>ud", "<cmd>lua TacoVim.Utilities.toggle_diagnostics()<cr>", { desc = "Toggle diagnostics" })
keymap("n", "<leader>uf", "<cmd>lua TacoVim.Utilities.toggle_format_on_save()<cr>", { desc = "Toggle format on save" })
keymap("n", "<leader>ul", "<cmd>lua TacoVim.Utilities.toggle_line_numbers()<cr>", { desc = "Toggle line numbers" })
keymap("n", "<leader>uw", "<cmd>lua TacoVim.Utilities.toggle_wrap()<cr>", { desc = "Toggle line wrap" })
keymap("n", "<leader>us", "<cmd>lua TacoVim.Utilities.show_stats()<cr>", { desc = "Show stats" })
keymap("n", "<leader>ur", "<cmd>lua TacoVim.Utilities.reload_config()<cr>", { desc = "Reload config" })
keymap("n", "<leader>uk", "<cmd>lua TacoVim.Utilities.keymap_manager()<cr>", { desc = "Keymap manager" })
keymap("n", "<leader>uz", "<cmd>ZenMode<cr>", { desc = "Toggle Zen mode" })
keymap("n", "<leader>uL", "<cmd>Lazy<cr>", { desc = "Lazy Plugin Manager" })
keymap("n", "<leader>uM", "<cmd>Mason<cr>", { desc = "Mason LSP Manager" })
keymap("n", "<leader>up", function()
  if TacoVim.PluginStore and TacoVim.PluginStore.open then
    -- Add small delay to ensure UI state is clean
    vim.defer_fn(function()
      TacoVim.PluginStore.open()
    end, 10)
  else
    vim.notify("Plugin Store not available", vim.log.levels.WARN)
  end
end, { desc = "Plugin Store" })
keymap("n", "<leader>uP", function()
  if TacoVim.PluginStore and TacoVim.PluginStore.search then
    vim.defer_fn(function()
      TacoVim.PluginStore.search()
    end, 10)
  else
    vim.notify("Plugin Store not available", vim.log.levels.WARN)
  end
end, { desc = "Search Plugins" })
keymap("n", "<leader>uI", "<cmd>Inspect<cr>", { desc = "Inspect element" })
keymap("n", "<leader>ui", function()
  if TacoVim.PluginStore and TacoVim.PluginStore.quick_install then
    vim.defer_fn(function()
      TacoVim.PluginStore.quick_install()
    end, 10)
  else
    vim.notify("Plugin Store not available", vim.log.levels.WARN)
  end
end, { desc = "Install Plugin" })
keymap("n", "<leader>uh", "<cmd>noh<cr>", { desc = "Clear search highlights" })
keymap("n", "<leader>uC", "<cmd>Telescope colorscheme<cr>", { desc = "Change colorscheme" })
keymap("n", "<leader>un", "<cmd>lua TacoVim.Utilities.toggle_number()<cr>", { desc = "Toggle line numbers" })
keymap("n", "<leader>uc", "<cmd>TacoConfig<cr>", { desc = "Edit user configuration" })
keymap("n", "<leader>uR", "<cmd>TacoReload<cr>", { desc = "Reload user configuration" })

-- NOTES/MISCELLANEOUS GROUP (<leader>n)
-- =============================================================================
keymap("n", "<leader>nn", "<cmd>enew<cr>", { desc = "New note/buffer" })
keymap("n", "<leader>ns", "<cmd>Telescope live_grep<cr>", { desc = "Search notes" })
keymap("n", "<leader>nr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent notes" })
keymap("n", "<leader>nt", "<cmd>lua require('todo-comments').jump_next()<cr>", { desc = "Next todo" })
keymap("n", "<leader>nT", "<cmd>lua require('todo-comments').jump_prev()<cr>", { desc = "Previous todo" })
keymap("n", "<leader>nl", "<cmd>TodoTelescope<cr>", { desc = "List todos" })

-- TESTING GROUP (<leader>m) - for "test methods"
-- =============================================================================
keymap("n", "<leader>mm", "<cmd>lua require('neotest').run.run()<cr>", { desc = "Run nearest test" })
keymap("n", "<leader>mf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", { desc = "Run file tests" })
keymap("n", "<leader>ms", "<cmd>lua require('neotest').summary.toggle()<cr>", { desc = "Toggle test summary" })
keymap("n", "<leader>mo", "<cmd>lua require('neotest').output.open()<cr>", { desc = "Test output" })
keymap("n", "<leader>mO", "<cmd>lua require('neotest').output_panel.toggle()<cr>", { desc = "Toggle output panel" })
keymap("n", "<leader>md", "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", { desc = "Debug test" })
keymap("n", "<leader>mS", "<cmd>lua require('neotest').run.stop()<cr>", { desc = "Stop test" })
keymap("n", "<leader>ma", "<cmd>lua require('neotest').run.run(vim.fn.getcwd())<cr>", { desc = "Run all tests" })

-- =============================================================================
-- DEBUGGING (F-keys for VS Code style debugging)
-- =============================================================================

-- Primary debugging controls
keymap("n", "<F5>", function() 
  local ok, dap = pcall(require, "dap")
  if ok then dap.continue() end
end, { desc = "Start/Continue" })

keymap("n", "<S-F5>", function() 
  local ok, dap = pcall(require, "dap")
  if ok then dap.terminate() end
end, { desc = "Stop" })

keymap("n", "<F9>", function() 
  local ok, dap = pcall(require, "dap")
  if ok then dap.toggle_breakpoint() end
end, { desc = "Toggle Breakpoint" })

keymap("n", "<F10>", function() 
  local ok, dap = pcall(require, "dap")
  if ok then dap.step_over() end
end, { desc = "Step Over" })

keymap("n", "<F11>", function() 
  local ok, dap = pcall(require, "dap")
  if ok then dap.step_into() end
end, { desc = "Step Into" })

keymap("n", "<S-F11>", function() 
  local ok, dap = pcall(require, "dap")
  if ok then dap.step_out() end
end, { desc = "Step Out" })

-- Additional F-key debug controls
keymap("n", "<S-F5>", function() 
  local ok, dap = pcall(require, "dap")
  if ok then 
    dap.terminate()
    vim.notify("🛑 Debug session stopped", vim.log.levels.INFO)
  end
end, { desc = "Stop Debug Session" })

keymap("n", "<C-S-F5>", function() 
  local ok, dap = pcall(require, "dap")
  if ok then 
    dap.restart()
    vim.notify("🔄 Debug session restarted", vim.log.levels.INFO)
  end
end, { desc = "Restart Debug Session" })

-- DEBUG GROUP (<leader>d) - Advanced debugging features
-- =============================================================================
keymap("n", "<leader>db", function() 
  local ok, dap = pcall(require, "dap")
  if ok then dap.toggle_breakpoint() end
end, { desc = "Toggle breakpoint" })

keymap("n", "<leader>dB", function() 
  local ok, dap = pcall(require, "dap")
  if ok then dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end
end, { desc = "Conditional breakpoint" })

keymap("n", "<leader>dc", function() 
  local ok, dap = pcall(require, "dap")
  if ok then dap.continue() end
end, { desc = "Continue" })

keymap("n", "<leader>dd", function() 
  local ok, dap = pcall(require, "dap")
  if ok then dap.clear_breakpoints() end
end, { desc = "Clear breakpoints" })

keymap("n", "<leader>du", function() 
  local ok, dapui = pcall(require, "dapui")
  if ok then dapui.toggle() end
end, { desc = "Toggle debug UI" })

keymap("n", "<leader>dr", function() 
  local ok, dap = pcall(require, "dap")
  if ok then dap.repl.open() end
end, { desc = "Debug console" })

-- Debug session control
keymap("n", "<leader>dq", function() 
  local ok, dap = pcall(require, "dap")
  if ok then 
    dap.terminate()
    local dapui_ok, dapui = pcall(require, "dapui")
    if dapui_ok then dapui.close() end
    vim.notify("🛑 Debug session terminated", vim.log.levels.INFO)
  end
end, { desc = "Quit/terminate debug session" })

keymap("n", "<leader>dQ", function() 
  local ok, dap = pcall(require, "dap")
  if ok then 
    dap.disconnect()
    dap.close()
    local dapui_ok, dapui = pcall(require, "dapui")
    if dapui_ok then dapui.close() end
    vim.notify("🔌 Debug session disconnected", vim.log.levels.INFO)
  end
end, { desc = "Disconnect and close debug session" })

-- Debug utilities
keymap("n", "<leader>dR", "<cmd>TacoDebugReload<cr>", { desc = "Reload DAP configuration" })
keymap("n", "<leader>dU", "<cmd>TacoDebugFixUI<cr>", { desc = "Fix Debug UI" })
keymap("n", "<leader>dT", "<cmd>TSUpdate<cr>", { desc = "Update treesitter parsers" })
keymap("n", "<leader>dS", "<cmd>TacoDebugStatus<cr>", { desc = "Debug session status" })
keymap("n", "<leader>dX", "<cmd>TacoDebugTerminate<cr>", { desc = "Force terminate debug session" })

-- =============================================================================
-- FOLDING (UFO)
-- =============================================================================

keymap("n", "zR", function() 
  local ok, ufo = pcall(require, "ufo")
  if ok then ufo.openAllFolds() end
end, { desc = "Open all folds" })

keymap("n", "zM", function() 
  local ok, ufo = pcall(require, "ufo")
  if ok then ufo.closeAllFolds() end
end, { desc = "Close all folds" })

-- =============================================================================
-- CUSTOM KEYMAPS
-- =============================================================================

-- Load custom keymaps if the file exists
local custom_keymaps_ok, _ = pcall(require, "tacovim.custom_keymaps")
if not custom_keymaps_ok then
  -- File doesn't exist yet, create it
  local custom_file = vim.fn.stdpath("config") .. "/lua/tacovim/custom_keymaps.lua"
  if vim.fn.filereadable(custom_file) == 0 then
    local content = {
      "-- Custom Keymaps - Add your own keymaps here",
      "-- Example: vim.keymap.set('n', '<leader>cc', '<cmd>ColorizerToggle<cr>', { desc = 'Toggle colorizer' })",
      ""
    }
    vim.fn.writefile(content, custom_file)
  end
end

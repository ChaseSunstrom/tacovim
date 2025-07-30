-- ~/.config/nvim/lua/tacovim/core/keymaps.lua
-- TacoVim Core Keymaps

local keymap = vim.keymap.set
local opts = { silent = true }

-- =============================================================================
-- GENERAL KEYMAPS
-- =============================================================================

-- Better escape sequences
keymap("i", "jk", "<ESC>", { desc = "Exit insert mode" })
keymap("i", "kj", "<ESC>", { desc = "Exit insert mode" })

-- Clear search highlighting
keymap({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Clear search and escape" })

-- Better navigation
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })

-- =============================================================================
-- SAVE AND QUIT
-- =============================================================================

keymap({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
keymap("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
keymap("n", "<leader>W", "<cmd>wa<cr>", { desc = "Save all files" })
keymap("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
keymap("n", "<leader>qQ", "<cmd>qa!<cr>", { desc = "Force quit all" })

-- =============================================================================
-- WINDOW NAVIGATION AND MANAGEMENT
-- =============================================================================

-- Navigate windows
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize windows with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize up" })
keymap("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize down" })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize left" })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize right" })

-- Window splits
keymap("n", "<leader>wv", "<C-w>v", { desc = "Split vertically" })
keymap("n", "<leader>wh", "<C-w>s", { desc = "Split horizontally" })
keymap("n", "<leader>we", "<C-w>=", { desc = "Equal window splits" })
keymap("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close split" })
keymap("n", "<leader>wo", "<C-w>o", { desc = "Close other windows" })

-- Window resize mode
keymap("n", "<leader>wr", function()
  local function resize_mode()
    print("Resize mode: h/l = width, j/k = height, = = equal, q = quit")
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

-- =============================================================================
-- TAB MANAGEMENT
-- =============================================================================

keymap("n", "<leader><tab>o", "<cmd>tabnew<CR>", { desc = "New tab" })
keymap("n", "<leader><tab>x", "<cmd>tabclose<CR>", { desc = "Close tab" })
keymap("n", "<leader><tab>n", "<cmd>tabnext<CR>", { desc = "Next tab" })
keymap("n", "<leader><tab>p", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
keymap("n", "<leader><tab>f", "<cmd>tabfirst<CR>", { desc = "First tab" })
keymap("n", "<leader><tab>l", "<cmd>tablast<CR>", { desc = "Last tab" })

-- Tab navigation shortcuts
keymap("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
keymap("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })

-- =============================================================================
-- BUFFER MANAGEMENT
-- =============================================================================

keymap("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
keymap("n", "<leader>bD", "<cmd>bdelete!<cr>", { desc = "Force delete buffer" })
keymap("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close other buffers" })
keymap("n", "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", { desc = "Toggle buffer pin" })
keymap("n", "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", { desc = "Delete non-pinned buffers" })
keymap("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
keymap("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- =============================================================================
-- MOVEMENT AND TEXT MANIPULATION
-- =============================================================================

-- Move lines up/down
keymap("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
keymap("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
keymap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
keymap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
keymap("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move lines down" })
keymap("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move lines up" })

-- Better indenting
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- Better paste (don't lose register)
keymap("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

-- System clipboard operations
keymap({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
keymap("n", "<leader>Y", [["+Y]], { desc = "Yank line to clipboard" })
keymap({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to void register" })

-- =============================================================================
-- SEARCH AND REPLACE
-- =============================================================================

-- Better search and replace
keymap("n", "<leader>sr", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Search and replace word under cursor" })
keymap("v", "<leader>sr", ":s/\\%V", { desc = "Search and replace in selection" })

-- Center search results
keymap("n", "n", "nzzzv", { desc = "Next search result" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result" })

-- =============================================================================
-- QUICKFIX AND LOCATION LIST
-- =============================================================================

keymap("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Open quickfix list" })
keymap("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Close quickfix list" })
keymap("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix item" })
keymap("n", "[q", "<cmd>cprev<cr>", { desc = "Previous quickfix item" })

keymap("n", "<leader>lo", "<cmd>lopen<cr>", { desc = "Open location list" })
keymap("n", "<leader>lc", "<cmd>lclose<cr>", { desc = "Close location list" })
keymap("n", "]l", "<cmd>lnext<cr>", { desc = "Next location item" })
keymap("n", "[l", "<cmd>lprev<cr>", { desc = "Previous location item" })

-- =============================================================================
-- FOLDING
-- =============================================================================

keymap("n", "zR", function() require("ufo").openAllFolds() end, { desc = "Open all folds" })
keymap("n", "zM", function() require("ufo").closeAllFolds() end, { desc = "Close all folds" })
keymap("n", "zr", function() require("ufo").openFoldsExceptKinds() end, { desc = "Open folds except kinds" })
keymap("n", "zm", function() require("ufo").closeFoldsWith() end, { desc = "Close folds with" })
keymap("n", "zp", function() require("ufo").peekFoldedLinesUnderCursor() end, { desc = "Peek fold" })

-- =============================================================================
-- DIAGNOSTICS
-- =============================================================================

keymap("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
keymap("n", "<leader>cD", "<cmd>Telescope diagnostics<cr>", { desc = "Workspace diagnostics" })

-- =============================================================================
-- TERMINAL MODE
-- =============================================================================

keymap("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
keymap("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal left" })
keymap("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal down" })
keymap("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal up" })
keymap("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal right" })

-- =============================================================================
-- PROJECT MANAGEMENT
-- =============================================================================

keymap("n", "<leader>pn", "<cmd>lua TacoVim.ProjectManager.create_project()<cr>", { desc = "New project" })
keymap("n", "<leader>po", "<cmd>Telescope projects<cr>", { desc = "Open project" })
keymap("n", "<leader>pr", "<cmd>lua TacoVim.ProjectManager.recent_projects()<cr>", { desc = "Recent projects" })

-- =============================================================================
-- BUILD AND RUN SYSTEM
-- =============================================================================

keymap("n", "<leader>rb", "<cmd>lua TacoVim.BuildSystem.build()<cr>", { desc = "Build project" })
keymap("n", "<leader>rr", "<cmd>lua TacoVim.BuildSystem.run()<cr>", { desc = "Run project" })
keymap("n", "<leader>rt", "<cmd>lua TacoVim.BuildSystem.test()<cr>", { desc = "Test project" })
keymap("n", "<leader>rc", "<cmd>lua TacoVim.BuildSystem.clean()<cr>", { desc = "Clean project" })
keymap("n", "<leader>rd", "<cmd>lua TacoVim.BuildSystem.debug()<cr>", { desc = "Debug project" })
keymap("n", "<leader>rR", "<cmd>OverseerRun<cr>", { desc = "Run task" })
keymap("n", "<leader>rT", "<cmd>OverseerToggle<cr>", { desc = "Toggle task list" })

-- =============================================================================
-- SESSION MANAGEMENT
-- =============================================================================

keymap("n", "<leader>qs", "<cmd>lua TacoVim.SessionManager.save_session()<cr>", { desc = "Save session" })
keymap("n", "<leader>ql", "<cmd>lua TacoVim.SessionManager.load_session()<cr>", { desc = "Load session" })
keymap("n", "<leader>qd", "<cmd>lua TacoVim.SessionManager.delete_session()<cr>", { desc = "Delete session" })

-- =============================================================================
-- UI AND THEME MANAGEMENT
-- =============================================================================

keymap("n", "<leader>ut", "<cmd>lua TacoVim.ThemeManager.switch_theme()<cr>", { desc = "Switch theme" })
keymap("n", "<leader>uT", "<cmd>lua TacoVim.Utilities.toggle_transparency()<cr>", { desc = "Toggle transparency" })
keymap("n", "<leader>ud", "<cmd>lua TacoVim.Utilities.toggle_diagnostics()<cr>", { desc = "Toggle diagnostics" })
keymap("n", "<leader>uf", "<cmd>lua TacoVim.Utilities.toggle_format_on_save()<cr>", { desc = "Toggle format on save" })
keymap("n", "<leader>ul", "<cmd>lua TacoVim.Utilities.toggle_line_numbers()<cr>", { desc = "Toggle line numbers" })
keymap("n", "<leader>uw", "<cmd>lua TacoVim.Utilities.toggle_wrap()<cr>", { desc = "Toggle line wrap" })
keymap("n", "<leader>us", "<cmd>lua TacoVim.Utilities.show_stats()<cr>", { desc = "Show stats" })
keymap("n", "<leader>uh", "<cmd>lua TacoVim.Utilities.health_check()<cr>", { desc = "Health check" })
keymap("n", "<leader>ur", "<cmd>lua TacoVim.Utilities.reload_config()<cr>", { desc = "Reload config" })

-- =============================================================================
-- ENHANCED DEBUGGING (Visual Studio style)
-- =============================================================================

-- Primary debugging controls
keymap("n", "<F5>", function() require("dap").continue() end, { desc = "🚀 Start/Continue" })
keymap("n", "<S-F5>", function() require("dap").terminate() end, { desc = "⏹️ Stop" })
keymap("n", "<C-S-F5>", function() require("dap").restart() end, { desc = "🔄 Restart" })
keymap("n", "<F9>", function() require("dap").toggle_breakpoint() end, { desc = "🔴 Toggle Breakpoint" })
keymap("n", "<F10>", function() require("dap").step_over() end, { desc = "⏭️ Step Over" })
keymap("n", "<F11>", function() require("dap").step_into() end, { desc = "⬇️ Step Into" })
keymap("n", "<S-F11>", function() require("dap").step_out() end, { desc = "⬆️ Step Out" })

-- Advanced breakpoints
keymap("n", "<leader>dB", function() 
  require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) 
end, { desc = "🎯 Conditional Breakpoint" })
keymap("n", "<leader>dL", function() 
  require("dap").set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) 
end, { desc = "📝 Log Point" })
keymap("n", "<leader>dC", function() require("dap").clear_breakpoints() end, { desc = "🧹 Clear Breakpoints" })

-- UI and inspection
keymap("n", "<leader>du", function() require("dapui").toggle() end, { desc = "🔧 Toggle Debug UI" })
keymap("n", "<leader>dr", function() require("dap").repl.open() end, { desc = "💬 Debug Console" })
keymap("n", "<leader>dl", function() require("dap").run_last() end, { desc = "🔄 Run Last" })
keymap("n", "<leader>dh", function() require("dap.ui.widgets").hover() end, { desc = "🔍 Hover Variables" })

-- =============================================================================
-- ADDITIONAL ENHANCEMENTS
-- =============================================================================

-- Increment/decrement numbers
keymap("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Select all
keymap("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- Better join lines
keymap("n", "J", "mzJ`z", { desc = "Join lines" })

-- Center half page movements
keymap("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })

-- Better undo break points
keymap("i", ",", ",<c-g>u", opts)
keymap("i", ".", ".<c-g>u", opts)
keymap("i", ";", ";<c-g>u", opts)

-- Make executable
keymap("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })

-- Source current file
keymap("n", "<leader><leader>", function()
  vim.cmd("so")
  vim.notify("File sourced!", vim.log.levels.INFO)
end, { desc = "Source current file" })

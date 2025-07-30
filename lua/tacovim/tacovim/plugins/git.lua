-- ~/.config/nvim/lua/tacovim/plugins/git.lua
-- TacoVim Git Integration

return {
  -- =============================================================================
  -- GITSIGNS - GIT DECORATIONS
  -- =============================================================================
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- Navigation
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")

        -- Actions
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
      max_file_length = 40000,
      preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      word_diff = false,
      diff_opts = {
        internal = true,
      },
    },
    keys = {
      { "<leader>ghb", desc = "Blame Line" },
      { "<leader>ghd", desc = "Diff This" },
      { "<leader>ghp", desc = "Preview Hunk" },
      { "<leader>ghR", desc = "Reset Buffer" },
      { "<leader>ghr", desc = "Reset Hunk", mode = { "n", "v" } },
      { "<leader>ghs", desc = "Stage Hunk", mode = { "n", "v" } },
      { "<leader>ghS", desc = "Stage Buffer" },
      { "<leader>ghu", desc = "Undo Stage Hunk" },
      { "]h", desc = "Next Hunk" },
      { "[h", desc = "Prev Hunk" },
    },
  },

  -- =============================================================================
  -- DIFFVIEW - GIT DIFF VIEWER
  -- =============================================================================
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView Open" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "DiffView Close" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "DiffView File History" },
      { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "DiffView Current File History" },
    },
    opts = {
      diff_binaries = false,
      enhanced_diff_hl = true,
      git_cmd = { "git" },
      hg_cmd = { "hg" },
      use_icons = true,
      show_help_hints = true,
      watch_index = true,
      icons = {
        folder_closed = "",
        folder_open = "",
      },
      signs = {
        fold_closed = "",
        fold_open = "",
        done = "✓",
      },
      view = {
        default = {
          layout = "diff2_horizontal",
          disable_diagnostics = true,
          winbar_info = false,
        },
        merge_tool = {
          layout = "diff3_horizontal",
          disable_diagnostics = true,
          winbar_info = true,
        },
        file_history = {
          layout = "diff2_horizontal",
          disable_diagnostics = true,
          winbar_info = false,
        },
      },
      file_panel = {
        listing_style = "tree",
        tree_options = {
          flatten_dirs = true,
          folder_statuses = "only_folded",
        },
        win_config = {
          position = "left",
          width = 35,
          win_opts = {}
        },
      },
      file_history_panel = {
        log_options = {
          git = {
            single_file = {
              diff_merges = "combined",
            },
            multi_file = {
              diff_merges = "first-parent",
            },
          },
        },
        win_config = {
          position = "bottom",
          height = 16,
          win_opts = {}
        },
      },
      commit_log_panel = {
        win_config = {
          win_opts = {},
        }
      },
      default_args = {
        DiffviewOpen = {},
        DiffviewFileHistory = {},
      },
      hooks = {},
      keymaps = {
        disable_defaults = false,
        view = {
          { "n", "<tab>", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle the file panel." } },
          { "n", "gf", "<cmd>DiffviewToggleFiles<cr>", { desc = "Toggle the file panel" } },
          -- Removed <leader>e to avoid conflicts with explorer group
          { "n", "<leader>co", "<Cmd>DiffviewClose<CR>", { desc = "Close diffview" } },
          { "n", "[x", "<cmd>DiffviewPrevConflict<cr>", { desc = "In the merge-tool: jump to the previous conflict" } },
          { "n", "]x", "<cmd>DiffviewNextConflict<cr>", { desc = "In the merge-tool: jump to the next conflict" } },
          { "n", "<leader>cO", "<Cmd>DiffviewClose<CR>", { desc = "Close diffview" } },
          { "n", "<leader>cR", "<Cmd>DiffviewRefresh<CR>", { desc = "Update stats and entries in the file list" } },
        },
        diff1 = {
          { "n", "g?", "<cmd>DiffviewToggleHelp<cr>", { desc = "Open the help panel" } },
        },
        diff2 = {
          { "n", "g?", "<cmd>DiffviewToggleHelp<cr>", { desc = "Open the help panel" } },
        },
        diff3 = {
          { { "n", "x" }, "2do", "<Cmd>diffget //2<CR>", { desc = "Obtain the diff hunk from the OURS version of the file" } },
          { { "n", "x" }, "3do", "<Cmd>diffget //3<CR>", { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
          { "n", "g?", "<cmd>DiffviewToggleHelp<cr>", { desc = "Open the help panel" } },
        },
        diff4 = {
          { { "n", "x" }, "1do", "<Cmd>diffget //1<CR>", { desc = "Obtain the diff hunk from the BASE version of the file" } },
          { { "n", "x" }, "2do", "<Cmd>diffget //2<CR>", { desc = "Obtain the diff hunk from the OURS version of the file" } },
          { { "n", "x" }, "3do", "<Cmd>diffget //3<CR>", { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
          { "n", "g?", "<cmd>DiffviewToggleHelp<cr>", { desc = "Open the help panel" } },
        },
        file_panel = {
          { "n", "j", "<cmd>lua require'diffview.actions'.next_entry()<cr>", { desc = "Bring the cursor to the next file entry" } },
          { "n", "<down>", "<cmd>lua require'diffview.actions'.next_entry()<cr>", { desc = "Bring the cursor to the next file entry" } },
          { "n", "k", "<cmd>lua require'diffview.actions'.prev_entry()<cr>", { desc = "Bring the cursor to the previous file entry." } },
          { "n", "<up>", "<cmd>lua require'diffview.actions'.prev_entry()<cr>", { desc = "Bring the cursor to the previous file entry." } },
          { "n", "<cr>", "<cmd>lua require'diffview.actions'.select_entry()<cr>", { desc = "Open the diff for the selected entry." } },
          { "n", "o", "<cmd>lua require'diffview.actions'.select_entry()<cr>", { desc = "Open the diff for the selected entry." } },
          { "n", "l", "<cmd>lua require'diffview.actions'.select_entry()<cr>", { desc = "Open the diff for the selected entry." } },
          { "n", "<2-LeftMouse>", "<cmd>lua require'diffview.actions'.select_entry()<cr>", { desc = "Open the diff for the selected entry." } },
          { "n", "-", "<cmd>lua require'diffview.actions'.toggle_stage_entry()<cr>", { desc = "Stage / unstage the selected entry." } },
          { "n", "S", "<cmd>lua require'diffview.actions'.stage_all()<cr>", { desc = "Stage all entries." } },
          { "n", "U", "<cmd>lua require'diffview.actions'.unstage_all()<cr>", { desc = "Unstage all entries." } },
          { "n", "X", "<cmd>lua require'diffview.actions'.restore_entry()<cr>", { desc = "Restore entry to the state on the left side." } },
          { "n", "L", "<cmd>lua require'diffview.actions'.open_commit_log()<cr>", { desc = "Open the commit log panel." } },
          { "n", "zo", "<cmd>lua require'diffview.actions'.open_fold()<cr>", { desc = "Expand fold" } },
          { "n", "h", "<cmd>lua require'diffview.actions'.close_fold()<cr>", { desc = "Collapse fold" } },
          { "n", "zc", "<cmd>lua require'diffview.actions'.close_fold()<cr>", { desc = "Collapse fold" } },
          { "n", "za", "<cmd>lua require'diffview.actions'.toggle_fold()<cr>", { desc = "Toggle fold" } },
          { "n", "zR", "<cmd>lua require'diffview.actions'.open_all_folds()<cr>", { desc = "Expand all folds" } },
          { "n", "zM", "<cmd>lua require'diffview.actions'.close_all_folds()<cr>", { desc = "Collapse all folds" } },
          { "n", "<c-b>", "<cmd>lua require'diffview.actions'.scroll_view(-0.25)<cr>", { desc = "Scroll the view up" } },
          { "n", "<c-f>", "<cmd>lua require'diffview.actions'.scroll_view(0.25)<cr>", { desc = "Scroll the view down" } },
          { "n", "<tab>", "<cmd>lua require'diffview.actions'.select_next_entry()<cr>", { desc = "Open the diff for the next file" } },
          { "n", "<s-tab>", "<cmd>lua require'diffview.actions'.select_prev_entry()<cr>", { desc = "Open the diff for the previous file" } },
          { "n", "gf", "<cmd>lua require'diffview.actions'.goto_file()<cr>", { desc = "Open the file in the previous tabpage" } },
          { "n", "<C-w><C-f>", "<cmd>lua require'diffview.actions'.goto_file_split()<cr>", { desc = "Open the file in a new split" } },
          { "n", "<C-w>gf", "<cmd>lua require'diffview.actions'.goto_file_tab()<cr>", { desc = "Open the file in a new tabpage" } },
          { "n", "i", "<cmd>lua require'diffview.actions'.listing_style()<cr>", { desc = "Toggle between 'list' and 'tree' views" } },
          { "n", "f", "<cmd>lua require'diffview.actions'.toggle_flatten_dirs()<cr>", { desc = "Flatten empty subdirectories in tree listing style." } },
          { "n", "R", "<cmd>lua require'diffview.actions'.refresh_files()<cr>", { desc = "Update stats and entries in the file list." } },
          -- Removed <leader>e to avoid conflicts with explorer group
          { "n", "<leader>b", "<cmd>lua require'diffview.actions'.toggle_files()<cr>", { desc = "Toggle the file panel." } },
          { "n", "g<C-x>", "<cmd>lua require'diffview.actions'.cycle_layout()<cr>", { desc = "Cycle through available layouts." } },
          { "n", "g?", "<cmd>DiffviewToggleHelp<cr>", { desc = "Open the help panel" } },
          { "n", "<leader>cO", "<Cmd>DiffviewClose<CR>", { desc = "Close diffview" } },
        },
        file_history_panel = {
          { "n", "g!", "<cmd>lua require'diffview.actions'.options()<cr>", { desc = "Open the option panel" } },
          { "n", "<C-A-d>", "<cmd>lua require'diffview.actions'.open_in_diffview()<cr>", { desc = "Open the entry under the cursor in a diffview" } },
          { "n", "y", "<cmd>lua require'diffview.actions'.copy_hash()<cr>", { desc = "Copy the commit hash of the entry under the cursor" } },
          { "n", "L", "<cmd>lua require'diffview.actions'.open_commit_log()<cr>", { desc = "Show commit details" } },
          { "n", "zR", "<cmd>lua require'diffview.actions'.open_all_folds()<cr>", { desc = "Expand all folds" } },
          { "n", "zM", "<cmd>lua require'diffview.actions'.close_all_folds()<cr>", { desc = "Collapse all folds" } },
          { "n", "j", "<cmd>lua require'diffview.actions'.next_entry()<cr>", { desc = "Bring the cursor to the next file entry" } },
          { "n", "<down>", "<cmd>lua require'diffview.actions'.next_entry()<cr>", { desc = "Bring the cursor to the next file entry" } },
          { "n", "k", "<cmd>lua require'diffview.actions'.prev_entry()<cr>", { desc = "Bring the cursor to the previous file entry." } },
          { "n", "<up>", "<cmd>lua require'diffview.actions'.prev_entry()<cr>", { desc = "Bring the cursor to the previous file entry." } },
          { "n", "<cr>", "<cmd>lua require'diffview.actions'.select_entry()<cr>", { desc = "Open the diff for the selected entry." } },
          { "n", "o", "<cmd>lua require'diffview.actions'.select_entry()<cr>", { desc = "Open the diff for the selected entry." } },
          { "n", "<2-LeftMouse>", "<cmd>lua require'diffview.actions'.select_entry()<cr>", { desc = "Open the diff for the selected entry." } },
          { "n", "<c-b>", "<cmd>lua require'diffview.actions'.scroll_view(-0.25)<cr>", { desc = "Scroll the view up" } },
          { "n", "<c-f>", "<cmd>lua require'diffview.actions'.scroll_view(0.25)<cr>", { desc = "Scroll the view down" } },
          { "n", "<tab>", "<cmd>lua require'diffview.actions'.select_next_entry()<cr>", { desc = "Open the diff for the next file" } },
          { "n", "<s-tab>", "<cmd>lua require'diffview.actions'.select_prev_entry()<cr>", { desc = "Open the diff for the previous file" } },
          { "n", "gf", "<cmd>lua require'diffview.actions'.goto_file()<cr>", { desc = "Open the file in the previous tabpage" } },
          { "n", "<C-w><C-f>", "<cmd>lua require'diffview.actions'.goto_file_split()<cr>", { desc = "Open the file in a new split" } },
          { "n", "<C-w>gf", "<cmd>lua require'diffview.actions'.goto_file_tab()<cr>", { desc = "Open the file in a new tabpage" } },
          -- Removed <leader>e to avoid conflicts with explorer group
          { "n", "<leader>b", "<cmd>lua require'diffview.actions'.toggle_files()<cr>", { desc = "Toggle the file panel." } },
          { "n", "g<C-x>", "<cmd>lua require'diffview.actions'.cycle_layout()<cr>", { desc = "Cycle through available layouts." } },
          { "n", "g?", "<cmd>DiffviewToggleHelp<cr>", { desc = "Open the help panel" } },
        },
        option_panel = {
          { "n", "<tab>", "<cmd>lua require'diffview.actions'.select_entry()<cr>", { desc = "Change the current option" } },
          { "n", "q", "<cmd>lua require'diffview.actions'.close()<cr>", { desc = "Close the panel" } },
          { "n", "g?", "<cmd>DiffviewToggleHelp<cr>", { desc = "Open the help panel" } },
        },
        help_panel = {
          { "n", "q", "<cmd>DiffviewToggleHelp<cr>", { desc = "Close help menu" } },
          { "n", "<esc>", "<cmd>DiffviewToggleHelp<cr>", { desc = "Close help menu" } },
        },
      },
    },
  },

  -- =============================================================================
  -- LAZYGIT INTEGRATION
  -- =============================================================================
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
      { "<leader>gG", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit Current File" },
      { "<leader>gF", "<cmd>LazyGitFilter<cr>", desc = "LazyGit Filter" },
      { "<leader>gf", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "LazyGit Filter Current File" },
    },
    config = function()
      vim.g.lazygit_floating_window_winblend = 0
      vim.g.lazygit_floating_window_scaling_factor = 0.9
      vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
      vim.g.lazygit_floating_window_use_plenary = 0
      vim.g.lazygit_use_neovim_remote = 1
      vim.g.lazygit_use_custom_config_file_path = 0
    end,
  },

  -- =============================================================================
  -- FUGITIVE - GIT WRAPPER
  -- =============================================================================
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit"
    },
    ft = { "fugitive" },
    keys = {
      { "<leader>gG", "<cmd>Git<cr>", desc = "Git Status" },
      { "<leader>gw", "<cmd>Gwrite<cr>", desc = "Git Write" },
      { "<leader>gr", "<cmd>Gread<cr>", desc = "Git Read" },
      { "<leader>gq", "<cmd>diffoff | q<cr>", desc = "Quit Diff" },
      {
        "<leader>gs",
        function()
          vim.cmd.Git()
          -- Close all other windows
          vim.cmd("only")
          vim.cmd("wincmd J")
          vim.api.nvim_win_set_height(0, 12)
        end,
        desc = "Git Status",
      },
    },
  },

  -- =============================================================================
  -- GIT WORKTREE
  -- =============================================================================
  {
    "ThePrimeagen/git-worktree.nvim",
    keys = {
      { "<leader>gwc", function() require("git-worktree").create_worktree() end, desc = "Create Worktree" },
      { "<leader>gws", function() require("git-worktree").switch_worktree() end, desc = "Switch Worktree" },
      { "<leader>gwd", function() require("git-worktree").delete_worktree() end, desc = "Delete Worktree" },
    },
    config = function()
      require("git-worktree").setup({
        change_directory_command = "cd",
        update_on_change = true,
        update_on_change_command = "e .",
        clearjumps_on_change = true,
        autopush = false,
      })
    end,
  },

  -- =============================================================================
  -- NEOGIT - MAGIT CLONE
  -- =============================================================================
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" },
      { "<leader>gN", "<cmd>Neogit kind=replace<cr>", desc = "Neogit Replace" },
    },
    opts = {
      graph_style = "ascii",
      git_services = {
        ["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
        ["bitbucket.org"] = "https://bitbucket.org/${owner}/${repository}/pull-requests/new?source=${branch_name}&t=1",
        ["gitlab.com"] = "https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
      },
      telescope_sorter = function()
        return require("telescope").extensions.fzf.native_fzf_sorter()
      end,
      remember_settings = true,
      use_per_project_settings = true,
      ignored_settings = {
        "NeogitPushPopup--force-with-lease",
        "NeogitPushPopup--force",
        "NeogitPullPopup--rebase",
        "NeogitCommitPopup--allow-empty",
        "NeogitRevertPopup--no-edit",
      },
      filewatcher = {
        interval = 1000,
        enabled = true,
      },
      integrations = {
        telescope = true,
        diffview = true,
        fzf_lua = nil,
      },
      sections = {
        sequencer = {
          folded = false,
          hidden = false,
        },
        untracked = {
          folded = false,
          hidden = false,
        },
        unstaged = {
          folded = false,
          hidden = false,
        },
        staged = {
          folded = false,
          hidden = false,
        },
        stashes = {
          folded = true,
          hidden = false,
        },
        unpulled_upstream = {
          folded = true,
          hidden = false,
        },
        unmerged_upstream = {
          folded = false,
          hidden = false,
        },
        unpulled_pushRemote = {
          folded = true,
          hidden = false,
        },
        unmerged_pushRemote = {
          folded = false,
          hidden = false,
        },
        recent = {
          folded = true,
          hidden = false,
        },
        rebase = {
          folded = true,
          hidden = false,
        },
      },
      mappings = {
        commit_editor = {
          ["q"] = "Close",
          ["<c-c><c-c>"] = "Submit",
          ["<c-c><c-k>"] = "Abort",
        },
        rebase_editor = {
          ["p"] = "Pick",
          ["r"] = "Reword",
          ["e"] = "Edit",
          ["s"] = "Squash",
          ["f"] = "Fixup",
          ["x"] = "Execute",
          ["d"] = "Drop",
          ["b"] = "Break",
          ["q"] = "Close",
          ["<cr>"] = "OpenCommit",
          ["gk"] = "MoveUp",
          ["gj"] = "MoveDown",
          ["<c-c><c-c>"] = "Submit",
          ["<c-c><c-k>"] = "Abort",
          ["[c"] = "OpenOrScrollUp",
          ["]c"] = "OpenOrScrollDown",
        },
        finder = {
          ["<cr>"] = "Select",
          ["<c-c>"] = "Close",
          ["<esc>"] = "Close",
          ["<c-n>"] = "Next",
          ["<c-p>"] = "Previous",
          ["<down>"] = "Next",
          ["<up>"] = "Previous",
          ["<tab>"] = "MultiselectToggleNext",
          ["<s-tab>"] = "MultiselectTogglePrevious",
          ["<c-j>"] = "NOP",
        },
        popup = {
          ["?"] = "HelpPopup",
          ["A"] = "CherryPickPopup",
          ["D"] = "DiffPopup",
          ["M"] = "RemotePopup",
          ["P"] = "PushPopup",
          ["X"] = "ResetPopup",
          ["Z"] = "StashPopup",
          ["b"] = "BranchPopup",
          ["c"] = "CommitPopup",
          ["f"] = "FetchPopup",
          ["l"] = "LogPopup",
          ["m"] = "MergePopup",
          ["p"] = "PullPopup",
          ["r"] = "RebasePopup",
          ["v"] = "RevertPopup",
          ["w"] = "WorktreePopup",
        },
        status = {
          ["q"] = "Close",
          ["I"] = "InitRepo",
          ["1"] = "Depth1",
          ["2"] = "Depth2",
          ["3"] = "Depth3",
          ["4"] = "Depth4",
          ["<tab>"] = "Toggle",
          ["x"] = "Discard",
          ["s"] = "Stage",
          ["S"] = "StageUnstaged",
          ["<c-s>"] = "StageAll",
          ["u"] = "Unstage",
          ["U"] = "UnstageStaged",
          ["$"] = "CommandHistory",
          ["Y"] = "YankSelected",
          ["<c-r>"] = "RefreshBuffer",
          ["<enter>"] = "GoToFile",
          ["<c-v>"] = "VSplitOpen",
          ["<c-x>"] = "SplitOpen",
          ["<c-t>"] = "TabOpen",
          ["{"] = "GoToPreviousHunkHeader",
          ["}"] = "GoToNextHunkHeader",
          ["[c"] = "OpenOrScrollUp",
          ["]c"] = "OpenOrScrollDown",
        },
      },
    },
  },

  -- =============================================================================
  -- GIT CONFLICT RESOLUTION
  -- =============================================================================
  {
    "akinsho/git-conflict.nvim",
    event = "BufReadPre",
    opts = {
      default_mappings = {
        ours = "co",
        theirs = "ct",
        none = "c0",
        both = "cb",
        next = "]x",
        prev = "[x",
      },
      default_commands = true,
      disable_diagnostics = false,
      list_opener = "copen",
      highlights = {
        incoming = "DiffAdd",
        current = "DiffText",
      }
    },
    keys = {
      { "<leader>gcb", "<cmd>GitConflictChooseBoth<cr>", desc = "Choose Both" },
      { "<leader>gcn", "<cmd>GitConflictNextConflict<cr>", desc = "Move to Next Conflict" },
      { "<leader>gco", "<cmd>GitConflictChooseOurs<cr>", desc = "Choose Ours" },
      { "<leader>gcp", "<cmd>GitConflictPrevConflict<cr>", desc = "Move to Previous Conflict" },
      { "<leader>gct", "<cmd>GitConflictChooseTheirs<cr>", desc = "Choose Theirs" },
    },
  },

  -- =============================================================================
  -- GITLINKER - GENERATE GIT LINKS
  -- =============================================================================
  {
    "ruifm/gitlinker.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      { "<leader>gy", desc = "Copy Git Link", mode = { "n", "v" } },
    },
    opts = {
      opts = {
        remote = nil,
        add_current_line_on_normal_mode = true,
        action_callback = function(url)
          local ok, actions = pcall(require, "gitlinker.actions")
          if ok then
            return actions.copy_to_clipboard(url)
          else
            -- Fallback to manual clipboard copy
            vim.fn.setreg("+", url)
            vim.notify("Copied to clipboard: " .. url)
          end
        end,
        print_url = true,
      },
      callbacks = function()
        local ok, hosts = pcall(require, "gitlinker.hosts")
        if ok then
          return {
            ["github.com"] = hosts.get_github_type_url,
            ["gitlab.com"] = hosts.get_gitlab_type_url,
            ["try.gitea.io"] = hosts.get_gitea_type_url,
            ["codeberg.org"] = hosts.get_gitea_type_url,
            ["bitbucket.org"] = hosts.get_bitbucket_type_url,
            ["try.gogs.io"] = hosts.get_gogs_type_url,
            ["git.sr.ht"] = hosts.get_srht_type_url,
            ["git.launchpad.net"] = hosts.get_launchpad_type_url,
            ["repo.or.cz"] = hosts.get_repoorcz_type_url,
            ["git.kernel.org"] = hosts.get_cgit_type_url,
            ["git.savannah.gnu.org"] = hosts.get_cgit_type_url,
          }
        else
          return {}
        end
      end,
      mappings = "<leader>gy",
    },
  },

  -- =============================================================================
  -- OCTO - GITHUB INTEGRATION
  -- =============================================================================
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    event = { { event = "BufReadCmd", pattern = "octo://*" } },
    opts = {
      use_local_fs = false,
      enable_builtin = true,
      default_remote = { "upstream", "origin" },
      default_merge_method = "commit",
      ssh_aliases = {},
      reaction_viewer_hint_icon = "",
      user_icon = " ",
      timeline_marker = "",
      timeline_indent = "2",
      right_bubble_delimiter = "",
      left_bubble_delimiter = "",
      github_hostname = "",
      snippet_context_lines = 4,
      gh_env = {},
      timeout = 5000,
      ui = {
        use_signcolumn = true,
        use_signstatus = true,
      },
      issues = {
        order_by = {
          field = "CREATED_AT",
          direction = "DESC",
        },
      },
      pull_requests = {
        order_by = {
          field = "CREATED_AT",
          direction = "DESC",
        },
        always_select_remote_on_create = false,
      },
      file_panel = {
        size = 10,
        use_icons = true,
      },
      mappings = {
        issue = {
          close_issue = { lhs = "<space>ic", desc = "close issue" },
          reopen_issue = { lhs = "<space>io", desc = "reopen issue" },
          list_issues = { lhs = "<space>il", desc = "list open issues on same repo" },
          reload = { lhs = "<C-r>", desc = "reload issue" },
          open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
          copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
          add_assignee = { lhs = "<space>aa", desc = "add assignee" },
          remove_assignee = { lhs = "<space>ad", desc = "remove assignee" },
          create_label = { lhs = "<space>lc", desc = "create label" },
          add_label = { lhs = "<space>la", desc = "add label" },
          remove_label = { lhs = "<space>ld", desc = "remove label" },
          goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
          add_comment = { lhs = "<space>ca", desc = "add comment" },
          delete_comment = { lhs = "<space>cd", desc = "delete comment" },
          next_comment = { lhs = "]c", desc = "go to next comment" },
          prev_comment = { lhs = "[c", desc = "go to previous comment" },
          react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
          react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
          react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
          react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
          react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
          react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
          react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
          react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
        },
        pull_request = {
          checkout_pr = { lhs = "<space>po", desc = "checkout PR" },
          merge_pr = { lhs = "<space>pm", desc = "merge commit PR" },
          squash_and_merge_pr = { lhs = "<space>psm", desc = "squash and merge PR" },
          list_commits = { lhs = "<space>pc", desc = "list PR commits" },
          list_changed_files = { lhs = "<space>pf", desc = "list PR changed files" },
          show_pr_diff = { lhs = "<space>pd", desc = "show PR diff" },
          add_reviewer = { lhs = "<space>va", desc = "add reviewer" },
          remove_reviewer = { lhs = "<space>vd", desc = "remove reviewer request" },
          close_issue = { lhs = "<space>ic", desc = "close PR" },
          reopen_issue = { lhs = "<space>io", desc = "reopen PR" },
          list_issues = { lhs = "<space>il", desc = "list open issues on same repo" },
          reload = { lhs = "<C-r>", desc = "reload PR" },
          open_in_browser = { lhs = "<C-b>", desc = "open PR in browser" },
          copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
          goto_file = { lhs = "gf", desc = "go to file" },
          add_assignee = { lhs = "<space>aa", desc = "add assignee" },
          remove_assignee = { lhs = "<space>ad", desc = "remove assignee" },
          create_label = { lhs = "<space>lc", desc = "create label" },
          add_label = { lhs = "<space>la", desc = "add label" },
          remove_label = { lhs = "<space>ld", desc = "remove label" },
          goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
          add_comment = { lhs = "<space>ca", desc = "add comment" },
          delete_comment = { lhs = "<space>cd", desc = "delete comment" },
          next_comment = { lhs = "]c", desc = "go to next comment" },
          prev_comment = { lhs = "[c", desc = "go to previous comment" },
          react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
          react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
          react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
          react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
          react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
          react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
          react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
          react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
        },
        review_thread = {
          goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
          add_comment = { lhs = "<space>ca", desc = "add comment" },
          add_suggestion = { lhs = "<space>sa", desc = "add suggestion" },
          delete_comment = { lhs = "<space>cd", desc = "delete comment" },
          next_comment = { lhs = "]c", desc = "go to next comment" },
          prev_comment = { lhs = "[c", desc = "go to previous comment" },
          select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
          react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
          react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
          react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
          react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
          react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
          react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
          react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
          react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
        },
        submit_win = {
          approve_review = { lhs = "<C-a>", desc = "approve review" },
          comment_review = { lhs = "<C-m>", desc = "comment review" },
          request_changes = { lhs = "<C-r>", desc = "request changes review" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
        },
        review_diff = {
          add_review_comment = { lhs = "<space>ca", desc = "add a new review comment" },
          add_review_suggestion = { lhs = "<space>sa", desc = "add a new review suggestion" },
          -- Removed <leader>e to avoid conflicts with explorer group
          toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
          next_thread = { lhs = "]t", desc = "move to next thread" },
          prev_thread = { lhs = "[t", desc = "move to previous thread" },
          select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
          toggle_viewed = { lhs = "<leader><space>", desc = "toggle viewer viewed state" },
          goto_file = { lhs = "gf", desc = "go to file" },
        },
        file_panel = {
          next_entry = { lhs = "j", desc = "move to next changed file" },
          prev_entry = { lhs = "k", desc = "move to previous changed file" },
          select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
          refresh_files = { lhs = "R", desc = "refresh changed files panel" },
          -- Removed <leader>e to avoid conflicts with explorer group
          toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
          select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
          toggle_viewed = { lhs = "<leader><space>", desc = "toggle viewer viewed state" },
        }
      },
    },
    keys = {
      { "<leader>gi", "<cmd>Octo issue list<cr>", desc = "List Issues (Octo)" },
      { "<leader>gI", "<cmd>Octo issue search<cr>", desc = "Search Issues (Octo)" },
      { "<leader>gp", "<cmd>Octo pr list<cr>", desc = "List PRs (Octo)" },
      { "<leader>gP", "<cmd>Octo pr search<cr>", desc = "Search PRs (Octo)" },
      { "<leader>gr", "<cmd>Octo repo list<cr>", desc = "List Repos (Octo)" },
      { "<leader>gS", "<cmd>Octo search<cr>", desc = "Search (Octo)" },
    },
  },
}

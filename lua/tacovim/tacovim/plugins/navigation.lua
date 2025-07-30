-- ~/.config/nvim/lua/tacovim/plugins/navigation.lua
-- TacoVim Navigation and File Management

return {
  -- =============================================================================
  -- TELESCOPE - FUZZY FINDER
  -- =============================================================================
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "nvim-telescope/telescope-dap.nvim",
      "nvim-telescope/telescope-project.nvim",
      "ahmedkhalf/project.nvim",
    },
    keys = {
      -- File searching
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fF", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find Files (Hidden)" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fG", "<cmd>Telescope grep_string<cr>", desc = "Grep String" },
      { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Find Word" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      
      -- Symbol searching (LSP-based)
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
      { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },
      { "<leader>fi", "<cmd>Telescope lsp_implementations<cr>", desc = "Implementations" },
      { "<leader>fd", "<cmd>Telescope lsp_definitions<cr>", desc = "Definitions" },
      { "<leader>fD", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Type Definitions" },
      { "<leader>fR", "<cmd>Telescope lsp_references<cr>", desc = "References" },
      
      -- Advanced searching
      { "<leader>f/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer Search" },
      { "<leader>f:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader>f;", "<cmd>Telescope search_history<cr>", desc = "Search History" },
      { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
      { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Marks" },
      { "<leader>fj", "<cmd>Telescope jumplist<cr>", desc = "Jump List" },
      { "<leader>fq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix" },
      { "<leader>fl", "<cmd>Telescope loclist<cr>", desc = "Location List" },
      
      -- Special searches
      { "<leader>fe", "<cmd>Telescope symbols<cr>", desc = "Emoji & Symbols" },
      { "<leader>fC", "<cmd>Telescope colorscheme<cr>", desc = "Colorschemes" },
      { "<leader>fH", "<cmd>Telescope highlights<cr>", desc = "Highlights" },
      { "<leader>fo", "<cmd>Telescope vim_options<cr>", desc = "Vim Options" },
      { "<leader>fA", "<cmd>Telescope autocommands<cr>", desc = "Autocommands" },
      
      -- Git integration
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
      { "<leader>gC", "<cmd>Telescope git_bcommits<cr>", desc = "Buffer Git Commits" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git Branches" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
      { "<leader>gf", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
      { "<leader>gS", "<cmd>Telescope git_stash<cr>", desc = "Git Stash" },
      
      -- Diagnostics and LSP
      { "<leader>xx", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Buffer Diagnostics" },
      { "<leader>xX", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
      
      -- Projects
      { "<leader>fp", "<cmd>Telescope projects<cr>", desc = "Projects" },
      
      -- Resume last search
      { "<leader>f.", "<cmd>Telescope resume<cr>", desc = "Resume Last Search" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local trouble_ok, trouble = pcall(require, "trouble.providers.telescope")

      telescope.setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          file_sorter = require("telescope.sorters").get_fuzzy_file,
          file_ignore_patterns = { 
            "^.git/", 
            "^.svn/", 
            "^.hg/", 
            "node_modules", 
            "%.o$", 
            "%.a$", 
            "%.out$", 
            "%.class$",
            "%.pdf$", 
            "%.mkv$", 
            "%.mp4$", 
            "%.zip$",
            "target/",
            "build/",
            "dist/",
          },
          generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
          path_display = { "truncate" },
          winblend = 0,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          use_less = true,
          set_env = { ["COLORTERM"] = "truecolor" },
          file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
          buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
          
          mappings = {
            i = {
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<Tab>"] = actions.move_selection_next,
              ["<S-Tab>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-l>"] = actions.complete_tag,
              ["<C-_>"] = actions.which_key,
              ["<C-w>"] = { "<c-s-w>", type = "command" },
              -- Trouble integration
              ["<c-t>"] = trouble_ok and trouble.open_with_trouble or actions.select_tab,
              ["<a-t>"] = trouble_ok and trouble.open_selected_with_trouble or actions.select_tab,
            },
            n = {
              ["<esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<Tab>"] = actions.move_selection_next,
              ["<S-Tab>"] = actions.move_selection_previous,
              ["<Up>"] = actions.move_selection_previous,
              ["<Down>"] = actions.move_selection_next,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
              ["?"] = actions.which_key,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              -- Trouble integration
              ["<c-t>"] = trouble_ok and trouble.open_with_trouble or actions.select_tab,
              ["<a-t>"] = trouble_ok and trouble.open_selected_with_trouble or actions.select_tab,
            },
          },
        },
        
        pickers = {
          find_files = {
            find_command = { "rg", "--files", "--iglob", "!.git", "--hidden" },
            previewer = false,
            theme = "dropdown",
          },
          git_files = {
            previewer = false,
            theme = "dropdown",
          },
          live_grep = {
            additional_args = function(opts)
              return { "--hidden" }
            end,
          },
          grep_string = {
            additional_args = function(opts)
              return { "--hidden" }
            end,
          },
          buffers = {
            theme = "dropdown",
            previewer = false,
            initial_mode = "normal",
            mappings = {
              i = {
                ["<C-d>"] = actions.delete_buffer,
              },
              n = {
                ["dd"] = actions.delete_buffer,
              },
            },
          },
          planets = {
            show_pluto = true,
            show_moon = true,
          },
          colorscheme = {
            enable_preview = true,
          },
          lsp_references = {
            theme = "dropdown",
            initial_mode = "normal",
          },
          lsp_definitions = {
            theme = "dropdown",
            initial_mode = "normal",
          },
          lsp_declarations = {
            theme = "dropdown",
            initial_mode = "normal",
          },
          lsp_implementations = {
            theme = "dropdown",
            initial_mode = "normal",
          },
        },
        
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          ["ui-select"] = {
            -- Use default configuration without themes initially
          },
          project = {
            base_dirs = {
              "~/Projects",
              vim.fn.expand("~"),
            },
            hidden_files = true,
            theme = "dropdown",
            order_by = "asc",
            search_by = "title",
            sync_with_nvim_tree = true,
          },
        },
      })

      -- Load extensions
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
      pcall(telescope.load_extension, "dap")
      pcall(telescope.load_extension, "projects")
      pcall(telescope.load_extension, "project")

      -- Custom pickers
      local function find_config_files()
        require("telescope.builtin").find_files({
          prompt_title = "Config Files",
          cwd = vim.fn.stdpath("config"),
          follow = true,
        })
      end

      local function find_plugin_files()
        require("telescope.builtin").find_files({
          prompt_title = "Plugin Files",
          cwd = vim.fn.stdpath("data") .. "/lazy",
          follow = true,
        })
      end

      vim.keymap.set("n", "<leader>fv", find_config_files, { desc = "Find Config Files" })
      vim.keymap.set("n", "<leader>fP", find_plugin_files, { desc = "Find Plugin Files" })
    end,
  },

  -- =============================================================================
  -- FZF NATIVE
  -- =============================================================================
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    enabled = vim.fn.executable("make") == 1,
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },

  -- =============================================================================
  -- PROJECT MANAGEMENT
  -- =============================================================================
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("project_nvim").setup({
        manual_mode = false,
        detection_methods = { "lsp", "pattern" },
        patterns = {
          ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json",
          "Cargo.toml", "go.mod", "pyproject.toml", "requirements.txt", "pom.xml",
          "build.gradle", "composer.json", ".vscode", ".idea", "tsconfig.json",
          "deno.json", "mod.ts", "deps.ts", "CMakeLists.txt", "build.zig",
          "flake.nix", "shell.nix", "mix.exs", "rebar.config", "stack.yaml",
          "cabal.config", "*.sln", "*.csproj", "gradlew", "mvnw"
        },
        show_hidden = false,
        silent_chdir = true,
        scope_chdir = "global",
        datapath = vim.fn.stdpath("data"),
      })
    end,
  },

  -- =============================================================================
  -- NEO-TREE - FILE EXPLORER
  -- =============================================================================
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
              -- Explorer keymaps moved to core keymaps for better organization
      { "<leader>ge", "<cmd>Neotree float git_status<cr>", desc = "Git Explorer" },
      { "<leader>be", "<cmd>Neotree toggle buffers right<cr>", desc = "Buffer Explorer" },
    },
    deactivate = function()
      -- Don't auto-close on deactivate
    end,
    init = function()
      if vim.fn.argc(-1) == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline", "dap-repl", "dapui_console", "dapui_watches", "dapui_stacks", "dapui_breakpoints", "dapui_scopes" },
      close_if_last_window = false, -- Don't close if it's the last window
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      sort_case_insensitive = false, -- Used when sorting files and directories in the tree
      sort_function = nil, -- Uses a custom function for sorting files and directories in the tree
      
      -- Prevent auto-close behavior
      retain_hidden_root_indent = false,
      default_source = "filesystem",
      
      -- Prevent auto-close when opening files
      event_handlers = {
        {
          event = "file_opened",
          handler = function(file_path)
            -- Neo-tree will stay open when opening files
          end
        },
      },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { 
          enabled = true,
          leave_dirs_open = true, -- Keep directories open
        },
        use_libuv_file_watcher = true,
        hijack_netrw_behavior = "open_default",
        

        
        -- Enhanced navigation
        group_empty_dirs = false,
        scan_mode = "deep",
        
        -- Search functionality
        find_by_full_path_words = false,
        find_command = "fd",
        find_args = {
          fd = {
            "--exclude", ".git",
            "--exclude", "node_modules"
          }
        },
        
        -- File filtering
        filtered_items = {
          visible = false,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_hidden = true,
          hide_by_name = {
            "node_modules",
            ".git",
            ".DS_Store",
            "thumbs.db",
            "__pycache__",
            ".pytest_cache",
            ".mypy_cache",
            ".vscode",
            ".idea",
            "*.pyc",
            "*.pyo",
            "*.pyd",
            ".Python",
            "env",
            "venv",
            ".env",
            ".venv",
            "ENV",
            "env.bak",
            "venv.bak"
          },
          hide_by_pattern = {
            "*.meta",
            "*/src/*/tsconfig.json",
            "*.tmp",
            "*.temp",
          },
          always_show = {
            ".gitignore",
            ".gitkeep",
            ".env.example",
            ".env.local",
            ".env.development",
            ".env.production",
          },
          never_show = {
            ".DS_Store",
            "thumbs.db",
            ".git",
          },
          never_show_by_pattern = {
            ".null-ls_*",
          },
        },
        
        -- Keep filesystem simple and working
        commands = {},
      },
      window = {
        position = "left",
        width = 40,
        auto_expand_width = false,
        same_level = false,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ["<space>"] = {
            "toggle_node",
            nowait = false,
          },
          ["<2-LeftMouse>"] = "open",
          ["<cr>"] = "open",
          ["<esc>"] = "cancel",
          ["o"] = "open",
          ["P"] = { "toggle_preview", config = { use_float = true } },
          ["l"] = "focus_preview",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["t"] = "open_tabnew",
          ["w"] = "open_with_window_picker",
          ["C"] = "close_node",
          ["z"] = "close_all_nodes",
          
          -- File operations (only basic ones)
          ["a"] = {
            "add",
            config = {
              show_path = "none",
            },
          },
          ["A"] = "add_directory",
          ["d"] = "delete",
          ["r"] = "rename",
          
          -- Basic navigation (j/k work normally for cursor movement)
          ["h"] = "close_node",
          ["l"] = "open",
          
          -- Directory navigation
          ["<BS>"] = "navigate_up",     -- Backspace to go up
          
          -- Window and view management
          ["q"] = "close_window",
          ["R"] = "refresh",
          ["?"] = "show_help",
          ["<"] = "prev_source",
          [">"] = "next_source",
        },
      },
      default_component_configs = {
        container = {
          enable_character_fade = true,
        },
        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          highlight = "NeoTreeIndentMarker",
          with_expanders = nil,
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "󰜌",
          default = "*",
          highlight = "NeoTreeFileIcon",
        },
        modified = {
          symbol = "[+]",
          highlight = "NeoTreeModified",
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = "NeoTreeFileName",
        },
        git_status = {
          symbols = {
            added = "",
            modified = "",
            deleted = "✖",
            renamed = "󰁕",
            untracked = "",
            ignored = "",
            unstaged = "󰄱",
            staged = "",
            conflict = "",
          },
        },
        file_size = {
          enabled = true,
          required_width = 64,
        },
        type = {
          enabled = true,
          required_width = 122,
        },
        last_modified = {
          enabled = true,
          required_width = 88,
        },
        created = {
          enabled = true,
          required_width = 110,
        },
        symlink_target = {
          enabled = false,
        },
      },
      commands = {},
      event_handlers = {
        {
          event = "file_opened",
          handler = function(file_path)
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
      },
    },
    config = function(_, opts)
      local function on_move(data)
        require("neo-tree.utils").rename_and_reload(data.source, data.destination)
      end

      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    end,
  },

  -- =============================================================================
  -- AERIAL - SYMBOL OUTLINE
  -- =============================================================================
  {
    "stevearc/aerial.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    keys = {
      { "<leader>cs", "<cmd>AerialToggle<cr>", desc = "Symbol Outline" },
      { "<leader>cS", "<cmd>AerialOpen<cr>", desc = "Open Outline" },
      { "<leader>cn", "<cmd>AerialNext<cr>", desc = "Next Symbol" },
      { "<leader>cp", "<cmd>AerialPrev<cr>", desc = "Prev Symbol" },
    },
    opts = {
      backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },
      layout = {
        max_width = { 40, 0.2 },
        width = nil,
        min_width = 10,
        win_opts = {},
        default_direction = "prefer_right",
        placement = "window",
        preserve_equality = false,
      },
      attach_mode = "window",
      close_automatic_events = {},
      keymaps = {
        ["?"] = "actions.show_help",
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.jump",
        ["<2-LeftMouse>"] = "actions.jump",
        ["<C-v>"] = "actions.jump_vsplit",
        ["<C-s>"] = "actions.jump_split",
        ["p"] = "actions.scroll",
        ["<C-j>"] = "actions.down_and_scroll",
        ["<C-k>"] = "actions.up_and_scroll",
        ["{"] = "actions.prev",
        ["}"] = "actions.next",
        ["[["] = "actions.prev_up",
        ["]]"] = "actions.next_up",
        ["q"] = "actions.close",
        ["o"] = "actions.tree_toggle",
        ["za"] = "actions.tree_toggle",
        ["O"] = "actions.tree_toggle_recursive",
        ["zA"] = "actions.tree_toggle_recursive",
        ["l"] = "actions.tree_open",
        ["zo"] = "actions.tree_open",
        ["L"] = "actions.tree_open_recursive",
        ["zO"] = "actions.tree_open_recursive",
        ["h"] = "actions.tree_close",
        ["zc"] = "actions.tree_close",
        ["H"] = "actions.tree_close_recursive",
        ["zC"] = "actions.tree_close_recursive",
        ["zr"] = "actions.tree_increase_fold_level",
        ["zR"] = "actions.tree_open_all",
        ["zm"] = "actions.tree_decrease_fold_level",
        ["zM"] = "actions.tree_close_all",
        ["zx"] = "actions.tree_sync_folds",
        ["zX"] = "actions.tree_sync_folds",
      },
      lazy_load = true,
      disable_max_lines = 10000,
      disable_max_size = 2000000,
      filter_kind = {
        "Class",
        "Constructor",
        "Enum",
        "Function",
        "Interface",
        "Module",
        "Method",
        "Struct",
      },
      highlight_mode = "split_width",
      highlight_closest = true,
      highlight_on_hover = false,
      highlight_on_jump = 300,
      autojump = false,
      icons = {},
      ignore = {
        unlisted_buffers = false,
        diff_windows = true,
        filetypes = {},
        buftypes = "special",
        wintypes = "special",
      },
      manage_folds = false,
      link_folds_to_tree = false,
      link_tree_to_folds = true,
      nerd_font = "auto",
      on_attach = function(bufnr)
        vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
      end,
      on_first_symbols = function(bufnr)
        -- Auto-open aerial if there are symbols
      end,
      open_automatic = function(bufnr)
        return false
      end,
      post_jump_cmd = "normal! zz",
      close_on_select = false,
      update_events = "TextChanged,InsertLeave",
      show_guides = false,
      float = {
        border = "rounded",
        relative = "cursor",
        max_height = 0.9,
        height = nil,
        min_height = { 8, 0.1 },
        override = function(conf, source_winid)
          return conf
        end,
      },
      lsp = {
        diagnostics_trigger_update = true,
        update_when_errors = true,
        update_delay = 300,
        priority = {
          pyright = 10,
        },
      },
      treesitter = {
        update_delay = 300,
      },
      markdown = {
        update_delay = 300,
      },
      asciidoc = {
        update_delay = 300,
      },
      man = {
        update_delay = 300,
      },
    },
  },

  -- Harpoon has been removed to clean up the keymap interface

  -- =============================================================================
  -- OIL - FILE BROWSER
  -- =============================================================================
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
      { "<leader>-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
    opts = {
      columns = {
        "icon",
        "permissions",
        "size",
        "mtime",
      },
      buf_options = {
        buflisted = false,
        bufhidden = "hide",
      },
      win_options = {
        wrap = false,
        signcolumn = "no",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
      },
      default_file_explorer = false,
      restore_win_options = true,
      skip_confirm_for_simple_edits = false,
      delete_to_trash = false,
      trash_command = "trash-put",
      prompt_save_on_select_new_entry = true,
      cleanup_delay_ms = 2000,
      lsp_file_methods = {
        timeout_ms = 1000,
        autosave_changes = false,
      },
      constrain_cursor = "editable",
      watch_for_changes = false,
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = "actions.select_vsplit",
        ["<C-h>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },
      use_default_keymaps = true,
      view_options = {
        show_hidden = false,
        is_hidden_file = function(name, bufnr)
          return vim.startswith(name, ".")
        end,
        is_always_hidden = function(name, bufnr)
          return false
        end,
        natural_order = true,
        sort = {
          { "type", "asc" },
          { "name", "asc" },
        },
      },
      float = {
        padding = 2,
        max_width = 0,
        max_height = 0,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
        override = function(conf)
          return conf
        end,
      },
      preview = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = 0.9,
        min_height = { 5, 0.1 },
        height = nil,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
        update_on_cursor_moved = true,
      },
      progress = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = { 10, 0.9 },
        min_height = { 5, 0.1 },
        height = nil,
        border = "rounded",
        minimized_border = "none",
        win_options = {
          winblend = 0,
        },
      },
      ssh = {
        border = "rounded",
      },
    },
  },

  -- =============================================================================
  -- PERSISTENCE - SESSION MANAGEMENT
  -- =============================================================================
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      options = vim.opt.sessionoptions:get(),
      pre_save = nil,
      save_empty = false,
    },
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },
}

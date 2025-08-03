-- ~/.config/nvim/init.lua
-- TacoVim - Professional Full-Stack Development IDE
-- A comprehensive Neovim configuration for modern development

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enhanced basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"
vim.opt.backspace = "indent,eol,start"
vim.opt.clipboard = "unnamedplus"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300
vim.opt.conceallevel = 2
vim.opt.fillchars = { eob = " ", fold = " ", foldopen = "▾", foldsep = " ", foldclose = "▸" }
vim.opt.laststatus = 3
vim.opt.showtabline = 2
vim.opt.cmdheight = 1
vim.opt.pumheight = 10
vim.opt.pumwidth = 30
vim.opt.winminwidth = 5
vim.opt.winminheight = 1
vim.opt.equalalways = false
vim.opt.shortmess:append("c")
vim.opt.shortmess:append("I")
vim.opt.iskeyword:append("-")
vim.opt.formatoptions:remove({ "c", "r", "o" })
vim.opt.mouse = "a"
vim.opt.mousemoveevent = true
vim.opt.splitkeep = "screen"
vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- Suppress some error messages
vim.opt.errorformat:prepend("%f:%l:%c: %m")
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Initialize global modules
_G.TacoVim = {
  ProjectManager = {},
  BuildSystem = {},
  ThemeManager = {},
  SessionManager = {},
  Utilities = {},
}

-- Plugin specifications
local plugins = {
  -- Color schemes
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = false,
      term_colors = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        treesitter = true,
        which_key = true,
        mason = true,
        noice = true,
        notify = true,
        mini = true,
        neotree = true,
        dap = true,
        dap_ui = true,
        native_lsp = { enabled = true, virtual_text = { errors = { "italic" }, hints = { "italic" }, warnings = { "italic" }, information = { "italic" } } },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Additional premium themes
  { "folke/tokyonight.nvim",       lazy = true },
  { "rebelot/kanagawa.nvim",       lazy = true },
  { "rose-pine/neovim",            name = "rose-pine", lazy = true },
  { "EdenEast/nightfox.nvim",      lazy = true },
  { "sainnhe/gruvbox-material",    lazy = true },
  { "sainnhe/everforest",          lazy = true },
  { "Mofiqul/dracula.nvim",        lazy = true },
  { "ellisonleao/gruvbox.nvim",    lazy = true },
  { "navarasu/onedark.nvim",       lazy = true },
  { "shaunsingh/nord.nvim",        lazy = true },
  { "marko-cerovac/material.nvim", lazy = true },
  { "bluz71/vim-nightfly-colors",  lazy = true },

  -- Icons and UI
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "MunifTanjim/nui.nvim",        lazy = true },

  -- Enhanced Dashboard
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        "                                                                     ",
        "                                ░░░░░▒░░                             ",
        "                           ░░░░░░░░░░░▒▒▒░░ ░░                        ",
        "                        ░░▒▒▒░▒▒  ░▓▒▓▓▒░░▒▓▒░ ░░                     ",
        "                      ░░░ ░░▒▓▓▒▒▒▒▓▓▓▒░░░░░░░░░░░░░                  ",
        "                    ░▒▓▓▒▒▒▒▒▓▓▓█▓▓▓░░░▒░░░░░░░░░░░░░░░               ",
        "                   ░▒▒▓▓▒▒▓▓░▒▒▒▒▒░▒░░░░░░░░░░░░▒▒▒░░░░░░░            ",
        "                  ░░▒▒▓▓▓▓██▓▓▒░░░░░░░░░░░░░░░░▒░░░░░░░░              ",
        "                  ▒▓▓▓██▓▓▓▓▒░░░░░░░░░░░░░░▒░░░░░░░                   ",
        "                 ░▒▓█▓▓▓█▓░▒░░░░▒░▒░░░▒░░░░░░                         ",
        "                ░▒▓▓▓▓██▓▒░░░░░░░░▒░░░░░░░                            ",
        "                ░▓▒▓██▓░░░░░░░░░░░░                                   ",
        "                 ▒▓▓▓░░░▒░░░                                          ",
        "                  ░▒░                                                 ",
        "                                                                     ",
        "      🌮 ████████╗ █████╗  ██████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ 🌮        ",
        "         ╚══██╔══╝██╔══██╗██╔════╝██╔═══██╗██║   ██║██║████╗ ████║             ",
        "            ██║   ███████║██║     ██║   ██║██║   ██║██║██╔████╔██║             ",
        "            ██║   ██╔══██║██║     ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║             ",
        "            ██║   ██║  ██║╚██████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║             ",
        "            ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝             ",
        "                                                                     ",
        "            🚀 Professional Full-Stack Development IDE 🚀           ",
        "                                                                     ",
      }

      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", "<cmd>Telescope find_files<CR>"),
        dashboard.button("n", "  New file", "<cmd>ene <BAR> startinsert<CR>"),
        dashboard.button("p", "  New project", "<cmd>lua TacoVim.ProjectManager.create_project()<CR>"),
        dashboard.button("r", "  Recent files", "<cmd>Telescope oldfiles<CR>"),
        dashboard.button("s", "  Find text", "<cmd>Telescope live_grep<CR>"),
        dashboard.button("g", "  Git status", "<cmd>Telescope git_status<CR>"),
        dashboard.button("l", "  Load session", "<cmd>lua TacoVim.SessionManager.load_session()<CR>"),
        dashboard.button("t", "  Themes", "<cmd>lua TacoVim.ThemeManager.switch_theme()<CR>"),
        dashboard.button("c", "  Configuration", "<cmd>e $MYVIMRC<CR>"),
        dashboard.button("u", "  Update plugins", "<cmd>Lazy update<CR>"),
        dashboard.button("m", "  Mason", "<cmd>Mason<CR>"),
        dashboard.button("h", "  Health check", "<cmd>checkhealth<CR>"),
        dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
      }

      local function footer()
        local total_plugins = #vim.tbl_keys(require("lazy").plugins())
        local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
        local version = vim.version()
        return "⚡ TacoVim loaded " .. total_plugins .. " plugins" .. datetime ..
            "\n🎯 Neovim v" .. version.major .. "." .. version.minor .. "." .. version.patch
      end

      dashboard.section.footer.val = footer()
      alpha.setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          dashboard.section.footer.val = footer()
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },

  -- Session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
    },
  },

  -- Project management
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
          "deno.json", "mod.ts", "deps.ts", "CMakeLists.txt"
        },
        show_hidden = false,
        silent_chdir = true,
        scope_chdir = 'global',
      })
    end,
  },

  -- Enhanced file explorer
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
      { "<leader>e",  "<cmd>Neotree toggle<cr>",               desc = "Explorer" },
      { "<leader>E",  "<cmd>Neotree focus<cr>",                desc = "Focus explorer" },
      { "<leader>ge", "<cmd>Neotree float git_status<cr>",     desc = "Git explorer" },
      { "<leader>be", "<cmd>Neotree toggle buffers right<cr>", desc = "Buffer explorer" },
    },
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      window = {
        position = "left",
        width = 35,
      },
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = true,
          hide_gitignored = true,
          hide_hidden = true,
          hide_by_name = { "node_modules", ".git", ".DS_Store", "build" },
          never_show = { ".DS_Store", "thumbs.db" },
        },
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
    },
  },

  -- Enhanced fuzzy finder with symbol search
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "nvim-telescope/telescope-dap.nvim",
    },
    keys = {
      -- File searching
      { "<leader>ff", "<cmd>Telescope find_files<cr>",                desc = "Find files" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                  desc = "Recent files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",                 desc = "Live grep" },
      { "<leader>fw", "<cmd>Telescope grep_string<cr>",               desc = "Find word under cursor" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",                   desc = "Buffers" },

      -- Symbol searching (LSP-based)
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>",      desc = "Document symbols" },
      { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>",     desc = "Workspace symbols" },
      { "<leader>fi", "<cmd>Telescope lsp_implementations<cr>",       desc = "Implementations" },
      { "<leader>fd", "<cmd>Telescope lsp_definitions<cr>",           desc = "Definitions" },
      { "<leader>fD", "<cmd>Telescope lsp_type_definitions<cr>",      desc = "Type definitions" },
      { "<leader>fR", "<cmd>Telescope lsp_references<cr>",            desc = "References" },

      -- Advanced searching
      { "<leader>f/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in current buffer" },
      { "<leader>f:", "<cmd>Telescope command_history<cr>",           desc = "Command history" },
      { "<leader>f;", "<cmd>Telescope search_history<cr>",            desc = "Search history" },
      { "<leader>fc", "<cmd>Telescope commands<cr>",                  desc = "Commands" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>",                   desc = "Keymaps" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",                 desc = "Help tags" },
      { "<leader>fm", "<cmd>Telescope marks<cr>",                     desc = "Marks" },
      { "<leader>fj", "<cmd>Telescope jumplist<cr>",                  desc = "Jump list" },
      { "<leader>fq", "<cmd>Telescope quickfix<cr>",                  desc = "Quickfix" },
      { "<leader>fl", "<cmd>Telescope loclist<cr>",                   desc = "Location list" },

      -- Symbols & emojis
      { "<leader>fe", "<cmd>Telescope symbols<cr>",                   desc = "Emoji & symbols" },

      -- Git integration
      { "<leader>gc", "<cmd>Telescope git_commits<cr>",               desc = "Git commits" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>",              desc = "Git branches" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>",                desc = "Git status" },
      { "<leader>gf", "<cmd>Telescope git_files<cr>",                 desc = "Git files" },

      -- Diagnostics
      { "<leader>fx", "<cmd>Telescope diagnostics<cr>",               desc = "Diagnostics" },

      -- Projects
      { "<leader>fp", "<cmd>Telescope projects<cr>",                  desc = "Projects" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "truncate" },
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55, results_width = 0.8 },
            vertical = { mirror = false },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          mappings = {
            i = {
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<Tab>"] = actions.move_selection_next,
              ["<S-Tab>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            },
            n = {
              ["<esc>"] = actions.close,
              ["q"] = actions.close,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            file_ignore_patterns = { "node_modules", ".git", "build", "target" }
          },
          live_grep = {
            additional_args = function() return { "--hidden" } end
          },
          buffers = {
            show_all_buffers = true,
            sort_lastused = true,
            mappings = {
              i = { ["<c-d>"] = actions.delete_buffer },
              n = { ["dd"] = actions.delete_buffer },
            },
          },
          colorscheme = { enable_preview = true },
          lsp_references = {
            show_line = false,
            include_declaration = false,
          },
          lsp_document_symbols = {
            symbol_width = 50,
          },
          lsp_workspace_symbols = {
            symbol_width = 50,
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
            require("telescope.themes").get_dropdown({})
          },
        },
      })

      -- Load extensions
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
      pcall(telescope.load_extension, "dap")
      pcall(telescope.load_extension, "projects")
    end,
  },

  -- FZF native for better performance
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },

  -- UI select replacement
  {
    "stevearc/dressing.nvim",
    config = function()
      require("dressing").setup {
        input = { enabled = true },
        select = { enabled = true, backend = { "telescope", "builtin" } },
      }
    end,
  },

  -- Advanced symbol navigation
  {
    "stevearc/aerial.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>cs", "<cmd>AerialToggle<cr>", desc = "🗂️ Symbol Outline" },
      { "<leader>cS", "<cmd>AerialOpen<cr>", desc = "🗂️ Open Outline" },
      { "<leader>cn", "<cmd>AerialNext<cr>", desc = "⬇️ Next Symbol" },
      { "<leader>cp", "<cmd>AerialPrev<cr>", desc = "⬆️ Prev Symbol" },
    },
    opts = {
      backends = { "treesitter", "lsp", "markdown", "man" },
      layout = {
        max_width = { 40, 0.3 },
        width = nil,
        min_width = 20,
        win_opts = {},
        default_direction = "prefer_right",
        placement = "window",
      },
      show_guides = true,
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
      guides = {
        mid_item = "├─",
        last_item = "└─",
        nested_top = "│ ",
        whitespace = "  ",
      },
    },
  },

  {
    "kosayoda/nvim-lightbulb",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      priority = 10,
      hide_in_unfocused_buffer = true,
      link_highlights = true,
      validate_config = 'auto',
      action_kinds = nil,
      sign = {
        enabled = true,
        text = "💡",
        hl = "LightBulbSign",
      },
      virtual_text = {
        enabled = false,
        text = "💡",
        pos = "eol",
        hl = "LightBulbVirtualText",
        hl_mode = "replace",
      },
      float = {
        enabled = false,
        text = "💡",
        hl = "LightBulbFloatText",
        win_opts = {},
      },
      status_text = {
        enabled = false,
        text = "💡",
        text_unavailable = ""
      },
      number = {
        enabled = false,
        hl = "LightBulbNumber",
      },
      line = {
        enabled = false,
        hl = "LightBulbLine",
      },
      autocmd = {
        enabled = true,
        updatetime = 200,
        events = { "CursorHold", "CursorHoldI" },
        pattern = { "*" },
      },
      ignore = {
        clients = {},
        ft = {},
        actions_without_kind = false,
      },
    },
  },

  -- Enhanced bookmarks & marks
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>mb", "<cmd>MarksToggleSigns<cr>", desc = "📚 Toggle bookmark signs" },
      { "<leader>ml", "<cmd>MarksListBuf<cr>", desc = "📋 List buffer bookmarks" },
      { "<leader>mL", "<cmd>MarksListGlobal<cr>", desc = "🌍 List global bookmarks" },
      { "<leader>md", "<cmd>DelMarks!<cr>", desc = "🗑️ Delete all marks" },
    },
    opts = {
      default_mappings = true,
      cyclic = true,
      force_write_shada = false,
      refresh_interval = 250,
      sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
      excluded_filetypes = {
        "qf",
        "NvimTree",
        "toggleterm",
        "TelescopePrompt",
        "alpha",
        "netrw",
        "neo-tree",
      },
      bookmark_0 = {
        sign = "⚑",
        virt_text = "hello world",
        annotate = false,
      },
      mappings = {
        toggle = "mm",
        next = "m]",
        prev = "m[",
        preview = "m:",
        delete = "dm",
        delete_line = "dm-",
        delete_buf = "dm<space>",
      }
    },
  },

  -- Enhanced multi-cursor & selection
  {
    "mg979/vim-visual-multi",
    keys = {
      { "<C-n>", mode = { "n", "v" }, desc = "🎪 Select next occurrence" },
      { "<C-Down>", mode = { "n", "v" }, desc = "🎪 Create cursor below" },
      { "<C-Up>", mode = { "n", "v" }, desc = "🎪 Create cursor above" },
    },
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = '<C-n>',
        ["Find Subword Under"] = '<C-n>',
        ["Select Cursor Down"] = '<C-Down>',
        ["Select Cursor Up"] = '<C-Up>',
        ["Add Cursor Down"] = '<C-j>',
        ["Add Cursor Up"] = '<C-k>',
      }
      vim.g.VM_set_statusline = 0
      vim.g.VM_silent_exit = 1
    end,
  },

  -- Enhanced indentation & alignment
  {
    "echasnovski/mini.align",
    version = "*",
    keys = {
      { "ga", mode = { "n", "v" }, desc = "🎯 Align" },
      { "gA", mode = { "n", "v" }, desc = "🎯 Align with preview" },
    },
    config = function()
      require('mini.align').setup()
    end,
  },

  -- Enhanced search & replace
  {
    "windwp/nvim-spectre",
    build = false,
    cmd = "Spectre",
    keys = {
      { "<leader>sr", function() require("spectre").toggle() end, desc = "🔍 Replace in files (Spectre)" },
      { "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end, desc = "🔍 Search current word", mode = "v" },
      { "<leader>sf", function() require("spectre").open_file_search({ select_word = true }) end, desc = "🔍 Search on current file" },
    },
    opts = {
      color_devicons = true,
      open_cmd       = 'vnew',
      live_update    = false,
      line_sep_start = '┌-----------------------------------------',
      result_padding = '¦  ',
      line_sep       = '└-----------------------------------------',
      highlight      = {
        ui = "String",
        search = "DiffChange",
        replace = "DiffDelete"
      },
      mapping        = {
        ['toggle_line'] = {
          map = "dd",
          cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
          desc = "toggle current item"
        },
        ['enter_file'] = {
          map = "<cr>",
          cmd = "<cmd>lua require('spectre').enter_file()<CR>",
          desc = "goto current file"
        },
        ['send_to_qf'] = {
          map = "<leader>q",
          cmd = "<cmd>lua require('spectre').send_to_qf()<CR>",
          desc = "send all item to quickfix"
        },
        ['replace_cmd'] = {
          map = "<leader>c",
          cmd = "<cmd>lua require('spectre').replace_cmd()<CR>",
          desc = "input replace vim command"
        },
        ['show_option_menu'] = {
          map = "<leader>o",
          cmd = "<cmd>lua require('spectre').show_options()<CR>",
          desc = "show option"
        },
        ['run_current_replace'] = {
          map = "<leader>rc",
          cmd = "<cmd>lua require('spectre').run_current_replace()<CR>",
          desc = "replace current line"
        },
        ['run_replace'] = {
          map = "<leader>R",
          cmd = "<cmd>lua require('spectre').run_replace()<CR>",
          desc = "replace all"
        },
        ['change_view_mode'] = {
          map = "<leader>v",
          cmd = "<cmd>lua require('spectre').change_view()<CR>",
          desc = "change result view mode"
        },
      },
    },
  },

  -- LSP Configuration
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        width = 0.8,
        height = 0.9,
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls", "pyright", "ts_ls", "html", "cssls", "jsonls", "yamlls",
        "rust_analyzer", "gopls", "clangd", "bashls", "dockerls",
        "vimls", "marksman", "tailwindcss", "emmet_ls",
        "jdtls", "omnisharp", "zls", "elixirls",
      },
      automatic_installation = true,
    },
  },

  -- Fixed LSP configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "mason-lspconfig.nvim",
      "cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      local capabilities = cmp_nvim_lsp.default_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      local function setup_server(server_name)
        local opts = { capabilities = capabilities }

        if server_name == "lua_ls" then
          opts.settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
              format = { enable = false },
            },
          }
        elseif server_name == "clangd" then
          opts.cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          }
        end

        pcall(function()
          lspconfig[server_name].setup(opts)
        end)
      end

      pcall(function()
        mason_lspconfig.setup_handlers({ setup_server })
      end)

      -- Enhanced diagnostics
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          source = "if_many",
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
        },
      })

      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end
    end,
  },

  -- Enhanced Rust support
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = {
        tools = {
          hover_actions = {
            auto_focus = true,
          },
        },
        server = {
          on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, silent = true }
            vim.keymap.set("n", "<leader>rr", "<cmd>RustLsp runnables<cr>",
              vim.tbl_extend("force", opts, { desc = "Rust Runnables" }))
            vim.keymap.set("n", "<leader>rd", "<cmd>RustLsp debuggables<cr>",
              vim.tbl_extend("force", opts, { desc = "Rust Debuggables" }))
            vim.keymap.set("n", "<leader>rt", "<cmd>RustLsp testables<cr>",
              vim.tbl_extend("force", opts, { desc = "Rust Testables" }))
            vim.keymap.set("n", "<leader>re", "<cmd>RustLsp expandMacro<cr>",
              vim.tbl_extend("force", opts, { desc = "Expand Macro" }))
            vim.keymap.set("n", "<leader>rc", "<cmd>RustLsp openCargo<cr>",
              vim.tbl_extend("force", opts, { desc = "Open Cargo.toml" }))
            vim.keymap.set("n", "<leader>rh", "<cmd>RustLsp hover actions<cr>",
              vim.tbl_extend("force", opts, { desc = "Hover Actions" }))
            vim.keymap.set("n", "K", "<cmd>RustLsp hover actions<cr>", opts)
          end,
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = { command = "clippy" },
              procMacro = { enable = true },
              cargo = { loadOutDirsFromCheck = true },
            },
          },
        },
      }
    end,
  },

  -- Enhanced autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
      "windwp/nvim-autopairs",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            before = function(entry, vim_item)
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
                nvim_lua = "[Lua]",
              })[entry.source.name]
              return vim_item
            end,
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip",  priority = 750 },
          { name = "nvim_lua", priority = 500 },
        }, {
          { name = "buffer", priority = 250 },
          { name = "path",   priority = 250 },
        }),
        experimental = { ghost_text = { hl_group = "LspCodeLens" } },
      })

      -- Autopairs integration
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Enhanced Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      ensure_installed = {
        "lua", "vim", "vimdoc", "query", "python", "javascript", "typescript",
        "html", "css", "json", "markdown", "bash", "rust", "go", "c", "cpp",
        "java", "php", "ruby", "yaml", "toml", "dockerfile", "tsx",
        "svelte", "astro", "prisma", "graphql", "sql", "regex", "comment",
        "jsdoc", "scss", "vue", "dart", "kotlin", "zig", "cmake",
        "c_sharp", "elixir", "clojure", "julia",
        "scala", "ocaml", "erlang", "nix", "terraform", "make"
      },
      sync_install = false,
      auto_install = true,
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- Enhanced status line (FIXED)
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "catppuccin",
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "neo-tree" } },
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          {
            "diff",
            symbols = { added = " ", modified = " ", removed = " " },
          },
        },
        lualine_c = {
          {
            "diagnostics",
            symbols = { error = " ", warn = " ", info = " ", hint = "󰠠 " },
          },
          { "filetype", icon_only = true, separator = "",                                            padding = { left = 1, right = 0 } },
          { "filename", path = 1,         symbols = { modified = "  ", readonly = "", unnamed = "" } },
        },
        lualine_x = {
          {
            function()
              local msg = "No LSP"
              local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
              local clients = vim.lsp.get_clients({ bufnr = 0 })
              if next(clients) == nil then return msg end
              for _, client in ipairs(clients) do
                local filetypes = client.config.filetypes
                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                  return client.name
                end
              end
              return msg
            end,
            icon = " LSP:",
            color = { fg = "#ffffff", gui = "bold" },
          },
          { "encoding" },
          { "fileformat" },
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "neo-tree", "lazy", "toggleterm", "mason" },
    },
  },

  -- Enhanced buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",            desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
      { "<Tab>",      "<cmd>BufferLineCycleNext<cr>",            desc = "Next buffer" },
      { "<S-Tab>",    "<cmd>BufferLineCyclePrev<cr>",            desc = "Prev buffer" },
      { "<leader>bd", "<cmd>bdelete<cr>",                        desc = "Delete buffer" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>",          desc = "Close other buffers" },
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = { Error = " ", Warn = " ", Info = " " }
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
              .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    },
  },

  -- WORKING Which-key configuration (re-enable after core is stable)
  {
    "folke/which-key.nvim",
    enabled = true, -- Re-enable when ready
    event = "VeryLazy",
    version = "^1.0.0", -- Pin to v1 for stability
    config = function()
      local wk = require("which-key")
      
      wk.setup({
        plugins = {
          marks = true,
          registers = true,
          spelling = { enabled = true, suggestions = 20 },
          presets = {
            operators = false,
            motions = false,
            text_objects = false,
            windows = true,
            nav = true,
            z = true,
            g = true,
          },
        },
        window = {
          border = "rounded",
          position = "bottom",
          margin = { 1, 0, 1, 0 },
          padding = { 2, 2, 2, 2 },
        },
        layout = {
          height = { min = 4, max = 25 },
          width = { min = 20, max = 50 },
          spacing = 3,
          align = "left",
        },
        ignore_missing = true,
        show_help = false,
      })

      -- Register groups using v1 API
      wk.register({
        ["<leader>b"] = { name = "buffer" },
        ["<leader>c"] = { name = "code" },
        ["<leader>f"] = { name = "find/file" },
        ["<leader>g"] = { name = "git" },
        ["<leader>p"] = { name = "project" },
        ["<leader>q"] = { name = "quit/session" },
        ["<leader>r"] = { name = "run/build" },
        ["<leader>s"] = { name = "search" },
        ["<leader>t"] = { name = "terminal/test" },
        ["<leader>u"] = { name = "ui" },
        ["<leader>w"] = { name = "windows" },
        ["<leader>x"] = { name = "trouble" },
        ["<leader>d"] = { name = "debug" },
        ["<leader>m"] = { name = "marks" },
        ["<leader><tab>"] = { name = "tabs" },
        ["]"] = { name = "next" },
        ["["] = { name = "prev" },
        ["g"] = { name = "goto" },
      })
    end,
  },

  -- Enhanced Git integration
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
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 1000,
        ignore_whitespace = false,
      },
      preview_config = { border = "rounded", style = "minimal", relative = "cursor", row = 0, col = 1 },
    },
  },

  -- Git enhancements
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>",        desc = "DiffView" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Git History" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = { layout = "diff2_horizontal" },
        merge_tool = { layout = "diff3_horizontal" },
      },
    },
  },

  {
    "kdheepak/lazygit.nvim",
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Better UI components
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        { filter = { event = "msg_show", any = { { find = "%d+L, %d+B" }, { find = "; after #%d+" }, { find = "; before #%d+" } } }, view = "mini" },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
  },

  -- Enhanced notifications
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 3000,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.75) end,
      background_colour = "#000000",
      render = "wrapped-compact",
      stages = "fade_in_slide_out",
    },
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require("notify")
    end,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = { lua = { "string", "source" }, javascript = { "string", "template_string" } },
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0,
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
    },
  },

  -- Enhanced commenting
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n",          desc = "Comment toggle current line" },
      { "gc",  mode = { "n", "o" }, desc = "Comment toggle linewise" },
      { "gc",  mode = "x",          desc = "Comment toggle linewise (visual)" },
      { "gbc", mode = "n",          desc = "Comment toggle current block" },
      { "gb",  mode = { "n", "o" }, desc = "Comment toggle blockwise" },
      { "gb",  mode = "x",          desc = "Comment toggle blockwise (visual)" },
    },
    opts = {
      padding = true,
      sticky = true,
      ignore = "^$",
      toggler = { line = "gcc", block = "gbc" },
      opleader = { line = "gc", block = "gb" },
      extra = { above = "gcO", below = "gco", eol = "gcA" },
      mappings = { basic = true, extra = true },
    },
  },

  -- Enhanced indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = { char = "│", tab_char = "│" },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason",
          "notify", "toggleterm", "lazyterm",
        },
      },
    },
  },

  -- Enhanced terminal
  {
    "akinsho/toggleterm.nvim",
    keys = {
      { "<C-\\>",     "<cmd>ToggleTerm direction=horizontal size=15<cr>", desc = "Terminal" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>",              desc = "Float Terminal" },
      { "<leader>th", "<cmd>ToggleTerm size=15 direction=horizontal<cr>", desc = "Horizontal Terminal" },
      { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>",   desc = "Vertical Terminal" },
    },
    opts = {
      size = 20,
      open_mapping = [[<C-\>]],
      direction = "float",
      float_opts = { border = "curved" },
      highlights = {
        Normal = { guibg = "#1e1e2e" },
        NormalFloat = { link = "Normal" },
        FloatBorder = { guifg = "#89b4fa", guibg = "#1e1e2e" },
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
    end,
  },

  -- Build system integration
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerTaskAction" },
    opts = {
      task_list = {
        direction = "bottom",
        min_height = 25,
        max_height = 25,
        default_detail = 1,
      },
      form = { border = "rounded", win_opts = { winblend = 0 } },
      confirm = { border = "rounded", win_opts = { winblend = 0 } },
      task_win = { border = "rounded", win_opts = { winblend = 0 } },
    },
  },

  -- Trouble diagnostics
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "Document Diagnostics" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
      { "<leader>xl", "<cmd>TroubleToggle loclist<cr>",               desc = "Location List" },
      { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",              desc = "Quickfix List" },
    },
  },

  -- Surround
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function() require("nvim-surround").setup({}) end,
  },

  -- Flash jump
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },

  -- FIXED: Enhanced Visual Studio-like debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      {
        "nvim-neodev/nvim-nio",
        config = function()
          -- Ensure nvim-nio is loaded properly
          pcall(require, "nio")
        end,
      },
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
      "nvim-telescope/telescope-dap.nvim",
      "mfussenegger/nvim-dap-python",
      "leoluz/nvim-dap-go",
      "mxsdev/nvim-dap-vscode-js",
    },
    keys = {
      -- Visual Studio keybindings
      { "<F5>", function() require("dap").continue() end, desc = "🚀 Start/Continue" },
      { "<S-F5>", function() require("dap").terminate() end, desc = "⏹️ Stop" },
      { "<C-S-F5>", function() require("dap").restart() end, desc = "🔄 Restart" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "🔴 Toggle Breakpoint" },
      { "<F10>", function() require("dap").step_over() end, desc = "⏭️ Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "⬇️ Step Into" },
      { "<S-F11>", function() require("dap").step_out() end, desc = "⬆️ Step Out" },

      -- Advanced breakpoints
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "🎯 Conditional Breakpoint" },
      { "<leader>dL", function() require("dap").set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, desc = "📝 Log Point" },
      { "<leader>dC", function() require("dap").clear_breakpoints() end, desc = "🧹 Clear Breakpoints" },

      -- UI controls
      { "<leader>du", function() require("dapui").toggle() end, desc = "🔧 Toggle Debug UI" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "💬 Debug Console" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "🔄 Run Last" },

      -- Variable inspection
      {
        "<leader>dv",
        function()
          local widgets = require('dap.ui.widgets')
          widgets.centered_float(widgets.variables)
        end,
        desc = "📊 Variables"
      },
      {
        "<leader>ds",
        function()
          local widgets = require('dap.ui.widgets')
          widgets.centered_float(widgets.scopes)
        end,
        desc = "🎯 Scopes"
      },
      {
        "<leader>df",
        function()
          local widgets = require('dap.ui.widgets')
          widgets.centered_float(widgets.frames)
        end,
        desc = "📚 Call Stack"
      },
    },

    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- FIXED DAP UI Configuration
      dapui.setup({
        icons = {
          expanded = "▾",
          collapsed = "▸",
          current_frame = "▸"
        },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 0.25,
            position = "bottom",
          },
        },
        controls = {
          enabled = true,
          element = "repl",
          icons = {
            pause = "⏸",
            play = "▶",
            step_into = "⏬",
            step_over = "⏭",
            step_out = "⏫",
            step_back = "⏮",
            run_last = "↻",
            terminate = "⏹",
          },
        },
        floating = {
          max_height = 0.8,
          max_width = 0.8,
          border = "rounded",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil,
          max_value_lines = 100,
        }
      })

      -- Enhanced virtual text
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        virt_text_pos = 'eol',
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil
      })

      -- Auto UI management
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Codelldb adapter
      dap.adapters.codelldb = {
        type = 'server',
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        }
      }

      -- Language configurations (simplified)
      dap.configurations.rust = {
        {
          name = "Launch Rust Binary",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
        },
      }

      dap.configurations.zig = {
        {
          name = "Launch Zig Binary",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/zig-out/bin/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
        },
      }

      dap.configurations.cpp = {
        {
          name = "Launch C++ Binary",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/build/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
        },
      }
      dap.configurations.c = dap.configurations.cpp

      -- Load language configs
      pcall(function() require("dap-python").setup("python") end)
      pcall(function() require("dap-go").setup() end)

      -- Breakpoint signs
      vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointCondition', {
        text = '🎯',
        texthl = 'DapBreakpointCondition',
        linehl = '',
        numhl = ''
      })
      vim.fn.sign_define('DapLogPoint', { text = '📝', texthl = 'DapLogPoint', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '▶️', texthl = 'DapStopped', linehl = 'DapStoppedLine', numhl = '' })
      vim.fn.sign_define('DapBreakpointRejected',
        { text = '❌', texthl = 'DapBreakpointRejected', linehl = '', numhl = '' })

      -- Colors
      vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#e51400' })
      vim.api.nvim_set_hl(0, 'DapBreakpointCondition', { fg = '#f79000' })
      vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#61afef' })
      vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#ffcc00' })
      vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#2e3440' })

      -- Load telescope extension safely
      pcall(function()
        require('telescope').load_extension('dap')
      end)
    end,
  },

  -- Enhanced code folding & navigation
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "BufReadPost",
    keys = {
      { "zR", function() require("ufo").openAllFolds() end, desc = "🔓 Open all folds" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "🔒 Close all folds" },
      { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "🔓 Open folds except kinds" },
      { "zm", function() require("ufo").closeFoldsWith() end, desc = "🔒 Close folds with" },
      { "zp", function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "👁️ Peek fold" },
    },
    opts = {
      provider_selector = function(bufnr, filetype, buftype)
        return { 'treesitter', 'indent' }
      end,
      open_fold_hl_timeout = 150,
      close_fold_kinds_for_ft = {
        default = { 'imports', 'comment' },
        json = { 'array' },
        c = { 'comment', 'region' }
      },
      preview = {
        win_config = {
          border = { '', '─', '', '', '', '─', '', '' },
          winhighlight = 'Normal:Folded',
          winblend = 0
        },
        mappings = {
          scrollU = '<C-u>',
          scrollD = '<C-d>',
          jumpTop = '[',
          jumpBot = ']'
        }
      },
    },
    config = function(_, opts)
      require('ufo').setup(opts)
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.fillchars = [[eob: ,fold: ,foldopen:▾,foldsep: ,foldclose:▸]]
    end,
  },

  -- Enhanced navigation & movement
  {
    "ggandor/leap.nvim",
    keys = {
      { "s",  mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "S",  mode = { "n", "x", "o" }, desc = "Leap backward to" },
      { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
    },
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      vim.keymap.del({ 'x', 'o' }, 'x')
      vim.keymap.del({ 'x', 'o' }, 'X')
    end,
  },

  -- Mason DAP setup
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        "python",
        "codelldb",
        "js-debug-adapter",
        "netcoredbg",
      },
    },
  },

  -- Enhanced formatting & linting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true, lsp_fallback = true }) end, desc = "Format buffer" },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { { "prettierd", "prettier" } },
        typescript = { { "prettierd", "prettier" } },
        javascriptreact = { { "prettierd", "prettier" } },
        typescriptreact = { { "prettierd", "prettier" } },
        json = { { "prettierd", "prettier" } },
        yaml = { { "prettierd", "prettier" } },
        markdown = { { "prettierd", "prettier" } },
        html = { { "prettierd", "prettier" } },
        css = { { "prettierd", "prettier" } },
        rust = { "rustfmt" },
        go = { "goimports", "gofmt" },
        cpp = { "clang_format" },
        c = { "clang_format" },
        zig = { "zig fmt" },
      },
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
    },
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        python = { "pylint" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      }

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        callback = function() lint.try_lint() end,
      })
    end,
  },

  -- Advanced refactoring
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "<leader>re",  ":Refactor extract ",              mode = "x",                    desc = "Extract function" },
      { "<leader>rf",  ":Refactor extract_to_file ",      mode = "x",                    desc = "Extract to file" },
      { "<leader>rv",  ":Refactor extract_var ",          mode = "x",                    desc = "Extract variable" },
      { "<leader>ri",  ":Refactor inline_var",            mode = { "n", "x" },           desc = "Inline variable" },
      { "<leader>rI",  ":Refactor inline_func",           desc = "Inline function" },
      { "<leader>rb",  ":Refactor extract_block",         desc = "Extract block" },
      { "<leader>rbf", ":Refactor extract_block_to_file", desc = "Extract block to file" },
    },
    opts = {},
  },

  -- TODO comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>ft", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
      { "<leader>fT", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
    },
    opts = {
      signs = true,
      sign_priority = 8,
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
    },
  },

  -- AI assistance
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
    end,
  },

  -- Enhanced UI components
  {
    "folke/zen-mode.nvim",
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
    opts = {
      window = { width = 120, options = { number = false, relativenumber = false } },
    },
  },

  -- Color picker
  {
    "uga-rosa/ccc.nvim",
    keys = {
      { "<leader>cp", "<cmd>CccPick<cr>",    desc = "Color Picker" },
      { "<leader>ct", "<cmd>CccConvert<cr>", desc = "Convert Color" },
    },
    opts = { highlighter = { auto_enable = true, lsp = true } },
  },
}

-- Setup lazy.nvim
require("lazy").setup(plugins, {
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
  ui = {
    border = "rounded",
    backdrop = 60,
  },
  performance = {
    cache = { enabled = true },
    reset_packpath = true,
    rtp = {
      reset = true,
      paths = {},
      disabled_plugins = {
        "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin", "netrwPlugin",
        "matchit", "matchparen", "2html_plugin", "getscript", "getscriptPlugin",
        "vimball", "vimballPlugin", "rrhelper", "spellfile_plugin", "logiPat",
      },
    },
  },
})

-- TacoVim Manager Functions (rest of the functions remain the same)
function TacoVim.ProjectManager.create_project()
  local project_templates = {
    -- Web Development
    { name = "HTML/CSS/JS Website", type = "web",        tech = "vanilla" },
    { name = "React App (Vite)",    type = "web",        tech = "react-vite" },
    { name = "React App (Next.js)", type = "web",        tech = "nextjs" },
    { name = "Vue.js App",          type = "web",        tech = "vue" },
    { name = "Svelte App",          type = "web",        tech = "svelte" },
    { name = "Angular App",         type = "web",        tech = "angular" },
    { name = "Astro App",           type = "web",        tech = "astro" },

    -- Backend APIs
    { name = "Node.js API",         type = "backend",    tech = "nodejs" },
    { name = "Express.js API",      type = "backend",    tech = "express" },
    { name = "Fastify API",         type = "backend",    tech = "fastify" },
    { name = "Python FastAPI",      type = "backend",    tech = "fastapi" },
    { name = "Python Flask",        type = "backend",    tech = "flask" },
    { name = "Python Django",       type = "backend",    tech = "django" },
    { name = "Go HTTP Server",      type = "backend",    tech = "go" },
    { name = "Rust Axum API",       type = "backend",    tech = "rust-axum" },

    -- Systems Programming
    { name = "Rust Binary",         type = "systems",    tech = "rust-bin" },
    { name = "Rust Library",        type = "systems",    tech = "rust-lib" },
    { name = "C++ CMake",           type = "systems",    tech = "cpp" },
    { name = "C Project",           type = "systems",    tech = "c" },
    { name = "Zig Application",     type = "systems",    tech = "zig" },

    -- JVM Languages
    { name = "Java Spring Boot",    type = "backend",    tech = "java-spring" },
    { name = "Java Maven",          type = "systems",    tech = "java-maven" },
    { name = "Java Gradle",         type = "systems",    tech = "java-gradle" },
    { name = "Kotlin JVM",          type = "systems",    tech = "kotlin-jvm" },
    { name = "Scala SBT",           type = "systems",    tech = "scala" },

    -- .NET Ecosystem
    { name = "C# Console App",      type = "systems",    tech = "csharp-console" },
    { name = "C# Web API",          type = "backend",    tech = "csharp-webapi" },
    { name = "C# Blazor App",       type = "web",        tech = "csharp-blazor" },

    -- Mobile Development
    { name = "React Native App",    type = "mobile",     tech = "react-native" },
    { name = "Flutter App",         type = "mobile",     tech = "flutter" },
    { name = "Dart Console",        type = "systems",    tech = "dart" },

    -- Data Science & ML
    { name = "Python Data Science", type = "data",       tech = "python-ds" },
    { name = "Jupyter Notebook",    type = "data",       tech = "jupyter" },
    { name = "R Project",           type = "data",       tech = "r" },
    { name = "Julia Project",       type = "data",       tech = "julia" },

    -- Functional Languages
    { name = "Haskell Project",     type = "functional", tech = "haskell" },
    { name = "Clojure Project",     type = "functional", tech = "clojure" },
    { name = "Elixir Project",      type = "functional", tech = "elixir" },

    -- Scripting & Automation
    { name = "Bash Scripts",        type = "scripts",    tech = "bash" },
    { name = "Lua Script",          type = "scripts",    tech = "lua" },
    { name = "Ruby Gem",            type = "scripts",    tech = "ruby" },
  }

  local project_names = {}
  for _, template in ipairs(project_templates) do
    table.insert(project_names, template.name)
  end

  vim.ui.select(project_names, {
    prompt = "🚀 Select project template:",
    format_item = function(item) return "  " .. item end,
  }, function(choice)
    if not choice then return end

    local selected_template
    for _, template in ipairs(project_templates) do
      if template.name == choice then
        selected_template = template
        break
      end
    end

    vim.ui.input({
      prompt = "📝 Project name: ",
    }, function(name)
      if not name or name == "" then return end

      vim.ui.input({
        prompt = "📁 Project directory (default: ~/Projects): ",
        default = vim.fn.expand("~/Projects"),
      }, function(dir)
        if not dir or dir == "" then
          dir = vim.fn.expand("~/Projects")
        end

        local full_path = dir .. "/" .. name
        TacoVim.ProjectManager.create_project_structure(selected_template, full_path, name)
      end)
    end)
  end)
end

function TacoVim.ProjectManager.create_project_structure(template, path, name)
  local result = pcall(vim.fn.mkdir, path, "p")
  if not result then
    vim.notify("❌ Failed to create project directory: " .. path, vim.log.levels.ERROR)
    return
  end

  local tech = template.tech

  if tech == "cpp" then
    vim.fn.mkdir(path .. "/src", "p")
    vim.fn.mkdir(path .. "/include", "p")
    vim.fn.mkdir(path .. "/build", "p")

    local cmake_content = string.format([[
cmake_minimum_required(VERSION 3.16)
project(%s VERSION 1.0.0)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Add compile options
if(MSVC)
    add_compile_options(/W4)
else()
    add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# Include directories
include_directories(include)

# Add executable
add_executable(%s src/main.cpp)

# Enable testing
enable_testing()

# Set output directory
set_target_properties(%s PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
)
]], name, name, name)

    local cpp_content = string.format([[
#include <iostream>
#include <string>
#include <vector>
#include <memory>

namespace %s {
    class Application {
    private:
        std::string name_;

    public:
        explicit Application(const std::string& name) : name_(name) {}

        void run() {
            std::cout << "🚀 Starting " << name_ << "..." << std::endl;
            std::cout << "✨ Built with TacoVim C++ template" << std::endl;

            auto numbers = std::vector<int>{1, 2, 3, 4, 5};
            std::cout << "Numbers: ";
            for (const auto& num : numbers) {
                std::cout << num << " ";
            }
            std::cout << std::endl;

            std::cout << "🎉 " << name_ << " completed successfully!" << std::endl;
        }
    };
}

int main() {
    try {
        auto app = std::make_unique<%s::Application>("%s");
        app->run();
        return 0;
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }
}
]], name, name, name)

    vim.fn.writefile(vim.split(cmake_content, "\n"), path .. "/CMakeLists.txt")
    vim.fn.writefile(vim.split(cpp_content, "\n"), path .. "/src/main.cpp")
  elseif tech == "zig" then
    local build_zig = string.format([[
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "%s",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const run_unit_tests = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
]], name)

    local main_zig = string.format([[
const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    print("🚀 Hello from {s}!\n", .{"%s"});
    print("✨ Built with TacoVim Zig template\n");

    const numbers = [_]i32{ 1, 2, 3, 4, 5 };
    print("Numbers: ");
    for (numbers) |num| {
        print("{d} ", .{num});
    }
    print("\n");

    print("🎉 {s} completed successfully!\n", .{"%s"});
}

test "basic test" {
    try std.testing.expect(true);
}
]], name, name)

    vim.fn.mkdir(path .. "/src", "p")
    vim.fn.writefile(vim.split(build_zig, "\n"), path .. "/build.zig")
    vim.fn.writefile(vim.split(main_zig, "\n"), path .. "/src/main.zig")
  elseif tech == "rust-bin" then
    vim.fn.system("cd " .. vim.fn.fnamemodify(path, ":h") .. " && cargo new " .. name)
  elseif tech == "go" then
    vim.fn.system("cd " .. path .. " && go mod init " .. name)
    local go_content = string.format([[
package main

import (
    "fmt"
    "time"
)

func main() {
    fmt.Printf("🚀 Starting %s...\n")
    fmt.Println("✨ Built with TacoVim Go template")

    numbers := []int{1, 2, 3, 4, 5}
    fmt.Print("Numbers: ")
    for _, num := range numbers {
        fmt.Printf("%%d ", num)
    }
    fmt.Println()

    fmt.Printf("🎉 %s completed successfully!\n")
    fmt.Printf("⏰ Current time: %%s\n", time.Now().Format("2006-01-02 15:04:05"))
}
]], name, name)
    vim.fn.writefile(vim.split(go_content, "\n"), path .. "/main.go")
  end

  -- Create universal project files
  local readme_content = string.format([[# %s

> A professional project created with TacoVim IDE

## 🚀 Getting Started

### Prerequisites
- Make sure you have the required tools installed for your project type

### Installation
```bash
cd %s
# Follow the setup instructions for your specific technology stack
```

### Development with TacoVim
```bash
# Build project
<Space>rb

# Run project
<Space>rr

# Test project
<Space>rt

# Clean project
<Space>rc

# Debug project
<F5>
```

## 🛠️ Built With
- **TacoVim** - Professional Full-Stack Development IDE
- **Modern tooling** - Latest development practices

## 📝 Features
- [ ] Add your features here
- [ ] Modern architecture
- [ ] Production ready

---
*Generated with ❤️ by TacoVim*
]], name, name)

  local gitignore_content = [[# TacoVim Generated .gitignore

# Dependencies
node_modules/
.pnp
.pnp.js

# Build directories
build/
dist/
target/
bin/
obj/
out/

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# IDE files
.vscode/
.idea/
*.swp
*.swo
*~

# Language specific
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
venv/
env/

# Rust
Cargo.lock

# C/C++
*.o
*.obj
*.exe
*.dll
*.dylib

# Java
*.class
*.jar
*.war

# C#
*.dll
*.exe
*.pdb

# Go
*.exe~

# Zig
zig-cache/
zig-out/

# Haskell
.stack-work/
dist/

# R
.Rhistory
.RData

# Julia
Manifest.toml
]]

  vim.fn.writefile(vim.split(readme_content, "\n"), path .. "/README.md")
  vim.fn.writefile(vim.split(gitignore_content, "\n"), path .. "/.gitignore")

  -- Initialize git
  vim.fn.system("cd " ..
    path .. " && git init && git add . && git commit -m 'Initial commit: Project created with TacoVim'")

  -- Open the project
  vim.cmd("cd " .. path)
  vim.cmd("Neotree toggle")
  vim.notify("🚀 Project '" .. name .. "' created successfully at " .. path, vim.log.levels.INFO)
end

-- Build System Functions
function TacoVim.BuildSystem.detect_project_type()
  local cwd = vim.fn.getcwd()

  -- .NET projects
  if vim.fn.glob(cwd .. "/*.csproj") ~= "" or vim.fn.glob(cwd .. "/*.sln") ~= "" then
    return "dotnet"
    -- Java projects
  elseif vim.fn.filereadable(cwd .. "/pom.xml") == 1 then
    return "maven"
  elseif vim.fn.filereadable(cwd .. "/build.gradle") == 1 or vim.fn.filereadable(cwd .. "/build.gradle.kts") == 1 then
    return "gradle"
    -- Native languages
  elseif vim.fn.filereadable(cwd .. "/Cargo.toml") == 1 then
    return "rust"
  elseif vim.fn.filereadable(cwd .. "/build.zig") == 1 then
    return "zig"
  elseif vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
    return "cmake"
  elseif vim.fn.filereadable(cwd .. "/Makefile") == 1 then
    return "make"
    -- Scripting and interpreted languages
  elseif vim.fn.filereadable(cwd .. "/package.json") == 1 then
    return "node"
  elseif vim.fn.filereadable(cwd .. "/go.mod") == 1 then
    return "go"
  elseif vim.fn.filereadable(cwd .. "/requirements.txt") == 1 or vim.fn.filereadable(cwd .. "/pyproject.toml") == 1 then
    return "python"
  else
    return "unknown"
  end
end

function TacoVim.BuildSystem.build()
  local project_type = TacoVim.BuildSystem.detect_project_type()
  local cmd = ""

  if project_type == "dotnet" then
    cmd = "dotnet build"
  elseif project_type == "maven" then
    cmd = "mvn compile"
  elseif project_type == "gradle" then
    cmd = "./gradlew build"
  elseif project_type == "rust" then
    cmd = "cargo build --release"
  elseif project_type == "zig" then
    cmd = "zig build"
  elseif project_type == "cmake" then
    cmd = "mkdir -p build && cd build && cmake .. && make -j$(nproc)"
  elseif project_type == "make" then
    cmd = "make"
  elseif project_type == "node" then
    cmd = "npm run build"
  elseif project_type == "go" then
    cmd = "go build -o bin/ ./..."
  elseif project_type == "python" then
    cmd = "python -m build"
  else
    vim.notify("⚠️ Unknown project type for building", vim.log.levels.WARN)
    return
  end

  -- Run in terminal with output visible
  local Terminal = require("toggleterm.terminal").Terminal
  local build_term = Terminal:new({
    cmd = cmd,
    direction = "horizontal",
    size = 15,
    close_on_exit = false,
    auto_scroll = true,
    on_open = function(term)
      vim.cmd("startinsert!")
    end,
  })

  build_term:toggle()
  vim.notify("🔨 Building project...", vim.log.levels.INFO)
end

function TacoVim.BuildSystem.run()
  local project_type = TacoVim.BuildSystem.detect_project_type()
  local cmd = ""
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

  if project_type == "dotnet" then
    cmd = "dotnet run"
  elseif project_type == "maven" then
    cmd = "mvn exec:java"
  elseif project_type == "gradle" then
    cmd = "./gradlew run"
  elseif project_type == "rust" then
    cmd = "cargo run"
  elseif project_type == "zig" then
    cmd = "zig build run"
  elseif project_type == "cmake" then
    cmd = "mkdir -p build && cd build && cmake .. && make -j$(nproc) && echo '\\n🚀 Running " ..
        project_name .. "...' && ./" .. project_name
  elseif project_type == "make" then
    cmd = "make && ./" .. project_name
  elseif project_type == "node" then
    cmd = "npm start"
  elseif project_type == "go" then
    cmd = "go run ."
  elseif project_type == "python" then
    if vim.fn.filereadable("main.py") == 1 then
      cmd = "python main.py"
    else
      cmd = "python -m " .. project_name
    end
  else
    vim.notify("⚠️ Unknown project type for running", vim.log.levels.WARN)
    return
  end

  -- Run in persistent terminal window
  local Terminal = require("toggleterm.terminal").Terminal
  local run_term = Terminal:new({
    cmd = cmd,
    direction = "horizontal",
    size = 15,
    close_on_exit = false,
    auto_scroll = true,
    on_open = function(term)
      vim.cmd("startinsert!")
      vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    end,
  })

  run_term:toggle()
  vim.notify("🚀 Running project... (Press 'q' to close, Ctrl+C to kill)", vim.log.levels.INFO)
end

function TacoVim.BuildSystem.clean()
  local project_type = TacoVim.BuildSystem.detect_project_type()
  local cmd = ""

  if project_type == "dotnet" then
    cmd = "dotnet clean"
  elseif project_type == "maven" then
    cmd = "mvn clean"
  elseif project_type == "gradle" then
    cmd = "./gradlew clean"
  elseif project_type == "rust" then
    cmd = "cargo clean"
  elseif project_type == "zig" then
    cmd = "rm -rf zig-cache zig-out"
  elseif project_type == "cmake" then
    cmd = "rm -rf build/ && echo '🧹 Build directory cleaned!'"
  elseif project_type == "make" then
    cmd = "make clean"
  elseif project_type == "node" then
    cmd = "rm -rf node_modules dist build && npm install"
  elseif project_type == "go" then
    cmd = "go clean -cache && rm -rf bin/"
  elseif project_type == "python" then
    cmd = "rm -rf __pycache__ dist build *.egg-info .pytest_cache && echo '🧹 Python cache cleaned!'"
  else
    vim.notify("⚠️ Unknown project type for cleaning", vim.log.levels.WARN)
    return
  end

  local Terminal = require("toggleterm.terminal").Terminal
  local clean_term = Terminal:new({
    cmd = cmd,
    direction = "horizontal",
    size = 10,
    close_on_exit = true,
    auto_scroll = true,
  })

  clean_term:toggle()
  vim.notify("🧹 Cleaning project...", vim.log.levels.INFO)
end

function TacoVim.BuildSystem.test()
  local project_type = TacoVim.BuildSystem.detect_project_type()
  local cmd = ""

  if project_type == "dotnet" then
    cmd = "dotnet test"
  elseif project_type == "maven" then
    cmd = "mvn test"
  elseif project_type == "gradle" then
    cmd = "./gradlew test"
  elseif project_type == "rust" then
    cmd = "cargo test"
  elseif project_type == "zig" then
    cmd = "zig build test"
  elseif project_type == "cmake" then
    cmd = "cd build && make test"
  elseif project_type == "make" then
    cmd = "make test"
  elseif project_type == "node" then
    cmd = "npm test"
  elseif project_type == "go" then
    cmd = "go test ./..."
  elseif project_type == "python" then
    cmd = "python -m pytest"
  else
    vim.notify("⚠️ Unknown project type for testing", vim.log.levels.WARN)
    return
  end

  local Terminal = require("toggleterm.terminal").Terminal
  local test_term = Terminal:new({
    cmd = cmd,
    direction = "horizontal",
    size = 15,
    close_on_exit = false,
  })

  test_term:toggle()
  vim.notify("🧪 Running tests...", vim.log.levels.INFO)
end

function TacoVim.BuildSystem.debug()
  local project_type = TacoVim.BuildSystem.detect_project_type()

  if project_type == "rust" then
    vim.cmd("RustLsp debuggables")
  elseif project_type == "zig" then
    vim.fn.system("zig build")
    if vim.v.shell_error == 0 then
      require("dap").continue()
      vim.notify("🐛 Starting Zig debugger...", vim.log.levels.INFO)
    else
      vim.notify("❌ Zig build failed", vim.log.levels.ERROR)
    end
  elseif project_type == "python" then
    require("dap-python").test_method()
  elseif project_type == "go" then
    require("dap-go").debug_test()
  elseif project_type == "cmake" then
    vim.fn.system("cd build && cmake -DCMAKE_BUILD_TYPE=Debug .. && make")
    if vim.v.shell_error == 0 then
      require("dap").continue()
    end
  else
    require("dap").continue()
  end
end

-- Theme Management Functions
local themes = {
  { name = "Catppuccin Mocha",  scheme = "catppuccin-mocha" },
  { name = "Catppuccin Latte",  scheme = "catppuccin-latte" },
  { name = "Tokyo Night",       scheme = "tokyonight" },
  { name = "Tokyo Night Storm", scheme = "tokyonight-storm" },
  { name = "Rose Pine",         scheme = "rose-pine" },
  { name = "Kanagawa",          scheme = "kanagawa" },
  { name = "Nightfox",          scheme = "nightfox" },
  { name = "Gruvbox Material",  scheme = "gruvbox-material" },
  { name = "Everforest",        scheme = "everforest" },
  { name = "Dracula",           scheme = "dracula" },
  { name = "Gruvbox",           scheme = "gruvbox" },
  { name = "One Dark",          scheme = "onedark" },
  { name = "Nord",              scheme = "nord" },
  { name = "Material",          scheme = "material" },
  { name = "Nightfly",          scheme = "nightfly" },
}

function TacoVim.ThemeManager.switch_theme()
  local theme_names = {}
  for _, theme in ipairs(themes) do
    table.insert(theme_names, theme.name)
  end

  vim.ui.select(theme_names, {
    prompt = "🎨 Select theme:",
    format_item = function(item) return "  " .. item end,
  }, function(choice)
    if not choice then return end

    for _, theme in ipairs(themes) do
      if theme.name == choice then
        local success, error_msg = pcall(vim.cmd.colorscheme, theme.scheme)
        if success then
          vim.notify("🎨 Theme changed to: " .. choice, vim.log.levels.INFO)
          local config_path = vim.fn.stdpath("data") .. "/tacovim_theme.txt"
          pcall(vim.fn.writefile, { theme.scheme }, config_path)

          local ok, lualine = pcall(require, "lualine")
          if ok then
            pcall(lualine.setup, {
              options = { theme = theme.scheme:match("catppuccin") and "catppuccin" or "auto" }
            })
          end
        else
          vim.notify("❌ Failed to load theme: " .. choice, vim.log.levels.ERROR)
        end
        break
      end
    end
  end)
end

-- Session Management Functions
function TacoVim.SessionManager.save_session()
  vim.ui.input({
    prompt = "💾 Session name: ",
    default = vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
  }, function(name)
    if not name or name == "" then return end

    require("persistence").save({ name = name })
    vim.notify("💾 Session '" .. name .. "' saved", vim.log.levels.INFO)
  end)
end

function TacoVim.SessionManager.load_session()
  require("persistence").load()
  vim.notify("📂 Session restored", vim.log.levels.INFO)
end

-- Utility Functions
function TacoVim.Utilities.toggle_transparency()
  if vim.g.transparent_enabled then
    vim.cmd("hi Normal guibg=#1e1e2e")
    vim.cmd("hi NormalFloat guibg=#1e1e2e")
    vim.g.transparent_enabled = false
    vim.notify("🎨 Transparency disabled", vim.log.levels.INFO)
  else
    vim.cmd("hi Normal guibg=NONE")
    vim.cmd("hi NormalFloat guibg=NONE")
    vim.g.transparent_enabled = true
    vim.notify("🎨 Transparency enabled", vim.log.levels.INFO)
  end
end

function TacoVim.Utilities.toggle_diagnostics()
  if vim.g.diagnostics_enabled then
    vim.diagnostic.disable()
    vim.g.diagnostics_enabled = false
    vim.notify("🔇 Diagnostics disabled", vim.log.levels.INFO)
  else
    vim.diagnostic.enable()
    vim.g.diagnostics_enabled = true
    vim.notify("🔊 Diagnostics enabled", vim.log.levels.INFO)
  end
end

function TacoVim.Utilities.reload_config()
  for name, _ in pairs(package.loaded) do
    if name:match('^cnf') or name:match('^config') then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
  vim.notify("🔄 TacoVim configuration reloaded", vim.log.levels.INFO)
end

function TacoVim.Utilities.show_stats()
  local stats = require("lazy").stats()
  local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

  local info = {
    "⚡ TacoVim Statistics",
    "",
    "📦 Plugins: " .. stats.loaded .. "/" .. stats.count,
    "⏱️  Startup: " .. ms .. "ms",
    "🎯 Neovim: " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch,
    "📁 Config: " .. vim.fn.stdpath("config"),
    "💾 Data: " .. vim.fn.stdpath("data"),
    "🗂️  Current: " .. vim.fn.getcwd(),
  }

  vim.notify(table.concat(info, "\n"), vim.log.levels.INFO, { title = "TacoVim Stats" })
end

function TacoVim.Utilities.health_check()
  vim.cmd("checkhealth")
end

-- Enhanced LSP keymaps
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("TacoVim_LspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }

    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation,
      vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
    vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition,
      vim.tbl_extend("force", opts, { desc = "Type definition" }))
    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show hover" }))
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
      vim.tbl_extend("force", opts, { desc = "Code action" }))
    vim.keymap.set("n", "<leader>cf", function() vim.lsp.buf.format { async = true } end,
      vim.tbl_extend("force", opts, { desc = "Format" }))
  end,
})

-- Enhanced keymaps
local keymap = vim.keymap.set

-- Better escape
keymap("i", "jk", "<ESC>", { desc = "Exit insert mode" })
keymap("i", "kj", "<ESC>", { desc = "Exit insert mode" })

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize up" })
keymap("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize down" })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize left" })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize right" })

-- Window management
keymap("n", "<leader>wv", "<C-w>v", { desc = "Split vertically" })
keymap("n", "<leader>wh", "<C-w>s", { desc = "Split horizontally" })
keymap("n", "<leader>we", "<C-w>=", { desc = "Equal splits" })
keymap("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close split" })

-- Tab management
keymap("n", "<leader><tab>o", "<cmd>tabnew<CR>", { desc = "New tab" })
keymap("n", "<leader><tab>x", "<cmd>tabclose<CR>", { desc = "Close tab" })
keymap("n", "<leader><tab>n", "<cmd>tabnext<CR>", { desc = "Next tab" })
keymap("n", "<leader><tab>p", "<cmd>tabprevious<CR>", { desc = "Previous tab" })

-- Better navigation
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })

-- Move Lines
keymap("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
keymap("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
keymap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
keymap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
keymap("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
keymap("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Better indenting
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- Clear search highlighting
keymap({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Save and quit
keymap({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
keymap("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Better copy/paste
keymap("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })
keymap({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
keymap("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

-- Project management
keymap("n", "<leader>pn", "<cmd>lua TacoVim.ProjectManager.create_project()<cr>", { desc = "New project" })
keymap("n", "<leader>po", "<cmd>Telescope projects<cr>", { desc = "Open project" })

-- Build and run
keymap("n", "<leader>rb", "<cmd>lua TacoVim.BuildSystem.build()<cr>", { desc = "Build project" })
keymap("n", "<leader>rr", "<cmd>lua TacoVim.BuildSystem.run()<cr>", { desc = "Run project" })
keymap("n", "<leader>rt", "<cmd>lua TacoVim.BuildSystem.test()<cr>", { desc = "Test project" })
keymap("n", "<leader>rc", "<cmd>lua TacoVim.BuildSystem.clean()<cr>", { desc = "Clean project" })
keymap("n", "<leader>rd", "<cmd>lua TacoVim.BuildSystem.debug()<cr>", { desc = "Debug project" })

-- Session management
keymap("n", "<leader>qs", "<cmd>lua TacoVim.SessionManager.save_session()<cr>", { desc = "Save session" })
keymap("n", "<leader>ql", "<cmd>lua TacoVim.SessionManager.load_session()<cr>", { desc = "Load last session" })

-- Theme management
keymap("n", "<leader>ut", "<cmd>lua TacoVim.ThemeManager.switch_theme()<cr>", { desc = "Switch theme" })

-- Utility functions
keymap("n", "<leader>uT", "<cmd>lua TacoVim.Utilities.toggle_transparency()<cr>", { desc = "Toggle transparency" })
keymap("n", "<leader>ud", "<cmd>lua TacoVim.Utilities.toggle_diagnostics()<cr>", { desc = "Toggle diagnostics" })
keymap("n", "<leader>ur", "<cmd>lua TacoVim.Utilities.reload_config()<cr>", { desc = "Reload config" })
keymap("n", "<leader>us", "<cmd>lua TacoVim.Utilities.show_stats()<cr>", { desc = "Show stats" })
keymap("n", "<leader>uh", "<cmd>lua TacoVim.Utilities.health_check()<cr>", { desc = "Health check" })

-- Diagnostics
keymap("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })

-- Terminal mode keymaps
keymap("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
keymap("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal left" })
keymap("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal down" })
keymap("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal up" })
keymap("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal right" })

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

-- Auto commands
local function augroup(name)
  return vim.api.nvim_create_augroup("TacoVim_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "help", "lspinfo", "man", "notify", "qf", "query", "startuptime",
    "checkhealth", "tsplayground", "neotest-output", "neotest-summary",
    "neotest-output-panel"
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Auto create directories
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then return end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function() vim.cmd("tabdo wincmd =") end,
})

-- Go to last location when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
      return
    end
    vim.b[buf].last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

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
})

-- Initialize global variables
vim.g.transparent_enabled = false
vim.g.diagnostics_enabled = true

-- User commands
vim.api.nvim_create_user_command("TacoVim", function()
  print([[
                                ░░░░░▒░░
                           ░░░░░░░░░░░▒▒▒░░ ░░
                        ░░▒▒▒░▒▒  ░▓▒▓▓▒░░▒▓▒░ ░░
                      ░░░ ░░▒▓▓▒▒▒▒▓▓▓▒░░░░░░░░░░░░░
                    ░▒▓▓▒▒▒▒▒▓▓▓█▓▓▓░░░▒░░░░░░░░░░░░░░░
                   ░▒▒▓▓▒▒▓▓░▒▒▒▒▒░▒░░░░░░░░░░░░▒▒▒░░░░░░░
                  ░░▒▒▓▓▓▓██▓▓▒░░░░░░░░░░░░░░░░▒░░░░░░░░
                  ▒▓▓▓██▓▓▓▓▒░░░░░░░░░░░░░░▒░░░░░░░
                 ░▒▓█▓▓▓█▓░▒░░░░▒░▒░░░▒░░░░░░
                ░▒▓▓▓▓██▓▒░░░░░░░░▒░░░░░░░
                ░▓▒▓██▓░░░░░░░░░░░░
                 ▒▓▓▓░░░▒░░░
                  ░▒░

      🌮 ████████╗ █████╗  ██████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ 🌮
         ╚══██╔══╝██╔══██╗██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
            ██║   ███████║██║     ██║   ██║██║   ██║██║██╔████╔██║
            ██║   ██╔══██║██║     ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
            ██║   ██║  ██║╚██████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
            ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝

            🚀 Professional Full-Stack Development IDE 🚀
                      Built with ❤️  for developers
]])
  TacoVim.Utilities.show_stats()
end, { desc = "Show TacoVim info" })

vim.api.nvim_create_user_command("TacoVimReload", function()
  TacoVim.Utilities.reload_config()
end, { desc = "Reload TacoVim configuration" })

vim.api.nvim_create_user_command("TacoVimTheme", function()
  TacoVim.ThemeManager.switch_theme()
end, { desc = "Switch TacoVim theme" })

vim.api.nvim_create_user_command("TacoVimProject", function()
  TacoVim.ProjectManager.create_project()
end, { desc = "Create new TacoVim project" })

vim.api.nvim_create_user_command("TacoVimHealth", function()
  TacoVim.Utilities.health_check()
end, { desc = "Run TacoVim health check" })

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
      "📚 Press <Space>us for statistics\n" ..
      "🐛 Press <F5> to start debugging\n" ..
      "🔍 Press <Space>fs to search symbols\n" ..
      "❤️  Built for professional development",
      vim.log.levels.INFO,
      { title = "TacoVim Professional IDE" }
    )
  end,
})

-- Final initialization
vim.defer_fn(function()
  print("🚀 TacoVim Professional IDE initialized successfully!")
end, 100)
-- ~/.config/nvim/lua/tacovim/plugins/ui.lua
-- TacoVim UI Components

return {
  -- =============================================================================
  -- ICONS AND DEPENDENCIES
  -- =============================================================================
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {
      override = {
        zsh = {
          icon = "",
          color = "#428850",
          cterm_color = "65",
          name = "Zsh"
        }
      },
      color_icons = true,
      default = true,
      strict = true,
      override_by_filename = {
        [".gitignore"] = {
          icon = "",
          color = "#f1502f",
          name = "Gitignore"
        }
      },
      override_by_extension = {
        ["log"] = {
          icon = "",
          color = "#81e043",
          name = "Log"
        }
      },
    },
  },

  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },

  -- =============================================================================
  -- DASHBOARD
  -- =============================================================================
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Custom TacoVim header
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

      -- Custom buttons with enhanced functionality
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

      -- Enhanced footer with more info
      local function footer()
        local total_plugins = #vim.tbl_keys(require("lazy").plugins())
        local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
        local version = vim.version()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
        
        return "⚡ TacoVim loaded " .. total_plugins .. " plugins in " .. ms .. "ms" .. datetime ..
            "\n🎯 Neovim v" .. version.major .. "." .. version.minor .. "." .. version.patch ..
            "\n💾 Config: " .. vim.fn.stdpath("config") ..
            "\n🏠 Data: " .. vim.fn.stdpath("data")
      end

      dashboard.section.footer.val = footer()
      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "Include"
      dashboard.section.buttons.opts.hl = "Keyword"

      dashboard.opts.opts.noautocmd = true
      alpha.setup(dashboard.opts)

      -- Auto-update footer when plugins finish loading
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          dashboard.section.footer.val = footer()
          pcall(vim.cmd.AlphaRedraw)
        end,
      })

      -- Close Alpha when opening a file
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          vim.cmd([[
            set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
          ]])
        end,
      })
    end,
  },

  -- =============================================================================
  -- STATUSLINE
  -- =============================================================================
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-web-devicons" },
    config = function()
      local function get_lsp_client()
        local msg = "No LSP"
        local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        
        if next(clients) == nil then 
          return msg 
        end
        
        for _, client in ipairs(clients) do
          local filetypes = client.config.filetypes
          if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            return client.name
          end
        end
        
        return msg
      end

      local function get_attached_clients()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if next(clients) == nil then
          return ""
        end

        local client_names = {}
        for _, client in pairs(clients) do
          table.insert(client_names, client.name)
        end
        return " " .. table.concat(client_names, "|")
      end

      local function get_python_venv()
        local venv = vim.env.CONDA_DEFAULT_ENV or vim.env.VIRTUAL_ENV
        if venv then
          return string.format("  %s", vim.fn.fnamemodify(venv, ":t"))
        end
        return ""
      end

      require("lualine").setup({
        options = {
          theme = "auto", -- Will auto-detect based on colorscheme
          globalstatus = true,
          icons_enabled = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "dashboard", "alpha", "neo-tree", "Outline" },
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(str)
                return " " .. str:sub(1, 1) .. " "
              end,
            },
          },
          lualine_b = {
            {
              "branch",
              icon = "",
            },
            {
              "diff",
              symbols = { 
                added = " ", 
                modified = " ", 
                removed = " " 
              },
              diff_color = {
                added = { fg = "#98be65" },
                modified = { fg = "#ECBE7B" },
                removed = { fg = "#ec5f67" },
              },
            },
          },
          lualine_c = {
            {
              "diagnostics",
              symbols = { 
                error = " ", 
                warn = " ", 
                info = " ", 
                hint = "󰠠 " 
              },
              diagnostics_color = {
                error = { fg = "#ec5f67" },
                warn = { fg = "#ECBE7B" },
                info = { fg = "#008080" },
                hint = { fg = "#10B981" },
              },
            },
            {
              "filetype",
              icon_only = true,
              separator = "",
              padding = { left = 1, right = 0 },
            },
            {
              "filename",
              path = 1,
              symbols = {
                modified = "  ",
                readonly = " ",
                unnamed = " ",
              },
            },
            {
              get_python_venv,
              color = { fg = "#ffda7b", gui = "bold" },
            },
          },
          lualine_x = {
            {
              "searchcount",
              maxcount = 999,
              timeout = 500,
            },
            {
              "selectioncount",
            },
            {
              get_attached_clients,
              color = { fg = "#ffffff", gui = "bold" },
            },
            {
              "encoding",
              fmt = string.upper,
            },
            {
              "fileformat",
              icons_enabled = true,
            },
          },
          lualine_y = {
            {
              "progress",
              fmt = function()
                return "%P/%L"
              end,
            },
          },
          lualine_z = {
            {
              "location",
              padding = { left = 0, right = 1 },
            },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {
          "neo-tree",
          "lazy",
          "toggleterm",
          "mason",
          "fugitive",
          "oil",
          "trouble",
          "symbols-outline",
        },
      })

      -- Auto-update theme when colorscheme changes
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          require("lualine").setup({
            options = { theme = "auto" }
          })
        end,
      })
    end,
  },

  -- =============================================================================
  -- BUFFERLINE
  -- =============================================================================
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = "nvim-web-devicons",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Buffer Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
    opts = {
      options = {
        mode = "buffers",
        themable = true,
        numbers = "none",
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        indicator = {
          icon = "▎",
          style = "icon",
        },
        buffer_close_icon = "󰅖",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 30,
        max_prefix_length = 30,
        truncate_names = true,
        tab_size = 21,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        show_duplicate_prefix = true,
        persist_buffer_sort = true,
        move_wraps_at_ends = false,
        separator_style = "slant",
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        hover = {
          enabled = true,
          delay = 200,
          reveal = {'close'}
        },
        sort_by = "insert_after_current",
        offsets = {
          {
            filetype = "neo-tree",
            text = " File Explorer",
            text_align = "left",
            separator = true,
          },
          {
            filetype = "Outline",
            text = " Symbols Outline",
            text_align = "left",
            separator = true,
          },
        },
        custom_filter = function(buf_number, buf_numbers)
          -- Filter out filetypes you don't want to see
          local filetype = vim.bo[buf_number].filetype
          if filetype == "qf" or filetype == "fugitive" or filetype == "git" then
            return false
          end
          
          -- Filter out by buffer name
          local name = vim.fn.bufname(buf_number)
          if name:match("%.git/") then
            return false
          end
          
          return true
        end,
      },
      highlights = (function()
        local ok, catppuccin = pcall(require, "catppuccin.groups.integrations.bufferline")
        if ok then
          return catppuccin.get()
        else
          return {}
        end
      end)(),
    },
  },

  -- =============================================================================
  -- WHICH-KEY
  -- =============================================================================
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    opts = {
      preset = "modern",
      delay = 200,
      filter = function(mapping)
        -- Filter out some basic mappings to keep interface clean
        local exclude = { "j", "k", "h", "l", "w", "b", "e", "gg", "G" }
        return not vim.tbl_contains(exclude, mapping.lhs)
      end,
      spec = {
        -- Hide individual plugin keymaps that might conflict
        { "<leader>L", hidden = true },  -- Plugin manager (moved to ui group)
        { "<leader>M", hidden = true },  -- Mason (moved to ui group)
        { "<leader>z", hidden = true },  -- Zen mode (moved to ui group)
        { "<leader>E", hidden = true },  -- Focus explorer (moved to explorer group)
        { "<leader>h", hidden = true },  -- Hide all h submappings
        { "<leader>hl", hidden = true }, -- Hide search highlights (moved to ui group)
        { "<leader>x", hidden = true },  -- Hide misc individual mappings
        { "<leader>~", hidden = true },  -- Hide tilde mappings
      },
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
        ellipsis = "…",
        rules = false,
      },
      layout = {
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "left",
      },
      keys = {
        scroll_down = "<c-d>",
        scroll_up = "<c-u>",
      },
      sort = { "local", "order", "group", "alphanum", "mod" },
      expand = 1,
      replace = {
        key = {
          function(key)
            return require("which-key.view").format(key)
          end,
        },
        desc = {
          { "<Plug>%(?(.*)%)?", "%1" },
          { "^%+", "" },
          { "<[cC]md>", "" },
          { "<[cC][rR]>", "" },
          { "<[sS]ilent>", "" },
          { "^lua%s+", "" },
          { "^call%s+", "" },
          { "^:%s*", "" },
        },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      -- Register clean, organized groups with subcategories
      wk.add({
        -- Main groups with emojis for better visual organization
        { "<leader>f", group = "📁 files" },
        { "<leader>s", group = "🔍 search" },
        { "<leader>p", group = "🚀 project" },
        { "<leader>b", group = "🗂️ buffers" },
        { "<leader>w", group = "🪟 windows" },
        { "<leader>c", group = "💻 code" },
        { "<leader>l", group = "🔧 lsp" },
        { "<leader>g", group = "🔗 git" },
        { "<leader>t", group = "🖥️ terminal" },
        { "<leader>r", group = "🏗️ run/build" },
        { "<leader>q", group = "💾 quit/session" },
        { "<leader>e", group = "📂 explorer" },
        { "<leader>u", group = "🎨 ui/utilities" },
        { "<leader>d", group = "🐛 debug" },
        { "<leader>n", group = "📝 notes" },
        { "<leader>m", group = "🧪 testing" },
        { "<leader><tab>", group = "📑 tabs" },
        
        -- Project subcategories
        { "<leader>pm", group = "📋 manage" },
        { "<leader>pf", group = "📁 files" },
        { "<leader>pn", group = "🧭 navigate" },
        
        -- Navigation groups  
        { "g", group = "goto" },
        { "]", group = "next" },
        { "[", group = "prev" },
      })
    end,
  },

  -- =============================================================================
  -- NOTIFICATIONS
  -- =============================================================================
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss All Notifications",
      },
    },
    opts = {
      background_colour = function()
        local ok, catppuccin = pcall(require, "catppuccin.palettes")
        if ok then
          return catppuccin.get_palette("mocha").base
        else
          return "#1e1e2e"
        end
      end,
      fps = 30,
      icons = {
        DEBUG = "",
        ERROR = "",
        INFO = "",
        TRACE = "✎",
        WARN = ""
      },
      level = 2,
      minimum_width = 50,
      render = "wrapped-compact",
      stages = "fade_in_slide_out",
      time_formats = {
        notification = "%T",
        notification_history = "%FT%T"
      },
      timeout = 5000,
      top_down = true,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require("notify")
    end,
  },

  -- =============================================================================
  -- ENHANCED UI COMPONENTS
  -- =============================================================================
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
      messages = {
        enabled = true,
        view = "notify",
        view_error = "notify",
        view_warn = "notify",
        view_history = "messages",
        view_search = "virtualtext",
      },
      popupmenu = {
        enabled = true,
        backend = "nui",
        kind_icons = {},
      },
      redirect = {
        view = "popup",
        filter = { event = "msg_show" },
      },
      commands = {
        history = {
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {
            any = {
              { event = "notify" },
              { error = true },
              { warning = true },
              { event = "msg_show", kind = { "" } },
              { event = "lsp", kind = "message" },
            },
          },
        },
        last = {
          view = "popup",
          opts = { enter = true, format = "details" },
          filter = {
            any = {
              { event = "notify" },
              { error = true },
              { warning = true },
              { event = "msg_show", kind = { "" } },
              { event = "lsp", kind = "message" },
            },
          },
          filter_opts = { count = 1 },
        },
        errors = {
          view = "popup",
          opts = { enter = true, format = "details" },
          filter = { error = true },
          filter_opts = { reverse = true },
        },
      },
      notify = {
        enabled = true,
        view = "notify",
      },
      lsp_doc_border = false,
    },
    keys = {
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>nl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>nh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>na", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>nd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"}},
    },
  },

  -- =============================================================================
  -- IMPROVED DRESSING
  -- =============================================================================
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
    opts = {
      input = {
        enabled = true,
        default_prompt = "Input",
        trim_prompt = true,
        title_pos = "left",
        insert_only = true,
        start_in_insert = true,
        border = "rounded",
        relative = "cursor",
        prefer_width = 40,
        width = nil,
        max_width = { 140, 0.9 },
        min_width = { 20, 0.2 },
        buf_options = {},
        win_options = {
          wrap = false,
          list = true,
          listchars = "precedes:…,extends:…",
          sidescrolloff = 0,
        },
        mappings = {
          n = {
            ["<Esc>"] = "Close",
            ["<CR>"] = "Confirm",
          },
          i = {
            ["<C-c>"] = "Close",
            ["<CR>"] = "Confirm",
            ["<Up>"] = "HistoryPrev",
            ["<Down>"] = "HistoryNext",
          },
        },
        override = function(conf)
          conf.col = -1
          conf.row = 0
          return conf
        end,
        get_config = nil,
      },
      select = {
        enabled = true,
        backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
        trim_prompt = true,
        telescope = function()
          local themes = require("telescope.themes")
          return themes.get_dropdown()
        end,
        fzf = {
          window = {
            width = 0.5,
            height = 0.4,
          },
        },
        fzf_lua = {
          winopts = {
            height = 0.5,
            width = 0.5,
          },
        },
        nui = {
          position = "50%",
          size = nil,
          relative = "editor",
          border = {
            style = "rounded",
          },
          buf_options = {
            swapfile = false,
            filetype = "DressingSelect",
          },
          win_options = {
            winblend = 0,
          },
          max_width = 80,
          max_height = 40,
          min_width = 40,
          min_height = 10,
        },
        builtin = {
          show_numbers = true,
          border = "rounded",
          relative = "editor",
          buf_options = {},
          win_options = {
            cursorline = true,
            winblend = 0,
          },
          width = nil,
          max_width = { 140, 0.8 },
          min_width = { 40, 0.2 },
          height = nil,
          max_height = 0.9,
          min_height = { 10, 0.2 },
          mappings = {
            ["<Esc>"] = "Close",
            ["<C-c>"] = "Close",
            ["<CR>"] = "Confirm",
          },
          override = function(conf)
            return conf
          end,
        },
        format_item_override = {},
        get_config = nil,
      },
    },
  },

  -- =============================================================================
  -- INDENT GUIDES
  -- =============================================================================
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled = false,
      },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },

  -- =============================================================================
  -- SCROLLBAR
  -- =============================================================================
  {
    "petertriho/nvim-scrollbar",
    event = "BufReadPost",
    opts = {
      show = true,
      show_in_active_only = false,
      set_highlights = true,
      folds = 1000,
      max_lines = false,
      hide_if_all_visible = false,
      throttle_ms = 100,
      handle = {
        text = " ",
        blend = 30,
        color = nil,
        color_nr = nil,
        highlight = "CursorColumn",
        hide_if_all_visible = true,
      },
      marks = {
        Cursor = {
          text = "•",
          priority = 0,
          gui = nil,
          color = nil,
          cterm = nil,
          color_nr = nil,
          highlight = "Normal",
        },
        Search = {
          text = { "-", "=" },
          priority = 1,
          gui = nil,
          color = nil,
          cterm = nil,
          color_nr = nil,
          highlight = "Search",
        },
        Error = {
          text = { "-", "=" },
          priority = 2,
          gui = nil,
          color = nil,
          cterm = nil,
          color_nr = nil,
          highlight = "DiagnosticVirtualTextError",
        },
        Warn = {
          text = { "-", "=" },
          priority = 3,
          gui = nil,
          color = nil,
          cterm = nil,
          color_nr = nil,
          highlight = "DiagnosticVirtualTextWarn",
        },
        Info = {
          text = { "-", "=" },
          priority = 4,
          gui = nil,
          color = nil,
          cterm = nil,
          color_nr = nil,
          highlight = "DiagnosticVirtualTextInfo",
        },
        Hint = {
          text = { "-", "=" },
          priority = 5,
          gui = nil,
          color = nil,
          cterm = nil,
          color_nr = nil,
          highlight = "DiagnosticVirtualTextHint",
        },
        Misc = {
          text = { "-", "=" },
          priority = 6,
          gui = nil,
          color = nil,
          cterm = nil,
          color_nr = nil,
          highlight = "Normal",
        },
        GitAdd = {
          text = "┆",
          priority = 7,
          gui = nil,
          color = nil,
          cterm = nil,
          color_nr = nil,
          highlight = "GitSignsAdd",
        },
        GitChange = {
          text = "┆",
          priority = 7,
          gui = nil,
          color = nil,
          cterm = nil,
          color_nr = nil,
          highlight = "GitSignsChange",
        },
        GitDelete = {
          text = "▁",
          priority = 7,
          gui = nil,
          color = nil,
          cterm = nil,
          color_nr = nil,
          highlight = "GitSignsDelete",
        },
      },
      excluded_buftypes = {
        "terminal",
      },
      excluded_filetypes = {
        "cmp_docs",
        "cmp_menu",
        "noice",
        "prompt",
        "TelescopePrompt",
        "alpha",
      },
      autocmd = {
        render = {
          "BufWinEnter",
          "TabEnter",
          "TermEnter",
          "WinEnter",
          "CmdwinLeave",
          "TextChanged",
          "VimResized",
          "WinScrolled",
        },
        clear = {
          "BufWinLeave",
          "TabLeave",
          "TermLeave",
          "WinLeave",
        },
      },
      handlers = {
        cursor = true,
        diagnostic = true,
        gitsigns = true,
        handle = true,
        search = false,
        ale = false,
      },
    },
  },

  -- =============================================================================
  -- PLUGIN STORE - SEARCH AND DISCOVERY
  -- =============================================================================
  {
    -- Plugin store functionality built into TacoVim utilities
    -- No external dependency needed - uses TacoVim.PluginStore
    dir = vim.fn.stdpath("config"),
    name = "tacovim-plugin-store",
    priority = 50,
        config = function()
      -- Initialize Plugin Store functionality with fallback support
      TacoVim.PluginStore = {
        -- Safe UI wrapper functions that create fresh state each time
        _safe_select = function(items, opts, callback)
          -- Ensure we have a clean copy of items for each call
          local clean_items = {}
          if type(items) == "table" then
            for i, item in ipairs(items) do
              clean_items[i] = item
            end
          else
            vim.notify("Plugin Store: Invalid items passed to select", vim.log.levels.ERROR)
            return
          end
          
          -- Ensure opts is a clean table
          local clean_opts = {}
          if type(opts) == "table" then
            for k, v in pairs(opts) do
              clean_opts[k] = v
            end
          end
          
          -- Wrap callback to ensure it's safe
          local safe_callback = function(choice)
            if callback and type(callback) == "function" then
              pcall(callback, choice)
            end
          end
          
          local ok, _ = pcall(vim.ui.select, clean_items, clean_opts, safe_callback)
          if not ok then
            vim.notify("Plugin Store UI error - using fallback", vim.log.levels.WARN)
            if callback and clean_items[1] then
              pcall(callback, clean_items[1])
            end
          end
        end,
        
        _safe_input = function(opts, callback)
          local clean_opts = {}
          if type(opts) == "table" then
            for k, v in pairs(opts) do
              clean_opts[k] = v
            end
          end
          
          local safe_callback = function(input)
            if callback and type(callback) == "function" then
              pcall(callback, input)
            end
          end
          
          local ok, _ = pcall(vim.ui.input, clean_opts, safe_callback)
          if not ok then
            vim.notify("Plugin Store: Input not available", vim.log.levels.WARN)
          end
        end,

        -- Get fresh plugin database each time to avoid state corruption
        _get_plugins_db = function()
          return {
            -- Core/Essential
            { name = "telescope.nvim", desc = "Fuzzy finder and live grep", category = "search", stars = "12k+" },
            { name = "nvim-treesitter", desc = "Syntax highlighting", category = "syntax", stars = "8k+" },
            { name = "nvim-lspconfig", desc = "LSP configurations", category = "lsp", stars = "8k+" },
            { name = "nvim-cmp", desc = "Completion engine", category = "completion", stars = "6k+" },
            { name = "which-key.nvim", desc = "Keymap helper", category = "ui", stars = "4k+" },
            
            -- File Management
            { name = "nvim-tree.lua", desc = "File explorer", category = "files", stars = "6k+" },
            { name = "neo-tree.nvim", desc = "Modern file explorer", category = "files", stars = "3k+" },
            { name = "oil.nvim", desc = "File manager as buffer", category = "files", stars = "2k+" },
            
            -- UI Enhancement
            { name = "lualine.nvim", desc = "Status line", category = "ui", stars = "5k+" },
            { name = "bufferline.nvim", desc = "Buffer line", category = "ui", stars = "3k+" },
            { name = "alpha-nvim", desc = "Start screen", category = "ui", stars = "1.5k+" },
            { name = "noice.nvim", desc = "UI replacement", category = "ui", stars = "3k+" },
            { name = "notify.nvim", desc = "Notification manager", category = "ui", stars = "2.5k+" },
            
            -- Git Integration
            { name = "gitsigns.nvim", desc = "Git decorations", category = "git", stars = "4k+" },
            { name = "neogit", desc = "Git interface", category = "git", stars = "3k+" },
            { name = "diffview.nvim", desc = "Git diff viewer", category = "git", stars = "3k+" },
            { name = "fugitive.vim", desc = "Git wrapper", category = "git", stars = "18k+" },
            
            -- Editing & Text
            { name = "nvim-autopairs", desc = "Auto pairs", category = "editing", stars = "2.5k+" },
            { name = "nvim-surround", desc = "Surround text objects", category = "editing", stars = "2.5k+" },
            { name = "comment.nvim", desc = "Smart commenting", category = "editing", stars = "3k+" },
            { name = "indent-blankline.nvim", desc = "Indent guides", category = "editing", stars = "3.5k+" },
            
            -- Terminal & Tasks
            { name = "toggleterm.nvim", desc = "Terminal manager", category = "terminal", stars = "3k+" },
            { name = "overseer.nvim", desc = "Task runner", category = "tasks", stars = "1k+" },
            
            -- Debugging & Testing
            { name = "nvim-dap", desc = "Debug adapter protocol", category = "debug", stars = "4k+" },
            { name = "neotest", desc = "Testing framework", category = "testing", stars = "1.8k+" },
            
            -- Language Specific
            { name = "rustaceanvim", desc = "Rust support", category = "rust", stars = "1k+" },
            { name = "typescript.nvim", desc = "TypeScript utilities", category = "typescript", stars = "800+" },
            { name = "go.nvim", desc = "Go development", category = "go", stars = "1.5k+" },
            
            -- Colorschemes
            { name = "catppuccin/nvim", desc = "Catppuccin theme", category = "colorscheme", stars = "4k+" },
            { name = "folke/tokyonight.nvim", desc = "Tokyo Night theme", category = "colorscheme", stars = "5k+" },
            { name = "ellisonleao/gruvbox.nvim", desc = "Gruvbox theme", category = "colorscheme", stars = "1.5k+" },
            { name = "rose-pine/neovim", desc = "Rose Pine theme", category = "colorscheme", stars = "1.8k+" },
          }
        end,
         -- Search for plugins
         search = function()
                      TacoVim.PluginStore._safe_input({
             prompt = "🔍 Search plugins: ",
           }, function(query)
             if query and query ~= "" then
               -- Get fresh plugin database to avoid state corruption
               local plugins_db = TacoVim.PluginStore._get_plugins_db()
              
              -- Filter results based on query
              local filtered = {}
              local query_lower = string.lower(query)
              for _, plugin in ipairs(plugins_db) do
                local name_match = string.find(string.lower(plugin.name), query_lower)
                local desc_match = string.find(string.lower(plugin.desc), query_lower)
                local cat_match = string.find(string.lower(plugin.category), query_lower)
                
                if name_match or desc_match or cat_match then
                  table.insert(filtered, plugin)
                end
              end
              
                             if #filtered > 0 then
                 TacoVim.PluginStore._safe_select(filtered, {
                   prompt = "📦 Plugin Results (" .. #filtered .. " found):",
                   format_item = function(plugin)
                     return string.format("  %s ⭐%s - %s", plugin.name, plugin.stars, plugin.desc)
                   end,
                 }, function(choice)
                   if choice then
                     TacoVim.PluginStore.show_plugin_details(choice)
                   end
                 end)
               else
                 vim.notify("No plugins found for: " .. query, vim.log.levels.WARN)
               end
             end
           end)
         end,

                 -- Show plugin details and installation
         show_plugin_details = function(plugin)
           local actions = {
             "📋 Copy Installation Code",
             "🔗 Open GitHub Repository", 
             "📚 View Documentation",
             "⬅️ Back to Search"
           }
           
           local plugin_name = plugin.name or "unknown"
           local plugin_desc = plugin.desc or ""
           
           TacoVim.PluginStore._safe_select(actions, {
             prompt = "📦 " .. plugin_name .. " - " .. plugin_desc,
             format_item = function(item) return "  " .. item end,
           }, function(action)
             if not action then return end
             
             if action:match("Copy Installation") then
               local install_code = string.format([[
-- Add to your user_config.lua plugins.additional section:
{ "%s", config = function() end },]], plugin_name)
               
               vim.fn.setreg('+', install_code)
               vim.notify("📋 Installation code copied to clipboard!", vim.log.levels.INFO)
               
             elseif action:match("Open GitHub") then
               local url = "https://github.com/" .. plugin_name
               vim.fn.setreg('+', url)
               vim.notify("🔗 GitHub URL copied: " .. url, vim.log.levels.INFO)
               
             elseif action:match("Documentation") then
               vim.notify("📚 Check the plugin's README on GitHub for documentation", vim.log.levels.INFO)
               
             elseif action:match("Back") then
               vim.defer_fn(function()
                 TacoVim.PluginStore.search()
               end, 10)
             end
           end)
         end,

                 -- Browse by categories (completely stateless)
         browse_categories = function()
           -- Create fresh arrays each time to avoid state corruption
           local categories = {
             "🔍 Search & Navigation",
             "🎨 UI & Appearance", 
             "📝 Editing & Text",
             "🔧 Language & LSP",
             "🐛 Debugging & Testing",
             "🔗 Git Integration",
             "🖥️ Terminal & Tasks",
             "🌈 Colorschemes",
             "📁 File Management",
             "⚡ Performance"
           }
           
           -- Create fresh mapping each time
           local category_keys = {
             ["🔍 Search & Navigation"] = "search",
             ["🎨 UI & Appearance"] = "ui",
             ["📝 Editing & Text"] = "editing", 
             ["🔧 Language & LSP"] = "lsp",
             ["🐛 Debugging & Testing"] = "debug",
             ["🔗 Git Integration"] = "git",
             ["🖥️ Terminal & Tasks"] = "terminal",
             ["🌈 Colorschemes"] = "colorscheme",
             ["📁 File Management"] = "files",
             ["⚡ Performance"] = "performance"
           }
           
           TacoVim.PluginStore._safe_select(categories, {
             prompt = "📂 Browse Plugin Categories:",
             format_item = function(item) return "  " .. item end,
           }, function(choice)
             if choice then
               local key = category_keys[choice]
               if key then
                 vim.notify("🔍 Searching for: " .. key, vim.log.levels.INFO)
                 -- Auto-trigger search with category (increased delay for state cleanup)
                 vim.defer_fn(function()
                   TacoVim.PluginStore.search()
                 end, 150)
               end
             end
           end)
         end,

        -- Quick installation helper
                 quick_install = function()
           TacoVim.PluginStore._safe_input({
             prompt = "📦 Plugin to install (user/repo): ",
           }, function(plugin)
            if plugin and plugin ~= "" then
              local install_snippet = string.format([[
-- Add this to your user_config.lua in the plugins.additional section:
{ "%s", 
  config = function()
    -- Plugin configuration goes here
  end 
},]], plugin)
              
              vim.fn.setreg('+', install_snippet)
              vim.notify("📋 Installation snippet copied to clipboard!", vim.log.levels.INFO)
              
              -- Show the snippet in a floating window
              local lines = vim.split(install_snippet, '\n')
              local buf = vim.api.nvim_create_buf(false, true)
              vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
              vim.bo[buf].filetype = 'lua'
              
              local width = math.min(80, vim.o.columns - 4)
              local height = math.min(#lines + 2, vim.o.lines - 4)
              
              local win = vim.api.nvim_open_win(buf, true, {
                relative = 'editor',
                width = width,
                height = height,
                col = (vim.o.columns - width) / 2,
                row = (vim.o.lines - height) / 2,
                style = 'minimal',
                border = 'rounded',
                title = ' 📦 Plugin Installation Code ',
                title_pos = 'center'
              })
              
              -- Close with escape or q
              vim.keymap.set('n', '<Esc>', function() 
                vim.api.nvim_win_close(win, true) 
              end, { buffer = buf })
              vim.keymap.set('n', 'q', function() 
                vim.api.nvim_win_close(win, true) 
              end, { buffer = buf })
            end
          end)
        end,

                 -- Main plugin store interface (completely stateless)
         open = function()
           -- Create fresh options array each time
           local options = {
             "🔍 Search Plugins",
             "📂 Browse Categories", 
             "📦 Quick Install Helper",
             "🔗 Useful Resources",
             "📚 Plugin Documentation"
           }
           
           TacoVim.PluginStore._safe_select(options, {
             prompt = "🏪 TacoVim Plugin Store:",
             format_item = function(item) return "  " .. item end,
           }, function(choice)
               if not choice then return end
               
                            if choice:match("Search") then
               vim.defer_fn(function()
                 TacoVim.PluginStore.search()
               end, 10)
             elseif choice:match("Browse") then
               vim.defer_fn(function()
                 TacoVim.PluginStore.browse_categories()
               end, 10)
             elseif choice:match("Quick Install") then
               vim.defer_fn(function()
                 TacoVim.PluginStore.quick_install()
               end, 10)
                            elseif choice:match("Resources") then
               -- Create fresh resources array each time
               local resources = {
                 "🌟 Awesome Neovim - https://github.com/rockerBOO/awesome-neovim",
                 "📦 Neovim Craft - https://neovimcraft.com/",
                 "🔍 Dotfyle - https://dotfyle.com/plugins",
                 "📚 Neovim Docs - https://neovim.io/doc/",
                 "💬 Reddit r/neovim - https://reddit.com/r/neovim",
                 "💻 This Week in Neovim - https://dotfyle.com/this-week-in-neovim"
               }
                 
                 TacoVim.PluginStore._safe_select(resources, {
                   prompt = "🔗 Useful Plugin Resources:",
                   format_item = function(item) return "  " .. item end,
                 }, function(resource)
                   if resource then
                     local url = resource:match("https://[%S]+")
                     if url then
                       vim.fn.setreg('+', url)
                       vim.notify("🔗 URL copied to clipboard: " .. url, vim.log.levels.INFO)
                     end
                   end
                 end)
               elseif choice:match("Documentation") then
                 pcall(function() vim.cmd("help TacoVim") end)
               end
             end)
                  end,
         
         -- Reset/reinitialize the plugin store if needed
         reset = function()
           vim.notify("🔄 Plugin Store reset", vim.log.levels.INFO)
           -- Simply do a garbage collection to clean up any stale references
           collectgarbage("collect")
         end
       }
       
       -- Create a command to manually reset the plugin store if needed
       vim.api.nvim_create_user_command("PluginStoreReset", function()
         if TacoVim.PluginStore and TacoVim.PluginStore.reset then
           TacoVim.PluginStore.reset()
         end
       end, { desc = "Reset TacoVim Plugin Store" })
     end,
   },
}

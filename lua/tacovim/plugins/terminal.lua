-- ~/.config/nvim/lua/tacovim/plugins/terminal.lua
-- TacoVim Terminal Integration

return {
  -- =============================================================================
  -- TOGGLETERM - ENHANCED TERMINAL
  -- =============================================================================
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm direction=horizontal size=15<cr>", desc = "Toggle Terminal" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float Terminal" },
      { "<leader>th", "<cmd>ToggleTerm size=15 direction=horizontal<cr>", desc = "Horizontal Terminal" },
      { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical Terminal" },
      { "<leader>tt", "<cmd>ToggleTerm direction=tab<cr>", desc = "Tab Terminal" },
      { "<leader>tg", function() _LAZYGIT_TOGGLE() end, desc = "LazyGit" },
      { "<leader>tn", function() _NODE_TOGGLE() end, desc = "Node REPL" },
      { "<leader>tp", function() _PYTHON_TOGGLE() end, desc = "Python REPL" },
      { "<leader>tr", function() _RANGER_TOGGLE() end, desc = "Ranger File Manager" },
      { "<leader>td", function() _DOCKER_TOGGLE() end, desc = "Docker TUI" },
      { "<leader>tk", function() _K9S_TOGGLE() end, desc = "K9s Kubernetes" },
      { "<leader>tm", function() _BTOP_TOGGLE() end, desc = "Btop System Monitor" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<C-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      autochdir = false,
      highlights = {
        Normal = {
          guibg = "NONE",
        },
        NormalFloat = {
          link = "Normal"
        },
        FloatBorder = {
          guifg = "#89b4fa",
          guibg = "NONE",
        },
      },
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = "horizontal",
      close_on_exit = true,
      shell = vim.o.shell,
      auto_scroll = true,
      float_opts = {
        border = "curved",
        width = function()
          return math.min(vim.o.columns - 4, 120)
        end,
        height = function()
          return math.min(vim.o.lines - 4, 30)
        end,
        winblend = 0,
        zindex = 1000,
      },
      winbar = {
        enabled = false,
        name_formatter = function(term)
          return term.name
        end
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      -- Terminal keymaps
      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
        vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
      end

      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

      -- Custom terminal instances
      local Terminal = require('toggleterm.terminal').Terminal

      -- LazyGit integration
      local lazygit = Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        direction = "float",
        float_opts = {
          border = "curved",
        },
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
        on_close = function(term)
          vim.cmd("startinsert!")
        end,
      })

      function _LAZYGIT_TOGGLE()
        lazygit:toggle()
      end

      -- Node.js REPL
      local node = Terminal:new({
        cmd = "node",
        direction = "float",
        float_opts = {
          border = "curved",
        },
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
      })

      function _NODE_TOGGLE()
        node:toggle()
      end

      -- Python REPL
      local python = Terminal:new({
        cmd = "python3",
        direction = "float",
        float_opts = {
          border = "curved",
        },
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
      })

      function _PYTHON_TOGGLE()
        python:toggle()
      end

      -- Ranger file manager
      local ranger = Terminal:new({
        cmd = "ranger",
        direction = "float",
        float_opts = {
          border = "curved",
          width = function()
            return math.min(vim.o.columns - 4, 160)
          end,
          height = function()
            return math.min(vim.o.lines - 4, 40)
          end,
        },
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
      })

      function _RANGER_TOGGLE()
        ranger:toggle()
      end

      -- Docker TUI
      local docker = Terminal:new({
        cmd = "docker",
        direction = "float",
        float_opts = {
          border = "curved",
        },
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
      })

      function _DOCKER_TOGGLE()
        docker:toggle()
      end

      -- K9s Kubernetes
      local k9s = Terminal:new({
        cmd = "k9s",
        direction = "float",
        float_opts = {
          border = "curved",
          width = function()
            return math.min(vim.o.columns - 4, 160)
          end,
          height = function()
            return math.min(vim.o.lines - 4, 40)
          end,
        },
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
      })

      function _K9S_TOGGLE()
        k9s:toggle()
      end

      -- Btop system monitor
      local btop = Terminal:new({
        cmd = "btop",
        direction = "float",
        float_opts = {
          border = "curved",
          width = function()
            return math.min(vim.o.columns - 4, 160)
          end,
          height = function()
            return math.min(vim.o.lines - 4, 40)
          end,
        },
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
      })

      function _BTOP_TOGGLE()
        btop:toggle()
      end

      -- Store terminal utilities in TacoVim namespace
      TacoVim.Terminal = {
        -- Create a new terminal with custom configuration
        new = function(cmd, opts)
          opts = opts or {}
          return Terminal:new(vim.tbl_extend("force", {
            cmd = cmd,
            direction = "float",
            float_opts = { border = "curved" },
            on_open = function(term)
              vim.cmd("startinsert!")
            end,
          }, opts))
        end,

        -- Execute command in terminal
        exec = function(cmd, opts)
          opts = opts or {}
          require("toggleterm").exec(cmd, opts.count, opts.size, opts.dir, opts.direction, opts.name)
        end,

        -- Send command to terminal
        send = function(cmd, terminal_id)
          terminal_id = terminal_id or 1
          require("toggleterm").send_lines_to_terminal("single_line", true, { cmd })
        end,

        -- Toggle specific terminal by ID
        toggle = function(id, size, direction)
          require("toggleterm").toggle(id, size, direction)
        end,
      }
    end,
  },

  -- =============================================================================
  -- FZF-LUA INTEGRATION FOR TERMINAL
  -- =============================================================================
  {
    "ibhagwan/fzf-lua",
    optional = true,
    keys = {
      { "<leader>ft", function() require("fzf-lua").live_grep({ cmd = "rg --column --line-number --no-heading --color=always --smart-case" }) end, desc = "Live Grep with FZF" },
    },
  },

  -- =============================================================================
  -- TERMINAL FILE MANAGER INTEGRATION
  -- =============================================================================
  {
    "is0n/fm-nvim",
    keys = {
      { "<leader>fm", function() require("fm-nvim").Ranger() end, desc = "Ranger" },
      { "<leader>fn", function() require("fm-nvim").Nnn() end, desc = "Nnn" },
      { "<leader>fl", function() require("fm-nvim").Lf() end, desc = "Lf" },
      { "<leader>fx", function() require("fm-nvim").Xplr() end, desc = "Xplr" },
    },
    opts = {
      ui = {
        default = "float",
        float = {
          border = "rounded",
          float_hl = "Normal",
          border_hl = "FloatBorder",
          blend = 0,
          height = 0.8,
          width = 0.8,
          x = 0.5,
          y = 0.5,
        },
        split = {
          direction = "topleft",
          size = 24,
        }
      },
      cmds = {
        ranger_cmd = "ranger",
        nnn_cmd = "nnn -P p",
        lf_cmd = "lf",
        xplr_cmd = "xplr",
      },
      mappings = {
        vert_split = "<C-v>",
        horz_split = "<C-h>",
        tabedit = "<C-t>",
        edit = "<C-e>",
        ESC = "<ESC>",
      },
      broot_conf = vim.fn.stdpath("data") .. "/site/pack/packer/start/fm-nvim/assets/broot_conf.hjson",
    },
  },

  -- =============================================================================
  -- TERMINAL SESSION MANAGEMENT
  -- =============================================================================
  {
    "ryanmsnyder/toggleterm-manager.nvim",
    dependencies = {
      "akinsho/toggleterm.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>tm", function() require("toggleterm-manager").open() end, desc = "Terminal Manager" },
    },
    opts = {
      mappings = {
        i = {
          ["<CR>"] = { action = require("toggleterm-manager.actions").toggle_term, exit_on_action = false },
          ["<C-i>"] = { action = require("toggleterm-manager.actions").create_term, exit_on_action = false },
          ["<C-d>"] = { action = require("toggleterm-manager.actions").delete_term, exit_on_action = false },
          ["<C-r>"] = { action = require("toggleterm-manager.actions").rename_term, exit_on_action = false },
        },
        n = {
          ["<CR>"] = { action = require("toggleterm-manager.actions").toggle_term, exit_on_action = false },
          ["i"] = { action = require("toggleterm-manager.actions").create_term, exit_on_action = false },
          ["d"] = { action = require("toggleterm-manager.actions").delete_term, exit_on_action = false },
          ["r"] = { action = require("toggleterm-manager.actions").rename_term, exit_on_action = false },
        },
      },
      titles = {
        preview = "Preview",
        prompt = " Terminals",
        results = "Results",
      },
    },
    config = function(_, opts)
      require("toggleterm-manager").setup(opts)
      require("telescope").load_extension("toggleterm_manager")
    end,
  },

  -- =============================================================================
  -- TMUX INTEGRATION
  -- =============================================================================
  {
    "alexghergh/nvim-tmux-navigation",
    cond = function()
      return vim.env.TMUX ~= nil
    end,
    keys = {
      { "<C-h>", function() require("nvim-tmux-navigation").NvimTmuxNavigateLeft() end, desc = "Navigate Left" },
      { "<C-j>", function() require("nvim-tmux-navigation").NvimTmuxNavigateDown() end, desc = "Navigate Down" },
      { "<C-k>", function() require("nvim-tmux-navigation").NvimTmuxNavigateUp() end, desc = "Navigate Up" },
      { "<C-l>", function() require("nvim-tmux-navigation").NvimTmuxNavigateRight() end, desc = "Navigate Right" },
      { "<C-\\>", function() require("nvim-tmux-navigation").NvimTmuxNavigateLastActive() end, desc = "Navigate Last Active" },
      { "<C-Space>", function() require("nvim-tmux-navigation").NvimTmuxNavigateNext() end, desc = "Navigate Next" },
    },
    opts = {
      disable_when_zoomed = true,
      keybindings = {
        left = "<C-h>",
        down = "<C-j>",
        up = "<C-k>",
        right = "<C-l>",
        last_active = "<C-\\>",
        next = "<C-Space>",
      },
    },
  },

  -- =============================================================================
  -- KITTY INTEGRATION
  -- =============================================================================
  {
    "knubie/vim-kitty-navigator",
    cond = function()
      return vim.env.TERM == "xterm-kitty"
    end,
    build = {
      "cp ./*.py ~/.config/kitty/",
    },
    keys = {
      { "<C-j>", function() vim.cmd("KittyNavigateDown") end, desc = "Kitty Navigate Down" },
      { "<C-k>", function() vim.cmd("KittyNavigateUp") end, desc = "Kitty Navigate Up" },
      { "<C-h>", function() vim.cmd("KittyNavigateLeft") end, desc = "Kitty Navigate Left" },
      { "<C-l>", function() vim.cmd("KittyNavigateRight") end, desc = "Kitty Navigate Right" },
    },
    init = function()
      vim.g.kitty_navigator_no_mappings = 1
    end,
  },

  -- =============================================================================
  -- WEZTERM INTEGRATION
  -- =============================================================================
  {
    "willothy/wezterm.nvim",
    cond = function()
      return vim.env.TERM_PROGRAM == "WezTerm"
    end,
    keys = {
      { "<leader>Wt", function() require("wezterm").switch_tab.index(1) end, desc = "Switch to tab 1" },
      { "<leader>Wn", function() require("wezterm").switch_tab.relative(1) end, desc = "Switch to next tab" },
      { "<leader>Wp", function() require("wezterm").switch_tab.relative(-1) end, desc = "Switch to prev tab" },
    },
    opts = {
      create_commands = true,
      multiplexer = "wezterm",
    },
  },

  -- =============================================================================
  -- ENHANCED TERMINAL UTILITIES
  -- =============================================================================
  {
    "chomosuke/term-edit.nvim",
    ft = "toggleterm",
    version = "1.*",
    opts = {
      prompt_end = "%$ ",
      mapping = {
        n = {
          s = false,
          S = false,
          ["<C-s>"] = require("term-edit").send_lines,
          ["<C-S>"] = require("term-edit").send_lines_split,
        },
        x = {
          s = false,
          S = false,
          ["<C-s>"] = require("term-edit").send_selection,
          ["<C-S>"] = require("term-edit").send_selection_split,
        },
      },
    },
  },

  -- =============================================================================
  -- ZELLIJ INTEGRATION
  -- =============================================================================
  {
    "swaits/zellij-nav.nvim",
    lazy = true,
    event = "VeryLazy",
    cond = function()
      return vim.env.ZELLIJ ~= nil
    end,
    keys = {
      { "<c-h>", "<cmd>ZellijNavigateLeft<cr>", { silent = true, desc = "navigate left" } },
      { "<c-j>", "<cmd>ZellijNavigateDown<cr>", { silent = true, desc = "navigate down" } },
      { "<c-k>", "<cmd>ZellijNavigateUp<cr>", { silent = true, desc = "navigate up" } },
      { "<c-l>", "<cmd>ZellijNavigateRight<cr>", { silent = true, desc = "navigate right" } },
    },
    opts = {},
  },

  -- =============================================================================
  -- TERMINAL PRODUCTIVITY ENHANCEMENTS
  -- =============================================================================
  {
    "akinsho/git-conflict.nvim",
    optional = true,
    opts = function(_, opts)
      -- Add terminal commands for git conflict resolution
      opts.default_commands = true
      return opts
    end,
  },

  -- =============================================================================
  -- SHELL INTEGRATION
  -- =============================================================================
  {
    "akinsho/nvim-bufferline.lua",
    optional = true,
    opts = function(_, opts)
      -- Don't show terminal buffers in bufferline by default
      opts.options = opts.options or {}
      opts.options.custom_filter = function(buf_number, buf_numbers)
        local buf_name = vim.fn.bufname(buf_number)
        if buf_name:match("^term://") then
          return false
        end
        return true
      end
      return opts
    end,
  },
}

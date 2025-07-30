-- ~/.config/nvim/lua/tacovim/plugins/search.lua
-- TacoVim Search and Replace Tools

return {
  -- =============================================================================
  -- SPECTRE - SEARCH AND REPLACE
  -- =============================================================================
  {
    "nvim-pack/nvim-spectre",
    build = false,
    cmd = "Spectre",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>sr", function() require("spectre").toggle() end, desc = "Replace in Files (Spectre)" },
      { "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end, desc = "Search Current Word", mode = "v" },
      { "<leader>sf", function() require("spectre").open_file_search({ select_word = true }) end, desc = "Search in Current File" },
      { "<leader>sp", function() require("spectre").open_visual() end, desc = "Search Selected Text", mode = "v" },
    },
    opts = {
      color_devicons = true,
      open_cmd = "vnew",
      live_update = false,
      line_sep_start = "┌-----------------------------------------",
      result_padding = "¦  ",
      line_sep = "└-----------------------------------------",
      highlight = {
        ui = "String",
        search = "DiffChange",
        replace = "DiffDelete"
      },
      mapping = {
        ["toggle_line"] = {
          map = "dd",
          cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
          desc = "toggle current item"
        },
        ["enter_file"] = {
          map = "<cr>",
          cmd = "<cmd>lua require('spectre').enter_file()<CR>",
          desc = "goto current file"
        },
        ["send_to_qf"] = {
          map = "<leader>q",
          cmd = "<cmd>lua require('spectre').send_to_qf()<CR>",
          desc = "send all items to quickfix"
        },
        ["replace_cmd"] = {
          map = "<leader>c",
          cmd = "<cmd>lua require('spectre').replace_cmd()<CR>",
          desc = "input replace command"
        },
        ["show_option_menu"] = {
          map = "<leader>o",
          cmd = "<cmd>lua require('spectre').show_options()<CR>",
          desc = "show options"
        },
        ["run_current_replace"] = {
          map = "<leader>rc",
          cmd = "<cmd>lua require('spectre').run_current_replace()<CR>",
          desc = "replace current line"
        },
        ["run_replace"] = {
          map = "<leader>R",
          cmd = "<cmd>lua require('spectre').run_replace()<CR>",
          desc = "replace all"
        },
        ["change_view_mode"] = {
          map = "<leader>v",
          cmd = "<cmd>lua require('spectre').change_view()<CR>",
          desc = "change result view mode"
        },
        ["change_replace_sed"] = {
          map = "trs",
          cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
          desc = "use sed to replace"
        },
        ["change_replace_oxi"] = {
          map = "tro",
          cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
          desc = "use oxi to replace"
        },
        ["toggle_live_update"] = {
          map = "tu",
          cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
          desc = "update when vim writes to file"
        },
        ["toggle_ignore_case"] = {
          map = "ti",
          cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
          desc = "toggle ignore case"
        },
        ["toggle_ignore_hidden"] = {
          map = "th",
          cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
          desc = "toggle search hidden"
        },
        ["resume_last_search"] = {
          map = "<leader>l",
          cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
          desc = "resume last search"
        },
      },
      find_engine = {
        ["rg"] = {
          cmd = "rg",
          args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
          },
          options = {
            ["ignore-case"] = {
              value = "--ignore-case",
              icon = "[I]",
              desc = "ignore case"
            },
            ["hidden"] = {
              value = "--hidden",
              desc = "hidden file",
              icon = "[H]"
            },
          }
        },
        ["ag"] = {
          cmd = "ag",
          args = {
            "--vimgrep",
            "-s"
          },
          options = {
            ["ignore-case"] = {
              value = "-i",
              icon = "[I]",
              desc = "ignore case"
            },
            ["hidden"] = {
              value = "--hidden",
              desc = "hidden file",
              icon = "[H]"
            },
          },
        },
      },
      replace_engine = {
        ["sed"] = {
          cmd = "sed",
          args = nil,
          options = {
            ["ignore-case"] = {
              value = "--ignore-case",
              icon = "[I]",
              desc = "ignore case"
            },
          }
        },
        ["oxi"] = {
          cmd = "oxi",
          args = {},
          options = {
            ["ignore-case"] = {
              value = "i",
              icon = "[I]",
              desc = "ignore case"
            },
          }
        },
      },
      default = {
        find = {
          cmd = "rg",
          options = { "ignore-case" }
        },
        replace = {
          cmd = "sed"
        }
      },
      replace_vim_cmd = "cdo",
      is_open = false,
      is_insert_mode = false,
    },
    config = function(_, opts)
      require("spectre").setup(opts)
    end,
  },

  -- =============================================================================
  -- GRUG-FAR - FAST SEARCH AND REPLACE
  -- =============================================================================
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            }
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },

  -- =============================================================================
  -- HLSLENS - ENHANCED SEARCH
  -- =============================================================================
  {
    "kevinhwang91/nvim-hlslens",
    keys = {
      { "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]] },
      { "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]] },
      { "*", [[*<Cmd>lua require('hlslens').start()<CR>]] },
      { "#", [[#<Cmd>lua require('hlslens').start()<CR>]] },
      { "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]] },
      { "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]] },
      { "<leader>hl", "<Cmd>noh<CR>", desc = "Clear Search Highlights" },
    },
    opts = {
      build_position_cb = function(plist, _, _, _)
        require("scrollbar.handlers.search").handler.show(plist.start_pos)
      end,
    },
    config = function(_, opts)
      require("hlslens").setup(opts)

      -- Integration with scrollbar
      local kopts = { noremap = true, silent = true }

      vim.api.nvim_set_keymap("n", "n",
        [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts)
      vim.api.nvim_set_keymap("n", "N",
        [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
        kopts)
      vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
      vim.api.nvim_set_keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

      vim.api.nvim_set_keymap("n", "<Leader>l", "<Cmd>noh<CR>", kopts)
    end,
  },

  -- =============================================================================
  -- SEARCH BOX - ENHANCED SEARCH UI
  -- =============================================================================
  {
    "VonHeikemen/searchbox.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim"
    },
    keys = {
      { "<leader>sb", "<cmd>SearchBoxIncSearch<cr>", desc = "Incremental Search" },
      { "<leader>sB", "<cmd>SearchBoxMatchAll<cr>", desc = "Match All" },
      { "<leader>sr", "<cmd>SearchBoxReplace<cr>", desc = "Search Replace" },
      { "<leader>sR", "<cmd>SearchBoxReplace confirm=menu<cr>", desc = "Search Replace (Confirm)" },
    },
    opts = {
      popup = {
        relative = "win",
        position = {
          row = "5%",
          col = "95%",
        },
        size = 30,
        border = {
          style = "rounded",
          text = {
            top = " Search ",
            top_align = "center",
          },
        },
        win_options = {
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        },
      },
      hooks = {
        before_mount = function(input)
          -- Map escape to close
          input:map("i", "<Esc>", input.input_props.on_close, { noremap = true })
        end,
      },
    },
  },

  -- =============================================================================
  -- MULTICURSOR AND SELECTION
  -- =============================================================================
  {
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvimtools/hydra.nvim",
    },
    opts = {},
    cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
    keys = {
      {
        mode = { "v", "n" },
        "<Leader>m",
        "<cmd>MCstart<cr>",
        desc = "Create a selection for selected text or word under the cursor",
      },
    },
  },

  -- =============================================================================
  -- RANGE HIGHLIGHT
  -- =============================================================================
  {
    "winston0410/range-highlight.nvim",
    dependencies = { "winston0410/cmd-parser.nvim" },
    event = "CmdlineEnter",
    opts = {},
  },

  -- =============================================================================
  -- PORTAL - QUICK JUMPS
  -- =============================================================================
  {
    "cbochs/portal.nvim",
    dependencies = {
      "cbochs/grapple.nvim",
      "ThePrimeagen/harpoon",
    },
    keys = {
      { "<leader>po", "<cmd>Portal jumplist backward<cr>", desc = "Portal Jump Backward" },
      { "<leader>pi", "<cmd>Portal jumplist forward<cr>", desc = "Portal Jump Forward" },
      { "<leader>ph", "<cmd>Portal harpoon backward<cr>", desc = "Portal Harpoon Backward" },
      { "<leader>pl", "<cmd>Portal harpoon forward<cr>", desc = "Portal Harpoon Forward" },
    },
    opts = {
      window_options = {
        relative = "cursor",
        width = 80,
        height = 16,
        col = 2,
        focusable = false,
        border = "single",
        noautocmd = true,
      },
      labels = { "j", "k", "h", "l" },
      escape = {
        ["<esc>"] = true,
      },
    },
  },

  -- =============================================================================
  -- REGEX EXPLAINER
  -- =============================================================================
  {
    "bennypowers/nvim-regexplainer",
    event = "BufRead",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      mode = "narrative", -- 'narrative'
      auto = false,
      filetypes = {
        "html",
        "js",
        "cjs",
        "mjs",
        "ts",
        "jsx",
        "tsx",
        "cjsx",
        "mjsx",
      },
      debug = false,
      display = "popup",
      mappings = {
        toggle = "gR",
        show = "gS",
        hide = "gH",
        show_split = "gP",
        show_popup = "gU",
      },
      narrative = {
        separator = "\n",
      },
    },
    keys = {
      { "gR", desc = "Toggle Regex Explainer" },
      { "gS", desc = "Show Regex Explanation" },
      { "gH", desc = "Hide Regex Explanation" },
      { "gP", desc = "Show Regex Explanation in Split" },
      { "gU", desc = "Show Regex Explanation in Popup" },
    },
  },

  -- =============================================================================
  -- SUBSTITUTE - ENHANCED SUBSTITUTION
  -- =============================================================================
  {
    "gbprod/substitute.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_substitute = nil,
      yank_substituted_text = false,
      preserve_cursor_position = false,
      modifiers = nil,
      highlight_substituted_text = {
        enabled = true,
        timer = 500,
      },
      range = {
        prefix = "s",
        prompt_current_text = false,
        confirm = false,
        complete_word = false,
        subject = nil,
        range = nil,
        suffix = "",
      },
      exchange = {
        motion = false,
        use_esc_to_cancel = true,
        preserve_cursor_position = false,
      },
    },
    keys = {
      { "s", function() require("substitute").operator() end, desc = "Substitute with motion" },
      { "ss", function() require("substitute").line() end, desc = "Substitute line" },
      { "S", function() require("substitute").eol() end, desc = "Substitute to end of line" },
      { "s", function() require("substitute").visual() end, mode = "x", desc = "Substitute in visual mode" },
      
      -- Exchange
      { "sx", function() require("substitute.exchange").operator() end, desc = "Exchange with motion" },
      { "sxx", function() require("substitute.exchange").line() end, desc = "Exchange line" },
      { "X", function() require("substitute.exchange").visual() end, mode = "x", desc = "Exchange in visual mode" },
      { "sxc", function() require("substitute.exchange").cancel() end, desc = "Cancel exchange" },
    },
  },

  -- =============================================================================
  -- REPLACER - QUICKFIX REPLACEMENTS
  -- =============================================================================
  {
    "gabrielpoca/replacer.nvim",
    keys = {
      {
        "<leader>qr",
        function()
          require("replacer").run()
        end,
        desc = "Replace in Quickfix",
      },
    },
    opts = {
      rename_files = true,
    },
  },

  -- =============================================================================
  -- VISUAL MULTI ENHANCED
  -- =============================================================================
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    init = function()
      vim.g.VM_default_mappings = 0
      vim.g.VM_maps = {
        ["Find Under"] = "",
        ["Find Subword Under"] = "",
        ["Select All"] = "",
        ["Start Regex Search"] = "",
        ["Add Cursor Down"] = "<M-Down>",
        ["Add Cursor Up"] = "<M-Up>",
        ["Add Cursor At Pos"] = "<M-i>",
        ["Visual Regex"] = "<M-/>",
        ["Visual All"] = "<M-a>",
        ["Visual Add"] = "<M-m>",
        ["Visual Find"] = "<M-f>",
        ["Visual Cursors"] = "<M-c>",
      }
      vim.g.VM_custom_remaps = {
        ["<C-p>"] = "[",
        ["<C-n>"] = "]",
      }
    end,
    keys = {
      { "<M-n>", desc = "Add cursor and move to next match" },
      { "<M-N>", desc = "Add cursor and move to previous match" },
      { "<C-n>", desc = "Select next occurrence" },
      { "<M-Down>", desc = "Add cursor below" },
      { "<M-Up>", desc = "Add cursor above" },
      { "<M-i>", desc = "Add cursor at position" },
      { "<M-a>", mode = "v", desc = "Select all occurrences" },
      { "<M-m>", mode = "v", desc = "Add visual cursors" },
      { "<M-f>", mode = "v", desc = "Find in visual selection" },
      { "<M-c>", mode = "v", desc = "Visual cursors" },
    },
  },
}

-- ~/.config/nvim/lua/tacovim/plugins/colorschemes.lua
-- TacoVim Colorscheme Plugins

return {
  -- =============================================================================
  -- PRIMARY COLORSCHEME - CATPPUCCIN
  -- =============================================================================
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = {
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      show_end_of_buffer = false,
      term_colors = true,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      no_italic = false,
      no_bold = false,
      no_underline = false,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      color_overrides = {},
      custom_highlights = {},
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = false,
        neotree = true,
        treesitter = true,
        telescope = {
          enabled = true,
          style = "nvchad",
        },
        which_key = true,
        mason = true,
        noice = true,
        notify = true,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
        dap = true,
        dap_ui = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
        aerial = true,
        alpha = true,
        barbecue = {
          dim_dirname = true,
          bold_basename = true,
          dim_context = false,
          alt_background = false,
        },
        beacon = true,
        dashboard = true,
        fern = true,
        fidget = true,
        flash = true,
        hop = true,
        indent_blankline = {
          enabled = true,
          scope_color = "",
          colored_indent_levels = false,
        },
        leap = true,
        lsp_trouble = true,
        markdown = true,
        neotest = true,
        overseer = true,
        rainbow_delimiters = true,
        ufo = true,
        vim_sneak = true,
        vimwiki = true,
        illuminate = {
          enabled = true,
          lsp = false,
        },
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
      
      -- Set TacoVim theme
      vim.g.tacovim.theme = "catppuccin-mocha"
    end,
  },

  -- =============================================================================
  -- ALTERNATIVE COLORSCHEMES
  -- =============================================================================
  
  -- Tokyo Night variants
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "night", -- night, storm, day, moon
      light_style = "day",
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "dark",
        floats = "dark",
      },
      sidebars = { "qf", "help", "neo-tree" },
      day_brightness = 0.3,
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = false,
    },
  },

  -- Rose Pine variants
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    opts = {
      variant = "auto", -- auto, main, moon, dawn
      dark_variant = "main",
      bold_vert_split = false,
      dim_nc_background = false,
      disable_background = false,
      disable_float_background = false,
      disable_italics = false,
      groups = {
        background = "base",
        background_nc = "_experimental_nc",
        panel = "surface",
        panel_nc = "base",
        border = "highlight_med",
        comment = "muted",
        link = "iris",
        punctuation = "subtle",
        error = "love",
        hint = "iris",
        info = "foam",
        warn = "gold",
        headings = {
          h1 = "iris",
          h2 = "foam",
          h3 = "rose",
          h4 = "gold",
          h5 = "pine",
          h6 = "foam",
        },
      },
      highlight_groups = {
        ColorColumn = { bg = "rose" },
        CursorLine = { bg = "foam", blend = 10 },
        StatusLine = { fg = "love", bg = "love", blend = 10 },
      },
    },
  },

  -- Kanagawa - elegant and calm
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = {
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      colors = {
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
      },
      overrides = function(colors)
        return {}
      end,
      theme = "wave", -- wave, dragon, lotus
      background = {
        dark = "wave",
        light = "lotus"
      },
    },
  },

  -- Nightfox family
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
    opts = {
      options = {
        compile_path = vim.fn.stdpath("cache") .. "/nightfox",
        compile_file_suffix = "_compiled",
        transparent = false,
        terminal_colors = true,
        dim_inactive = false,
        module_default = true,
        colorblind = {
          enable = false,
          simulate_only = false,
          severity = {
            protan = 0,
            deutan = 0,
            tritan = 0,
          },
        },
        styles = {
          comments = "italic",
          conditionals = "NONE",
          constants = "NONE",
          functions = "NONE",
          keywords = "NONE",
          numbers = "NONE",
          operators = "NONE",
          strings = "NONE",
          types = "NONE",
          variables = "NONE",
        },
        inverse = {
          match_paren = false,
          visual = false,
          search = false,
        },
      },
      palettes = {},
      specs = {},
      groups = {},
    },
  },

  -- Gruvbox Material
  {
    "sainnhe/gruvbox-material",
    lazy = true,
    config = function()
      vim.g.gruvbox_material_background = "medium" -- hard, medium, soft
      vim.g.gruvbox_material_foreground = "material" -- material, mix, original
      vim.g.gruvbox_material_disable_italic_comment = 0
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_enable_bold = 1
      vim.g.gruvbox_material_transparent_background = 0
      vim.g.gruvbox_material_visual = "grey background"
      vim.g.gruvbox_material_menu_selection_background = "grey"
      vim.g.gruvbox_material_sign_column_background = "none"
      vim.g.gruvbox_material_spell_foreground = "colored"
      vim.g.gruvbox_material_ui_contrast = "low"
      vim.g.gruvbox_material_show_eob = 1
      vim.g.gruvbox_material_diagnostic_text_highlight = 0
      vim.g.gruvbox_material_diagnostic_line_highlight = 0
      vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
      vim.g.gruvbox_material_current_word = "grey background"
      vim.g.gruvbox_material_statusline_style = "material"
      vim.g.gruvbox_material_lightline_disable_bold = 0
    end,
  },

  -- Everforest
  {
    "sainnhe/everforest",
    lazy = true,
    config = function()
      vim.g.everforest_background = "medium" -- hard, medium, soft
      vim.g.everforest_foreground = "material" -- material, mix, original
      vim.g.everforest_disable_italic_comment = 0
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_transparent_background = 0
      vim.g.everforest_sign_column_background = "none"
      vim.g.everforest_spell_foreground = "colored"
      vim.g.everforest_ui_contrast = "low"
      vim.g.everforest_show_eob = 1
      vim.g.everforest_diagnostic_text_highlight = 0
      vim.g.everforest_diagnostic_line_highlight = 0
      vim.g.everforest_diagnostic_virtual_text = "colored"
      vim.g.everforest_current_word = "grey background"
    end,
  },

  -- Modern colorschemes
  {
    "Mofiqul/dracula.nvim",
    lazy = true,
    opts = {
      colors = {},
      show_end_of_buffer = true,
      transparent_bg = false,
      lualine_bg_color = "#44475a",
      italic_comment = true,
    },
  },

  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    opts = {
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true,
      contrast = "", -- hard, soft or empty string
      palette_overrides = {},
      overrides = {},
      dim_inactive = false,
      transparent_mode = false,
    },
  },

  {
    "navarasu/onedark.nvim",
    lazy = true,
    opts = {
      style = "dark", -- dark, darker, cool, deep, warm, warmer, light
      transparent = false,
      term_colors = true,
      ending_tildes = false,
      cmp_itemkind_reverse = false,
      toggle_style_key = nil,
      toggle_style_list = {"dark", "darker", "cool", "deep", "warm", "warmer", "light"},
      code_style = {
        comments = "italic",
        keywords = "none",
        functions = "none",
        strings = "none",
        variables = "none"
      },
      lualine = {
        transparent = false,
      },
      colors = {},
      highlights = {},
      diagnostics = {
        darker = true,
        undercurl = true,
        background = true,
      },
    },
  },

  -- Additional modern themes
  {
    "shaunsingh/nord.nvim",
    lazy = true,
    config = function()
      vim.g.nord_contrast = true
      vim.g.nord_borders = false
      vim.g.nord_disable_background = false
      vim.g.nord_italic = true
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_bold = false
    end,
  },

  {
    "marko-cerovac/material.nvim",
    lazy = true,
    opts = {
      contrast = {
        terminal = false,
        sidebars = false,
        floating_windows = false,
        cursor_line = false,
        non_current_windows = false,
        filetypes = {},
      },
      styles = {
        comments = { italic = true },
        strings = { bold = true },
        keywords = { underline = true },
        functions = { bold = true, undercurl = true },
        variables = {},
        operators = {},
        types = {},
      },
      plugins = {
        "dap",
        "gitsigns",
        "indent-blankline",
        "lspsaga",
        "mini",
        "neo-tree",
        "nvim-cmp",
        "nvim-navic",
        "nvim-tree",
        "nvim-web-devicons",
        "telescope",
        "trouble",
        "which-key",
      },
      disable = {
        colored_cursor = false,
        borders = false,
        background = false,
        term_colors = false,
        eob_lines = false
      },
      high_visibility = {
        lighter = false,
        darker = false
      },
      lualine_style = "default",
      async_loading = true,
      custom_colors = nil,
      custom_highlights = {},
    },
  },

  {
    "bluz71/vim-nightfly-colors",
    name = "nightfly",
    lazy = true,
    config = function()
      vim.g.nightflyCursorColor = true
      vim.g.nightflyItalics = true
      vim.g.nightflyNormalFloat = true
      vim.g.nightflyTerminalColors = true
      vim.g.nightflyTransparent = false
      vim.g.nightflyUndercurls = true
      vim.g.nightflyUnderlineMatchParen = true
      vim.g.nightflyVirtualTextColor = true
      vim.g.nightflyWinSeparator = 2
    end,
  },
}

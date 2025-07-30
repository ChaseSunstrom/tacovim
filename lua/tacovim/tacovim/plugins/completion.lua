-- ~/.config/nvim/lua/tacovim/plugins/completion.lua
-- TacoVim Completion and Snippets

return {
  -- =============================================================================
  -- NVIM-CMP - AUTOCOMPLETION ENGINE
  -- =============================================================================
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-emoji",
      "f3fora/cmp-spell",
      "ray-x/cmp-treesitter",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local luasnip = require("luasnip")

      local function has_words_before()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local function border(hl_name)
        return {
          { "╭", hl_name },
          { "─", hl_name },
          { "╮", hl_name },
          { "│", hl_name },
          { "╯", hl_name },
          { "─", hl_name },
          { "╰", hl_name },
          { "│", hl_name },
        }
      end

      return {
        completion = {
          completeopt = "menu,menuone,noinsert",
          keyword_length = 1,
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered({
            border = border("CmpBorder"),
            winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
            col_offset = -3,
            side_padding = 0,
            scrollbar = true,
          }),
          documentation = cmp.config.window.bordered({
            border = border("CmpDocBorder"),
            winhighlight = "Normal:CmpDoc",
            max_height = 15,
            max_width = 60,
          }),
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            local kind = require("lspkind").cmp_format({
              mode = "symbol_text",
              maxwidth = 50,
              ellipsis_char = "...",
              show_labelDetails = true,
              before = function(entry, vim_item)
                return vim_item
              end,
            })(entry, vim_item)
            
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. " "
            kind.menu = "    (" .. (strings[2] or "") .. ")"

            -- Source-specific styling
            if entry.source.name == "nvim_lsp" then
              kind.menu = "    [LSP]"
            elseif entry.source.name == "luasnip" then
              kind.menu = "    [Snippet]"
            elseif entry.source.name == "buffer" then
              kind.menu = "    [Buffer]"
            elseif entry.source.name == "path" then
              kind.menu = "    [Path]"
            elseif entry.source.name == "calc" then
              kind.menu = "    [Calc]"
            elseif entry.source.name == "emoji" then
              kind.menu = "    [Emoji]"
            elseif entry.source.name == "treesitter" then
              kind.menu = "    [TS]"
            end

            return kind
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<S-CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<C-CR>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
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
          { name = "luasnip", priority = 750 },
          { name = "nvim_lua", priority = 500 },
          { name = "nvim_lsp_signature_help", priority = 500 },
        }, {
          { name = "buffer", priority = 250, keyword_length = 3 },
          { name = "path", priority = 250 },
          { name = "treesitter", priority = 200 },
          { name = "calc", priority = 150 },
          { name = "emoji", priority = 100 },
          { name = "spell", priority = 100, keyword_length = 4 },
        }),
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        sorting = defaults.sorting,
        performance = {
          debounce = 60,
          throttle = 30,
          fetching_timeout = 500,
          confirm_resolve_timeout = 80,
          async_budget = 1,
          max_view_entries = 200,
        },
      }
    end,
    config = function(_, opts)
      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end

      local cmp = require("cmp")
      cmp.setup(opts)

      -- Use buffer source for `/` and `?`
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "nvim_lsp_document_symbol" },
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':'
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },

  -- =============================================================================
  -- LUASNIP - SNIPPETS ENGINE
  -- =============================================================================
  {
    "L3MON4D3/LuaSnip",
    build = (function()
      if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
        return
      end
      return "make install_jsregexp"
    end)(),
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
      updateevents = "TextChanged,TextChangedI",
      enable_autosnippets = true,
      ext_opts = {},
    },
    keys = {
      {
        "<tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
      { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
    config = function(_, opts)
      require("luasnip").setup(opts)

      -- Custom snippets for TacoVim
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node

      -- Custom snippets
      ls.add_snippets("lua", {
        s("req", {
          t('local '),
          i(1, "module"),
          t(' = require("'),
          i(2, "module"),
          t('")'),
        }),
        s("func", {
          t("function "),
          i(1, "name"),
          t("("),
          i(2, "args"),
          t({ ")", "  " }),
          i(3, "-- body"),
          t({ "", "end" }),
        }),
      })

      -- Additional filetypes
      ls.add_snippets("javascript", {
        s("log", {
          t("console.log("),
          i(1),
          t(")"),
        }),
        s("func", {
          t("function "),
          i(1, "name"),
          t("("),
          i(2, "args"),
          t({ ") {", "  " }),
          i(3, "// body"),
          t({ "", "}" }),
        }),
      })

      -- Store snippet utilities in TacoVim namespace
      TacoVim.Snippets = {
        -- Expand snippet
        expand = function()
          if ls.expand_or_jumpable() then
            ls.expand_or_jump()
          end
        end,

        -- Jump to next snippet node
        jump_next = function()
          if ls.jumpable(1) then
            ls.jump(1)
          end
        end,

        -- Jump to previous snippet node
        jump_prev = function()
          if ls.jumpable(-1) then
            ls.jump(-1)
          end
        end,

        -- List available snippets
        list_snippets = function()
          local ft = vim.bo.filetype
          local snippets = ls.get_snippets(ft)
          local snippet_list = {}
          for _, snippet in ipairs(snippets) do
            table.insert(snippet_list, {
              trigger = snippet.trigger,
              description = snippet.description or "",
            })
          end
          return snippet_list
        end,
      }
    end,
  },

  -- =============================================================================
  -- ENHANCED CMP SOURCES
  -- =============================================================================

  -- LSP completion
  {
    "hrsh7th/cmp-nvim-lsp",
    dependencies = { "nvim-cmp" },
  },

  -- Buffer completion
  {
    "hrsh7th/cmp-buffer",
    dependencies = { "nvim-cmp" },
  },

  -- Path completion
  {
    "hrsh7th/cmp-path",
    dependencies = { "nvim-cmp" },
  },

  -- Command line completion
  {
    "hrsh7th/cmp-cmdline",
    dependencies = { "nvim-cmp" },
  },

  -- Neovim Lua API completion
  {
    "hrsh7th/cmp-nvim-lua",
    dependencies = { "nvim-cmp" },
    ft = "lua",
  },

  -- LSP signature help
  {
    "hrsh7th/cmp-nvim-lsp-signature-help",
    dependencies = { "nvim-cmp" },
  },

  -- Calculator completion
  {
    "hrsh7th/cmp-calc",
    dependencies = { "nvim-cmp" },
  },

  -- Emoji completion
  {
    "hrsh7th/cmp-emoji",
    dependencies = { "nvim-cmp" },
  },

  -- Spell completion
  {
    "f3fora/cmp-spell",
    dependencies = { "nvim-cmp" },
  },

  -- Treesitter completion
  {
    "ray-x/cmp-treesitter",
    dependencies = { "nvim-cmp", "nvim-treesitter" },
  },

  -- =============================================================================
  -- SNIPPET COLLECTIONS
  -- =============================================================================
  {
    "rafamadriz/friendly-snippets",
    event = "InsertEnter",
  },

  -- =============================================================================
  -- CMP ENHANCEMENT PLUGINS
  -- =============================================================================

  -- Enhanced LSP kind icons
  {
    "onsails/lspkind.nvim",
    opts = {
      mode = "symbol",
      preset = "codicons",
      symbol_map = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "",
      },
    },
    enabled = vim.g.icons_enabled ~= false,
  },

  -- =============================================================================
  -- AUTOPAIRS INTEGRATION
  -- =============================================================================
  {
    "windwp/nvim-autopairs",
    dependencies = { "nvim-cmp" },
    config = function()
      local npairs = require("nvim-autopairs")
      npairs.setup({
        check_ts = true,
        ts_config = {
          lua = { "string", "source" },
          javascript = { "string", "template_string" },
          java = false,
        },
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
      })

      -- Integration with nvim-cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on(
        "confirm_done",
        cmp_autopairs.on_confirm_done()
      )
    end,
  },
}

-- ~/.config/nvim/lua/tacovim/plugins/formatting.lua
-- TacoVim Code Formatting and Linting

return {
  -- =============================================================================
  -- CONFORM - FORMATTING
  -- =============================================================================
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
      {
        "<leader>cF",
        function()
          require("conform").format({ formatters = { "injected" } })
        end,
        mode = { "n", "v" },
        desc = "Format injected langs",
      },
    },
    opts = {
      formatters_by_ft = {
        -- Web Development
        javascript = { { "prettierd", "prettier" } },
        typescript = { { "prettierd", "prettier" } },
        javascriptreact = { { "prettierd", "prettier" } },
        typescriptreact = { { "prettierd", "prettier" } },
        json = { { "prettierd", "prettier" } },
        jsonc = { { "prettierd", "prettier" } },
        html = { { "prettierd", "prettier" } },
        css = { { "prettierd", "prettier" } },
        scss = { { "prettierd", "prettier" } },
        less = { { "prettierd", "prettier" } },
        vue = { { "prettierd", "prettier" } },
        svelte = { { "prettierd", "prettier" } },
        astro = { { "prettierd", "prettier" } },
        
        -- Markdown and Documentation
        markdown = { { "prettierd", "prettier" } },
        ["markdown.mdx"] = { { "prettierd", "prettier" } },
        yaml = { { "prettierd", "prettier" } },
        toml = { "taplo" },
        
        -- Systems Programming
        lua = { "stylua" },
        python = { "isort", "black" },
        rust = { "rustfmt" },
        go = { "goimports", "gofmt" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        zig = { "zigfmt" },
        
        -- JVM Languages
        java = { "google-java-format" },
        kotlin = { "ktlint" },
        scala = { "scalafmt" },
        
        -- .NET Languages
        cs = { "csharpier" },
        
        -- Functional Languages
        haskell = { "fourmolu" },
        elixir = { "mix" },
        
        -- Shell and Config
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        fish = { "fish_indent" },
        
        -- Data formats
        xml = { "xmlformat" },
        proto = { "buf" },
        
        -- Other languages
        php = { "php_cs_fixer" },
        ruby = { "rubocop" },
        dart = { "dart_format" },
        terraform = { "terraform_fmt" },
        sql = { "sqlfluff" },
        
        -- Special: any filetype
        ["_"] = { "trim_whitespace" },
      },
      
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        
        -- Disable autoformat for files in certain paths
        local file = vim.api.nvim_buf_get_name(bufnr)
        if file:match("/node_modules/") then
          return
        end
        
        return { timeout_ms = 500, lsp_fallback = true }
      end,
      
      formatters = {
        -- Enhanced configurations for specific formatters
        black = {
          prepend_args = { "--line-length", "88" },
        },
        prettier = {
          prepend_args = { "--tab-width", "2" },
        },
        prettierd = {
          prepend_args = { "--tab-width", "2" },
        },
        stylua = {
          prepend_args = { 
            "--column-width", "100", 
            "--line-endings", "Unix",
            "--indent-type", "Spaces",
            "--indent-width", "2",
          },
        },
        rustfmt = {
          prepend_args = { "--edition", "2021" },
        },
        clang_format = {
          prepend_args = { 
            "--style", 
            "{ BasedOnStyle: LLVM, IndentWidth: 2, ColumnLimit: 100 }" 
          },
        },
        shfmt = {
          prepend_args = { "-i", "2", "-ci" },
        },
        
        -- Custom formatter for trim whitespace
        trim_whitespace = {
          format = function(self, ctx, lines, callback)
            local new_lines = {}
            for _, line in ipairs(lines) do
              table.insert(new_lines, line:gsub("%s+$", ""))
            end
            callback(nil, new_lines)
          end,
        },
        
        -- Custom injected language formatter
        injected = {
          options = {
            ignore_errors = true,
            lang_to_formatters = {
              json = { "jq" },
              sql = { "sqlfluff" },
              bash = { "shfmt" },
            },
          },
        },
      },
      
      -- Notification function
      notify_on_error = true,
      notify_no_formatters = true,
    },
    
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      
      -- Create commands for toggling format on save
      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })
      
      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = "Re-enable autoformat-on-save",
      })
      
      vim.api.nvim_create_user_command("FormatToggle", function(args)
        if args.bang then
          -- Toggle for current buffer
          vim.b.disable_autoformat = not vim.b.disable_autoformat
        else
          -- Toggle globally
          vim.g.disable_autoformat = not vim.g.disable_autoformat
        end
      end, {
        desc = "Toggle autoformat-on-save",
        bang = true,
      })
    end,
  },

  -- =============================================================================
  -- NVIM-LINT - LINTING
  -- =============================================================================
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      
      lint.linters_by_ft = {
        -- Web Development
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        svelte = { "eslint_d" },
        vue = { "eslint_d" },
        
        -- Python
        python = { "pylint", "mypy" },
        
        -- Lua
        lua = { "luacheck" },
        
        -- Shell
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        zsh = { "shellcheck" },
        
        -- Markdown
        markdown = { "markdownlint" },
        
        -- YAML
        yaml = { "yamllint" },
        
        -- Docker
        dockerfile = { "hadolint" },
        
        -- Go
        go = { "golangcilint" },
        
        -- JSON
        json = { "jsonlint" },
        
        -- CSS
        css = { "stylelint" },
        scss = { "stylelint" },
        less = { "stylelint" },
        
        -- PHP
        php = { "phpcs" },
        
        -- Ruby
        ruby = { "rubocop" },
        
        -- Terraform
        terraform = { "tflint" },
        
        -- SQL
        sql = { "sqlfluff" },
      }
      
      -- Enhanced linter configurations
      lint.linters.eslint_d.args = {
        "--no-eslintrc",
        "--config",
        function()
          local config_files = {
            ".eslintrc.js",
            ".eslintrc.cjs",
            ".eslintrc.yaml",
            ".eslintrc.yml",
            ".eslintrc.json",
            "eslint.config.js",
          }
          for _, config_file in ipairs(config_files) do
            if vim.fn.filereadable(config_file) == 1 then
              return vim.fn.fnamemodify(config_file, ":p")
            end
          end
          return vim.fn.expand("~/.eslintrc.json")
        end,
        "--format",
        "json",
        "--stdin",
        "--stdin-filename",
        function()
          return vim.api.nvim_buf_get_name(0)
        end,
      }
      
      -- Custom pylint configuration
      lint.linters.pylint.args = {
        "-f",
        "json",
        "--rcfile",
        function()
          local config_files = { "pyproject.toml", ".pylintrc", "pylint.toml" }
          for _, config_file in ipairs(config_files) do
            if vim.fn.filereadable(config_file) == 1 then
              return vim.fn.fnamemodify(config_file, ":p")
            end
          end
          return ""
        end,
        "--from-stdin",
        function()
          return vim.api.nvim_buf_get_name(0)
        end,
      }
      
      -- Auto-lint on specific events
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          -- Only lint if the buffer is attached to a file
          if vim.api.nvim_buf_get_name(0) ~= "" then
            lint.try_lint()
          end
        end,
      })
      
      -- Lint on text change with debounce
      local timer = vim.loop.new_timer()
      vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        group = lint_augroup,
        callback = function()
          timer:stop()
          timer:start(1000, 0, vim.schedule_wrap(function()
            if vim.api.nvim_buf_get_name(0) ~= "" then
              lint.try_lint()
            end
          end))
        end,
      })
      
      -- Store lint utilities in TacoVim namespace
      TacoVim.Lint = {
        toggle = function()
          if vim.g.lint_enabled == false then
            vim.g.lint_enabled = true
            vim.notify("🔍 Linting enabled", vim.log.levels.INFO)
          else
            vim.g.lint_enabled = false
            vim.notify("🔇 Linting disabled", vim.log.levels.INFO)
          end
        end,
        
        lint_file = function()
          lint.try_lint()
        end,
        
        get_linters = function()
          return lint.get_running()
        end,
      }
    end,
  },

  -- =============================================================================
  -- MASON-NULL-LS BRIDGE
  -- =============================================================================
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    opts = {
      ensure_installed = {
        -- Formatters
        "stylua",
        "black",
        "isort", 
        "prettier",
        "prettierd",
        "rustfmt",
        "gofmt",
        "goimports",
        "clang_format",
        "shfmt",
        "taplo",
        "google-java-format",
        -- "csharpier",  -- Often fails on Linux, install manually if needed
        "xmlformat",
        "sqlfluff",
        
        -- Linters
        "eslint_d",
        "pylint",
        "mypy",
        -- "luacheck",   -- Use lua_ls diagnostics instead
        "shellcheck",
        "markdownlint",
        "yamllint",
        "hadolint",
        "golangci-lint",
        "jsonlint",
        "stylelint",
        "tflint",
      },
      automatic_installation = false,
      handlers = {
        -- Handle specific tools that might fail
        csharpier = function()
          -- Don't install csharpier automatically due to Linux compatibility issues
        end,
        luacheck = function()
          -- Don't install luacheck, use lua_ls diagnostics instead
        end,
      },
    },
  },

  -- =============================================================================
  -- NONE-LS (NULL-LS FORK)
  -- =============================================================================
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          -- Code actions (only include available ones)
          nls.builtins.code_actions.gitsigns,
          
          -- Diagnostics (only stable ones)
          nls.builtins.diagnostics.trail_space,
          
          -- Hover
          nls.builtins.hover.dictionary,
        },
      }
    end,
  },

  -- =============================================================================
  -- EDITORCONFIG SUPPORT
  -- =============================================================================
  {
    "editorconfig/editorconfig-vim",
    event = { "BufReadPre", "BufNewFile" },
    init = function()
      vim.g.EditorConfig_exclude_patterns = { "fugitive://.*", "scp://.*" }
      vim.g.EditorConfig_disable_rules = { "trim_trailing_whitespace" }
    end,
  },

  -- =============================================================================
  -- LANGUAGE SPECIFIC FORMATTERS
  -- =============================================================================

  -- SQL Formatting
  {
    "cappyzawa/trim.nvim",
    event = "BufWritePre",
    opts = {
      ft_blocklist = {"markdown"},
      patterns = {
        [[%s/\(\n\n\)\n\+/\1/]],   -- replace 3+ line breaks with 2
        [[%s/\%^\n\+//]],          -- trim leading newlines
        [[%s/\n\+\%$//]],          -- trim trailing newlines
      },
      highlight = true,
      highlight_bg = "#ff0000",
      highlight_ctermbg = "red",
    },
  },

  -- Enhanced JSON formatting
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "json", "json5", "jsonc" })
      end
    end,
  },

  -- =============================================================================
  -- PRETTIER INTEGRATION
  -- =============================================================================
  {
    "MunifTanjim/prettier.nvim",
    ft = {
      "javascript",
      "typescript", 
      "javascriptreact",
      "typescriptreact",
      "vue",
      "css",
      "scss",
      "less",
      "html",
      "json",
      "jsonc",
      "yaml",
      "markdown",
      "graphql",
      "handlebars",
    },
    opts = {
      bin = 'prettierd',
      filetypes = {
        "css",
        "graphql",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "less",
        "markdown",
        "scss",
        "typescript",
        "typescriptreact",
        "yaml",
      },
      cli_options = {
        arrow_parens = "always",
        bracket_spacing = true,
        bracket_same_line = false,
        embedded_language_formatting = "auto",
        end_of_line = "lf",
        html_whitespace_sensitivity = "css",
        jsx_bracket_same_line = false,
        jsx_single_quote = false,
        print_width = 80,
        prose_wrap = "preserve",
        quote_props = "as-needed",
        semi = true,
        single_attribute_per_line = false,
        single_quote = false,
        tab_width = 2,
        trailing_comma = "es5",
        use_tabs = false,
        vue_indent_script_and_style = false,
      },
    },
  },

  -- =============================================================================
  -- AUTO-PAIRS AND BRACKET MANAGEMENT
  -- =============================================================================
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local npairs = require("nvim-autopairs")
      local Rule = require('nvim-autopairs.rule')
      local ts_conds = require('nvim-autopairs.ts-conds')

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

      -- Custom rules for specific languages
      npairs.add_rules({
        Rule("$", "$", {"tex", "latex"}),
        Rule("$$", "$$", "tex"),
        Rule("`", "`", {"markdown", "vimwiki"}),
        Rule("```", "```", {"markdown", "vimwiki"}),
      })

      -- Add spaces between parentheses
      local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
      npairs.add_rules {
        Rule(' ', ' ')
          :with_pair(function (opts)
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({
              brackets[1][1]..brackets[1][2],
              brackets[2][1]..brackets[2][2],
              brackets[3][1]..brackets[3][2],
            }, pair)
          end)
      }
      for _,bracket in pairs(brackets) do
        npairs.add_rules {
          Rule(bracket[1]..' ', ' '..bracket[2])
            :with_pair(function() return false end)
            :with_move(function(opts)
              return opts.prev_char:match('.%'..bracket[2]) ~= nil
            end)
            :use_key(bracket[2])
        }
      end

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

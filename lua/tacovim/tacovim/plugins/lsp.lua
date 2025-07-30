-- ~/.config/nvim/lua/tacovim/plugins/lsp.lua
-- TacoVim LSP Configuration

return {
  -- =============================================================================
  -- MASON - LSP/DAP/LINTER INSTALLER
  -- =============================================================================
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
      },
      pip = {
        upgrade_pip = false,
        install_args = {},
      },
      log_level = vim.log.levels.INFO,
      max_concurrent_installers = 4,
      registries = {
        "github:mason-org/mason-registry",
      },
      providers = {
        "mason.providers.registry-api",
        "mason.providers.client",
      },
    },
  },

  -- =============================================================================
  -- MASON LSP CONFIG
  -- =============================================================================
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    opts = {
      ensure_installed = {
        -- Web Development
        "html",           -- HTML
        "cssls",          -- CSS
        "ts_ls",          -- TypeScript/JavaScript
        "jsonls",         -- JSON
        "yamlls",         -- YAML
        "tailwindcss",    -- Tailwind CSS
        "emmet_ls",       -- Emmet
        "volar",          -- Vue.js
        "svelte",         -- Svelte
        "astro",          -- Astro

        -- Backend Languages
        "lua_ls",         -- Lua
        "pyright",        -- Python
        "ruff_lsp",       -- Python (Ruff)
        "rust_analyzer",  -- Rust
        "gopls",          -- Go
        "clangd",         -- C/C++

        -- JVM Languages
        "jdtls",          -- Java

        -- .NET Languages
        "omnisharp",      -- C#

        -- Native Languages
        "zls",            -- Zig

        -- Functional Languages
        "elixirls",       -- Elixir

        -- Markup and Config
        "marksman",       -- Markdown
        "dockerls",       -- Docker
        "bashls",         -- Bash
        "vimls",          -- Vim script

        -- Additional  
        "terraformls",    -- Terraform
        "cmake",          -- CMake
      },
      automatic_installation = true,
      handlers = {
        -- Default handler for servers without custom config
        function(server_name)
          local ok, lspconfig = pcall(require, "lspconfig")
          if not ok then return end
          
          -- Skip servers that commonly fail
          local skip_servers = {
            "csharpier",     -- Often fails on Linux
            "luacheck",      -- Replaced by lua_ls
            "fsautocomplete", -- F# server issues
            "hls",           -- Haskell server issues
            "csharp_ls",     -- Use omnisharp instead
          }
          
          for _, skip in ipairs(skip_servers) do
            if server_name == skip then
              vim.notify("Skipping problematic server: " .. server_name, vim.log.levels.WARN)
              return
            end
          end
          
          -- Setup with default config
          lspconfig[server_name].setup({})
        end,
      },
    },
  },

  -- =============================================================================
  -- NEOVIM LSP CONFIG
  -- =============================================================================
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

      -- Enhanced capabilities with completion support
      local capabilities = cmp_nvim_lsp.default_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true
      }

      -- Enhanced on_attach function
      local function on_attach(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        -- Highlight references of the word under cursor
        if client.server_capabilities.documentHighlightProvider then
          local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
          vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = group,
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = group,
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
          })
        end

        -- Enable inlay hints if supported
        if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end

        -- Code lens support
        if client.server_capabilities.codeLensProvider then
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = bufnr,
            callback = vim.lsp.codelens.refresh,
          })
        end
      end

      -- Server-specific configurations
      local server_configs = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = {
                globals = { "vim", "awesome", "client", "root", "screen" },
                disable = { "missing-fields" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
                maxPreload = 100000,
                preloadFileSize = 10000,
              },
              telemetry = { enable = false },
              format = { enable = false },
              hint = {
                enable = true,
                paramName = "Disable",
                setType = false,
                paramType = true,
                arrayIndex = "Disable",
              },
            },
          },
        },

        ts_ls = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
            },
          },
        },

        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "basic",
                autoImportCompletions = true,
                inlayHints = {
                  variableTypes = true,
                  functionReturnTypes = true,
                },
              },
            },
          },
        },

        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = { command = "clippy" },
              procMacro = { enable = true },
              cargo = { loadOutDirsFromCheck = true },
              inlayHints = {
                bindingModeHints = { enable = false },
                chainingHints = { enable = true },
                closingBraceHints = { enable = true, minLines = 25 },
                closureReturnTypeHints = { enable = "never" },
                lifetimeElisionHints = { enable = "never", useParameterNames = false },
                maxLength = 25,
                parameterHints = { enable = true },
                reborrowHints = { enable = "never" },
                renderColons = true,
                typeHints = { enable = true, hideClosureInitialization = false, hideNamedConstructor = false },
              },
            },
          },
        },

        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
              gofumpt = true,
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },

        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
            "--inlay-hints",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },

        jdtls = {
          -- Special handling for Java is done in a separate file
          autostart = false,
        },

        omnisharp = {
          cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
          settings = {
            FormattingOptions = {
              EnableEditorConfigSupport = true,
              OrganizeImports = nil,
            },
            MsBuild = {
              LoadProjectsOnDemand = nil,
            },
            RoslynExtensionsOptions = {
              EnableAnalyzersSupport = nil,
              EnableImportCompletion = nil,
              AnalyzeOpenDocumentsOnly = nil,
            },
            Sdk = {
              IncludePrereleases = true,
            },
          },
        },

        html = {
          settings = {
            html = {
              format = {
                templating = true,
                wrapLineLength = 120,
                wrapAttributes = "auto",
              },
              hover = {
                documentation = true,
                references = true,
              },
            },
          },
        },

        cssls = {
          settings = {
            css = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
            },
            scss = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
            },
            less = {
              validate = true,
              lint = {
                unknownAtRules = "ignore",
              },
            },
          },
        },

        jsonls = {
          settings = {
            json = {
              schemas = (function()
                local ok, schemastore = pcall(require, "schemastore")
                if ok then
                  return schemastore.json.schemas()
                else
                  return {}
                end
              end)(),
              validate = { enable = true },
            },
          },
        },

        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = false,
                url = "",
              },
              schemas = (function()
                local ok, schemastore = pcall(require, "schemastore")
                if ok then
                  return schemastore.yaml.schemas()
                else
                  return {}
                end
              end)(),
            },
          },
        },
      }

      -- Setup function for each server
      local function setup_server(server_name)
        local opts = {
          capabilities = capabilities,
          on_attach = on_attach,
        }

        -- Merge server-specific config
        if server_configs[server_name] then
          opts = vim.tbl_deep_extend("force", opts, server_configs[server_name])
        end

        -- Skip JDTLS as it's handled separately
        if server_name == "jdtls" then
          return
        end

        lspconfig[server_name].setup(opts)
      end

      -- Setup all servers through mason-lspconfig
      if mason_lspconfig.setup_handlers then
        mason_lspconfig.setup_handlers({
          setup_server,
          -- Custom handlers for specific servers can go here
        })
      else
        -- Fallback: setup servers manually if setup_handlers doesn't exist
        local installed_servers = mason_lspconfig.get_installed_servers()
        for _, server_name in pairs(installed_servers) do
          setup_server(server_name)
        end
      end

      -- Setup servers that aren't managed by Mason
      local manual_servers = {
        -- Add any servers that need manual setup
      }

      for _, server_name in ipairs(manual_servers) do
        setup_server(server_name)
      end

      -- Store LSP utilities in TacoVim namespace
      TacoVim.LSP = {
        capabilities = capabilities,
        on_attach = on_attach,
        setup_server = setup_server,
        
        -- Utility functions
        restart = function()
          vim.cmd("LspRestart")
          vim.notify("LSP servers restarted", vim.log.levels.INFO)
        end,
        
        get_active_clients = function()
          return vim.lsp.get_clients({ bufnr = 0 })
        end,
        
        toggle_inlay_hints = function()
          if vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end
        end,
      }
    end,
  },

  -- =============================================================================
  -- ADDITIONAL LSP ENHANCEMENTS
  -- =============================================================================
  
  -- JSON schemas
  {
    "b0o/schemastore.nvim",
    lazy = true,
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
          runnables = {
            use_telescope = true,
          },
          inlay_hints = {
            auto = true,
            show_parameter_hints = true,
            parameter_hints_prefix = "<- ",
            other_hints_prefix = "=> ",
          },
        },
        server = {
          on_attach = function(client, bufnr)
            -- Custom Rust keymaps
            local opts = { buffer = bufnr, silent = true }
            
            vim.keymap.set("n", "<leader>rr", function()
              vim.cmd.RustLsp("runnables")
            end, vim.tbl_extend("force", opts, { desc = "Rust Runnables" }))
            
            vim.keymap.set("n", "<leader>rd", function()
              vim.cmd.RustLsp("debuggables")
            end, vim.tbl_extend("force", opts, { desc = "Rust Debuggables" }))
            
            vim.keymap.set("n", "<leader>rt", function()
              vim.cmd.RustLsp("testables")
            end, vim.tbl_extend("force", opts, { desc = "Rust Testables" }))
            
            vim.keymap.set("n", "<leader>re", function()
              vim.cmd.RustLsp("expandMacro")
            end, vim.tbl_extend("force", opts, { desc = "Expand Macro" }))
            
            vim.keymap.set("n", "<leader>rc", function()
              vim.cmd.RustLsp("openCargo")
            end, vim.tbl_extend("force", opts, { desc = "Open Cargo.toml" }))
            
            vim.keymap.set("n", "<leader>rh", function()
              vim.cmd.RustLsp("hover", "actions")
            end, vim.tbl_extend("force", opts, { desc = "Hover Actions" }))
            
            vim.keymap.set("n", "K", function()
              vim.cmd.RustLsp({ "hover", "actions" })
            end, opts)
          end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              checkOnSave = {
                allFeatures = true,
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
            },
          },
        },
      }
    end,
  },

  -- LSP progress notifications (fixed version)
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      progress = {
        poll_rate = 0,
        suppress_on_insert = false,
        ignore_done_already = false,
        ignore_empty_message = false,
        clear_on_detach = function(client_id)
          local client = vim.lsp.get_client_by_id(client_id)
          return client and client.name or nil
        end,
        notification_group = function(msg)
          return msg.lsp_server and msg.lsp_server.name or "LSP"
        end,
        ignore = {},
        display = {
          render_limit = 16,
          done_ttl = 3,
          done_icon = "✔",
          done_style = "Constant",
          progress_ttl = math.huge,
          progress_icon = { pattern = "dots", period = 1 },
          progress_style = "WarningMsg",
          group_style = "Title",
          icon_style = "Question",
          priority = 30,
          skip_history = true,
          format_message = function(msg)
            local message = msg.message
            if not message then
              message = msg.done and "Completed" or "In progress..."
            end
            if msg.percentage then
              message = string.format("%s (%.0f%%)", message, msg.percentage)
            end
            return message
          end,
          format_annote = function(msg)
            return msg.title
          end,
          format_group_name = function(group)
            return tostring(group)
          end,
          overrides = {
            rust_analyzer = { name = "rust-analyzer" },
          },
        },
        lsp = {
          progress_ringbuf_size = 0,
          log_handler = false,
        },
      },
      notification = {
        poll_rate = 10,
        filter = vim.log.levels.INFO,
        history_size = 128,
        override_vim_notify = false,
        configs = { default = {} },
        redirect = function(msg, level, opts)
          if opts and opts.on_open then
            local ok, notify = pcall(require, "fidget.integration.nvim-notify")
            if ok then
              return notify.delegate(msg, level, opts)
            end
          end
        end,
        view = {
          stack_upwards = true,
          icon_separator = " ",
          group_separator = "---",
          group_separator_hl = "Comment",
          render_message = function(msg, cnt)
            return cnt == 1 and msg or string.format("(%dx) %s", cnt, msg)
          end,
        },
        window = {
          normal_hl = "Comment",
          winblend = 100,
          border = "none",
          zindex = 45,
          max_width = 0,
          max_height = 0,
          x_padding = 1,
          y_padding = 0,
          align = "bottom",
          relative = "editor",
        },
      },
      integration = {
        ["nvim-tree"] = {
          enable = true,
        },
      },
      logger = {
        level = vim.log.levels.WARN,
        max_size = 10000,
        float_precision = 0.01,
        path = string.format("%s/fidget.nvim.log", vim.fn.stdpath("cache")),
      },
    },
  },

  -- Lightbulb for code actions
  {
    "kosayoda/nvim-lightbulb",
    event = "LspAttach",
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
}
